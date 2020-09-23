import 'package:BanksAppBetav1/models/AccountModel.dart';
import 'package:flutter/material.dart';
import './ignoreCase.dart';

class AccountUtils {
  static String getBankName(bankName bkname) {    
    String img = "";
    switch (bkname) {
      case bankName.icici:
        img = 'assets/images/icici.png';
        break;
      case bankName.hdfc:
        img = 'assets/images/hdfc.png';
        break;
      case bankName.sbi:
        img = "assets/images/sbi.png";
        break;
      case bankName.others:
        img = "assets/images/credit.png";
        break;
      case bankName.invalid:
       img = "assets/images/warning.png";
        break;
    }

    return img;
    
    // Widget widget;
    // if (img.isNotEmpty) {
    //   widget = new Image.asset(
    //     img,
    //   );
    // }
    // else{
    //   widget=icon;
    // }
    // return widget;
  }

  static bankName getBankNameFrmText(String input) {
    bankName bkname;

    if (equalsIgnoreCase(input, 'icici bank')) {
      bkname = bankName.icici;
    }
    else if (equalsIgnoreCase(input, 'hdfc bank')) {
      bkname = bankName.hdfc;
    }
    else if (equalsIgnoreCase(input, 'sbi bank')) {
      bkname = bankName.sbi;
    } 
    else  {
      bkname = bankName.others;
    }
    return bkname;
  }
}
