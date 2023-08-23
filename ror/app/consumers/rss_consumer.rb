require 'bunny'
require 'json/ext'

class RssConsumer
  def initialize
    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    @channel = connection.create_channel
    @queue = @channel.queue('rss_feed_queue')
  end

  def start
    @queue.subscribe do |_delivery_info, _metadata, body|
      # Process and save parsed RSS feed data to the database
      parsed_data = JSON.parse(body)
      Feed.create!(url: parsed_data['url'], name: parsed_data['name'], active: parsed_data['active'])
    end

    loop { sleep 1 }
  rescue Interrupt => _
    connection.close

    exit(0)
  end
end
