import 'package:flutter/material.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/bloc/marketplace/vendor_row.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/theme_data.dart' as theme;

class MarketplacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MarketplacePageState();
  }
}

class MarketplacePageState extends State<MarketplacePage> {
  final String _title = "Marketplace";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MarketplaceBloc _marketplaceBloc = AppBlocsProvider.of<MarketplaceBloc>(context);
    return StreamBuilder(
        stream: _marketplaceBloc.vendorsStream,
        builder: (context, snapshot) {
          VendorModel vendorsModel;
          if (snapshot.hasData) {
            vendorsModel = snapshot.data;
          }

          if (vendorsModel == null) {
            return Center(child: RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/bitrefill')));
          }

          if (vendorsModel != null) {
            return _buildScaffold(Center(
                child: Text("There are no available vendors at the moment.")));
          }

          return _buildScaffold(_buildVendors(vendorsModel));
        });
  }

  Widget _buildScaffold(Widget body) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
        leading: backBtn.BackButton(),
        title: new Text(
          _title,
          style: theme.appBarTextStyle,
        ),
        elevation: 0.0,
      ),
      body: body,
    );
  }

  Widget _buildVendors(VendorModel vendorModel) {
    return ListView(
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, index) =>
              new VendorRow(vendorModel.vendorsList[index]),
          itemCount: vendorModel.vendorsList.length,
          itemExtent: 200.0,
        )
      ],
    );
  }
}
