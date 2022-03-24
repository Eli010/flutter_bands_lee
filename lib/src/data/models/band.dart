class Band {
  String id;
  String name;
  int? votos;

  Band({required this.id, required this.name, this.votos});

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'] ?? 'no tiene id',
        name: obj['nombre'] ?? 'no tiene nombre',
        votos: obj['votos'] ?? 'no tiene votos',
      );
}
