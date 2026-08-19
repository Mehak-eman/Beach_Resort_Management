import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:flutter/material.dart';


class FavouriteCard extends StatelessWidget {


final ResortModel resort;


const FavouriteCard({
super.key,
required this.resort,
});



@override
Widget build(BuildContext context){


return Container(

margin:
const EdgeInsets.only(bottom:15),


height:120,


decoration:BoxDecoration(

color:Colors.white,

borderRadius:
BorderRadius.circular(20),


boxShadow:[

BoxShadow(

color:
Colors.black.withOpacity(0.08),

blurRadius:10,

)

]

),



child:Row(

children:[



ClipRRect(

borderRadius:
const BorderRadius.horizontal(
left:Radius.circular(20)
),


child:
Image.network(

resort.imageUrl,

width:120,

height:120,

fit:BoxFit.cover,

),

),



const SizedBox(width:15),



Expanded(

child:Column(

mainAxisAlignment:
MainAxisAlignment.center,

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

resort.name,

style:
const TextStyle(

fontSize:18,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:8),



Row(

children:[

const Icon(
Icons.location_on,
size:18,
color:Colors.red,
),


Expanded(

child:
Text(
resort.location,
overflow:
TextOverflow.ellipsis,
),

)

],

),



const SizedBox(height:8),


Text(

"\$${resort.pricePerNight}/night",

style:
const TextStyle(

color:Colors.blue,

fontWeight:
FontWeight.bold

),

)



]

),

)



],

),

);


}

}