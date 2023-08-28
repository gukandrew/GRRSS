require 'rails_helper'

feature "Item Index Page" do
  scenario "Able to display items and", js: true do
    item = create(:item)
    item2 = create(:item)

    visit('/items')

    expect(page).to have_content(item.title)
    expect(page).to have_content(item.description)
    expect(page).to have_content(item2.title)
    expect(page).to have_content(item2.description)

    # first item
    within('.list-group-item', text: item.description) do
      expect(page).to have_selector('small', text: item.description)
    end

    # second item
    within('.list-group-item', text: item2.description) do
      expect(page).to have_selector('small', text: item2.description)
    end
  end

  scenario "Able to open modal for reading item", js: true do
    item = create(:item, :with_feed)
    item2 = create(:item, :with_feed)

    visit('/items')

    # first item
    within('.list-group-item', text: item.description) do
      expect(page).to have_selector('small', text: item.description)
    end

    # second item
    within('.list-group-item', text: item2.description) do
      expect(page).to have_selector('small', text: item2.description)
    end

    find('.list-group-item', text: item.description).click
    within('#viewRecordModal') do
      expect(page).to have_link(item.title, href: item.link)
      expect(page).to have_selector('a.h1.modal-title', text: item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_selector('span.badge.bg-success', text: item.source)


      sleep 1 # wait before closing modal
      find('button.btn-close').click
    end

    find('.list-group-item', text: item2.description).click
    within('#viewRecordModal') do
      expect(page).to have_link(item2.title, href: item2.link)
      expect(page).to have_selector('a.h1.modal-title', text: item2.title)
      expect(page).to have_content(item2.description)
      expect(page).to have_selector('span.badge.bg-success', text: item2.source)

      sleep 1 # wait before closing modal
      find('button.btn-close').click
    end
  end

  scenario "Able to navigate forward and back", js: true do
    item = create(:item, :with_feed)
    item2 = create(:item, :with_feed)

    visit('/items')

    # first item
    within('.list-group-item', text: item.description) do
      expect(page).to have_selector('small', text: item.description)
    end

    # second item
    within('.list-group-item', text: item2.description) do
      expect(page).to have_selector('small', text: item2.description)
    end

    find('.list-group-item', text: item2.description).click
    within('#viewRecordModal') do
      expect(page).to have_link(item2.title, href: item2.link)
      expect(page).to have_selector('a.h1.modal-title', text: item2.title)
      expect(page).to have_content(item2.description)
      expect(page).to have_selector('span.badge.bg-success', text: item2.source)

      sleep 1
      find('button i.bi.bi-arrow-left').click

      sleep 1
      expect(page).to have_link(item.title, href: item.link)
      expect(page).to have_selector('a.h1.modal-title', text: item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_selector('span.badge.bg-success', text: item.source)

      sleep 1
      find('button i.bi.bi-arrow-right').click

      sleep 1
      expect(page).to have_link(item2.title, href: item2.link)
      expect(page).to have_selector('a.h1.modal-title', text: item2.title)
      expect(page).to have_content(item2.description)
      expect(page).to have_selector('span.badge.bg-success', text: item2.source)
    end
  end
end
