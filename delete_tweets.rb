require 'twitter'
require 'yaml'
require 'date'

CONFIG = YAML.load_file(File.expand_path('/data/config.yml', __FILE__))

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONFIG['twitter']['CONSUMER_KEY']
  config.consumer_secret     = CONFIG['twitter']['CONSUMER_SECRET']
  config.access_token        = CONFIG['twitter']['ACCESS_TOKEN']
  config.access_token_secret = CONFIG['twitter']['ACCESS_SECRET']
  config.username = CONFIG['twitter']['USER_NAME']
end

## https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

rule = DateTime.now - CONFIG['rule']
tweets = client.get_all_tweets(CONFIG['USER_NAME'])
tweets.each do |tweet|
  datetime = tweet.created_at.to_datetime
  local = datetime.new_offset(CONFIG['offset'])
  next unless local < rule
  client.destroy_status(tweet.id)
  printf "Deleted %s", tweet
end
