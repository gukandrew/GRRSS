class Api::ItemsController < ApplicationController
  def index
    @records = Item.all.order(published_at: :desc)

    render json: { success: 1, records: @records }
  end
end
