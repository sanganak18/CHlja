import 'dart:math';

import '../models/AccountModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as KEY;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../helper/delperDB.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

final storage = new FlutterSecureStorage();
Random random = new Random();

int index = random.nextInt(100);

class AccountProvider with ChangeNotifier {
  List<Account> _items = [
    Account(
        //   id: 'A1',
        //   firstName: 'Girish',
        // lastName: 'Verma',
        // accountNumber: '50100145717840',
        // bankName: 'hdfc bank',
        // atm: 1234,
        // upi: 1234,
        // ifsc: 'jsdfnjksd',
        // cvc: 123,
        // cardNum: 4058405967804569,
        // custId: 1234567,
        // netbnkpswd: 'kdsnfindf',
        )
  ];

  List<Account> get items {
    return [..._items];
  }

  String _encryptedData;
  String _origData;

  Future<void> _encryptData(String text) async {
    const platform = MethodChannel('samples.flutter.dev/encryption');
    try {
      final encryptedData =
          await platform.invokeMethod('encryptData', {'text': text});

      _encryptedData = encryptedData;
    } on PlatformException catch (error) {
      _encryptedData = "25";
    }
  }

  Future<void> _readEncData() async {
    const platform = MethodChannel('samples.flutter.dev/encryption');
    try {
      final origData = await platform.invokeMethod('readEncData');

      _origData = origData;
    } on PlatformException catch (error) {
      _origData = "25";
    }
  }

 
  Future<void> addAccount(Account account) async {
    const url = 'https://banksapp2.firebaseio.com/Accounts.json';

    return http
        .post(
      url,
      body: json.encode({
        'firstName':account.firstName,
        'lastName': account.lastName,
        'accountNumber': account.accountNumber,
        'bankName': account.bankName,
        'upi': account.upi,
        'ifsc': account.ifsc,
        'cvc': account.cvc,
        'netbnkpswd': account.netbnkpswd,
        'atm': account.atm,
        'cardNum': account.cardNum,
        'custId': account.custId,
      }),
    )
        .then(
      (response) {
        final newAccount = Account(
          id: json.decode(response.body)['name'],
          firstName: account.firstName,
          lastName: account.lastName,
          accountNumber: account.accountNumber,
          bankName: account.bankName,
          upi: account.upi,
          ifsc: account.ifsc,
          cvc: account.cvc,
          netbnkpswd: account.netbnkpswd,
          atm: account.atm,
          cardNum: account.cardNum,
          custId: account.custId,
        );
        _items.add(newAccount);
        notifyListeners();
      },
    ).catchError((error) {
      print(error);
      throw error;
    });
  }

  // Future<void> addAccount(Account account) async {
  //   const platform = MethodChannel('samples.flutter.dev/encryption');
  //   try {
  //     final encryptedData = await platform
  //         .invokeMethod('encryptData', {'text': account.firstName});

    
  //     _encryptedData = encryptedData;
  //   } on PlatformException catch (error) {
  //     _encryptedData = "25";
  //   }

  //   _readEncData();
  //   final newAccount = Account(
  //     id: DateTime.now().toIso8601String(),
  //     firstName: _origData,
  //     lastName: account.lastName,
  //     accountNumber: account.accountNumber,
  //     bankName: account.bankName,
  //     upi: account.upi,
  //     ifsc: account.ifsc,
  //     cvc: account.cvc,
  //     netbnkpswd: account.netbnkpswd,
  //     atm: account.atm,
  //     cardNum: account.cardNum,
  //     custId: account.custId,
  //   );
  //   _items.add(newAccount);
  //   notifyListeners();
  // }

  Future<void> fetchAndSet() async {
    final List<Account> loadedAcc = [];
    const platform = MethodChannel('samples.flutter.dev/encryption');
    try {
      final origData = await platform.invokeMethod('readEncData');

      _origData = origData;
    } on PlatformException catch (error) {
      _origData = "25";
    }

    loadedAcc.add(
      Account(
        id: DateTime.now().toIso8601String(),
        firstName: _origData,
        lastName: 'Verma',
        accountNumber: '50100145717840',
        bankName: 'hdfc bank',
        atm: 1234,
        upi: 1234,
        ifsc: 'jsdfnjksd',
        cvc: 123,
        cardNum: 4058405967804569,
        custId: 1234567,
        netbnkpswd: 'kdsnfindf',
      ),
    );
    _items = loadedAcc;
  }

  Future<void> updateAccount(String id, Account newAcc) async {
    final accIndex = _items.indexWhere((acc) => acc.id == id);
    if (accIndex >= 0) {
      final url = 'https://banksapp2.firebaseio.com/Accounts.json';
      await http.patch(url,
          body: json.encode({
            'firstName': newAcc.firstName,
            'lastName': newAcc.lastName,
            'accountNumber': newAcc.accountNumber,
            'bankName': newAcc.bankName,
            'upi': newAcc.upi,
            'ifsc': newAcc.ifsc,
            'cvc': newAcc.cvc,
            'netbnkpswd': newAcc.netbnkpswd,
            'atm': newAcc.atm,
            'cardNum': newAcc.cardNum,
            'custId': newAcc.custId
          }));
      _items[accIndex] = newAcc;
      notifyListeners();
    } else {}
  }

  void deleteAccount(String id) {
    final url = 'https://banksapp2.firebaseio.com/Accounts.json';
    final existingAccIndex = _items.indexWhere((acc) => acc.id == id);
    var existingAcc = _items[existingAccIndex];
    _items.removeAt(existingAccIndex);
    notifyListeners();
    http.delete(url).then((_) {
      existingAcc = null;
    }).catchError((_) {
      _items.insert(existingAccIndex, existingAcc);
    });
    notifyListeners();
  }

  Account findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
