import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';

class Account {
  String id;
  String firstName;
  String lastName;
  String bankName;
  String accountNumber;
  int cardNum;
  int cvc;
  String ifsc;
  int custId;
  String netbnkpswd;
  int upi;
  int atm;

  Account({
    @required this.id,
    @required this.firstName,
    @required this.accountNumber,
    @required this.bankName,
    @required this.lastName,
    @required this.cardNum,
    @required this.cvc,
    @required this.ifsc,
    @required this.custId,
    @required this.netbnkpswd,
    @required this.upi,
    @required this.atm,
  });
}

enum bankName { icici, hdfc, sbi, others, invalid }
