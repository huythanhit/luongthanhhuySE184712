---
title: "Blog 2"
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

# Các tính năng mới và trải nghiệm dành cho nhà phát triển với Dịch vụ định vị Amazon được cải tiến


bởi Zach Elliott vào 02 THÁNG 4 NĂM 2025 tại Vị trí Amazon , Thông báo , Hướng dẫn kỹ thuật|Liên kết cố định|Chia sẻ.
Bài đăng trên blog này được viết bởi Yasunori Kirimoto – CEO của MIERUNE
Việc xây dựng các ứng dụng không gian địa lý đòi hỏi chuyên môn về xử lý dữ liệu không gian địa lý, cũng như thiết kế và phát triển hệ thống. Nó cũng đòi hỏi kỹ năng thu thập và quản lý khối lượng lớn dữ liệu không gian địa lý và sử dụng hiệu quả trong ứng dụng. Quá trình này có thể rất tốn công sức, nhưng độ phức tạp của nó có thể được giảm thiểu đáng kể bằng cách tận dụng Amazon Location Service.
Với Amazon Location Service, dữ liệu không gian địa lý có độ chính xác cao có thể được thu thập nhanh chóng từ các API, cho phép các nhà phát triển tập trung vào việc xây dựng ứng dụng. Ngoài ra, Amazon Location Service đã được cập nhật, bổ sung thêm các tính năng mới bên cạnh các chức năng trước đây. Chúng tôi sẽ giới thiệu các tính năng mới của Amazon Location Service và hướng dẫn cách tận dụng chúng trong ứng dụng của bạn.


---

## Các tính năng được phát hành từ Amazon Location Service


Thay đổi lớn nhất là việc tạo tài nguyên không còn cần thiết nữa. Điều này có nghĩa là người dùng không còn cần phải tạo từng tài nguyên riêng lẻ (chẳng hạn như Chỉ mục Địa điểm, Bản đồ và Máy tính Tuyến đường), mà có thể thiết lập khóa API và bắt đầu sử dụng Amazon Location Service ngay lập tức.
Ngoài ra, các API Bản đồ, Địa điểm và Tuyến đường đã được bổ sung nhiều cải tiến đáng kể và tính năng mới. API Bản đồ đã được cập nhật với các kiểu dáng bổ sung, cũng như khả năng bản đồ tĩnh mới. API Địa điểm đã được cải tiến với các tính năng tìm kiếm và mã hóa địa lý mới. Cuối cùng, API Tuyến đường đã được cập nhật với các tính năng mới như Snap to Road, Tối ưu hóa Điểm dừng và các chế độ di chuyển bổ sung.

## Tạo khóa API
Để tạo Khóa API , chúng ta có thể sử dụng AWS Management Console hoặc AWS Cloud Control API . Trong ví dụ này, chúng ta sẽ sử dụng bảng điều khiển. Điều hướng đến Amazon Location Service Console và chọn Khóa API trong mục Quản lý tài nguyên. Chọn Tạo Khóa API.


Để trình diễn, chúng tôi sẽ đặt tên cho Khóa API là LasVegasMaps và chọn các hành động sau:
– GetStaticMap
– GetTile
– Geocode
– GetPlace
– SearchNearby
– SearchText
– CalculateIsolines
– SnapToRoads


Scrolling down, we have additional options including the ability to set an Expire time, and Referers. ThCuộn xuống, chúng ta có các tùy chọn bổ sung, bao gồm khả năng đặt Thời gian hết hạn và Người giới thiệu. Đây là các tùy chọn tùy chọn, nhưng chúng tôi thực sự khuyên bạn nên sử dụng chúng cho các ứng dụng sản xuất.
 LƯU Ý : Trong bài trình diễn này, chúng tôi để chúng ở chế độ Mặc định.

Cuộn xuống, chúng ta có các tùy chọn bổ sung, bao gồm khả năng đặt Thời gian hết hạn và Người giới thiệu. Đây là các tùy chọn tùy chọn, nhưng chúng tôi thực sự khuyên bạn nên sử dụng chúng cho các ứng dụng sản xuất.
**LƯU Ý** : Trong bài trình diễn này, chúng tôi để chúng ở chế độ Mặc định.


Chọn **Tạo khóa API**.
Sau khi Khóa API đã được tạo, chúng ta cần lấy giá trị để sử dụng trong ứng dụng. Chọn Hiển thị giá trị Khóa API và sao chép giá trị vào một vị trí an toàn.


