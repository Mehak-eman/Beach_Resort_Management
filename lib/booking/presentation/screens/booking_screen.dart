import 'package:beach_resort_management/booking/models/booking_model.dart';
import 'package:beach_resort_management/booking/presentation/viewmodels/booking_view_model.dart';
import 'package:beach_resort_management/payment/presentation/screens/payment_screen.dart';
import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class BookingScreen extends StatefulWidget {

  final RoomModel room;

  const BookingScreen({
    super.key,
    required this.room,
  });


  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();

}



class _BookingScreenState extends State<BookingScreen>{


DateTime checkIn =
DateTime.now();


DateTime checkOut =
DateTime.now()
.add(
const Duration(days:2)
);



int rooms = 1;

int guests = 2;


bool loading=false;



double get totalPrice {

final nights =
checkOut.difference(checkIn).inDays;


return widget.room.pricePerNight *
rooms *
(nights <=0 ? 1 : nights);

}





Future<void> selectDate(
bool isCheckIn
) async {


final date =
await showDatePicker(

context: context,

firstDate:
DateTime.now(),

lastDate:
DateTime(2030),

initialDate:
DateTime.now(),

);



if(date!=null){

setState((){

if(isCheckIn){

checkIn=date;

}else{

checkOut=date;

}

});

}

}




Future<void> confirmBooking() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please login first"),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  final booking = BookingModel(
    userId: user.id,
    resortId: widget.room.resortId,
    roomId: widget.room.id!,
    checkIn: checkIn,
    checkOut: checkOut,
    guests: guests,
    totalPrice: totalPrice,
    bookingStatus: "Pending",
    paymentStatus: "Pending",
  );

  try {
    final createdBooking = await context
        .read<BookingViewModel>()
        .createBooking(booking);

    setState(() {
      loading = false;
    });

    if (createdBooking != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            booking: createdBooking,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking failed"),
        ),
      );
    }
  } catch (e) {
    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }
}





@override
Widget build(BuildContext context){


return Scaffold(


appBar:
AppBar(

title:
const Text(
"Booking Details"
),

),



body:
Padding(

padding:
const EdgeInsets.all(20),


child:
Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



Text(

widget.room.roomType,

style:
const TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:25),




ListTile(

title:
const Text(
"Check In"
),

subtitle:
Text(
"${checkIn.day}/${checkIn.month}/${checkIn.year}"
),

trailing:
IconButton(

icon:
const Icon(
Icons.calendar_month
),

onPressed:
()=>selectDate(true),

),

),




ListTile(

title:
const Text(
"Check Out"
),

subtitle:
Text(
"${checkOut.day}/${checkOut.month}/${checkOut.year}"
),

trailing:
IconButton(

icon:
const Icon(
Icons.calendar_month
),

onPressed:
()=>selectDate(false),

),

),





Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[


const Text(
"Rooms",
style:
TextStyle(
fontSize:18
),
),



Row(

children:[


IconButton(

onPressed:(){

if(rooms>1){

setState((){

rooms--;

});

}

},

icon:
const Icon(
Icons.remove
),

),



Text(
"$rooms"
),



IconButton(

onPressed:(){

setState((){

rooms++;

});

},

icon:
const Icon(
Icons.add
),

),


],

)

],

),





const SizedBox(height:20),




Text(

"Guests: $guests",

style:
const TextStyle(
fontSize:18
),

),



const Spacer(),



Text(

"Total Price: \$${totalPrice.toStringAsFixed(0)}",

style:
const TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),




const SizedBox(height:20),




SizedBox(

width:
double.infinity,


child:
ElevatedButton(

onPressed:
loading?
null:
confirmBooking,


child:

loading

?
const CircularProgressIndicator()

:
const Text(
"Confirm Booking"
),


),

)


],

),

),

);

}


}