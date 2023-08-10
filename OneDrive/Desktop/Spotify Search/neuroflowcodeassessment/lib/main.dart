//Sanjana Gunda
//August 9th, 2023
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'artistsearch.dart';

const String clientId = 'e984abca99da42a69b1814ee7eceb7ee'; 
const String clientSecret = '3068a3dbd0ab4d53bf7b00c5ecb40f98';

Future<String?> getAccessToken() async { //function created to gain an access token for the app; Allows for information from the API to be obtained
  String tokenUrl = 'https://accounts.spotify.com/api/token';
  String basicAuth = 'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}'; //encoding is implemented to gain the access token from the client ID and secret provided

Future<Map<String, dynamic>?> searchArtist(String query, String accessToken) async{
  String apiUrl = 'https://api.spotify.com/v1/artists/0TnOYISbd1XYRBk9myaseg';
  Map<String, String>headers = {
    'Authorization': 'Bearer $accessToken',
  };
  try{
    var response = await http.get(
      Uri.parse('$apiUrl?q=$query&type=artist'), //provides the link to the information the user is searching for through combining the search url and the artist information based on what the user types
      headers: headers,
      );
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body); //Translates JSON information into information comprehensible by Dart in order to provide information from the API
    return jsonResponse['artists'];
  } else{
    print ('Artist not Found: ${response.statusCode}');
    return null;
  }
  }catch (e){
    print('Unexpected Error: $e');
    return null;
  }
}

 try{ 
  var response = await http.post(
    Uri.parse(tokenUrl),
    headers: {
      'Authorization':basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {'grant_type':'client_credentials'},
  );
  if (response.statusCode == 200){
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['access_token']; 
  } else{
    print('Failed to get Access token: ${response.statusCode}');
    return null;
    }
 }catch (e){
  print('Error during API call: $e');
  return null;
 }
}
void main() async{
  String? accessToken = await getAccessToken(); //Function created to make sure that the correct access token is received
  if (accessToken != null) {
    runApp(ArtistApp(accessToken: accessToken));
  } else {
    print('Access token is null');
  }
}

class ArtistApp extends StatelessWidget {
  final String accessToken;

  const ArtistApp({Key? key , required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Artist Finder'),
          backgroundColor: Colors.deepPurple.shade400,
        ),
        body: ArtistSearch(accessToken: accessToken))
    );
  }
}