## Các tính năng API bản đồ mới
Đầu tiên, chúng tôi sẽ làm nổi bật và giới thiệu các hàm SetStyle Descriptor và Get Static Map.

## Xây dựng nền tảng cho ứng dụng bản đồ với GetStyle Descriptor

Hàm SetStyle Descriptor cho phép bạn truy xuất thông tin kiểu bản đồ và nhanh chóng xây dựng nền tảng cho ứng dụng bản đồ của mình. Tính năng này có thể được sử dụng cho nhiều giải pháp không gian địa lý và nền tảng ứng dụng khác nhau. Phiên bản mới cung cấp các kiểu bản đồ mở rộng, được thiết kế riêng cho các ứng dụng khác nhau—cung cấp chế độ tối và sáng với các mức độ chi tiết bản đồ khác nhau.
Chúng tôi sẽ trình bày cách tận dụng các kiểu bản đồ này bằng MapLibre GL JS. Chúng tôi sẽ tạo một trang HTML rất đơn giản bằng MapLibre GL JS và Khóa API Amazon Location Service.
Bắt đầu bằng cách tạo một trang HTML trống, đặt tên là simpleMap.html và sao chép đoạn mã sau vào trang:
HTML:

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
Bây giờ hãy mở trang HTML này trong trình duyệt. Bạn sẽ thấy bản đồ Las Vegas, NV. Chìa khóa của bản đồ này là URL kiểu mà chúng ta đã thiết lập trước đó trong mã. Trong URL này, chúng tôi đã yêu cầu sử dụng bản đồ kiểu Chuẩn với tông màu sáng. Chúng ta cũng có thể thêm các tham số bổ sung như quan điểm chính trị.

## Tạo ảnh bản đồ tĩnh bằng GetStaticMap
Tính năng GetStaticMap cho phép bạn tạo ảnh bản đồ tĩnh dựa trên tọa độ, mức thu phóng và kích thước ảnh bạn chỉ định. Tính năng này giúp đưa ảnh bản đồ vào tài liệu in và bài đăng trên phương tiện truyền thông. Có nhiều tham số khác nhau cho tính năng này, bao gồm khả năng chồng các dữ liệu khác (chẳng hạn như điểm, đường và đa giác). Chúng tôi đã cung cấp một ví dụ cơ bản. Hãy nhớ chỉnh sửa URL cho Vùng AWS của bạn và Khóa API mới tạo. Dán URL sau vào thanh địa chỉ của trình duyệt web để hiển thị ảnh bản đồ tĩnh của vị trí đã chỉ định:
**https://maps.geo.<Your AWS Region>.amazonaws.com/v2/static/map?center=-115.170,36.122&zoom=15&width=1024&height=1024&key=<Your API Key>**
## Các tính năng API Địa điểm mới
Tiếp theo, chúng tôi sẽ nêu bật và giới thiệu các tính năng SearchText và Search Nearby.

## Tìm kiếm dữ liệu POI đã chỉ định bằng SearchText

Tính năng SearchText cho phép người dùng tìm kiếm và hiển thị dữ liệu điểm ưa thích (POI) đã chỉ định. Tính năng này được thiết kế để người dùng nhanh chóng tìm kiếm một địa điểm hoặc cơ sở cụ thể. Người dùng có thể gửi yêu cầu POST với các tham số đã chỉ định và nhận được phản hồi chứa dữ liệu điểm ứng viên. Chúng tôi sẽ trình bày một ví dụ về cách hiển thị dữ liệu đó trên bản đồ.
Tạo một tệp HTML mới có tên searchText.html và dán nội dung sau vào tệp:

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
Mở tệp HTML trong trình duyệt sẽ hiển thị bản đồ sau với các quán cà phê tập trung xung quanh Venetian Resort ở Las Vegas, NV (Hình 7).

## Tìm kiếm để lấy dữ liệu POI xung quanh một vị trí cụ thể với Search Nearby

Chức năng Search Nearby cho phép bạn truy xuất dữ liệu POI gần một vị trí được chỉ định. Tính năng này rất tiện lợi cho người dùng tìm kiếm các cửa hàng và điểm tham quan gần đó. Người dùng có thể gửi yêu cầu POST với các tham số được chỉ định và nhận được phản hồi chứa dữ liệu điểm ứng viên. Chúng tôi sẽ minh họa một ví dụ về cách hiển thị dữ liệu đó trên bản đồ.
Tạo một tệp HTML mới có tên là searchNearby.html và dán nội dung sau vào tệp:

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
Mở tệp HTML trong trình duyệt sẽ hiển thị bản đồ sau đây cho thấy vị trí khách sạn và sòng bạc tập trung xung quanh Venetian Resort ở Las Vegas, NV (Hình 8).


