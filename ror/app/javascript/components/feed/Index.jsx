import React, { useState, useEffect, useRef } from "react";
import { Modal } from "bootstrap"
import { formatDate } from "../../utils/datetime.js";

const Index = () => {
  const [records, setRecords] = useState([]);
  const [updatedTimestamp, _setUpdatedTimestamp] = useState([]);
  const [editRecord, setEditRecord] = useState({ name: '', url: '', active: false});
  const modal = useRef(null);

  useEffect(() => { // This will run only once for modal initialization
    modal.current = new Modal('#editRecordModal', {
      keyboard: true
    })
  }, [])

  useEffect(() => {
    fetch('/api/feeds', {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    }).then(response => response.json())
      .then(data => {
        if (data.success) {
          setRecords(data.records);
        }
      });
  }, [updatedTimestamp])

  const faviconUrl = (url) => {
    if (!url) {
      return "📰";
    }

    const urlObject = new URL(url);
    const faviconUrl = `${urlObject.protocol}//${urlObject.hostname}/favicon.ico`;

    return <img src={faviconUrl} width="20" height="20" alt="" className="me-1" title={url} />;
  }

  const renderRecords = () => {
    return records.map(record => {
      return (
        <div className="list-group-item list-group-item-action" aria-current="true" key={record.id} role="button" onClick={() => openEditModal(record)}>
          <div className="d-flex w-100 justify-content-between">
            <h5 className="mb-1">
              {faviconUrl(record.url)}
              {record.name}
            </h5>
            <div>
              {record.active ?
                <span title="Enabled">✅ </span> :
                <span title="Disabled">⛔ </span>
              }
              <small>{formatDate(record.created_at)}</small>
            </div>
          </div>
          {/* <p className="mb-1">Some placeholder content in a paragraph.</p> */}
          <small>{record.url}</small>
        </div>
      )
    })
  }

  const openEditModal = (record) => {
    setEditRecord(record);

    modal.current.show();
  }

  const updateRecordLocally = (updatedRecord) => {
    setRecords(records.map(record => {
      if (record.id === updatedRecord.id) {
        return updatedRecord;
      } else {
        return record;
      }
    }));
  }

  const handleSubmit = (event) => {
    event.preventDefault();

    fetch(`/api/feeds/${editRecord.id}`, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ feed: editRecord })
    }).then(response => response.json())
      .then(data => {
        if (data.success) {
          updateRecordLocally(editRecord);
          // setUpdatedTimestamp(Date.now()); // This will trigger useEffect() to fetch the latest records
          modal.current.hide();
        } else {
          alert('Something went wrong! Check the enered data and try again.');
        }
      });
  }

  const handleDestroy = (record) => {
    if (confirm('Are you sure?')) {
      fetch(`/api/feeds/${record.id}`, {
        method: 'DELETE',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
      }).then(response => response.json())
        .then(data => {
          if (data.success) {
            setRecords(records.filter(r => r.id !== record.id));
            modal.current.hide();
          } else {
            alert('Something went wrong! Check the enered data and try again.');
          }
        });
    }
  }

  return <div className="container mt-3">
    <div className="list-group">
      {renderRecords()}
    </div>

    <div className="modal fade" id="editRecordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabIndex={-1} aria-labelledby="editRecordModalLabel" aria-hidden="true">
      <div className="modal-dialog modal-dialog-centered">
        <div className="modal-content">
          <div className="modal-header">
            <h1 className="modal-title fs-5" id="editRecordModalLabel">
              Edit record
            </h1>
            <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close" />
          </div>
          <form onSubmit={handleSubmit}>
            <div className="modal-body">
              <div className="mb-3">
                <div className="mb-3">
                  <label htmlFor="name" className="form-label">Name</label>
                  <input type="text" className="form-control" id="name" aria-describedby="nameHelp" value={editRecord.name} onChange={(e) => setEditRecord({ ...editRecord, name: e.target.value })} />
                  <div id="nameHelp" className="form-text">Name of the feed</div>
                </div>

                <div className="mb-3">
                  <label htmlFor="url" className="form-label">URL</label>
                  <input type="text" className="form-control" id="url" aria-describedby="urlHelp" value={editRecord.url} onChange={(e) => setEditRecord({ ...editRecord, url: e.target.value })} />
                  <div id="urlHelp" className="form-text">URL of the feed</div>
                </div>

                <div className="mb-3 form-check">
                  <label htmlFor="active" className="form-check-label">Active</label>
                  <input type="checkbox" className="form-check-input" id="active" aria-describedby="activeHelp" checked={editRecord.active} onChange={(e) => setEditRecord({ ...editRecord, active: e.target.checked })} />
                  <div id="activeHelp" className="form-text">Is the feed active?</div>
                </div>
              </div>

              <div className="modal-footer justify-content-between">
                <button type="button" className="btn btn-danger me-1" onClick={() => handleDestroy(editRecord)}>
                  Destroy
                </button>

                <div>
                  <button type="submit" className="btn btn-primary me-1">
                    Update
                  </button>
                  <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">
                    Close
                  </button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
}

export default Index
