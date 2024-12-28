import 'package:dart_assincronismo/models/account_model.dart';
import 'package:dart_assincronismo/services/account_service.dart';
import 'dart:io';

class Cli {
  final AccountService _accountService = AccountService();

  void initStream() {
    _accountService.streamInfos.listen(
      (event) => print(event),
    );
  }

  Future<void> _getAll() async {
    List<Account> accounts = await _accountService.getAll();
    for (Account ac in accounts) {
      print(ac.id);
      print(ac.name);
      print(ac.lastName);
      print(ac.balance);
      print("");
    }
  }

  _addExampleAccount() async {
    Account newAccount =
        Account(id: "02193", name: "test", lastName: "test", balance: 8901);
    _accountService.addAccount(newAccount);
  }

  void runBot() async {
    print("Hello World!");
    bool isRunnig = true;
    while (isRunnig) {
      print("1 - Show All Accounts\n2 - Add an Account\n3 - Quit");
      String? io = stdin.readLineSync();
      if (io != null) {
        switch (io) {
          case "1":
            await _getAll();
            break;
          case "2":
            await _addExampleAccount();
            break;
          case "3":
            isRunnig = false;
            print("Bye");
            break;
          default:
            print("error");
        }
      }
    }
  }
}
