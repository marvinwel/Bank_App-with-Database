import 'package:flutter/material.dart';
import 'NewEmployeeForm.dart';

class NewEmployee extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewEmployeeForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/NewEmployee.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Hire Employee', style: TextStyle(fontSize: 22,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


