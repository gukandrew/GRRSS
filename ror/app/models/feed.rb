# == Schema Information
#
# Table name: feeds
#
#  id         :bigint           not null, primary key
#  url        :string
#  name       :string
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Feed < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true

  def self.trigger_active!
    urls = Feed.where(active: true).pluck(:url)

    Bunny::UrlsTrigger.call(urls)
  end
end
