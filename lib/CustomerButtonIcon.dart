import 'package:bank_database/CustomerOptions.dart';
import 'package:flutter/material.dart';

class CustomerButtonIcon extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerOptions() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/customers.png'),
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Customer', style: TextStyle(fontSize: 32,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


