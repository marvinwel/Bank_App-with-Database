import 'package:flutter/material.dart';
import 'customerForm.dart';

class NewCutomerButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => customerForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/newcustomer.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('New Customer', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


