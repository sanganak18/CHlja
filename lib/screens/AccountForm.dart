import 'package:BanksAppBetav1/providers/AccountProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/AccountModel.dart';
import 'package:provider/provider.dart';
import './AccountList.dart';
import './AccountDetailswithLocalAuth.dart';
import '../providers/AccountProvider.dart';
import '../widgets/accountAddn.dart';
import 'package:encrypt/encrypt.dart' as KEY;

// ignore: must_be_immutable
class AccountForm extends StatefulWidget {
  static const routeName = '/Form';

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  var _user = Account(id: null);
  var _isLoading = false;
  var _isInit = true;
  var _initValues = {
    'id': '',
    'firstName': '',
    'lastName': '',
    'accountNumber': '',
    'bankName': '',
    'atm': '',
    'upi': '',
    'ifsc': '',
    'cvc': '',
    'cardNum': '',
    'custId': '',
    'netbnkpswd': '',
  };

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final accId = ModalRoute.of(context).settings.arguments as String;
      if (accId != null) {
        _user = Provider.of<AccountProvider>(context, listen: false)
            .findById(accId);
        _initValues = {
          'id': _user.id,
          'firstName': _user.firstName,
          'lastName': _user.lastName,
          'accountNumber': _user.accountNumber,
          'bankName': _user.bankName,
          'atm': _user.atm.toString(),
          'upi': _user.upi.toString(),
          'ifsc': _user.ifsc,
          'cvc': _user.cvc.toString(),
          'cardNum': _user.cardNum.toString(),
          'custId': _user.custId.toString(),
          'netbnkpswd': _user.netbnkpswd,
        };
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });

      if (_user.id != null) {
        await Provider.of<AccountProvider>(context, listen: false)
            .updateAccount(_user.id, _user);
      } else {
        await Provider.of<AccountProvider>(context, listen: false)
            .addAccount(_user)
            .catchError((error) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error Occurred!'),
              content: Text(
                'Something went wrong!',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountsList(),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var formWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Builder(builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    child: Container(
                      height: 700,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Enter Account Details',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['firstName'],
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\s"),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      border: InputBorder.none,
                                      labelText: 'First Name',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter your First Name';
                                      }
                                    },
                                    onSaved: (val) async {
                                      _user.firstName = val;
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['lastName'],
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\s"),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      border: InputBorder.none,
                                      labelText: 'Last Name',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter your Last Name';
                                      }
                                    },
                                    onSaved: (val) {
                                      _user.lastName = val;
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          TextFormField(
                            initialValue: _initValues['bankName'],
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                border: InputBorder.none,
                                labelText: 'Name of the Bank'),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z]+|\s"),
                              ),
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter name of the Bank';
                              }
                            },
                            onSaved: (val) {
                              _user.bankName = val;
                              _user.id = _user.id;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['accountNumber'],
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                border: InputBorder.none,
                                labelText: 'Account Number'),
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Account Number';
                              }
                            },
                            keyboardType: TextInputType.number,
                            onSaved: (val) {
                              _user.id = _user.id;
                              _user.accountNumber = val.replaceAllMapped(
                                  RegExp(r".{4}"),
                                  (match) => "${match.group(0)}");
                            },
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: formWidth / (10 / 6.3),
                                  child: TextFormField(
                                    initialValue: _initValues['cardNum'],
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        labelText: 'Card Number'),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(16),
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter Card Number';
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    onSaved: (val) {
                                      _user.cardNum = int.parse(val);
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  width: formWidth / (10 / 2.7),
                                  child: TextFormField(
                                    initialValue: _initValues['cvc'],
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        labelText: 'CVC'),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter CVC';
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    onSaved: (val) {
                                      _user.cvc = int.parse(val);
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          TextFormField(
                            initialValue: _initValues['ifsc'],
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                border: InputBorder.none,
                                labelText: 'IFSC Code'),
                            inputFormatters: [],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter IFSC Code of the Bank';
                              }
                            },
                            onSaved: (val) {
                              _user.ifsc = val;
                              _user.id = _user.id;
                            },
                          ),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['custId'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        labelText: 'Customer ID'),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter Customer ID';
                                      }
                                    },
                                    onSaved: (val) {
                                      _user.custId = int.parse(val);
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['netbnkpswd'],
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      border: InputBorder.none,
                                      labelText: 'NetBanking\nPassword',
                                      labelStyle: TextStyle(),
                                    ),
                                    inputFormatters: [],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter NetBanking Password';
                                      }
                                    },
                                    onSaved: (val) {
                                      _user.netbnkpswd = val;
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['upi'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        labelText: 'UPI Pin'),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter your UPI Pin';
                                      }
                                    },
                                    onSaved: (val) {
                                      _user.upi = int.parse(val);
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  width: formWidth / (10 / 4.5),
                                  child: TextFormField(
                                    initialValue: _initValues['atm'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        labelText: 'ATM Pin'),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter ATM Pin';
                                      }
                                    },
                                    onSaved: (val) {
                                      _user.atm = int.parse(val);
                                      _user.id = _user.id;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),

                          Container(
                            child: Consumer<AccountProvider>(
                                builder: (context, data, child) {
                              return RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _saveForm();
                                },
                              );
                            }),
                          ),
                          // Container(
                          //   child: RaisedButton(
                          //     child: Text('See Accounts List'),
                          //     onPressed: () {},
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
