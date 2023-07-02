// ignore_for_file: avoid_print, file_names
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:parking_spot_app/constants.dart';

class SocketService {
  late io.Socket socket;

  void connectToServer() {

    // Create the WebSocket connection
    socket = io.io(Constants.serverUrl, <String, dynamic>{
      Constants.transports: [Constants.websocket],
      Constants.autoConnect: true,
    });
  
   // Setup connection event handlers
    socket.onConnect((_) => print(Constants.connectedToServer));

    socket.onError((data) => print('${Constants.errorConnectingToServer}$data'));
    socket.onDisconnect((_) => print(Constants.disconnectedFromServer));
  }

  void addParkingUpdateHandler(dynamic handler) {
    // Set up event listeners for the desired events
    socket.on(Constants.grabbedParkingUpdate, handler);
    socket.on(Constants.releaseParkingUpdate, handler);
    socket.on(Constants.releaseTimeUpdate, handler);
    socket.on(Constants.hiddenParkingUpdate, handler);

  }
}