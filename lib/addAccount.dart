import 'package:flutter/material.dart';
import 'accountForm.dart';

class addAccountButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => accountForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/bankAccount.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Add Account', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


