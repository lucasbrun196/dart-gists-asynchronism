import 'dart:async';
import 'dart:convert';

import 'package:dart_assincronismo/gists_key.dart';
import 'package:http/http.dart';
import '../models/account_model.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = "https://api.github.com/gists/cb045f11414d3f46265bbfbac8dbfacc";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController
        .add("${DateTime.now()} | requisicao de leitura usando await");
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> contentList =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);
    List<Account> accounts = [];
    for (dynamic d in contentList) {
      Map<String, dynamic> mp = d as Map<String, dynamic>;
      Account ac = Account.fromMap(mp);
      accounts.add(ac);
    }
    return accounts;
  }

  addAccount(Account account) async {
    List<Account> listAccount = await getAll();
    listAccount.add(account);
    List<Map<String, dynamic>> listContent = [];
    for (Account ac in listAccount) {
      listContent.add(ac.toMap());
    }
    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content,
          },
        }
      }),
      headers: {
        "Authorization": "Bearer $key",
      },
    );
    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | requisicao de adicao 200 | ${account.name}");
    } else {
      _streamController
          .add("${DateTime.now()} | requisicao falhou | ${account.name}");
    }
  }
}
