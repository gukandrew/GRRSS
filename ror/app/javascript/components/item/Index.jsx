import React, { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom"
import { Modal } from "bootstrap"
import ArrowsComponent from "../common/arrows_control";
import { formatDate } from "../../utils/datetime.js";

const Index = () => {
  const [feeds, setFeeds] = useState([]);
  const [records, setRecords] = useState([]);
  const [activeRecordIndex, setActiveRecordIndex] = useState(null);
  const [updatedAt, setUpdatedAt] = useState(0);
  const [feedsSelected, setFeedsSelected] = useState(localStorage.getItem('feedsSelected') ? JSON.parse(localStorage.getItem('feedsSelected')) : []);
  const [orderBy, setOrderBy] = useState(localStorage.getItem('orderBy') ? localStorage.getItem('orderBy') : 'desc');

  useEffect(() => {
    localStorage.setItem('feedsSelected', JSON.stringify(feedsSelected));
  }, [feedsSelected])

  useEffect(() => {
    localStorage.setItem('orderBy', orderBy);
  }, [orderBy])

  const [viewRecord, setViewRecord] = useState({
    id: null,
    title: '',
    source: '',
    source_url: '',
    link: '',
    published_at: 0,
    description: '',
    feed_id: null,
    created_at: 0,
    updated_at: 0,
  });
  const modal = useRef(null);

  useEffect(() => { // This will run only once for modal initialization
    const domModal = document.getElementById('viewRecordModal');

    if (domModal) {
      modal.current = new Modal('#viewRecordModal', {
        keyboard: true
      })

      domModal.addEventListener('hidden.bs.modal', function () {
        setActiveRecordIndex(null)
      });
    }
  }, [])

  useEffect(() => {
    if (activeRecordIndex !== null) {
      const record = records[activeRecordIndex];
      setViewRecord(record);
      modal.current.show();
    }
  }, [activeRecordIndex])

  useEffect(() => {
    (async () => {
      const data = await fetchFeeds();
      if (data.success) {
        setFeeds(data.records);
      }

      if (feedsSelected.length === 0) {
        selectAllFeeds(data.records);
      }
    })();
  }, [])

  useEffect(() => {
    fetchRecords();
  }, [orderBy, feedsSelected])

  const fetchFeeds = () => {
    return fetch('/api/feeds', {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    }).then(response => response.json())
  }

  const selectAllFeeds = (records) => {
    setFeedsSelected(records.map((feed) => feed.id));
  }

  const fetchRecords = () => {
    const queryParams = new URLSearchParams();

    queryParams.append('order_by', orderBy);
    feedsSelected.forEach((feedId) => queryParams.append('feed_ids[]', feedId));

    fetch('/api/items?' + queryParams.toString(), {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    }).then(response => response.json())
      .then(data => {
        if (data.success) {
          setRecords(data.records);
          setUpdatedAt(Date.now());
        }
      });
  }

  const handleKeydown = (event) => {
    if (event.key === 'ArrowRight') {
      nextRecord()
    } else if (event.key === 'ArrowLeft') {
      previousRecord()
    }
  }

  const nextRecord = () => {
    if (activeRecordIndex < records.length - 1) {
      setActiveRecordIndex(activeRecordIndex + 1);
    }
  }

  const previousRecord = () => {
    if (activeRecordIndex > 0) {
      setActiveRecordIndex(activeRecordIndex - 1);
    }
  }

  const textDescription = (description) => {
    var text = description.replace(/<\/?[^>]+(>|$)/g, "");

    if (text.length > 100) {
      return text.substring(0, 100) + '...';
    }

    return text;
  }

  const selectFeed = (feedId) => {
    const index = feedsSelected.indexOf(feedId);

    if (index !== -1) {
      setFeedsSelected([...feedsSelected.slice(0, index), ...feedsSelected.slice(index + 1)]);
    } else {
      setFeedsSelected([...feedsSelected, feedId]);
    }
  }

  const isFeedSelected = (feedId) => {
    return feedsSelected.indexOf(feedId) > -1;
  }

  const renderFilterFeedsOptions = () => {
    return feeds.map((feed) => {
      return (
        <div className="form-check ms-3" key={feed.id}>
          <input className="form-check-input" type="checkbox" value={feed.id} id="feedsSelected" onChange={() => selectFeed(feed.id)} checked={isFeedSelected(feed.id)} />
          <label className="form-check-label" htmlFor="feedsSelected">
            {feed.name}
          </label>
        </div>
      )
    })
  }

  const renderRecords = () => {
    return records.map((record, index) => {
      // if (record.feed_id in feedsSelected) {
        return (
          <div className="list-group-item list-group-item-action" aria-current="true" key={record.id} role="button" onClick={() => setActiveRecordIndex(index)} index={index}>
            <div className="d-flex w-100 justify-content-between">
              <h5 className="mb-1">
                {faviconUrl(record.source_url)}

                {record.title}
              </h5>
              <small>{formatDate(record.published_at)}</small>
            </div>
            {/* <p className="mb-1">Some placeholder content in a paragraph.</p> */}
            <small>{textDescription(record.description)}</small>
          </div>
        )
      // }
    })
  }

  const faviconUrl = (url) => {
    if (!url) {
      return "📰";
    }

    const urlObject = new URL(url);
    const path = `https://www.google.com/s2/favicons?sz=256&domain=${urlObject.hostname}`;

    return <img src={path} width="20" height="20" alt="" className="me-1" title={url} />;
  }

  const renderRecordBody = (record) => {
    return <div dangerouslySetInnerHTML={{ __html: record.description }} />;
  }

  const handleRefreshClick = () => {
    fetchFeeds();
    fetchRecords();
  }

  return <div className="container mt-3" onKeyDown={handleKeydown}>
    <div className="row">
      <div className="col-md-3">
        <div className="dropdown">
          <button className="btn btn-secondary dropdown-toggle" type="button" id="checkboxDropdown" data-bs-toggle="dropdown" aria-expanded="false">
            Filter
          </button>
          <div className="dropdown-menu p-2" aria-labelledby="checkboxDropdown">
            Order by:
            <select className="form-select form-select-sm mb-3" onChange={(e) => { setOrderBy(e.target.value) }} defaultValue={orderBy}>
              <option value="desc">Newest</option>
              <option value="asc">Oldest</option>
            </select>

            Show feeds:
            <form>
              {renderFilterFeedsOptions()}
            </form>
          </div>
        </div>
      </div>
      <div className="col-md-6 text-center">
        <button type="button" className="btn btn-primary mb-3" onClick={handleRefreshClick}>
          <i className="bi bi-arrow-clockwise"></i>
          Refresh
        </button>
      </div>
      <div className="col-md-3 text-end">
        Updated at: <span className="badge bg-success">{formatDate(updatedAt/1000)}</span>
      </div>
    </div>

    <div className="list-group">
      {renderRecords()}
    </div>

    <div className="modal fade " id="viewRecordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabIndex={-1} aria-labelledby="viewRecordModalLabel" aria-hidden="true">
      <div className="modal-dialog modal-lg">
        <div className="modal-content">
          <ArrowsComponent onLeftArrowClick={previousRecord} onRightArrowClick={nextRecord}>
            <div className="modal-header">
              <div>
                <a className="h1 modal-title fs-5" href={viewRecord.link} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
                  {viewRecord.title} 🔗
                </a>
                <h2 className="fs-6">
                  {faviconUrl(viewRecord.source_url)}
                  <span className="badge bg-success">{viewRecord.source}</span>
                  <span className="badge text-bg-secondary ms-1">{formatDate(viewRecord.published_at)}</span>
                </h2>
              </div>
              <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close" />
            </div>
            <div className="modal-body">
              {renderRecordBody(viewRecord)}
            </div>
          </ArrowsComponent>
          {/* <div className="modal-footer"></div> */}
        </div>
      </div>
    </div>
  </div>
}

export default Index
