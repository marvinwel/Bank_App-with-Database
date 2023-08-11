import 'package:flutter/material.dart';
import 'ViewDetails.dart';

class Info extends StatelessWidget{

  String? SSN,City,name,Street,ESSN,accountNumber,date,balance,overdraft,deposit,withdraw,bankerType,loanAmount;
  bool savings,loan,checkings;
  Info(this.SSN,this.City,this.name,this.Street,this.ESSN,this.accountNumber,this.date,this.balance,this.overdraft,this.deposit,this.withdraw,this.savings,
      this.bankerType,this.loanAmount,this.loan,this.checkings);

  @override
  Widget build(BuildContext context) {

    Widget? widget ;

        if(checkings){
          widget= Column(
            children: [
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Name : $name",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("SSN : $SSN",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Address : $Street, $City",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Date opened : $date",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Account Number : $accountNumber",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Balance : $balance",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Overdraft Limit : $overdraft",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Amount Deposited : $deposit",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Withdraw : $withdraw",style: TextStyle(color: Colors.blue,fontSize: 20),),),
            ],
          );
        }
        else if(savings){
          widget= Column(
            children: [
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Name : $name",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("SSN : $SSN",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Address : $Street, $City",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Date opened : $date",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Account Number : $accountNumber",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Balance : $balance",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Interest Rate : $overdraft",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Amount Deposited : $deposit",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Withdraw : $withdraw",style: TextStyle(color: Colors.blue,fontSize: 20),),),
            ],
          );
        }
        else if(loan){
          widget = Column(
            children: [
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Name : $name",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("SSN : $SSN",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Address : $Street, $City",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Branch Name : $overdraft",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Loan Number : $accountNumber",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Loan Amount : $loanAmount",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Approval Date : $deposit",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Date opened : $deposit",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Loan Type : $withdraw",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Date Payment : $date",style: TextStyle(color: Colors.blue,fontSize: 20),),),
              Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Payment Amount : $balance",style: TextStyle(color: Colors.blue,fontSize: 20),),),








            ],
          );
        }
        else{
          widget = Column(children: [
          Container(margin: EdgeInsets.only(left: 100,top: 100,),child: Text("No Account Found!",style: TextStyle(color: Colors.red,fontSize: 32),),),
          ],);

        }

        return widget;





    //   Column(
    //   children: [
    //     Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Name : $name",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("SSN : $SSN",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Address : $Street",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Date opened : $date",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 10,),child: Text("Account Number : $accountNumber",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Balance : $balance",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //
    //
    //     savings ?
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Interest Rate : $overdraft",style: TextStyle(color: Colors.blue,fontSize: 20),),)
    //     :
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Overdraft Limit : $overdraft",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //
    //
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Amount Deposited : $deposit",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //     Container(margin: EdgeInsets.only(left: 30,top: 20,),child: Text("Withdraw : $withdraw",style: TextStyle(color: Colors.blue,fontSize: 20),),),
    //   ],
    // );


  }



}


