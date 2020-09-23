import 'package:BanksAppBetav1/providers/AccountProvider.dart';
import 'package:BanksAppBetav1/screens/AccountDetailswithLocalAuth.dart';
import 'package:BanksAppBetav1/screens/AccountForm.dart';
import 'package:BanksAppBetav1/widgets/ignoreCase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AccountProvider.dart';
import '../models/AccountModel.dart';
import 'package:intl/intl.dart';
import './bankName.dart';
import 'package:recase/recase.dart';
import 'package:basic_utils/basic_utils.dart';
import '../screens/AccountForm.dart';

class AccountAddn extends StatelessWidget {
  final List<Account> accs;
  int index;
  String id;
  AccountAddn(this.accs, this.id, this.index);
  final f = NumberFormat('000,0000,0000,00', 'fr');

  Color abc(String name) {
    if (equalsIgnoreCase(name, 'SBI Bank')) {
      return Color(0x191166DD);
    } else if (equalsIgnoreCase(name, 'HDFC Bank')) {
      return Color(0x19001F79);
    }
    return Color(0x19830000);
  }

  Color bankColor(String name) {
    if (equalsIgnoreCase(name, 'SBI Bank')) {
      return Color(0xFF1166DD);
    } else if (equalsIgnoreCase(name, 'HDFC Bank')) {
      return Color(0xFF001F79);
    }
    return Color(0xFF830000);
  }

  // AssetImage xyz(String bkName) {
  //   if (bkName == 'SBI Bank') {
  //     return AssetImage('assets/images/sbi.png');
  //   } else if (bkName == 'HDFC Bank') {
  //     return AssetImage('assets/images/hdfc.png');
  //   } else
  //     return AssetImage('assets/images/icici.png');
  // }

  @override
  Widget build(BuildContext context) {
    var test = Provider.of<AccountProvider>(context, listen: true).items;
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AccountDetails(index, bankColor(test[index].bankName)),
            ),
          );
        },
        child: Container(
          height: 75,
          margin: EdgeInsets.only(bottom: 23),
          //padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey[200],
                spreadRadius: 1.0,
                offset: Offset(0, 6.0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                alignment: Alignment.center,
                width: 120,
                decoration: BoxDecoration(
                  color: abc(test[index].bankName),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage(
                          AccountUtils.getBankName(
                            AccountUtils.getBankNameFrmText(
                                Provider.of<AccountProvider>(context,
                                        listen: false)
                                    .items[index]
                                    .bankName),
                          ),
                        ),
                        height: 22,
                        //width: 26,
                      ),
                    ),
                    Text(
                      Provider.of<AccountProvider>(context, listen: false)
                          .items[index]
                          .bankName
                          .toUpperCase(),
                      style: TextStyle(
                        color: bankColor(test[index].bankName),
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ReCase(Provider.of<AccountProvider>(context, listen: false)
                                .items[index]
                                .firstName +
                            '' +
                            Provider.of<AccountProvider>(context, listen: false)
                                .items[index]
                                .lastName)
                        .titleCase,
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                      fontSize: 21.0,
                    ),
                  ),
                  Text(
                    StringUtils.addCharAtPosition(
                        test[index].accountNumber, " ", 4,
                        repeat: true),
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                      color: bankColor(test[index].bankName),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   arguments:
                    //   MaterialPageRoute(
                    //     builder: (context) => AccountForm(),
                    //   ),
                    // );
                    Navigator.of(context).pushNamed(AccountForm.routeName,
                        arguments:
                            Provider.of<AccountProvider>(context, listen: false)
                                .items[index]
                                .id);
                  },
                ),
              ),

              // Text(
              //   "${Provider.of<AccountProvider>(context,listen:false).items[index].id}",
              //   style: TextStyle(
              //     fontSize: 5,
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                  ),
                  onPressed: () {
                    Provider.of<AccountProvider>(context, listen: true)
                        .deleteAccount(
                            Provider.of<AccountProvider>(context, listen: true)
                                .items[index]
                                .id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
