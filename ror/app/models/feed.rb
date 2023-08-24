class Feed < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.trigger_active!
    urls = Feed.where(active: true).pluck(:url)

    Bunny::UrlsTrigger.call(urls)
  end
end
