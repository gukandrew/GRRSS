class Api::StatisticsController < ApplicationController
  def index
    @feeds = Feed.count
    @items = Item.count

    render json: { success: 1, feeds: @feeds, items: @items }
  end
end
