require 'rails_helper'

RSpec.describe "feeds/edit", type: :view do
  let(:feed) {
    Feed.create!(
      url: "MyString",
      name: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:feed, feed)
  end

  it "renders the edit feed form" do
    render

    assert_select "form[action=?][method=?]", feed_path(feed), "post" do

      assert_select "input[name=?]", "feed[url]"

      assert_select "input[name=?]", "feed[name]"

      assert_select "input[name=?]", "feed[active]"
    end
  end
end
