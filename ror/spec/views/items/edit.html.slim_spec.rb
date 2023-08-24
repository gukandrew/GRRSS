require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) {
    Item.create!(
      title: "MyString",
      source: "MyString",
      source_url: "MyString",
      link: "MyString",
      description: "MyText",
      feed: nil
    )
  }

  before(:each) do
    assign(:item, item)
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[title]"

      assert_select "input[name=?]", "item[source]"

      assert_select "input[name=?]", "item[source_url]"

      assert_select "input[name=?]", "item[link]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[feed_id]"
    end
  end
end
