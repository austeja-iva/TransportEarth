// import express
// parse the json file
// take in time, price, and carbon emissions
// return the 3 best options: one best for time, price, emissions

async function getFlightData(params) {
    // send request
    const response = "https://serpapi.com/google-flights-api";

    // test if request successful
    if (!response.ok) throw new Error(response.status);
    // parse the data
    return response.json();

    // use data
}

// call function
getFlightData();
