import 'dart:io';

import 'package:beach_resort_management/profile/models/profile_model.dart';
import 'package:beach_resort_management/profile/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditProfileScreen extends StatefulWidget {


final ProfileModel profile;


const EditProfileScreen({

super.key,

required this.profile,

});





@override
State<EditProfileScreen> createState()
=> _EditProfileScreenState();

}



class _EditProfileScreenState 
extends State<EditProfileScreen>{



late TextEditingController nameController;

late TextEditingController phoneController;

late TextEditingController imageController;



bool loading=false;
File?
selectedImage;


String?
imageUrl;

Future<void> pickImage() async {


final picker =
ImagePicker();



final image =
await picker.pickImage(
source:
ImageSource.gallery,
);



if(image != null){


setState((){

selectedImage =
File(image.path);

});


}


}

@override
void initState(){

super.initState();


nameController =
TextEditingController(
text: widget.profile.name,
);



phoneController =
TextEditingController(
text: widget.profile.phone,
);



imageController =
TextEditingController(
text: widget.profile.avatarUrl ?? "",
);



}




Future<void> saveProfile() async{


setState((){

loading=true;

});

String? uploadedUrl;


XFile? selectedImage;

if (selectedImage != null) {
  uploadedUrl = await context
      .read<ProfileViewModel>()
      .uploadImage(
        selectedImage!,
        widget.profile.id,
      );
}



final updatedProfile =
ProfileModel(

id: widget.profile.id,

name:
nameController.text.trim(),

email:
widget.profile.email,

phone:
phoneController.text.trim(),

avatarUrl:

uploadedUrl ??
widget.profile.avatarUrl,

);



await context
.read<ProfileViewModel>()
.updateProfile(
updatedProfile,
);



setState((){

loading=false;

});



if(context.mounted){

Navigator.pop(context);

}


}




@override
Widget build(BuildContext context){


return Scaffold(

appBar:
AppBar(

title:
const Text(
"Edit Profile",
),

),



body:
Padding(

padding:
const EdgeInsets.all(20),


child:
Column(

children:[



TextField(

controller:
nameController,

decoration:
const InputDecoration(

labelText:"Name",

prefixIcon:
Icon(Icons.person),

),

),



const SizedBox(height:20),



TextField(

controller:
phoneController,

keyboardType:
TextInputType.phone,

decoration:
const InputDecoration(

labelText:"Phone",

prefixIcon:
Icon(Icons.phone),

),

),



const SizedBox(height:20),



GestureDetector(

onTap:pickImage,


child:
CircleAvatar(

radius:55,


backgroundImage:

selectedImage != null

?

FileImage(
selectedImage!
)

:

widget.profile.avatarUrl != null

?

NetworkImage(
widget.profile.avatarUrl!
)

:

null,


child:
selectedImage == null &&
widget.profile.avatarUrl == null

?

const Icon(
Icons.camera_alt,
size:40,
)

:

null,


),

),



const Spacer(),




SizedBox(

width:
double.infinity,


child:
ElevatedButton(

onPressed:
loading
?
null
:
saveProfile,


child:

loading

?

const CircularProgressIndicator(
color:Colors.white,
)

:

const Text(
"Save Changes",
),

),

)


],

),

),

);

}


}