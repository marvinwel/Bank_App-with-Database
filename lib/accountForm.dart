import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class accountForm extends StatefulWidget{

  State<accountForm> createState() => accountFormState();
}


class accountFormState extends State<accountForm>{


  String? custName,loanAmount,loanNumber,loanType;
  String? name;
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  int index=0,accountNumber=0;
  double depositAmount=0.00,checkingBalance=0.00;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;

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
    var result = await pool.execute("select * from Customer order by NAME");


    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        CustName.add(row.colAt(2).toString());
        custSSn.add(row.colAt(0).toString());
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

    //get account number
    var result = await conn.execute("Select * from Customer as c, Held_Account as h where c.NAME=\'$custName\' and c.SSN=h.CSSN");
    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      //update account number
      setState(() {
        accountNumber = int.parse(row.colAt(7).toString());
      });}

    //insert into Savings table
    var stmt = await conn.prepare("INSERT INTO Savings (AccountNumber,RecentDate, Balance, InterestRate,Deposit,Withdraw) VALUES (?, ?, ?, ?,?,?)",);
    await stmt.execute([int.parse(accountNumber.toString()) ,date.toString(), depositAmount,0.01,depositAmount,0.00]);


    conn.close();
  }









  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = CustName.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();

    return Scaffold(
      appBar: AppBar(title: Text("New Account"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Add A New Account",style: TextStyle(fontSize: 22, color: Colors.blue),),
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
              Container(margin: EdgeInsets.only(left: 30,top: 15),child: Text("Choose Acount Type",style: TextStyle(fontSize: 15,color: Colors.grey[700])),),

              //checkbox here
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Checkbox(
                      value: checkBoxValue1,
                      onChanged: (bool? value){

                        setState(() {
                          checkBoxValue1 = value!;
                        });},),),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 10),
                    child: Text("Checking Account", style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                  ),

                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Checkbox(
                      value: checkBoxValue2,
                      onChanged: (bool? value){

                        setState(() {
                          checkBoxValue2 = value!;
                        });},),),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 10),
                    child: Text("Saving Account", style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                  ),

                ],
              ),

              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Deposit Amount"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter Payment Amount";
                    }else{
                      depositAmount = double.parse(value);
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



                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate() ) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tAccount Added!!')),);



                    }

                  },
                  child: const Text('Submit'),
                ),
              )

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


    });
  }
}