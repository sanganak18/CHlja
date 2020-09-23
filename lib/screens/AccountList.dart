import 'package:shared_preferences/shared_preferences.dart';

import 'package:BanksAppBetav1/providers/AccountProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/AccountModel.dart';
import '../widgets/accountAddn.dart';
import './AccountForm.dart';

class AccountsList extends StatefulWidget {
  static const routeName = '/edit-product';

  // final List<Account> useraccounts;
  // AccountsList(this.useraccounts);

  @override
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AccountProvider>(context).fetchAndSet().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshAccs(BuildContext context) async {
    await Provider.of<AccountProvider>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final accountsData = Provider.of<AccountProvider>(context);

    return new Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshAccs(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    top: 25.0, bottom: 10.0, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 675,
                      child: ListView.builder(
                        itemCount: accountsData.items.length,
                        itemBuilder: (_, i) => Column(
                          children: <Widget>[
                            Consumer<AccountProvider>(
                              builder: (context, data, child) {
                                return new AccountAddn(
                                    data.items, data.items[i].id, i);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountForm(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