## Các tính năng API tuyến đường mới
Cuối cùng, chúng ta sẽ thảo luận về các hàm CalculateIsolines và SnapToRoads mới.

## Tìm phạm vi có thể tiếp cận từ một vị trí được chỉ định với CalculateIsolines
Hàm CalculateIsolines có thể truy xuất phạm vi tiếp cận từ một điểm được chỉ định. Một số trường hợp sử dụng Isolines bao gồm xác định các khu vực có thể giao hàng và đánh giá vị trí bất động sản. Người dùng có thể gửi yêu cầu POST với các tham số được chỉ định và nhận được phản hồi chứa dữ liệu đa giác cho biết khu vực tiếp cận. Chúng tôi sẽ trình bày một ví dụ về cách trực quan hóa dữ liệu đó trên bản đồ.
Tạo một tệp HTML mới và đặt tên là calculateIsolines.html rồi dán nội dung sau vào tệp:


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


## Nhận dữ liệu tuyến đường đã hiệu chỉnh vị trí bằng SnapToRoads
Chức năng SnapToRoads cho phép bạn chụp dữ liệu GPS và các dữ liệu vị trí khác vào đường gần nhất và lấy dữ liệu đường sau khi hiệu chỉnh vị trí. Tính năng này rất hữu ích trong việc cải thiện độ chính xác của việc theo dõi phương tiện và phân tích giao thông. Người dùng có thể gửi yêu cầu POST với các tham số được chỉ định và nhận được phản hồi chứa dữ liệu đường đã hiệu chỉnh vị trí. Chúng tôi sẽ trình bày một ví dụ về cách trực quan hóa dữ liệu trước và sau khi xử lý trên bản đồ.

Tạo một tệp HTML mới có tên là snapToRoad.html và dán nội dung sau vào tệp:

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
Mở tệp HTML trong trình duyệt sẽ hiển thị bản đồ sau (Hình 10), với đường màu xanh biểu thị dấu vết GPS và đường màu đỏ biểu thị phiên bản được gắn vào đường.
## Dọn dẹp

Tài nguyên duy nhất của Amazon Location Service được tạo trong bản demo này là Khóa API. Để xóa Khóa API, hãy điều hướng đến Bảng điều khiển Amazon Location Service, chọn Khóa API chúng tôi đã tạo và chọn Hủy kích hoạt. Xác nhận quyết định hủy kích hoạt khóa, sau đó chọn Xóa. Đồng thời, hãy chọn bỏ qua thời gian hủy kích hoạt tiêu chuẩn 90 ngày.
## Phần kết luận
Dịch vụ Định vị Amazon giờ đây mang đến sự linh hoạt hơn nữa với các tính năng mới. Với bản cập nhật này, quy trình tạo tài nguyên trước đây không còn cần thiết nữa, và người dùng có thể sử dụng nhiều API khác nhau bằng cách thiết lập khóa API. Điều này cho phép người dùng xây dựng các ứng dụng không gian địa lý một cách nhanh chóng và mượt mà.
Các tính năng mới đáng chú ý bao gồm GetStyleDescriptor và GetStaticMap trong API Maps, SearchText và SearchNearby trong API Places và CalculateIsolines và SnapToRoads trong API Routes.
Trong API Bản đồ, GetStyleDescriptor có thể được sử dụng để truy xuất nhiều kiểu bản đồ khác nhau và áp dụng chúng vào ứng dụng của bạn, còn GetStaticMap có thể tạo ảnh bản đồ tĩnh dựa trên tọa độ và mức thu phóng bạn chỉ định. API Địa điểm cho phép bạn tìm kiếm dữ liệu POI bằng SearchText, và SearchNearby sẽ cho phép bạn tìm các POI xung quanh một vị trí cụ thể. API Tuyến đường có thể sử dụng CalculateIsolines để tính toán khả năng tiếp cận từ một điểm đã chỉ định và SnapToRoads để hiệu chỉnh dữ liệu GPS nhằm có được dữ liệu tuyến đường chính xác.
Những tính năng mới này cho phép các nhà phát triển ứng dụng sử dụng dữ liệu không gian địa lý hiệu quả hơn và cải thiện đáng kể trải nghiệm người dùng. Liên hệ với Đại diện AWS để biết thêm thông tin về cách chúng tôi có thể giúp thúc đẩy doanh nghiệp của bạn.


