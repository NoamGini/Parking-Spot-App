// ignore_for_file: avoid_print, file_names

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;

  void connectToServer() {
    // Define the server URL and namespace
    const serverUrl = 'http://10.0.2.2:5000/';

    // Create the WebSocket connection
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

  
   // Setup connection event handlers
    socket.onConnect((_) => print('Connected to server'));

    socket.onError((data) => print('Error connecting to server: $data'));
    socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void addParkingUpdateHandler(dynamic handler) {
    // Set up event listeners for the desired events
    socket.on('grabbed_parking_update', handler);
    socket.on('release_parking_update', handler);
    socket.on('release_time_update', handler);
    socket.on('hidden_parking_update', handler);

  }
}