import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class locateStore extends StatefulWidget {
  const locateStore({super.key});

  @override
  State<locateStore> createState() => _locateStoreState();
}

class _locateStoreState extends State<locateStore> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Locations'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.brightness_1, // You can use any bullet icon here
                        size: 10,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: locations[index],
                    style: TextStyle(
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
    );
  }
}