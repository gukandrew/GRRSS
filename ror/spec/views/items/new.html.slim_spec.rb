require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      title: "MyString",
      source: "MyString",
      source_url: "MyString",
      link: "MyString",
      description: "MyText",
      feed: nil
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[title]"

      assert_select "input[name=?]", "item[source]"

      assert_select "input[name=?]", "item[source_url]"

      assert_select "input[name=?]", "item[link]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[feed_id]"
    end
  end
end
