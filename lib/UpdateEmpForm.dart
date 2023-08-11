import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class UpdateEmpForm extends StatefulWidget{

  State<UpdateEmpForm> createState() => UpdateEmpFormState();
}


class UpdateEmpFormState extends State<UpdateEmpForm>{


  String? custName,loanAmount,loanNumber,loanType;
  String? name,newHireDate,notification=" ";
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  int index=0,accountNumber=0;
  double depositAmount=0.00,checkingBalance=0.00;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false,hireDate=false;

  List<String> CustName = [];
  List<String> LoanNumber = [];
  List<String> LoanAmount = [];
  List<String> custSSn = [];
  List<String> startDate = [];
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
    var result = await pool.execute("select * from Employee order by Name;");


    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        CustName.add(row.colAt(1).toString());
        custSSn.add(row.colAt(0).toString());
        startDate.add(row.colAt(2).toString());
        //LoanNumber.add(row.colAt(8).toString());
        //LoanAmount.add(row.colAt(9).toString());
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

    //update employee start date
    var result1 = await conn.execute("UPDATE Employee SET Start_Date = \'${newHireDate}\' WHERE Name = \'${custName}\';");

    print("here:::\n");
    print(custName);
    print(newHireDate);
    for (final row in result1.rows) {
      print(row.colAt(0));
    }
    //get notiification
    var result = await conn.execute("Select * from notifications;");
    for (final row in result.rows) {
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









  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = CustName.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Update !!"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Modify Employee",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose Employee",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: custName,onChanged: changedValue,
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              SizedBox(height: 20,),
              hireDate ?
              Container(margin: EdgeInsets.only(left: 30,right: 100),child: Text("Hire Date : ${startDate.elementAt(index)}",style: TextStyle(fontSize: 18,color: Colors.grey[700]),),)
                  :
              Container(margin: EdgeInsets.only(left: 30,right: 100),child: Text("Hire Date : YYYY-MM-DD",style: TextStyle(fontSize: 18,color: Colors.grey[700]),),),
              //Container(margin: EdgeInsets.only(left: 30,top: 15),child: Text("Choose Acount Type",style: TextStyle(fontSize: 15,color: Colors.grey[700])),),


              SizedBox(height: 20,),


              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Enter New Hire Date YYYY-MM-DD"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter Hire Date";
                    }else{
                      newHireDate = value;
                      return null;}
                  },),),

              SizedBox(height: 20,),
              SizedBox(height: 20,),






              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {

                    UpdateData();



                    // Validate returns true if the form is valid, or false otherwise.
                    //if (_formKey.currentState!.validate() ) {
                    if (_formKey.currentState!.validate() ) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Updated")),);



                    }

                  },
                  child: const Text('Submit'),

                ),
              ),
              Text("$notification")

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
      hireDate=true;


    });
  }
}