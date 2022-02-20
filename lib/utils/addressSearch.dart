import 'package:clicandeats/services/placesServices.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate {
  AddressSearch(this.sessionToken) : super(searchFieldLabel: 'Rechercher') {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  late PlaceApiProvider apiClient;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Dégager', //Clear
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Dos', //Back
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == ""
            ? null
            : apiClient.fetchSuggestions(
                query, Localizations.localeOf(context).languageCode),
        builder: (context, AsyncSnapshot snapshot) {
          if (query == '')
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                  child: Text(
                      'Entrez votre adresse svp')), //Enter your restaurant address
            );
          else if (snapshot.hasData)
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.location_pin,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(snapshot.data![index].description),
                  onTap: () {
                    close(context, snapshot.data[index]);
                  },
                ),
              ),
              itemCount: snapshot.data!.length,
            );
          else if (snapshot.hasError)
            {
              print('${snapshot.error}');
              return Text('$errorText}');
            }
          else
            return Container(child: Center(child: Text('$loadingText...')));
        });
  }
}
