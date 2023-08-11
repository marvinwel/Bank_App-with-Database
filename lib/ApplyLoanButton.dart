import 'package:flutter/material.dart';
import 'LoanForm.dart';

class ApplyLoanButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoanForm() ));
        },
        child: Column(
          children: [
            Ink.image(image: AssetImage('images/loan.png'),
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6,),
            Text('Loan', style: TextStyle(fontSize: 28,color: Colors.blue),),
            SizedBox(height: 6,)
          ],
        )
    );


  }



}


