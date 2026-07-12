
const http = require('http');
const fs = require('fs');
const path = require('path');

const HOST = '127.0.0.1';
const PORT = Number(process.env.PORT) || 8081;
const API_KEY = process.env.SERPAPI_KEY;

if(!API_KEY) throw new Error('Key is not configured');

// Send the json responses with status code and utf-8 content type
function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(payload));
}

// Servers static files index and test from disk
function sendFile(res, filePath, contentType) {
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Not found');
      return;
    }

    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
}

// Proxies the flight search to SerAPI  so the browser calls have the same origin
// This is so the API key is not exposed in the browser
async function handleApiFlights(reqUrl, res) {
  try {
    // Parses the query params
    const incoming = new URL(reqUrl, `http://${HOST}:${PORT}`);
    const params = new URLSearchParams(incoming.search);

    // Provides default route options
    if (!params.has('departure_id')) params.set('departure_id', 'JFK');
    if (!params.has('arrival_id')) params.set('arrival_id', 'LAX');
    if (!params.has('outbound_date')) params.set('outbound_date', '2026-08-01');
    if (!params.has('type')) params.set('type', '2');
    if (!params.has('currency')) params.set('currency', 'USD');
    if (!params.has('hl')) params.set('hl', 'en');

    // Forwards request to SerAPI with the engine and API key
    const upstream = await fetch(
      `https://serpapi.com/search.json?engine=google_flights&${params.toString()}&api_key=${API_KEY}`
    );

    const text = await upstream.text();

    // Bubbles up upstream errors to the browser unchanged 
    if (!upstream.ok) {
      res.writeHead(upstream.status, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end(text);
      return;
    }

    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(text);
  } catch (error) {
    sendJson(res, 500, { error: `Proxy request failed: ${error.message}` });
  }
}

// Main router for API and static asset requests
const server = http.createServer(async (req, res) => {
  if (!req.url) {
    sendJson(res, 400, { error: 'Bad request' });
    return;
  }

  const url = new URL(req.url, `http://${HOST}:${PORT}`);

  if (url.pathname === '/api/flights') {
    await handleApiFlights(req.url, res);
    return;
  }

  if (url.pathname === '/' || url.pathname === '/index.html') {
    sendFile(
      res, 
      path.join(__dirname, '../../web/index.html'), 
      'text/html; charset=utf-8'
    );
    return;
  }

  if (url.pathname === '/test.js') {
    sendFile(res, path.join(__dirname, 'test.js'), 'application/javascript; charset=utf-8');
    return;
  }

  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('Not found');
});

// Starts local server for Chrome at the http://127.0.0.1:<PORT>
server.listen(PORT, HOST, () => {
  console.log(`Server running at http://${HOST}:${PORT}`);
});

