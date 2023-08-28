require 'rails_helper'

feature "Feed Index Page" do
  scenario "Able to display feeds and", js: true do
    feed = create(:feed, name: "Test title", active: true, url: "https://blog.uaid.net.ua/1feed")
    feed2 = create(:feed, name: "Test title 2", active: true, url: "https://blog.uaid.net.ua/2feed")

    visit('/feeds')

    expect(page).to have_content(feed.name)
    expect(page).to have_content(feed.url)
    expect(page).to have_content(feed2.name)
    expect(page).to have_content(feed2.url)

    # first feed
    within('.list-group-item', text: feed.url) do
      expect(page).to have_selector('small', text: feed.url)
      expect(page).to have_selector('span', text: '✅')
    end

    # second feed
    within('.list-group-item', text: feed2.url) do
      expect(page).to have_selector('small', text: feed2.url)
      expect(page).to have_selector('span', text: '✅')
    end
  end

  scenario "Able to destroy the feed", js: true do
    feed = create(:feed, name: "Test title 3", active: true, url: "https://blog.uaid.net.ua/3feed")
    feed2 = create(:feed, name: "Test title 4", active: true, url: "https://blog.uaid.net.ua/4feed")

    visit('/feeds')

    # first feed
    within('.list-group-item', text: feed.url) do
      expect(page).to have_selector('small', text: feed.url)
      expect(page).to have_selector('span', text: '✅')
    end

    # second feed
    within('.list-group-item', text: feed2.url) do
      expect(page).to have_selector('small', text: feed2.url)
      expect(page).to have_selector('span', text: '✅')
    end

    find('.list-group-item', text: feed.url).click

    expect do
      within('#editRecordModal') do
        page.evaluate_script('window.confirm = function() { return true; }') # accept confirmation dialog programmatically
        find('button', text: 'Destroy').click
      end
    end.to change(Feed, :count).by(-1)

    expect(page).not_to have_selector('.list-group-item', text: feed.url)
    expect(page).to have_selector('.list-group-item', text: feed2.url)
  end

  scenario "Able to enable and disable a feed", js: true do
    feed = create(:feed, name: "Test title 3", active: true, url: "https://blog.uaid.net.ua/3feed")
    feed2 = create(:feed, name: "Test title 4", active: true, url: "https://blog.uaid.net.ua/4feed")

    visit('/feeds')

    # first feed
    within('.list-group-item', text: feed.url) do
      expect(page).to have_selector('small', text: feed.url)
      expect(page).to have_selector('span', text: '✅')
    end

    # second feed
    within('.list-group-item', text: feed2.url) do
      expect(page).to have_selector('small', text: feed2.url)
      expect(page).to have_selector('span', text: '✅')
    end

    find('.list-group-item', text: feed.url).click

    within('#editRecordModal') do
      find('input#active[type="checkbox"]').click
      find('input[id="name"]').fill_in(with: 'New Feed Name')
      find('input[id="url"]').fill_in(with: 'https://some-new-url.com')
      find('button', text: 'Update').click
    end

    expect(page).not_to have_selector('.list-group-item', text: feed.url)
    expect(page).to have_selector('.list-group-item', text: feed2.url)
    expect(page).to have_selector('.list-group-item', text: 'https://some-new-url.com')

    feed.reload
    expect(feed.name).to eq('New Feed Name')
    expect(feed.url).to eq('https://some-new-url.com')
  end
end
