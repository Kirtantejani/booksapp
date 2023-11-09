import 'dart:async';

import 'package:booksapp/widget/resuableText.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


import '../api/ApiConnection.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final String api = 'https://api.thenotary.app/lead/getLeads';
  late List<dynamic> leads = [];
  bool isLoading = true;
  bool isNetwork=false;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();


  }


  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isLoading = false;
        isNetwork=true;
      });
      // Handle no internet connection, show a message to the user
      // You can display an error message or use a Dialog to inform the user
    } else {
      Completer<void> completer = Completer<void>();
      fetchData(api, {'notaryId': '643074200605c500112e0902'}).then((data) {
        setState(() {
          leads = data['leads'];
          isLoading = false;
        });
        completer.complete();
      }).catchError((error) {

        setState(() {
          isLoading = false;
        });
        completer.completeError(error);
      });
      Future.delayed(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError(
              'Request timed out'); // Complete with an error message if the request takes more than 30 seconds
        }
      });
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .secondaryContainer,
          title: ResuableText(color: Theme
              .of(context)
              .primaryColor,
              size: 24,
              data: 'List Example',
              weight: FontWeight.bold),
        ),
        body: Center(
          child: isNetwork==false? isLoading
              ? const CircularProgressIndicator() // Show loading indicator while fetching data
              : leads != null && leads != []
              ? RefreshIndicator(
            onRefresh: () async{
              await checkInternetConnection();
            },
                child: ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
                var lead = leads[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Name: ${lead['firstName']} ${lead['lastName']}', style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,),
                      subtitle: Text('Email: ${lead['email']}', style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall),
                    ),
                  ),
                );
            },
          ),
              )
              : Text('Failed to load data', style: Theme
              .of(context)
              .textTheme
              .titleMedium,)
              :
          Text('Please on Mobile Data or WIFI!', style: Theme
              .of(context)
              .textTheme
              .titleLarge!.copyWith(
            color: Colors.red.withOpacity(0.5)
          ),)
          , // Show error message if failed to load data
        ),
      );
    }
  }

