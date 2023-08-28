# GRRSS - rss app written on Ruby on Rails and Go
## How to build & run using Docker Compose?
```sh
docker compose up --build
```

Shut down
```sh
docker compose down
```

Drop db volume
```sh
docker volume rm grrss_db-data;
```

## How to start in dev mode?
Set up environment variables in ror/.ene file. Then run:
```sh
docker compose up -d rabbitmq db
ror/bin/rails db:prepare
bin/dev
```

How to update cron?

```sh
ror/bin/bundle exec whenever --update-crontab -s 'environment=development'
```

How to verify if cron is working?

```sh
tail -f /var/log/syslog
```

How to clear cron?

```sh
ror/bin/bundle exec whenever -c
```

## How to run tests?
```sh
docker compose up -d rabbitmq db
cd ror
bin/rails db:prepare
bin/bundle exec rspec spec
```
