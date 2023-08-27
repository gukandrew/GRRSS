const fetchStatistics = (setItem) => {
  fetch('/api/statistics', {
    method: 'GET',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
  }).then(response => response.json())
    .then(data => {
      if (data.success) {
        setItem('statistics', data);
      } else {
        alert('Something went wrong! Check the enered data and try again.');
      }
    });
}

export { fetchStatistics };
