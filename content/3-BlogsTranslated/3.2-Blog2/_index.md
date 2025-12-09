---
title: "Blog 2"
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

# New features and developer experience with enhanced Amazon Location Service

This blog post was written by Yasunori Kirimoto – CEO of MIERUNE

Building geospatial applications requires expertise in handling geospatial data, as well as designing and developing systems. It also requires skills in collecting and managing vast amounts of geospatial data and using it effectively within the application. This process can be very labor intensive, but its complexity can be greatly reduced by leveraging Amazon Location Service.

With Amazon Location Service, highly accurate geospatial data can be quickly obtained from APIs, allowing developers to focus on building applications. In addition, Amazon Location Service has been updated, adding new features in addition to its previous functionality. We’ll introduce the new features of Amazon Location Service and demonstrate how to leverage them in your application.

---

## New features released from Amazon Location Service

The biggest change is that resource creation is no longer required. This means users no longer need to create individual resources (such as Place Indexes, Maps, and Route Calculators), but can set up an API key and immediately start using Amazon Location Service.

In addition, significant enhancements and new features have been added to the Maps, Places, and Routes APIs. The Maps API has been updated with additional styles, as well as the new static map capability. The Places API has been enhanced with new search and geocoding capabilities. Finally, the Routes API has been updated with new features such as Snap to Road, Waypoint Optimization, and additional travel modes.
## Creating API Keys
In order to create an API Key, we can utilize the AWS Management Console, or the AWS Cloud Control API. For this example, we will use the console. Navigate to the Amazon Location Service Console, and select API keys under Manage resources. Select Create API key
For the purposes of our demonstration, we will name the API Key LasVegasMaps and select the following actions:

– GetStaticMap
– GetTile
– Geocode
– GetPlace
– SearchNearby
– SearchText
– CalculateIsolines
– SnapToRoads

Scrolling down, we have additional options including the ability to set an Expire time, and Referers. These are optional, but we highly recommend them for production applications. NOTE: For the purposes of this demonstration we are leaving these as Default.


Select **Create API key**.
Now with the API Key created, we need to retrieve the value to use in our application. Select Show API key value and copy the value into a safe location.
## New Maps API features
First, we will highlight and introduce the GetStyleDescriptor and GetStaticMap functions.
## Building the foundation for a map application with GetStyleDescriptor
The GetStyleDescriptor function allows you to retrieve map style information and quickly build the foundation for your map application. This feature could be used for various geospatial solutions and application foundations. The new version offers expanded map styles, purpose-built for different applications—offering dark and light mode with varying levels of map detail.

We will demonstrate how to take advantage of these map styles using MapLibre GL JS. We’ll create a very straightforward HTML page using MapLibre GL JS and Amazon Location Service API Keys.

Begin by creating a blank HTML page, naming it simpleMap.html, and copying the following code into the page:
```yaml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon Location Service Map</title>

    <!-- MapLibre GL CSS -->
    <link href="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
        }
        #map {
            height: 100vh; /* Full viewport height */
        }
    </style>
</head>

<body>
    <!-- Map container -->
    <div id="map"></div>

    <!-- JavaScript dependencies -->
    <script src="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.js"></script>

    <script>
        // Configuration
        const region = "<AWS Region>"; // Replace with your AWS region
        const mapApiKey = "<Your API Key>"; // Replace with your Amazon Location Service API key

        async function initializeMap() {
            // Initialize the map
            const map = new maplibregl.Map({
                container: "map", // HTML element ID where the map will be rendered
                center: [-115.1473824627421, 36.17071351509272], // Initial map center coordinates (Las Vegas)
                zoom: 12, // Initial zoom level
                style: `https://maps.geo.${region}.amazonaws.com/v2/styles/Standard/descriptor?&color-scheme=Light&variant=Default&key=${mapApiKey}`, // Map style URL
            });

            // Add navigation controls to the map
            map.addControl(new maplibregl.NavigationControl(), "top-left");
        }

        // Call the function to initialize the map
        initializeMap();
    </script>
