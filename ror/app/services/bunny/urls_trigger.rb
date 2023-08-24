# frozen_string_literal: true

class Bunny::UrlsTrigger
  include Service

  def call(urls = [])
    return if urls.empty?

    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    @channel = connection.create_channel
    @queue = @channel.queue('service_rss_feed_in')

    @queue.publish(urls.to_json)
  end
end
