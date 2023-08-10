import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neuroflowcodeassessment/artistinfo.dart';

class ArtistSearch extends StatefulWidget{
  final String accessToken;

  const ArtistSearch({Key? key, required this.accessToken}): super(key: key);

  @override
  _ArtistSearchState createState() => _ArtistSearchState();
}
  class _ArtistSearchState extends State<ArtistSearch>{
    TextEditingController _searchController = TextEditingController();
    List<Map<String, dynamic>> searchResults = [];

    Future<void> searchSpotify(String query) async {
      String searchUrl = 'https://api.spotify.com/v1/search'; 
      
      var response = await http.get(
        Uri.parse('$searchUrl?q=$query&type=artist'), 
        headers: {'Authorization':'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200){ 
        var jsonResponse = jsonDecode(response.body); 
        List<Map<String, dynamic>> results = []; 
        for (var artist in jsonResponse['artists']['items']) { ///for loop implemented to go through as many artists as possible
          results.add({ //will add the three categories (artist, artist's spotify ID, and follower count ) needed into the results list as it this information is key to providing the user with what they are looking for
            'name': artist['name'],
            'id': artist['id'],
            'followers': artist['followers'],
          });
        }
        setState(() {
          searchResults = results;
        });
      } else {
        throw Exception('Failed');
      }
    }
    void _openArtistInformation(String artistname, String artistId, int nofollowers){ //This function will take the user to the page revealing all of their chosen artist's information
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtistInformation(artistname: artistname, artistId: artistId, nofollowers: nofollowers),
          ),
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for Artist',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchSpotify(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var artist = searchResults[index];
                  var artistId = artist['id'];

                  return ListTile(
                    title: Text(artist['name']),
                    onTap: () { 
                      _openArtistInformation( 
                        artist['name'],
                        artistId,
                        artist['followers']['total'],
                      ); 
                    },
                    leading: searchResults.isNotEmpty
                        ? Image.network(
                            'https://i.scdn.co/image/${searchResults[0]['id']}',
                            width: 50, 
                            height: 50,
                          )
                        : SizedBox.shrink(),
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}
