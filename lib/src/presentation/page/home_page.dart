import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:band_names_app/src/data/models/band.dart';
import 'package:band_names_app/src/common/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload) {
      //*con esta linea de condigo traemos todos los datos de nuestra banda
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nombres de Bandas',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.offline_bolt, color: Colors.red))
        ],
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) {
                return _bandTitle(bands[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), elevation: 1, onPressed: addNewBand),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (!Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text('Add New Band'),
                content: TextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  MaterialButton(
                      child: const Text('Add'),
                      elevation: 5,
                      textColor: Colors.blue,
                      onPressed: () => addNewBandToList(textController.text))
                ]);
          });
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('New Band Name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Add'),
                isDefaultAction: true,
                onPressed: () => addNewBandToList(textController.text),
              ),
              CupertinoDialogAction(
                  child: const Text('Cancelar'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  void addNewBandToList(String name) {
    // ignore: avoid_print
    print(name);
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);

      //!emitimos nuestro evento
      socketService.socket.emit('add-band', {'name': name});
      // bands.add(Band(id: DateTime.now().toString(), name: name, votos: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        //!emitimos le mensaje al back
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.redAccent,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar banda ...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votos}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        onTap: () {
          //!emitimos nuestro voto al node
          socketService.socket.emit('vote-band', {'id': band.id});
          // print(band.name);
        },
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    List<Color> colorList = [
      const Color(0xffD95Af3),
      const Color(0xff3ee094),
      const Color(0xff3398f6),
      const Color(0xffFA4A42),
      const Color(0xffFE9539),
      const Color.fromARGB(255, 146, 12, 128),
    ];

    //realizo un barrido de todo mis datos
    // ignore: avoid_function_literals_in_foreach_calls
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votos.toDouble());
    });
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        colorList: colorList,
        chartRadius: MediaQuery.of(context).size.width / 2,
        centerText: "Bandas",
        chartType: ChartType.ring,
        ringStrokeWidth: 25,
        animationDuration: const Duration(seconds: 3),
        chartValuesOptions: const ChartValuesOptions(
            showChartValues: true,
            showChartValuesOutside: false,
            showChartValuesInPercentage: true,
            showChartValueBackground: false),
      ),
    );
    //  SizedBox(
    //   width: double.infinity,
    //   height: 200,
    //   child: PieChart(dataMap: dataMap),
    // );
  }
}
