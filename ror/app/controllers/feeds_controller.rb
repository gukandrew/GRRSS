class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy ]

  def import_feeds
  end

  def create_feeds
    urls = create_feed_urls

    connection = Bunny.new(ENV['RABBITMQ_URL'])
    connection.start

    @channel = connection.create_channel
    @queue = @channel.queue('service_rss_feed_in')

    @queue.publish(urls.to_json)

    redirect_to items_path, notice: "Feeds are being processed. Please wait a few minutes and refresh the page!"
  end

  # GET /feeds or /feeds.json
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1 or /feeds/1.json
  def show
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds or /feeds.json
  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to feed_url(@feed), notice: "Feed was successfully created." }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1 or /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to feed_url(@feed), notice: "Feed was successfully updated." }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1 or /feeds/1.json
  def destroy
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url, notice: "Feed was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feed_params
      params.require(:feed).permit(:url, :name, :active)
    end

    def create_feed_params
      params.require(:urls)
    end

    def create_feed_urls
      urls = create_feed_params.split("\n")

      parser = URI::DEFAULT_PARSER
      urls.select { |url| parser.make_regexp.match?(url) }
    end
end
