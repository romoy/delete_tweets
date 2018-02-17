Deletes Tweets older than x days

* Install docker

* Create docker image
docker build -t delete-tweets .

* Create docker volume
docker volume create delete-tweets-config

* Create config.yml
cp config.yml.sample config.yml

* Update config.yml with your twitter app config

* Copy config.yml to docker volume
cp config.yml /var/lib/volumes/delete-tweets-config/_data/config.yml

* Run delete tweets docker image
docker run -v delete-tweets-config:/data delete-Tweets
