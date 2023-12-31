import React from "react";
import { Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Create from "../components/feed/Create";
import FeedsIndex from "../components/feed/Index";
import ItemsIndex from "../components/item/Index";

export default (
  <>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/add" element={<Create />} />
      <Route path="/feeds" element={<FeedsIndex />} />
      <Route path="/items" element={<ItemsIndex />} />
    </Routes>
  </>
);
