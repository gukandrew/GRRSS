class Api::FeedsController < ApplicationController
  def create_feeds
    Bunny::UrlsTrigger.call(create_feed_urls)

    render json: { success: 1, message: "Feeds are being processed. Please wait a few minutes and refresh the page!" }
  end

  def index
    @feeds = Feed.all

    render json: { success: 1, records: @feeds }
  end

  def update
    @feed = Feed.find(params[:id])

    if @feed.update(feed_params)
      render json: { success: 1, message: "Feed has been successfully updated!" } and return
    end

    render json: { success: 0, message: @feed.errors.full_messages.join(", ") }
  end

  def destroy
    @feed = Feed.find(params[:id])

    if @feed.destroy
      render json: { success: 1, message: "Feed has been successfully deleted!" } and return
    end

    render json: { success: 0, message: @feed.errors.full_messages.join(", ") }
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

  def feed_params
    params.require(:feed).permit(:url, :name, :active)
  end
end
