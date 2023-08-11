import 'package:flutter/material.dart';
import 'BankForm.dart';

class NewBranch extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BankForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/bankimage.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Open Branch', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