</body>
</html>
```
Now open this HTML page in a browser. You should see a map of Las Vegas, NV. The key to this map is the style URL we set previously in our code. In this URL, we’ve requested that we use the Standard style map in a light color scheme. We can add additional parameters such as political views as well.
## Creating a static map image with GetStaticMap
zoom level, and image size you specify. This feature helps include map images in printed materials and media posts. There are various parameters for this feature, including the ability to overlay other data (such as points, lines and polygons). We’ve provided a basic example. Be certain to edit the URL for your AWS Region and your newly created API Key. Paste the following URL into the address bar of your web browser to display a static map image of the specified location:
**https://maps.geo.<Your AWS Region>.amazonaws.com/v2/static/map?center=-115.170,36.122&zoom=15&width=1024&height=1024&key=<Your API Key>**
## New Places API features
Next, we will highlight and introduce the SearchText and SearchNearby features
## Searching for specified POI data with SearchText
The SearchText feature allows users to search for and present specified points of interest (POI) data. This feature is designed for users to quickly search for a specific location or facility. Users can send a POST request with the specified parameters and receive a response containing candidate point data. We will demonstrate an example of visualizing that data on a map.

Create a new HTML file named searchText.html and paste the following contents into the file:
```yaml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon Location Service – Search Text</title>

    <link href="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.css" rel="stylesheet" />
    <style>
      body {
        margin: 0;
      }
      #map {
        height: 100vh;
      }
    </style>
  </head>

  <body>
    <!-- map container -->
    <div id="map"></div>
    <!-- JavaScript dependencies -->
    <script src="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.js"></script>
    <!-- Import the Amazon Location Client -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-client@1"></script>
    <!-- Import the utility library -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-utilities-datatypes@1"></script>
    <script>
      // Configuration
      // Set the AWS region for Amazon Location Service
      const region = "<AWS Region>";
      // API key for authenticating requests
      const mapApiKey = "<Amazon Location Service API Key>";
    
      async function initializeMap() {
        // Create an authentication helper using the API key
        const authHelper = await amazonLocationClient.withAPIKey(mapApiKey, region);
        
        // Initialize the Amazon Location Service Places client
        const client = new amazonLocationClient.places.GeoPlacesClient(
          authHelper.getClientConfig()
        );
    
        // Define search parameters for coffee shops
        const SearchTextInput = {
          BiasPosition: [-115.170, 36.122], // Las Vegas coordinates
          MaxResults: 25,
          QueryText: "Coffee Shops"
        }
    
        // Perform the search using Amazon Location Service
        const searchResults = await client.send(
          new amazonLocationClient.places.SearchTextCommand(SearchTextInput)
        )
    
        // Initialize the map
        const map = new maplibregl.Map({
          container: "map",
          center: [-115.170, 36.122], // Las Vegas coordinates
          zoom: 14,
          style: `https://maps.geo.${region}.amazonaws.com/v2/styles/Standard/descriptor?&color-scheme=Light&variant=Default&key=${mapApiKey}`,
        });
    
        // Add navigation controls to the map
        map.addControl(new maplibregl.NavigationControl(), "top-left");
    
        // When the map is loaded, add search results as a layer
        map.on("load", () => {
          // Convert search results into a GeoJSON FeatureCollection
          const featureCollection = amazonLocationDataConverter.searchTextResponseToFeatureCollection(searchResults);
    
          // Add a data source containing GeoJSON from the search results
          map.addSource("place-index-results", {
            type: "geojson",
            data: featureCollection,
          });
    
          // Add a new layer to visualize the points
          map.addLayer({
            id: "place-index-results",
            type: "circle",
            source: "place-index-results",
            paint: {
              "circle-radius": 8,
              "circle-color": "#0080ff",
            },
          });
    
          // Add click event listener for the search result points
          map.on('click', 'place-index-results', (e) => {
            if (e.features.length > 0) {
              const feature = e.features[0];
              const coordinates = feature.geometry.coordinates.slice();
              
              // Create a formatted HTML string with the feature's properties
              const properties = feature.properties;
              let description = '<h3>' + (properties['Title'] || 'Unnamed Location') + '</h3>';
              description += '<p>Address: ' + (properties['Address.Label'] || 'N/A') + '</p>';
    
              // Create and display a popup with the location information
              new maplibregl.Popup()
                .setLngLat(coordinates)
                .setHTML(description)
                .addTo(map);
            }
          });
          map.on('mouseenter', 'place-index-results', () => {
            map.getCanvas().style.cursor = 'pointer';
          });
          map.on('mouseleave', 'place-index-results', () => {
            map.getCanvas().style.cursor = '';
          });
        });
      }
    
      // Call the function to initialize the map
      initializeMap();
    </script>
  </body>
