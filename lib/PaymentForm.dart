import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class PaymentForm extends StatefulWidget{

  State<PaymentForm> createState() => PaymentFormState();
}


class PaymentFormState extends State<PaymentForm>{


  String? custName,loanAmount,loanNumber,loanType;
  String? name,notification=" ";
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  int index=0,accountNumber=0;
  double paymentAount=0.00,checkingBalance=0.00,overDraft=0.00;
  String? selectBranch;
  bool checkBoxValue = false,loan = false;

  List<String> CustName = [];
  List<String> LoanNumber = [];
  List<String> LoanAmount = [];
  List<String> custSSn = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }


  Future<void> connect() async{

    final pool = MySQLConnectionPool(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'password',
      maxConnections: 100,
      databaseName: 'Bank', // optional,
    );

    //get data
    var result = await pool.execute("select * from Customer as c, Borrow as b,Loan as l where b.SSN = c.SSN and l.LoanNumber = b.LoanNumber order by c.NAME");


    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        CustName.add(row.colAt(2).toString());
        custSSn.add(row.colAt(0).toString());
        LoanNumber.add(row.colAt(8).toString());
        LoanAmount.add(row.colAt(9).toString());
      });}




    pool.close();
  }


  Future<void> UpdateData() async{
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "Bank", // optional
    );

    //connect to database
    await conn.connect();


    // //get ssn from customer table
    // int indexValue = CustName.indexOf(custName.toString());
    // print("Index value : $indexValue");

    var result = await conn.execute("Select * from Customer as c, Held_Account as h, Checking as ch where c.SSN=h.CSSN and c.NAME=\'$custName\' and ch.AccountNumber=h.AccountNumber");
    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        checkingBalance = double.parse(row.colAt(10).toString());
        accountNumber = int.parse(row.colAt(8).toString());
        overDraft = double.parse(row.colAt(11).toString());//overdraft is 11
      });}

    print("Checking balance : $checkingBalance");
    print("new balance is ${paymentAount-checkingBalance}");
    print("account number : ${accountNumber}");

    //update loan amount
    if( paymentAount < checkingBalance){

      //update checking account balance
      await conn.execute("UPDATE Checking SET Balance = :Balance,Withdraw = :withdraw where AccountNumber = :AccountNumber", {
        "Balance": (checkingBalance-paymentAount),
        "withdraw" : paymentAount,
        "AccountNumber" : accountNumber});

      //update loan amount
      await conn.execute("UPDATE Loan SET LoanAmount = :LoanAmount,DatePayment = :date,PaymentAmount = :PaymentAmount where LoanNumber = :LoanNumber", {
        "LoanAmount": (double.parse(LoanAmount.elementAt(index))-paymentAount),
        "date": date,
        "PaymentAmount" : paymentAount,
        "LoanNumber":LoanNumber.elementAt(index)});
    }
    else{

      //update checking account balance ad overdraft
      print("execute 1");
      await conn.execute("UPDATE Checking SET Balance=\'00.00\', OverDraft = \'${(overDraft - (paymentAount-checkingBalance))}\', Withdraw = ${paymentAount} where AccountNumber = ${accountNumber}");
      //OverDraft = \'${(overDraft - (paymentAount-checkingBalance))}\',
      // await conn.execute("UPDATE Checking SET Balance = :Balance, OverDraft = :overdraft, Withdraw = :withdraw where AccountNumber = :AccountNumber", {
      //   "Balance": double.0.00,
      //   "overdraft" : (overDraft - (paymentAount-checkingBalance)),
      //   "withdraw" : paymentAount,
      //   "AccountNumber" : accountNumber});

      //update loan amount
      print("execute 2");
      await conn.execute("UPDATE Loan SET LoanAmount = :LoanAmount,DatePayment = :date,PaymentAmount = :PaymentAmount where LoanNumber = :LoanNumber", {
        "LoanAmount": (double.parse(LoanAmount.elementAt(index))-paymentAount),
        "date": date,
        "PaymentAmount" : paymentAount,
        "LoanNumber":LoanNumber.elementAt(index)});
      setState(() {

      });

    }
    print(overDraft);
    print("checking balance: ${checkingBalance} \n payment amount : ${paymentAount}");


    //get notiification
    var result2 = await conn.execute("Select * from notifications;");
    for (final row in result2.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      //save message
      setState(() {
        notification = row.colAt(0).toString();
      });}

    //delete all data in table
    await conn.execute("DELETE FROM notifications;",);









    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        custName = selectedValue;
      });
    }
  }

  Widget  calltext(){
    return DropdownMenuItem(child: Text("Branch"),value: "Branch",);
  }

  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = CustName.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Payment"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Loan Payment",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Customer",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: custName,onChanged: changedValue,
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              SizedBox(height: 20,),
              loan ?
              Container(margin: EdgeInsets.only(left: 30,right: 100),child: Text("Loan Amount : \$${LoanAmount.elementAt(index)}",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),)
                  :
              Container(margin: EdgeInsets.only(left: 30,right: 100),child: Text("Loan Amount : \$0.00",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Payment Amount"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter Payment Amount";
                    }else{
                      paymentAount = double.parse(value);
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Date  YYYY-MM-DD"),
                  validator: (value){
                    if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
                      return "Please Enter Date";
                    }else{
                      date = value;
                      return null;}
                  },),),
              SizedBox(height: 15,),
              SizedBox(height: 20,),
              SizedBox(height: 20,),






              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {

                    UpdateData();


                    print("paymet amount before if  $paymentAount");
                    print("checking balance amount before if  $checkingBalance");

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate() ) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('\t\t\t\t$notification')),);
                      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tPayment Submitted!!')),);



                      print("Value : $name");
                      print("Value : $SSN");
                      print("Value : $date");
                      print("Value : $phoneNumber");
                      print("Value : $custName");

                    }

                  },
                  child: const Text('Submit'),
                ),
              ),

              Text(notification.toString()),

            ],

          ),
        ),
      ),
    );
  }

  changedValue(value) {
    //(val) => setState(() => custName = val)
    setState(() {
      custName = value;
      index = CustName.indexOf(custName.toString());
      if(double.parse(LoanAmount.elementAt(index)) > 0.00){
        loan = true;
      }

    });
  }
}