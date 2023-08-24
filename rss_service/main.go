package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"runtime"
	"time"

	reader "main/reader"

	amqp "github.com/rabbitmq/amqp091-go"
)

var conn *amqp.Connection
var chIn *amqp.Channel
var qIn amqp.Queue
var chOut *amqp.Channel
var qOut amqp.Queue

type ResponseJSON struct {
	Items []reader.RssItem `json:"items"`
}

func main() {
	hello()

	var err error
	conn, err = amqp.Dial("amqp://grrss:grrss_secret@localhost:5672")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	chIn, qIn = prepareChannel(conn, "service_rss_feed_in")
	chOut, qOut = prepareChannel(conn, "service_rss_feed_out")

	defer chIn.Close()
	defer chOut.Close()
	listenChannel(chIn, qIn)

	for {
		time.Sleep(1 * time.Second)
	}
}

func prepareChannel(conn *amqp.Connection, name string) (*amqp.Channel, amqp.Queue) {
	ch, err := conn.Channel()
	failOnError(err, "Failed to open a channel")

	q, err := ch.QueueDeclare(
		name, // name
		false,   // durable
		false,   // delete when unused
		false,   // exclusive
		false,   // no-wait
		nil,     // arguments
	)
	failOnError(err, "Failed to declare a queue")
	return ch, q
}

func listenChannel(ch *amqp.Channel, q amqp.Queue) {
	msgs, err := ch.Consume(
		q.Name, // queue
		"",     // consumer
		true,   // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	go func() {
		for d := range msgs {
			log.Printf("Received a message: %s", d.Body)

			var urls []string
			json.Unmarshal(d.Body, &urls)

			items := reader.Parse(urls)
			body, _ := json.Marshal(ResponseJSON{ Items: items })
			log.Printf("Processed %v items!", len(items))

			publishMessage(chOut, qOut, string(body))
		}
	}()

	log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
}

func publishMessage(ch *amqp.Channel, q amqp.Queue, body string) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err := ch.PublishWithContext(ctx,
		"",     // exchange
		q.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte(body),
		})
	failOnError(err, "Failed to publish a message")
	log.Print(" [x] Sent result!\n")
}

func failOnError(err error, msg string) {
  if err != nil {
    log.Panicf("%s: %s", msg, err)
  }
}

func hello() {
	fmt.Println("Hello, World!")
	fmt.Println("Go version: ", runtime.Version())
}
