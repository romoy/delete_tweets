FROM 'ruby'
WORKDIR /opt/
COPY . .
RUN gem install bundle twitter pry
CMD ["ruby","delete_tweets.rb"]
