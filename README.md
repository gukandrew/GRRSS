# GRRSS - rss app written on Ruby on Rails and Go

How to start?
Set up environment variables in ror/.env file and rss_reader/.env file. Then run:
```sh
docker compose up -d

rails db:create
rails db:migrate
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
