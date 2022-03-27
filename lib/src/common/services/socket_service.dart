import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  // ignore: constant_identifier_names
  Online,
  // ignore: constant_identifier_names
  Offline,
  // ignore: constant_identifier_names
  Connecting
}

class SocketService with ChangeNotifier {
  // IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.Connecting;
  //crea una nueva variable de tipo IO.Socket
  late IO.Socket _socket;

  //realixamos una peticion  get para usarlo en fuera de este archivo
  ServerStatus get serverStatus => _serverStatus;

  //con esto podemos usar el socket fuera de este archivo
  IO.Socket get socket => _socket;

  //creo su constructor
  SocketService() {
    _initConfig();
  }

  //conectamos con nuestra back
  void _initConfig() {
    // String urlSocket = 'http://192.168.1.40:3000/';

    _socket = IO.io(
        'http://192.168.1.40:3000/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // ?recibimos mensaje desde el back
    _socket.on('nuevo-mensaje', (payload) {
      // ignore: avoid_print
      // print('nuevo mensaje: $payload ');
      // ignore: avoid_print
      print('nombre: ' + payload['nombre']);
      // ignore: avoid_print
      print('mensaje: ' + payload['mensaje']);
      // ignore: avoid_print
      print(payload.containsKey('mensaje') ? payload['mensaje'] : 'no hay');
    });

    //emitimos desde nuestro flutter ---> back
  }
}
