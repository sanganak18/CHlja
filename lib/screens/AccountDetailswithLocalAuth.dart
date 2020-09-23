import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'dart:async';
import '../widgets/detailTab.dart';
import '../providers/AccountProvider.dart';
import 'package:provider/provider.dart';
import '../widgets/bankName.dart';
import '../widgets/accountAddn.dart';
import '../models/AccountModel.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as KEY;

class AccountDetails extends StatefulWidget {
  int i;
  Color bankColor;
  AccountDetails(this.i, this.bankColor);
  int get indexVal {
    return i;
  }

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final key = KEY.Key.fromUtf8('my 32 length key................');
  final iv = KEY.IV.fromLength(16);
  final encrypter = KEY.Encrypter(
      KEY.AES(KEY.Key.fromUtf8('my 32 length key................')));
  bool isObscure = true;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable!');

    return isAvailable;
  }

  Future<void> _getListofBiometricTypes() async {
    List<BiometricType> listBiometrics;
    try {
      listBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please Authenticate to view ATM Pin",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    isAuthenticated
        ? print('User is Authenticated')
        : print('User is not Authenticated');

    if (isAuthenticated == true) {
      setState(() {
        isObscure = false;
      });
    }
  }

  // AccountProvider provider = Provider.of<AccountProvider>(context,listen:false);
// int get i {
//   return (Provider.of<AccountProvider>(context,listen:false).items.length - 1);
// }
  @override
  void initstate() {
    super.initState();
    _loadName();
  }

  String nameAcc;
  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameAcc = prefs.getString('Girish/01');
    });
  }

  @override
  Widget build(BuildContext context) {
    var xyz = Provider.of<AccountProvider>(context, listen: false).items;
    String test1 = xyz[widget.i].accountNumber.toString();

    // String getValue() async{
    //  String val = await getString(
    //                       Provider.of<AccountProvider>(context, listen: false)
    //                           .items[widget.i]
    //                           .firstName,
    //                       "01").toString();
    //                       return val;
    //                       }

    return Scaffold(
      body: new ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 20),
            height: 200,
            width: 345,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: widget.bankColor,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 25,
                  child: Text(
                    xyz[widget.i].bankName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: Container(
                    width: 325,
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        StringUtils.addCharAtPosition(
                            ((xyz[widget.i].cardNum.toString())
                                    .replaceAll(RegExp(r'\d(?!\d{0,3}$)'), 'X'))
                                .toString(),
                            "  ",
                            4,
                            repeat: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xDCFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: widget.bankColor,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      AccountUtils.getBankName(
                        AccountUtils.getBankNameFrmText(
                            Provider.of<AccountProvider>(context, listen: false)
                                .items[widget.i]
                                .bankName),
                      ),
                      width: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  (Provider.of<AccountProvider>(context, listen: false)
                          .items[widget.i]
                          .firstName
                          .toUpperCase() +
                      ' ' +
                      Provider.of<AccountProvider>(context, listen: false)
                          .items[widget.i]
                          .lastName
                          .toUpperCase()),
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 17,
                    color: widget.bankColor,
                  ),
                ),
                Divider(
                  height: 45,
                  thickness: 1,
                  color: Colors.grey[250],
                  indent: 105,
                  endIndent: 105,
                ),
                Text(
                  'A/c No.',
                  style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontSize: 13,
                  ),
                ),
                Text(
                  StringUtils.addCharAtPosition(
                      xyz[widget.i].accountNumber, " ", 4,
                      repeat: true),
                  style: TextStyle(
                    height: 1.45,
                    fontFamily: 'Proxima Nova',
                    fontSize: 20,
                    color: widget.bankColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.transparent,
              //margin: EdgeInsets.all(5),
              //padding: EdgeInsets.all(5),
              height: 215,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Details(
                          'Customer ID\n', '${xyz[widget.i].custId}', false),
                      Details('IFSC Code\n', '${xyz[widget.i].ifsc}', false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Details('NetBanking\n', '${xyz[widget.i].netbnkpswd}',
                          isObscure),
                      Details('UPI Pin\n', '${xyz[widget.i].upi}', isObscure),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Details('ATM Pin\n', '${xyz[widget.i].atm}', isObscure),
                      Details(
                          'CVC \n',
                          //
                          '${xyz[widget.i].cvc}',
                          isObscure),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 68,
            thickness: 1,
            color: Colors.grey[250],
            indent: 120,
            endIndent: 120,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      share(context, xyz[widget.i]);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x104A6075),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/copy.png',
                          width: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Copy \nDetails',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if (await _isBiometricAvailable()) {
                        await _getListofBiometricTypes();
                        await _authenticateUser();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x104A6075),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.visibility,
                          color: Color(0xFF4A6075),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'View \nDetails',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void share(BuildContext context, Account acct) {
    final RenderBox box = context.findRenderObject();
    final String text =
        "Name: ${acct.firstName.toUpperCase() + " " + acct.lastName.toUpperCase()}  \nBank Name: ${acct.bankName.toUpperCase()}  \nAccount Number: ${acct.accountNumber} \nIFSC Code: ${acct.ifsc}";

    Share.share(
      text,
      subject: "Bank details of ${acct.firstName}",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
