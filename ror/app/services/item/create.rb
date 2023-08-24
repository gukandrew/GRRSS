# frozen_string_literal: true

class Item::Create
  include Service

  attr_accessor :item, :params, :admin_action, :feed

  def call(params = {}, scope = Item.all, admin_action: false)
    @admin_action = admin_action
    @params = params
    @item = scope.new(item_params)

    self
  end

  def save
    before_save
    item.save
    after_save if item.persisted?

    item
  end

  def before_save
    source_url = item.source_url.gsub(%r{/$}, '') # remove ending slash from source_url

    @feed = Feed.find_or_initialize_by(url: source_url) do |feed|
      feed.name = item['source']
    end

    feed.update(active: true) # reactivates feed if it was deactivated
    item.feed_id = @feed.id
  end

  def after_save; end

  def item_params
    {
      title: params['title'],
      source: params['source'],
      source_url: params['source_url'],
      link: params['link'],
      published_at: params['publish_date'],
      description: params['description']
    }
  end
end
