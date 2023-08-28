class Api::ItemsController < ApplicationController
  def index
    @records = Item.all.order(published_at: order_by)
    @records = @records.where(feed_id: selected_feed_ids) if selected_feed_ids.present?

    render json: { success: 1, records: @records }
  end

  private

  def order_by
      case filter_params[:order_by]
      when 'asc'
        :asc
      else
        :desc
      end
  end

  def selected_feed_ids
    filter_params[:feed_ids]
  end

  def filter_params
    params.permit(:order_by, feed_ids: [])
  end
end
