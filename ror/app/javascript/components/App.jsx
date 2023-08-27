import React from "react";
import { BrowserRouter } from "react-router-dom";
import Routes from "../routes";
import { StorageProvider } from './services/storage';
import Navbar from './common/navbar';

const App = () => {
  return <StorageProvider>
    <BrowserRouter>
      <Navbar />
      <div>
        <div className="container mt-3">
          {Routes}
        </div>
      </div>
    </BrowserRouter>
  </StorageProvider>;
};

export default App;


