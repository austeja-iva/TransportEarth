
const API_KEY_DISTANCE = "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImUyNzQ2MTRmNDdiNTQwZDY4ZmUwMjM4YWRmNzVmODNiIiwiaCI6Im11cm11cjY0In0=";
const API_KEY_GEOCODE = "6a52b70157b03893596038csr272c94";

async function getCarInfo(origin, destination) {
  const body = JSON.stringify({
    coordinates: [
      [origin[0], origin[1]],
      [destination[0], destination[1]],
    ],
  });

  console.log("Request body:", body);

  const response = await fetch("https://api.openrouteservice.org/v2/directions/driving-car", {
    method: "POST",
    headers: {
      Accept: "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8",
      "Content-Type": "application/json",
      Authorization: API_KEY_DISTANCE,
    },
    body,
  });

  console.log("Status:", response.status);
  let responseBody = await response.text();
  console.log("Body:", responseBody);
  let distance = JSON.parse(responseBody)["routes"][0]["summary"]["distance"];
  let duration = JSON.parse(responseBody)["routes"][0]["summary"]["duration"];
  console.log("Distance:", distance);
  console.log("Duration:", duration);
}

getCarInfo([8.681495, 49.41461], [8.687872, 49.420318]);