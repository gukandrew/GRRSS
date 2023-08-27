import React from 'react';

const Jumbotron = (props) => {
  return <div className="p-5 mb-4 bg-light rounded-3">
    <div className="container-fluid py-5">
      <h1 className="display-5 fw-bold">GRRSS - RSS Reader App</h1>
      <div className="col-md-8 fs-4">
        <p>Welcome to the RSS reader application. Stay up-to-date with your favorite feeds from around the web.</p>
        <p>With our user-friendly interface, you can easily subscribe to, organize, and read the latest articles and news from various sources.</p>
      </div>

      <div className="fs-4 my-3 text-muted">Currently you have {props.feedsCount} feeds with {props.itemsCount} items in total.</div>

      <a className="btn btn-primary btn-lg" href="/add">Add feeds</a>

      {props.feedsCount > 0 && <a className="btn btn-secondary btn-lg ms-3" href="/feeds">Manage feeds</a>}
      {props.itemsCount > 0 && <a className="btn btn-success btn-lg ms-3" href="/items">👁️‍🗨️ Read</a>}
    </div>
  </div>
}

export default Jumbotron;
