require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        title: "Title",
        source: "Source",
        source_url: "Source Url",
        link: "Link",
        description: "MyText",
        feed: nil
      ),
      Item.create!(
        title: "Title",
        source: "Source",
        source_url: "Source Url",
        link: "Link",
        description: "MyText",
        feed: nil
      )
    ])
  end

  it "renders a list of items" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Source".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Source Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Link".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
