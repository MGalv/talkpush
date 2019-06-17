# Talkpush Sync

## How to install

1. Pull the repo and move into the app's root folder
2. Install the gems using bundler:
```bash
$ bundle install
```
3. Create the database and run the migrations (you will require to have installed Postgresql)
```bash
$ bundle exec rake db:create db:migrate db:test:prepare
```
4. Run the cron job using whenever and check the cron is running:
```bash
$ whenever --update-crontab
$ whenever -l
```
5. Run the rails application:
```bash
$ rails s
```