</html>
```
Opening the HTML file in a browser will show the following map with coffee shops centered around the Venetian Resort in Las Vegas, NV.
## Searching to retrieve POI data around a specified location with SearchNearby

The SearchNearby function allows you to retrieve POI data near a specified location. This feature is handy for users to search for nearby stores and attractions. Users can send a POST request with the specified parameters and receive a response containing candidate point data. We will demonstrate an example of visualizing that data on a map.

Create a new HTML file named searchNearby.html and paste the following contents into the file:
```yaml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon Location Service – Search Nearby</title>

    <link href="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.css" rel="stylesheet" />
    <style>
      body {
        margin: 0;
      }
      #map {
        height: 100vh;
      }
    </style>
  </head>

  <body>
    <!-- map container -->
    <div id="map"></div>
    <!-- JavaScript dependencies -->
    <script src="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.js"></script>
    <!-- Import the Amazon Location Client -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-client@1"></script>
    <!-- Import the utility library -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-utilities-datatypes@1"></script>
    <script>
      // Configuration
      
      // Set the AWS region for Amazon Location Service
      const region = "<AWS Region>";
      // API key for authenticating map requests
      const mapApiKey = "<Amazon Location Service API Key>";
    
      async function initializeMap() {
        // Create an authentication helper using the API key
        const authHelper = await amazonLocationClient.withAPIKey(mapApiKey, region);
        
        // Initialize the Amazon Location Service Places client
        const client = new amazonLocationClient.places.GeoPlacesClient(
          authHelper.getClientConfig()
        );
    
        // Define search parameters for nearby casinos and hotels
        const SearchNearbyInput = {
          QueryPosition: [-115.170, 36.122], // Las Vegas coordinates
          MaxResults: 25,
          Filter: {
            IncludeCategories: [
              "casino",
              "hotel"
            ]
          }
        }
    
        // Perform the nearby search using Amazon Location Service
        const searchResults = await client.send(
          new amazonLocationClient.places.SearchNearbyCommand(SearchNearbyInput)
        )
    
        // Initialize the map
        const map = new maplibregl.Map({
          container: "map",
          center: [-115.170, 36.122], // Las Vegas coordinates
          zoom: 15,
          style: `https://maps.geo.${region}.amazonaws.com/v2/styles/Standard/descriptor?&color-scheme=Light&variant=Default&key=${mapApiKey}`,
        });
    
        // Add navigation controls to the map
        map.addControl(new maplibregl.NavigationControl(), "top-left");
    
        // When the map is loaded, add search results as a layer
        map.on("load", () => {
          // Convert search results into a GeoJSON FeatureCollection
          const featureCollection = amazonLocationDataConverter.searchNearbyResponseToFeatureCollection(searchResults);
    
          // Add a data source containing GeoJSON from the search results
          map.addSource("place-index-results", {
            type: "geojson",
            data: featureCollection,
          });
        
          // Add a new layer to visualize the points
          map.addLayer({
            id: "place-index-results",
            type: "circle",
            source: "place-index-results",
            paint: {
              "circle-radius": 8,
              "circle-color": "#0080ff",
            },
          });
    
          // Add click event listener for the search result points
          map.on('click', 'place-index-results', (e) => {
            if (e.features.length > 0) {
              const feature = e.features[0];
              const coordinates = feature.geometry.coordinates.slice();
              
              // Create a formatted HTML string with the feature's properties
              const properties = feature.properties;
              let description = '<h3>' + (properties['Title'] || 'Unnamed Location') + '</h3>';
              description += '<p>Address: ' + (properties['Address.Label'] || 'N/A') + '</p>';
    
              // Create and display a popup with the location information
              new maplibregl.Popup()
                .setLngLat(coordinates)
                .setHTML(description)
                .addTo(map);
            }
          });
          map.on('mouseenter', 'place-index-results', () => {
            map.getCanvas().style.cursor = 'pointer';
          });
          map.on('mouseleave', 'place-index-results', () => {
            map.getCanvas().style.cursor = '';
          });
        });
      }
    
      // Call the function to initialize the map
      initializeMap();
    </script>
  </body>
