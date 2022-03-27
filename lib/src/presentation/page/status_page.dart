import 'package:band_names_app/src/common/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //invocamos nuestros provider
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Text('Estado: ${socketService.serverStatus} '),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            //!emitimos desde nuestro flutter ---> back
            socketService.socket.emit('emitir-mensaje',
                {'nombre: ': 'Flutter', 'mensaje': 'hola desde flutter'});
          }),
    );
  }
}
