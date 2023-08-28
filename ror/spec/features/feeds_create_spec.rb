require 'rails_helper'

feature "Feed Create Page" do
  scenario "Able to add feeds", js: true do
    visit('/')

    expect(page).to have_content("Add feeds")

    buttons = page.all('a', text: 'Add feeds')
    expect(buttons.any?).to be_truthy

    buttons[1].click # click on second button

    expect(page).to have_content("Feed URLs")
    expect(page).to have_selector('textarea')
    expect(page).to have_button('Submit')

    textarea = find('textarea#feed_urls')
    textarea.fill_in(with: 'https://blog.uaid.net.ua/feed')

    submit_button = find('button[type="submit"]')
    submit_button.click

    expect(page).to have_content("Feeds are being processed. Please wait a few minutes and refresh the page!")
  end
end
