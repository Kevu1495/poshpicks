import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:url_launcher/url_launcher.dart';

import 'get_location.dart';

class LocateStore extends StatefulWidget {
  const LocateStore({super.key});

  @override
  State<LocateStore> createState() => _LocateStoreState();
}

class _LocateStoreState extends State<LocateStore> {
  final List<String> locations = [
    '1st Floor, Narayan Niwas, Plot 720 A, Hanuman Rd, near Gazali Hotel, Om Shri Siddhivinayak Society, Navpada, Vile Parle East, Vile Parle, Mumbai, Maharashtra 400057',
    'No 001/101, The Destination MG Road Next Shopper Stop, Brindavan Colony, Chembur West, Tilak Nagar, Chembur, Mumbai, Maharashtra 400089',
    'Hardcastle Restaurants Pvt Ltd,Shop No.5, Kohinoor corner Shop No.5, Kohinoor corner, Swatantryaveer Savarkar Rd, opposite Siddhi Vinayak Temple, Prabhadevi, Mumbai, Maharashtra 400025',
    'Plot No 6A, Ripplez Mall, Sec -8, Sector 7, Airoli, Navi Mumbai, Maharashtra 400708',
    '5/76 Padam Singh Road West, Ajmal Khan Rd, Near Tanishq Jewellery - Delhi - Karol Bagh, Block 5, WEA, Karol Bagh, Delhi, 110005',
    'Block No. 5 Plot, 4, Desh Bandhu Gupta Rd, near Sheila Cinema, Arya Nagar, Paharganj, New Delhi, Delhi 110055',
    'Plot No C7/67/1, Arte Services Pvt Ltd, Gunjan Rd, GIDC Housing Board Colony, Vapi East, Crossroads, Vapi, Gujarat 396195',
    ' S No 3, GF, Millionaire Business Park, Subhash Chandra Bose Marg, TGB, Adajan Gam, Adajan, Surat, Gujarat 395009',
    'Ground Floor, NH 8, near Cheverolet Showroom, Vadadla, Bharuch, Gujarat 392015',
    'Plot No 2, Paiki No 3 & 14, 15 To 19 Revenue Sy No 342, beside Essar Petrol Pump, Vidhyanagar, Nagalpur, Mehsana, Gujarat 384002',
  ];
  bool isLoading = false;
  String lat = '';
  String long = '';
  void redirectToURL({required String query}) async {
    setState(() {
      isLoading = true;
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            );
          });
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) {
      //       return Scaffold(
      //         backgroundColor: Colors.transparent,
      //         body: Center(
      //           child: CircularProgressIndicator(
      //             color: greenColor,
      //           ),
      //         ),
      //       );
      //     }));
    });
    Position position = await determinePosition();
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      isLoading = false;
      Navigator.of(context).pop();
    });
// This is the 255th attempt to try to understand what's happening
    //increase counter if you failed to understand
    //counter=255
    var url = Uri.parse(
        "https://www.google.com/maps/search/$query/@$lat,$long,15.25z?entry=ttu");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  void _sendEmail() async {
    final GoogleSignInAccount? user = await GoogleAuthApi().signIn();
    final email = user!.email;
    final auth = await user.authentication;
    final token = auth.accessToken;
    final smtpServer = gmailSaslXoauth2(email, token!);
    final message = Message()
      ..from = Address(email, 'Aditya')
      ..recipients = ['2021.aditya.kushwaha@ves.ac.in']
      ..subject = 'Test'
      ..text = 'Hi';
    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sent email')));
    } on MailerException catch (err) {
      print('mail error$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Locations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons
                                  .brightness_1, // You can use any bullet icon here
                              size: 10,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: locations[index],
                          style: const TextStyle(
                              color: Colors.black), // Adjust style as needed
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Handle when a location is tapped
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    redirectToURL(query: 'MacDonalds');
                  },
                  child: Text('Google Maps')),
              ElevatedButton(
                  onPressed: () {
                    _sendEmail();
                  },
                  child: Text('Place Order')),
            ],
          )
        ],
      ),
    );
  }
}

class GoogleAuthApi {
  final _googleSignIn = GoogleSignIn();
  Future<GoogleSignInAccount?> signIn() async {
    try {
      {
        return await _googleSignIn.signIn();
      }
    } catch (err) {
      print('google error' + err.toString());
    }
  }
}
