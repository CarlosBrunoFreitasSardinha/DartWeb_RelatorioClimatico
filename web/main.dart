import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dialog/dialog.dart';

void main() {
  List cidades = List();
  cidades.add('Palmas,TO');
  cidades.add('Araguaina,TO');
  cidades.add('Pedro Afonso,TO');
  cidades.add('Porto Nacional,TO');
  cidades.add('Paraiso do Tocantins,TO');
  cidades.add('Miracema,TO');

  loadData(cidades);

  querySelector('#searchCity').onClick.listen((a) async {

    var myPrompt = await prompt('Qual cidade você de seja buscar? ');

    if (myPrompt.toString().length > 0)
      loadData([myPrompt.toString()]);
    else
      alert('Nenhuma Cidade Informada');
  });
}

Future getWeather(String cidade) {
  String url = 'https://api.hgbrasil.com/weather?format=json-cors&key=e9a7491e&city_name=$cidade';
  print(url);
  return http.get(url);
}

void loadData(List cidades) {
  var empty = querySelector('#empty');

  if (empty != null) empty.remove();
  cidades.forEach((cidade) {
    insertData(getWeather(cidade));
  });
}

void insertData(Future data) async {
  var insertData = await data;
  var body = json.decode(insertData.body);
  if (body['results']['forecast'].length > 0) {
    String html = '<div class="row">';
    html += formatedHtml(body['results']['city']);
    html += formatedHtml(body['results']['temp']);
    html += formatedHtml(body['results']['description']);
    html += formatedHtml(body['results']['wind_speedy']);
    html += formatedHtml(body['results']['sunrise']);
    html += formatedHtml(body['results']['sunset']);
    html += '</div>';

    querySelector('.table').innerHtml += html;
    print(html);
  }
}

String formatedHtml(var data) => '<div class="cell"> $data</div>';