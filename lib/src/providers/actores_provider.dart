import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actor_model.dart';

final actoresInfo = new Actor();

class ActorProvider {
  String _apikey = '1dcd98de779eb59fdef2fe7a0c78befb';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _actores = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Actores.fromJsonList(decodedData['results']);

    return actores.actores;
  }

  Future<List<Actor>> getActorFoto() async {
    final url = Uri.https(
        _url, '3/person/popular', {'api_key': _apikey, 'language': _language});
    return await _procesarRespuesta(url);
  }

  Future<String> getActorBiografia(int id) async {
    final url = Uri.https(
        _url, '3/person/$id', {'api_key': _apikey, 'language': _language});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    return decodedData['biography'];
  }

  Future<String> getActorNombre(int id) async {
    final url = Uri.https(
        _url, '3/person/$id', {'api_key': _apikey, 'language': _language});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    return decodedData['name'];
  }
}
