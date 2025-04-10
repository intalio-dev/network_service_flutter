## Usage
1. Import the necessary packages:

```dart
  network_service:
    git:
      url: https://source.intalio.com/etgs-qatar/shared_group/flutter_packages/network_service_flutter.git
      ref: main
```
2. Use Dio Factory:

```dart
- Use DioFactory 
- Implement Helper Class
   class CustomDioFactory extends DioFactory {
      static final CustomDioFactory _instance =
      CustomDioFactory._internal(baseUrl: APIRoutes.baseURL);

      CustomDioFactory._internal({required super.baseUrl});
      
      factory CustomDioFactory() => _instance;

      static void initialize() {
        DioFactory.initialize(APIRoutes.baseURL, connectTimeout: 60);
      
         dio.interceptors.add(
            InterceptorsWrapper(
               onRequest: (options, handler) {
                  options.headers['Authorization'] = 'Bearer Token';
                  handler.next(options);
               },
               onResponse: (response, handler) {
                  handler.next(response);
               },
               onError: (error, handler) async {
                  if (error.response?.statusCode == 401) {
                     // UnAuthorized Request Handle
                  } else {
                    handler.next(error);
                  }
               },
            ),
         );
      }
      

      static Dio get dio => DioFactory.dio;
   }

- Use Helper Class
 in main function :
    CustomDioFactory.initialize();
```

# NetworkStatusService
This class provides functionality to monitor the network status and internet connectivity.

## APIs:

1. NetworkStatusHelper.instance
    - Returns the singleton instance of NetworkStatusHelper.

2. NetworkStatusHelper.init()
    - Initializes the NetworkStatusHelper and starts monitoring the network status.

3. NetworkStatusHelper.updateInternetStatus()
    - Call this method whenever there might be a change in network connectivity
      to update the internet status based on the current network connectivity.

4. NetworkStatusHelper.currentConnectivity
    - Returns the current network connectivity as [ConnectivityResult] for example {[ConnectivityResult.none],[ConnectivityResult.wifi], ...}.

5. NetworkStatusHelper.hasNetworkAccess
    - Returns a boolean indicating if there is network access.

6. NetworkStatusHelper.connectionChangeStream
    - Subscribe to this stream to receive updates on network connectivity changes.
