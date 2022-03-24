// ignore_for_file: avoid_print

import 'dart:io';

import 'package:band_names_app/src/data/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Nirvana', votos: 5),
    Band(id: '2', name: 'NigthTwings', votos: 3),
    Band(id: '3', name: 'ColdPlay', votos: 1),
    Band(id: '4', name: 'Indie', votos: 4),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nombres de Bandas',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          return _bandTitle(bands[index]);
        },
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
    print(name);
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votos: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direccion: $direction');
        print('id: ${band.id}');
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
          print(band.name);
        },
      ),
    );
  }
}
