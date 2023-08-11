import 'package:flutter/material.dart';
import 'NewEmployeeForm.dart';
import 'AccountOptions.dart';

class OpenAccountButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountOptions() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/account.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Account', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


