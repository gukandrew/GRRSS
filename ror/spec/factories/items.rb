FactoryBot.define do
  factory :item do
    title { "MyString" }
    source { "MyString" }
    source_url { "MyString" }
    link { "MyString" }
    published_at { "2023-08-24 16:24:31" }
    description { "MyText" }
    feed { nil }
  end
end
