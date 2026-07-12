const API_KEY_DISTANCE = "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImUyNzQ2MTRmNDdiNTQwZDY4ZmUwMjM4YWRmNzVmODNiIiwiaCI6Im11cm11cjY0In0=";
const API_KEY_GEOCODE = "6a52b70157b03893596038csr272c94";

async function getCarInfo(origin = '', destination = '') {
    try {
        if (typeof origin === 'string' && typeof destination === 'string') {
            return JSON.stringify(await getCarRoute(origin, destination));
        }

        return JSON.stringify(await getCarInfoData(origin, destination));
    } catch (error) {
        return JSON.stringify({ error: error?.message || String(error) });
    }
}

async function getBikeInfo(origin = '', destination = '') {
    try {
        if (typeof origin === 'string' && typeof destination === 'string') {
            return JSON.stringify(await getBikeRoute(origin, destination));
        }

        return JSON.stringify(await getBikeInfoData(origin, destination));
    } catch (error) {
        return JSON.stringify({ error: error?.message || String(error) });
    }
}

async function getCarInfoData(origin, destination) {
    const body = JSON.stringify({
        coordinates: [
            [origin[0], origin[1]],
            [destination[0], destination[1]],
        ],
    });

    const response = await fetch("https://api.openrouteservice.org/v2/directions/driving-car", {
        method: "POST",
        headers: {
            Accept: "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8",
            "Content-Type": "application/json",
            Authorization: API_KEY_DISTANCE,
        },
        body,
    });

    let responseBody = await response.text();
    let distance = JSON.parse(responseBody)["routes"][0]["summary"]["distance"];
    let duration = JSON.parse(responseBody)["routes"][0]["summary"]["duration"];
    return { distance, duration, co2: distance * 0.4 };
}

async function getBikeInfoData(origin, destination) {
    const body = JSON.stringify({
        coordinates: [
            [origin[0], origin[1]],
            [destination[0], destination[1]],
        ],
    });

    const response = await fetch("https://api.openrouteservice.org/v2/directions/cycling-regular", {
        method: "POST",
        headers: {
            Accept: "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8",
            "Content-Type": "application/json",
            Authorization: API_KEY_DISTANCE,
        },
        body,
    });

    let responseBody = await response.text();
    let distance = JSON.parse(responseBody)["routes"][0]["summary"]["distance"];
    let duration = JSON.parse(responseBody)["routes"][0]["summary"]["duration"];
    return { distance, duration, co2: 0.0 };
}

async function getCoordsFromAddress(address) {
    const url = `https://geocode.maps.co/search?q=${encodeURIComponent(address)}&api_key=${API_KEY_GEOCODE}`;
    return (await fetch(url)).text();
}

async function getCarRoute(originAddress, destinationAddress) {
    var oCoords = await getCoordsFromAddress(originAddress);
    var olat = parseFloat(JSON.parse(oCoords)[0]["lat"]);
    var olng = parseFloat(JSON.parse(oCoords)[0]["lon"]);
    var originCoords = [olng, olat];
    var dCoords = await getCoordsFromAddress(destinationAddress);
    var dlat = parseFloat(JSON.parse(dCoords)[0]["lat"]);
    var dlng = parseFloat(JSON.parse(dCoords)[0]["lon"]);
    var destinationCoords = [dlng, dlat];
    return await getCarInfoData(originCoords, destinationCoords);
}

async function getBikeRoute(originAddress, destinationAddress) {
    var oCoords = await getCoordsFromAddress(originAddress);
    var olat = parseFloat(JSON.parse(oCoords)[0]["lat"]);
    var olng = parseFloat(JSON.parse(oCoords)[0]["lon"]);
    var originCoords = [olng, olat];
    var dCoords = await getCoordsFromAddress(destinationAddress);
    var dlat = parseFloat(JSON.parse(dCoords)[0]["lat"]);
    var dlng = parseFloat(JSON.parse(dCoords)[0]["lon"]);
    var destinationCoords = [dlng, dlat];
    return await getBikeInfoData(originCoords, destinationCoords);
}
