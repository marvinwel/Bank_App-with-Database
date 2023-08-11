import 'package:flutter/material.dart';
import 'PaymentForm.dart';

class PaymentButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/payment.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Payment', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


