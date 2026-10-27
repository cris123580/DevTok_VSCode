// const DEVTOK_API = (() => {
//   const livePorts = ["5500", "5501", "5173", "3000"];

//   if (livePorts.includes(location.port) || location.protocol === "file:") {
//     return "http://localhost/devtok/api";
//   }

//   return new URL("api/", location.href).href.replace(/\/$/, "");
// })();
const DEVTOK_API = "https://devtok.local/api";