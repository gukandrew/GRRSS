import React from "react";
import Jumbotron from "./common/jumbotron";
import { useStorage } from './services/storage';

export default () => {
  const { getItem } = useStorage();
  const statistics = getItem('statistics') || { feeds: 0, items: 0 };

  return (<div className="container">
    <Jumbotron feedsCount={statistics.feeds} itemsCount={statistics.items} />
  </div>)
};
