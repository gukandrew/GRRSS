import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Create from "../components/feed/Create";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/add" element={<Create />} />
    </Routes>
  </Router>
);
