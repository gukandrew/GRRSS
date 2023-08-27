import React, { useEffect } from 'react';
import { fetchStatistics } from "../services/statistics";
import { Link } from "react-router-dom";
import { useStorage } from '../services/storage.jsx';

export default () => {
  const { setItem } = useStorage();

  useEffect(() => {
    fetchStatistics(setItem)
  }, []);

  const { getItem } = useStorage();
  const statistics = getItem('statistics') || { feeds: 0, items: 0 };

  return <nav className="navbar navbar-expand-lg bg-body-tertiary">
    <div className="container"><a className="navbar-brand" href="/">GRRSS</a><button aria-controls="navbarSupportedContent"
      aria-expanded="false" aria-label="Toggle navigation" className="navbar-toggler"
      data-bs-target="#navbarSupportedContent" data-bs-toggle="collapse" type="button"><span
        className="navbar-toggler-icon"></span></button>
      <div className="collapse navbar-collapse" id="navbarSupportedContent">
        <ul className="navbar-nav me-auto mb-2 mb-lg-0">
          {statistics.feeds > 0 &&
            <li className="nav-item">
              <Link to="/feeds" className="nav-link">Feeds</Link>
            </li>
          }
          {statistics.items > 0 &&
            <li className="nav-item">
              <Link to="/items" className="nav-link">Items</Link>
            </li>
          }
        </ul>
        <div className="d-flex">
          <div className="nav-item"><a className="btn btn-outline-success" href="/add">Add feeds</a></div>
        </div>
      </div>
    </div>
  </nav>
}
