require 'bunny'
require 'json/ext'

class RssConsumer
  def initialize
    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    @channel = connection.create_channel
    @queue = @channel.queue('service_rss_feed_out')
  end

  def start
    puts '🐰 Waiting for messages. To exit press CTRL+C'
    puts 'RAILS_ENV: ' + ENV['RAILS_ENV']

    @queue.subscribe do |_delivery_info, _metadata, body|
      puts "🐰 Received message!"
      # Process and save parsed RSS feed data to the database
      parsed_data = JSON.parse(body)

      parsed_data['items'].each do |item|
        puts "Processing item: #{item['source']}"

        record = Item::Create.call(item).save

        if record.persisted?
          puts "✅ Source: #{record.source}: created record for '#{record.title}'"
        else
          puts "❌ Source: #{item['source']}: failed to create record for '#{item['title']}'"
        end
      end
    end

    loop { sleep 1 }
  rescue Interrupt => _
    exit(0)
  ensure
    connection.close
  end
end
