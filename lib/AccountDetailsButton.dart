import 'package:flutter/material.dart';
import 'ViewDetails.dart';

class AccountDetailsButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetails() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/accountDetail.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Details', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


