# == Schema Information
#
# Table name: items
#
#  id           :bigint           not null, primary key
#  title        :string
#  source       :string
#  source_url   :string
#  link         :string
#  published_at :datetime
#  description  :text
#  feed_id      :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Item < ApplicationRecord
  belongs_to :feed, optional: true

  validates :title, presence: true
  validates :source, presence: true
  validates :published_at, presence: true

  validates :title, uniqueness: { scope: :source }

  def as_json(args)
    super(args).merge({
      published_at: self.published_at.to_i,
    })
  end
end
