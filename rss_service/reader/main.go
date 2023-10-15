package reader

import (
	"time"

	gofeed "github.com/mmcdole/gofeed"
)

type RssItem struct {
	Title       string    `json:"title"`
	Source      string    `json:"source"`
	SourceURL   string    `json:"source_url"`
	Link        string    `json:"link"`
	PublishDate time.Time `json:"publish_date"`
	Description string    `json:"description"`
}

func Parse(urls []string) []RssItem {
	var items []RssItem
	for _, url := range urls {
		items = append(items, parseFeed(url)...)
	}
	return items
}

// parseURL is a variable that can be mocked in tests
var parseURL = func(fp *gofeed.Parser, url string) (feed *gofeed.Feed, err error) {
	return fp.ParseURL(string(url))
}

func parseFeed(url string) []RssItem {
	fp := gofeed.NewParser()
	fp.UserAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0"
	feed, err := parseURL(fp, url)

	if err != nil {
		panic(err)
	}

	var items []RssItem
	for _, item := range feed.Items {
		publishDate := time.Time{}
		if item.PublishedParsed != nil {
			publishDate = *item.PublishedParsed
		}

		items = append(items, RssItem{
			Title:       item.Title,
			Source:      feed.Title,
			SourceURL:   url,
			Link:        item.Link,
			PublishDate: publishDate,
			Description: item.Description,
		})
	}

	return items
}
