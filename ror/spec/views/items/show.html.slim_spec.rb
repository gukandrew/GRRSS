require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    assign(:item, Item.create!(
      title: "Title",
      source: "Source",
      source_url: "Source Url",
      link: "Link",
      description: "MyText",
      feed: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/Source Url/)
    expect(rendered).to match(/Link/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