</html>
```
Opening the HTML file in a browser will show the following map showing hotel and casino locations centered around the Venetian Resort in Las Vegas, NV.

## New Routes API features
Finally, we will discuss the new CalculateIsolines and SnapToRoads functions.
## Find the reachable range from a specified location with CalculateIsolines
The CalculateIsolines function can retrieve the reachable range from a specified point. Some use cases for Isolines include identifying deliverable areas and evaluating property locations. Users can send a POST request with the specified parameters and receive a response containing polygon data indicating the reachable area. We will demonstrate an example of visualizing that data on a map.

Create a new HTML file and name it calculateIsolines.html and paste the following contents into the file:
```yaml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon Location Service - Isolines</title>

    <link href="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.css" rel="stylesheet" />
    <style>
      body {
        margin: 0;
      }
      #map {
        height: 100vh;
      }
    </style>
  </head>

  <body>
    <!-- map container -->
    <div id="map"></div>
    <!-- JavaScript dependencies -->
    <script src="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.js"></script>
    <!-- Import the Amazon Location Client -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-client@1"></script>
    <!-- Import the utility library -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-utilities-datatypes@1"></script>
    <script>
      // Configuration
      
      // Set the AWS region for the Amazon Location Service
      const region = "<AWS Region>";
      // API key for authenticating map requests
      const mapApiKey = "<Amazon Location Service API Key";
    
      async function initializeMap() {
        // Create an authentication helper using the API key
        const authHelper = await amazonLocationClient.withAPIKey(mapApiKey, region);
        
        // Initialize the Amazon Location Service Routes client
        const client = new amazonLocationClient.routes.GeoRoutesClient(
          authHelper.getClientConfig()
        );
    
        // Define parameters for calculating isolines
        const IsolinesInput = {
          Origin: [-115.17015436843275, 36.12122662193694], // Starting point coordinates
          Thresholds: {
            Time: [
              300, 600, 900 // Time thresholds in seconds
            ]
          },
          TravelMode: "Pedestrian" // Travel mode for isoline calculation
        }
    
        // Calculate isolines using Amazon Location Service
        const routeResults = await client.send(
          new amazonLocationClient.routes.CalculateIsolinesCommand(IsolinesInput)
        )
    
        // Initialize the map
        const map = new maplibregl.Map({
          container: "map",
          center: [-115.16766776735061, 36.12177195550658], // Map center coordinates
          zoom: 15,
          style: `https://maps.geo.${region}.amazonaws.com/v2/styles/Standard/descriptor?&color-scheme=Light&variant=Default&key=${mapApiKey}`,
        });
    
        // Add navigation controls to the map
        map.addControl(new maplibregl.NavigationControl(), "top-left");
    
        // Add a marker at the origin point
        const marker = new maplibregl.Marker()
          .setLngLat([-115.17015436843275, 36.12122662193694])
          .addTo(map)
    
        // When the map is loaded, add isolines as layers
        map.on("load", () => {
          // Convert isoline results into a GeoJSON FeatureCollection
          const featureCollection = amazonLocationDataConverter.calculateIsolinesResponseToFeatureCollection(routeResults);
    
          // Add a data source containing GeoJSON from the isoline results
          map.addSource("isolines", {
            type: "geojson",
            data: featureCollection
          });
    
          // Add a fill layer to visualize the isoline areas
          map.addLayer({
            'id': 'isolines-fill-900',
            'type': 'fill',
            'source': 'isolines',
            'filter': ['==', ['get', 'TimeThreshold'], 900],
            'paint': {
              'fill-color': '#0000ff',
              'fill-opacity': 0.5
            }
          });

          // Add a layer for 600m (10)
          map.addLayer({
            'id': 'isolines-fill-600',
            'type': 'fill',
            'source': 'isolines',
            'filter': ['==', ['get', 'TimeThreshold'], 600],
            'paint': {
              'fill-color': '#00ff00',
              'fill-opacity': .5
            }
          });

          // Add a layer for 300m (5)
          map.addLayer({
            'id': 'isolines-fill-300',
            'type': 'fill',
            'source': 'isolines',
            'filter': ['==', ['get', 'TimeThreshold'], 300],
            'paint': {
              'fill-color': '#f10000',
              'fill-opacity': 0.5
            }
          });
    
          // Add an outline layer to highlight the isoline boundaries
          map.addLayer({
            'id': 'isolines-outline',
            'type': 'line',
            'source': 'isolines',
            'paint': {
              'line-color': '#000000',
              'line-width': 2
            }
          });
        });
      }
    
      // Call the function to initialize the map
      initializeMap();
    </script>
  </body>
