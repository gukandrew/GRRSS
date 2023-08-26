class Api::FeedsController < ApplicationController
  def create_feeds
    Bunny::UrlsTrigger.call(create_feed_urls)

    render json: { success: 1, message: "Feeds are being processed. Please wait a few minutes and refresh the page!" }
  end

  private

  def create_feed_params
    params.permit(:urls)
  end

  def create_feed_urls
    urls = create_feed_params[:urls].split("\n")

    parser = URI::DEFAULT_PARSER
    urls.select { |url| parser.make_regexp.match?(url) }
  end
end
