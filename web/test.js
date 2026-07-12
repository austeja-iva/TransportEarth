function buildApiUrl(departure, arrival, date) {
  const params = new URLSearchParams({
    departure_id: departure.trim().toUpperCase(),
    arrival_id: arrival.trim().toUpperCase(),
    outbound_date: date,
    type: '2',
    currency: 'USD',
    hl: 'en',
  });

  return `/api/flights?${params.toString()}`;
}

// Calls the local proxy endpoint
async function getFlightData(departure, arrival, date) {
    const apiUrl = buildApiUrl(departure, arrival, date);
    try {
        // Browser requests local endpoint
        const response = await fetch(apiUrl);

        // Tests if the request is successful. If it returns an error, it provides status and response body
        if (!response.ok) {
            const body = await response.text();
            throw new Error(`HTTP ${response.status} ${body}`);
        }
        // Parses the JSON body
        const flightData = await response.json();

        // Logs full payload
        console.log(flightData);
        // Returns raw flight data
        return flightData;
    } catch (error) {
        // If error happens, then it returns null
        console.error('Error reading API: ', error);
        return null;
    }
}

// Picks the best flights by price, time, and emissions
function findFlights(flightData) {
    // Google flights results 
    const flights = flightData?.best_flights || [];

    if (!Array.isArray(flights) || flights.length === 0) {
        return null;
    }

    // Finds cheapest flight
    const bestPrice = flights.reduce((best, current) =>
        (current.price || Infinity) < (best.price || Infinity) ? current : best
    );

    // Finds shortest time duration
    const bestDuration = flights.reduce((best, current) =>
        (current.total_duration || Infinity) < (best.total_duration || Infinity) ? current : best
    );

    // Finds lowest carbon emission
    const bestEmissions = flights.reduce((best, current) =>
        (current.carbon_emissions?.this_flight || Infinity) < (best.carbon_emissions?.this_flight || Infinity)
            ? current
            : best
    );

    return {
        totalFlights: flights.length,
        bestPrice,
        bestDuration,
        bestEmissions,
    };
}

// Fetches data, computes the summaries, and returns output
async function runFlightsDemo() {
    const flightData = await getFlightData();
    if (!flightData) {
        return null;
    }

    const results = findFlights(flightData);
    console.log('Flight summary:', results);
    return results;
}

// Expose for browser button click or console use
if (typeof window !== 'undefined') {
    window.runFlightsDemo = runFlightsDemo;
}
