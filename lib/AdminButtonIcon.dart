import 'package:flutter/material.dart';
import 'AdminOptions.dart';

class AdminButtonIcon extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminOptions() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/admin.png'),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Admin', style: TextStyle(fontSize: 32,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


