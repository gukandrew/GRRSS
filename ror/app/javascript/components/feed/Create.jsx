import React, { useState } from "react";

const Add = () => {
  const placeholderUrls = ['https://techcrunch.com/feed', 'https://www.wired.com/feed/rss', 'https://www.theverge.com/rss/index.xml'];
  const [feedUrls, setFeedUrls] = useState(placeholderUrls.join("\n"));
  const [downloadNow, setDownloadNow] = useState(true);
  const [response, setResponse] = useState({ status: 0, message: null });

  const handleChange = (event) => {
    setFeedUrls(event.target.value);
  }

  const handleDownloadNowChange = (event) => {
    setDownloadNow(event.target.checked);
  }

  const navigate = (path = '/') => {
    window.location.replace(path)
  }

  const handleSubmit = (event) => {
    event.preventDefault();

    fetch('/feeds/import_feeds', {
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
          setTimeout(() => {
            navigate('/items')
          }, 1000);
        }
      });
  }

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
        <textarea className="form-control" id="feed_urls" rows="10" aria-describedby="feed_urls_help" onChange={handleChange} value={feedUrls} />
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
