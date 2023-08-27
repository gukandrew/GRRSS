import React, { createContext, useContext, useState } from 'react';

const StorageContext = createContext();

export function StorageProvider({ children }) {
  const [data, setData] = useState({}); // Initial data

  const setItem = (key, value) => {
    setData(prevData => ({
      ...prevData,
      [key]: value,
    }));
  };

  const getItem = key => data[key];

  const storageContextValue = {
    setItem,
    getItem,
  };

  return (
    <StorageContext.Provider value={storageContextValue}>
      {children}
    </StorageContext.Provider>
  );
}

export function useStorage() {
  return useContext(StorageContext);
}
