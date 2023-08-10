import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArtistInformation extends StatelessWidget{
  final String artistname;  
  final String artistId; 
  final int nofollowers; //This variable is called nofollowers because it is the phrase "Number of Followers" shortened


  const ArtistInformation({super.key, 
    required this.artistname,
    required this.artistId,
    required this.nofollowers,
  });
@override
Widget build(BuildContext context){
  String imageUrl = 'https://i.scdn.co/image/$artistId';
  print('Image URL: $imageUrl'); //print statement was implemented to see if the correct image was being received for a specific artist through the terminal; There were multiple issues that prevented my android emulator from connecting to my code and my web emulator displayed error messages
  
 //To Do: Ensure that the app shows the correct image; multiple urls were tested but the image did not show up and provided error messages
  
  return Scaffold(
    appBar: AppBar(
      title: const Text('Artist Finder'), 
      backgroundColor: Colors.deepPurple.shade300,
    ),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.network(imageUrl),
      const SizedBox(height:20),
      Text(
        'Artist: ',
        style: TextStyle(fontWeight: FontWeight.bold),  //Bolded to highlight information category to ensure users know what type information they are looking at 
        ), 
      Text(
        '$artistname',
        style:TextStyle(fontWeight:FontWeight.normal)
      ),
      const SizedBox(height:10),
      Text(
        'Followers: ',
        style: TextStyle(fontWeight: FontWeight.bold), 
      ),
      Text(
        NumberFormat.decimalPattern().format(nofollowers),
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
    ],
  )
  );
}
}