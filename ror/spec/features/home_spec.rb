require 'rails_helper'

feature "Visit homepage" do
  scenario "Able see general info", js: true do
    visit('/')

    expect(page).not_to have_selector(".nav-link[href=\"/feeds\"]")
    expect(page).not_to have_selector(".nav-link[href=\"/items\"]")

    expect(page).to have_content("Add feeds", count: 2)
    expect(page).not_to have_content("Manage feeds")
    expect(page).not_to have_content("👁️‍🗨️ Read")

    expect(page).to have_content("GRRSS - RSS Reader App")
    expect(page).to have_content("Welcome to the RSS reader application. Stay up-to-date with your favorite feeds from around the web.")
    expect(page).to have_content("With our user-friendly interface, you can easily subscribe to, organize, and read the latest articles and news from various sources.")
    expect(page).to have_content("Currently you have 0 feeds with 0 items in total.")
  end

  scenario "Able see actual statistics if feeds / items exists", js: true do
    feed = create(:feed, name: "Test title", active: true, url: "https://blog.uaid.net.ua/feed")
    feed.items << create_list(:item, 5)

    visit('/')

    expect(page).to have_selector(".nav-link[href=\"/feeds\"]")
    expect(page).to have_selector(".nav-link[href=\"/items\"]")
    expect(page).to have_content("Add feeds", count: 2)
    expect(page).to have_content("Manage feeds")
    expect(page).to have_content("👁️‍🗨️ Read")

    expect(page).to have_content("GRRSS - RSS Reader App")
    expect(page).to have_content("Welcome to the RSS reader application. Stay up-to-date with your favorite feeds from around the web.")
    expect(page).to have_content("With our user-friendly interface, you can easily subscribe to, organize, and read the latest articles and news from various sources.")
    expect(page).to have_content("Currently you have 1 feeds with 5 items in total.")
  end
end