</html>
```
Opening the HTML file in a browser will show the following map (Figure 9). This map shows walkable distances from the Venetian Resort in 5-, 15-, and 30-minute timeframes.
## Obtaining location-corrected route data with SnapToRoads
The SnapToRoads function allows you to snap GPS data and other location data to the nearest road and obtain line data after location correction. This feature is very useful in improving the accuracy of vehicle tracking and traffic analysis. Users can send a POST request with specified parameters and receive a response containing position-corrected line data. We will demonstrate an example of visualizing the data before and after processing on a map.

Create a new HTML file named snapToRoad.html and paste the following contents into the file:
```yaml
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon Location Service - Snap to Roads</title>

    <!-- MapLibre GL CSS -->
    <link href="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
        }
        #map {
            height: 100vh; /* Full viewport height */
        }
    </style>
</head>

<body>
    <!-- Map container -->
    <div id="map"></div>

    <!-- JavaScript dependencies -->
    <script src="https://unpkg.com/maplibre-gl@3.x/dist/maplibre-gl.js"></script>
    <!-- Amazon Location Client -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-client@1"></script>
    <!-- Amazon Location utility library -->
    <script src="https://cdn.jsdelivr.net/npm/@aws/amazon-location-utilities-datatypes@1"></script>

    <script>
        // Configuration
        const region = "<AWS Region>"; // Replace with your AWS region
        const mapApiKey = "<Amazon Location Service API Key>"; // Replace with your API key

        async function initializeMap() {
            // Create authentication helper
            const authHelper = await amazonLocationClient.withAPIKey(mapApiKey, region);
            // Initialize Amazon Location Service Routes client
            const client = new amazonLocationClient.routes.GeoRoutesClient(
                authHelper.getClientConfig()
            );

            // GPS trace coordinates
            const gpsTraceCoordinates = [
                [-115.14564318728544, 36.09359703860663],
                [-115.14522142988834, 36.09368914760097],
                [-115.14477687479442, 36.09345887491297],
                [-115.14452610012599, 36.093560194978636],
                [-115.14432092085157, 36.09364309311755],
                [-115.14383077036334, 36.09360624951118],
                [-115.14303285096376, 36.09360624951118],
                [-115.14273648090104, 36.09375362383305],
                [-115.14218933616989, 36.09353256224662],
                [-115.14163079259018, 36.0936154604141],
                [-115.14126602943631, 36.093633882217304],
                [-115.14136861907319, 36.09338518751021],
                [-115.14126602943631, 36.093035171404196],
                [-115.14093546282783, 36.092906217708844],
                [-115.140479508885, 36.09289700672278],
                [-115.14033132385379, 36.09270357576062],
                [-115.13951060675709, 36.09278647480254],
                [-115.13900905742025, 36.09291542869438],
                [-115.13839351959763, 36.09298911653757],
                [-115.1378349760179, 36.092906217708844],
                [-115.13733342668108, 36.09301674946067],
                [-115.13703705661834, 36.09286016276663]
             ];

            // Format trace points for Snap to Roads API
            const tracePoints = gpsTraceCoordinates.map(coord => ({
                Position: coord,
            }));    

            // Snap to Roads API input
            const SnapInput = {
                TracePoints: tracePoints
            };

            // Call Snap to Roads API
            const snapResults = await client.send(
                new amazonLocationClient.routes.SnapToRoadsCommand(SnapInput)
            );

            // Initialize the map
            const map = new maplibregl.Map({
                container: "map",
                center: [-115.14127503567818, 36.09249839687936], // Las Vegas area
                zoom: 16,
                style: `https://maps.geo.${region}.amazonaws.com/v2/styles/Standard/descriptor?&color-scheme=Light&variant=Default&key=${mapApiKey}`,
            });

            // Add navigation controls
            map.addControl(new maplibregl.NavigationControl(), "top-left");

            // When the map is loaded, add the GPS trace and snapped route
            map.on("load", () => {
                // Convert snap results to GeoJSON
                const featureCollection = amazonLocationDataConverter.snapToRoadsResponseToFeatureCollection(snapResults);

                // Add GPS trace source
                map.addSource("gpsTrace", {
                    type: "geojson",
                    data: {
                        type: "Feature",
                        geometry: {
                            type: "LineString",
                            coordinates: gpsTraceCoordinates
                        }
                    }
                });

                // Add snapped trace source
                map.addSource("snappedTrace", {
                    type: "geojson",
                    data: featureCollection
                });

                // Add GPS trace layer
                map.addLayer({
                    'id': 'gpsTrace',
                    'type': 'line',
                    'source': 'gpsTrace',
                    layout: {
                        "line-join": "round",
                        "line-cap": "round",
                    },
                    paint: {
                        "line-color": "#00b0ff",
                        "line-width": 8,
                    }
                });

                // Add snapped trace layer
                map.addLayer({
                    'id': 'snappedTrace',
                    'type': 'line',
                    'source': 'snappedTrace',
                    layout: {
                        "line-join": "round",
                        "line-cap": "round",
                    },
                    paint: {
                        "line-color": "#d59a9a",
                        "line-width": 8,
                    }
                });
            });
        }

        // Initialize the map
        initializeMap();
    </script>
