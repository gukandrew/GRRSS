export function formatDate(timestamp) {
  const date = new Date(timestamp * 1000); // Convert the passed timestamp to milliseconds

  const day = date.getDate();
  const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const month = monthNames[date.getMonth()];
  const year = date.getFullYear();
  const hours = ('0' + date.getHours()).slice(-2); // Zero-padding
  const minutes = ('0' + date.getMinutes()).slice(-2); // Zero-padding

  return `${day} ${month} ${year} ${hours}:${minutes}`;
}
