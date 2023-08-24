require 'rails_helper'

RSpec.describe "feeds/new", type: :view do
  before(:each) do
    assign(:feed, Feed.new(
      url: "MyString",
      name: "MyString",
      active: false
    ))
  end

  it "renders new feed form" do
    render

    assert_select "form[action=?][method=?]", feeds_path, "post" do

      assert_select "input[name=?]", "feed[url]"

      assert_select "input[name=?]", "feed[name]"

      assert_select "input[name=?]", "feed[active]"
    end
  end
end