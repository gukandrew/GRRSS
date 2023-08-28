# GRRSS - RSS Aggregator Application

Welcome to the GRRSS repository! This repository contains the source code for a feature-rich RSS aggregator application built using Ruby on Rails and Go, with RabbitMQ handling the data flow in between. The frontend is developed using the React Component API, with Bootstrap for styling.

## Features

- Aggregates RSS feeds from various sources.
- Provides a seamless user interface for managing and reading RSS content.
- Efficient data processing using Go and RabbitMQ.
- Real-time background updates.
- TBD: User authentication and authorization.
- TBD: Notifications.

## Demo

Check out our [LIVE DEMO](http://i.ukie.me:3000/) of the GRRSS application, hosted on a Raspberry Pi 4. We've set up a tunnel to the IONOS hosting provider to ensure a smooth user experience.

## Getting Started

To build and run the GRRSS application using Docker Compose, follow these steps:

1. Clone this repository to your local machine.
2. Open a terminal and navigate to the repository's root directory.

### Build and Run

```bash
docker-compose up --build
```

To shut down the application, use:

```bash
docker-compose down
```

To remove the database volume, if needed:

```bash
docker volume rm grrss_db-data
```

### Development Mode

For development, follow these steps:

1. Set up environment variables in `ror/.env` and `docker-compose.yml`.
2. Run the following commands:

```bash
docker-compose up -d rabbitmq db
ror/bin/rails db:prepare
bin/dev
```

### Updating Cron Jobs

To update the cron jobs, execute:

```bash
ror/bin/bundle exec whenever --update-crontab -s 'environment=development'
```

### Verifying Cron Jobs

To verify if the cron jobs are working, monitor the syslog using:

```bash
tail -f /var/log/syslog
```

### Clearing Cron Jobs

To clear the cron jobs, use:

```bash
ror/bin/bundle exec whenever -c
```

### Running Tests

To run tests, follow these steps:

1. Start the required services:

```bash
docker-compose up -d rabbitmq db
cd ror
bin/rails db:prepare
```

2. Run the tests:

```bash
bin/bundle exec rspec spec
```
