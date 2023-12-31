import React, { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { fetchStatistics } from "../services/statistics";
import { useStorage } from '../services/storage';

const Add = () => {
  const { getItem, setItem } = useStorage();
  const placeholderUrls = [
    'http://feeds.feedburner.com/ItsFoss',
    'https://itc.ua/ua/feed/',
    'https://blog.uaid.net.ua/feed/',
  ];
  const navigate = useNavigate();
  const [feedUrls, setFeedUrls] = useState(placeholderUrls.join("\n"));
  const [downloadNow, setDownloadNow] = useState(true);
  const [response, setResponse] = useState({ status: 0, message: null });
  // const [formSubmitted, setFormSubmitted] = useState(0);
  const statistics = getItem('statistics') || { feeds: 0, items: 0 };
  const [statisticsCached, setStatisticsCached] = useState(statistics);
  let updater = useRef(null);
  let updaterTimeout = useRef(null);

  const handleChange = (event) => {
    setFeedUrls(event.target.value);
  }

  const handleDownloadNowChange = (event) => {
    setDownloadNow(event.target.checked);
  }

  const handleSubmit = (event) => {
    event.preventDefault();

    fetch('/api/feeds/import_feeds', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ urls: feedUrls, download_now: downloadNow })
    }).then(response => response.json())
      .then(data => {
        setResponse(data);

        if (data.success) {
          updater.current = setInterval(() => fetchStatistics(setItem), 500);
          localStorage.setItem('feedsSelected', JSON.stringify([])); // reset selected feeds
        }
      });
  }

  const stopUpdaterAndGoToItemsPage = () => {
    clearTimeout(updaterTimeout.current);
    clearInterval(updater.current);
    navigate('/items');
  }

  useEffect(() => {
    updaterTimeout.current = setTimeout(() => stopUpdaterAndGoToItemsPage(), 5000); // stop updater after 5 seconds
    if (statisticsCached.items > 0 && statisticsCached.items < statistics.items) { // new items added
      stopUpdaterAndGoToItemsPage();
    }
    setStatisticsCached(statistics);
  }, [statistics])

  const alertMsg = () => {
    if (response.status === 0) {
      return null;
    }

    return <div className="alert alert-success alert-dismissible fade show" role="alert">
      {response.message}
      <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  }

  return <div className="container mt-3">
    {alertMsg()}

    <form onSubmit={handleSubmit}>
      <div className="mb-3">
        <label htmlFor="feed_urls" className="form-label">Feed URLs</label>
        <textarea className="form-control" id="feed_urls" rows="10" aria-describedby="feed_urls_help" onChange={handleChange} value={feedUrls} required={true} />
        <div id="feed_urls_help" className="form-text">Feed urls seperated by new lines</div>
      </div>

      <div className="mb-3 form-check">
        <input type="checkbox" className="form-check-input" id="download_now" checked={downloadNow} onChange={handleDownloadNowChange} disabled />
        <label className="form-check-label" htmlFor="download_now">Download last items now</label>
      </div>
      <button type="submit" className="btn btn-primary">Submit</button>
    </form>
  </div>
}

export default Add
