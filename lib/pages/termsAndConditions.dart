import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class TermsCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: _settings.themeLight ? Colors.black :Colors.white, fontSize: 16),
        title: Text('Terms and Conditions'),),
      body: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 150)).then((value) {
          return rootBundle.loadString('assets/termAndConditions.md');
        }),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Markdown(
              data: snapshot.data.toString(),
            );
          }
          else if(snapshot.hasError){
            return Center(child: Text("$errorText"));
          }
          else return Center(child: Text('$loadingText...'));
        },
      ),
    );
  }
}
