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
FactoryBot.define do
  factory :item do
    sequence(:title) { |n| "Item #{n}" }
    sequence(:source) { |n| "Feed #{n}" }
    sequence(:source_url) { |n| "http://example.com/#{n}" }
    sequence(:link) { |n| "http://example.com/item/#{n}" }
    published_at { rand(1..5).days.ago }
    sequence(:description) { |n| "Item #{n} description" }

    trait :with_feed do
      feed
    end
  end
end
