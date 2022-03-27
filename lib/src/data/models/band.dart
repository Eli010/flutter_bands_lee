class Band {
  String id;
  String name;
  int votos;

  Band({required this.id, required this.name, required this.votos});

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        //?seguridad normal
        // id: obj['id'] ?? 'no tiene id',
        // name: obj['nombre'] ?? 'no tiene nombre',
        // votos: obj['votos'] ?? 'no tiene votos',

        //?agregamos una seguridad extras con el contains''votos''?obj para que no crashee
        id: obj.containsKey('id') ? obj['id'] : 'no tiene id',
        name: obj.containsKey('name') ? obj['name'] : 'no tiene nombre',
        votos: obj.containsKey('votos') ? obj['votos'] : 'no tiene votos',
      );
}
