package reader

import (
	"testing"
	"time"

	gofeed "github.com/mmcdole/gofeed"
)

func TestParseFeed(t *testing.T) {
	mockParser := &mockGofeedParser{}
	parseURL = func(_fp *gofeed.Parser, url string) (feed *gofeed.Feed, err error) {
		return mockParser.ParseURL(url)
	}

	url := "https://example.com/feed"
	items := parseFeed(url)

	if len(items) == 0 {
		t.Errorf("Expected at least one item, but got none")
	}
}

func TestParse(t *testing.T) {
	mockParser := &mockGofeedParser{}
	parseURL = func(_fp *gofeed.Parser, url string) (feed *gofeed.Feed, err error) {
		return mockParser.ParseURL(url)
	}

	urls := []string{"https://example.com/feed1", "https://example.com/feed2"}
	items := Parse(urls)

	if len(items) != 2 {
		t.Errorf("Expected 2 items, but got %d", len(items))
	}
}

func TestParseFeedWithMockParser(t *testing.T) {
	mockParser := &mockGofeedParser{}
	parseURL = func(_fp *gofeed.Parser, url string) (feed *gofeed.Feed, err error) {
		return mockParser.ParseURL(url)
	}

	url := "https://example.com/feed"
	items := parseFeed(url)

	if len(items) != 1 {
		t.Errorf("Expected 1 item, but got %d", len(items))
	}
}

type mockGofeedParser struct{}

func (m *mockGofeedParser) ParseURL(url string) (*gofeed.Feed, error) {
	return &gofeed.Feed{
		Title: "Mocked Feed",
		Link:  "https://example.com/mock-feed",
		Items: []*gofeed.Item{
			{
				Title:           "Mocked Item",
				Link:            "https://example.com/mock-item",
				PublishedParsed: &time.Time{},
				Description:     "Mocked Description",
			},
		},
	}, nil
}