</body>
</html>
```
Opening the HTML file in a browser will show the following map (Figure 10), with the blue line representing a GPS trace, and the red line representing a version that is snapped to roads.
## Cleanup
The only Amazon Location Service resources created during this demonstration was an API Key. To delete the API Key, navigate to the Amazon Location Service Console, select the API Key we created, and select Deactivate. Confirm your decision to deactivate the key, then select Delete. Also select that you would like to bypass the standard 90-day deactivation period.
## Conclusion
Amazon Location Service now offers even greater flexibility with the new features. With this update, the previously required resource creation procedure is no longer necessary, and various APIs can be used by setting an API key. This allows users to quickly and smoothly build geospatial applications.

Notable new features include GetStyleDescriptor and GetStaticMap in the Maps API, SearchText and SearchNearby in the Places API, and CalculateIsolines and SnapToRoads in the Routes API.

In the Maps API, GetStyleDescriptor can be used to retrieve various map styles and apply them to your application, and GetStaticMap can generate static map images based on the coordinates and zoom levels you specify. The Places API allows you to search POI data using SearchText, and SearchNearby will enable you to find POIs around a specific location. The Routes API can use CalculateIsolines to calculate reachability from a specified point and SnapToRoads to correct GPS data to obtain accurate route data.

These new features allow application developers to more effectively utilize geospatial data and significantly improve the user experience. Contact an AWS Representative for more information about how we can help accelerate your business.
