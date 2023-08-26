import React from "react";

const ArrowsComponent = ({ children, onLeftArrowClick, onRightArrowClick }) => {
  return (
    <div className="d-flex justify-content-center align-items-center vh-100">
      <div className="d-flex justify-content-between w-100 h-100">
        <button className="btn btn-light" onClick={onLeftArrowClick}>
          <i className="bi bi-arrow-left"></i>
        </button>
        <div style={{ overflowY: 'scroll' }}>{children}</div>
        <button className="btn btn-light" onClick={onRightArrowClick}>
          <i className="bi bi-arrow-right"></i>
        </button>
      </div>
    </div>
  );
}

export default ArrowsComponent;
