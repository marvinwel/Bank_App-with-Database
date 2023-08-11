import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class customerForm extends StatefulWidget{

  State<customerForm> createState() => customerFormState();
}


class customerFormState extends State<customerForm>{


  String? _dropdownValue;
  String? accountType;
  String? Custname;
  String? CustSSN;
  String? CustAddresss;
  String? CustCity;
  String? branch;
  String? depositAmount;
  String? date;
  String? AccountNumber;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  List<String> list = <String>['Checkings', 'Savings'];

  List<String> Employee = [];
  List<String> EmployeeSSN = [];
  int tableCount=0;
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

    var result = await pool.execute("Select Name, SSN from Employee");



    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        Employee.add(row.colAt(0).toString());
        EmployeeSSN.add(row.colAt(1).toString());
        tableCount++;
      });}

    pool.close();
  }


  Future<void> InsertData() async{
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "Bank", // optional
    );

// actually connect to database
    await conn.connect();

    int indexValue = Employee.indexOf(_dropdownValue.toString());


    var stmt = await conn.prepare(
      "INSERT INTO Customer (SSN, City, Name, Street, ESSN,BankerType) VALUES (?, ?, ?, ?, ?, ?)",
    );

    //insert into customer table
    if(checkBoxValue1 ){
      await stmt.execute([CustSSN, CustCity, Custname, CustAddresss, EmployeeSSN.elementAt(indexValue), "Personal Banker"]); //supervisor SSSN
    }else if(checkBoxValue2){
      await stmt.execute([CustSSN, CustCity, Custname, CustAddresss, EmployeeSSN.elementAt(indexValue), 'Loan Officer' ]); //another supervisor
    }


    //insert into held table
    var stmt2 = await conn.prepare("INSERT INTO Held_Account (CSSN) VALUES (?)",);
    await stmt2.execute([CustSSN]);

    //fetch account number
    var result = await conn.execute("Select AccountNumber,CSSN from Held_Account");



    for (final row in result.rows) {

      //print(row.assoc());
      //print(row.colAt(0));



      if(CustSSN == row.colAt(1).toString() ){

        setState(() {
          AccountNumber = row.colAt(0).toString();
        });

      }}



    if(identical(accountType,"Checkings")) {
      var accountStmt = await conn.prepare("INSERT INTO Checking (AccountNumber, RecentDate, Balance, OverDraft, Deposit,Withdraw) VALUES (?, ?, ?, ?, ?, ?)");
      await accountStmt.execute([AccountNumber,date,depositAmount,500.00,depositAmount,0.00]);
    }
    else if(identical(accountType,"Savings")) {
      var accountStmt = await conn.prepare("INSERT INTO Saving (AccountNumber, RecentDate, Balance, InterestRate, Deposit,Withdraw) VALUES (?, ?, ?, ?, ?, ?)");
      await accountStmt.execute([AccountNumber,date,depositAmount,0.01,depositAmount,0.00]);
    }





    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        accountType = selectedValue;
      });
    }
  }

  Widget  calltext(){
    return DropdownMenuItem(child: Text("Branch"),value: "Branch",);
  }

  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = Employee.map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Customer Form"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Welcome!! Join Us!",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Name"),
                  validator: (value){
                    if(value!.isEmpty ){ //|| RegExp(r'^[a-z A-Z]').hasMatch(value!)
                      return "Please Enter name";
                    }else{
                      Custname = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "SSN (xxxxxxxxx)"),
                  validator: (value){
                    if(value!.isEmpty ){ //RegExp(r'^[0-9]{9,9}').hasMatch(value!)
                      return "Please Enter SSN";
                    }else{
                      CustSSN = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Address"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter Address";
                    }else{
                      CustAddresss = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "City"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter City";
                    }else{
                      CustCity = value;
                      return null;}
                  },),),
              SizedBox(height: 20,),
              // Container(
              //   margin: EdgeInsets.only(left: 30,right: 100),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //         labelText: "Phone Number xxx-xxx-xxxx"),
              //     validator: (value){
              //       if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
              //         return "Please Enter corrrect Date Format";
              //       }else{
              //         phoneNumber = value;
              //         return null;}
              //     },),),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Bank Employee: ",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: _dropdownValue,onChanged: (val) => setState(() => _dropdownValue = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),

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
                    child: Text("Personal Banker", style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
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
                    child: Text("Loan Officer", style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
                  ),

                ],
              ),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Account Type: ",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),

              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                  value: accountType,onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        accountType = value!;
                      });
                    },
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Date"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter Date";
                    }else{
                      date = value;
                      return null;}
                  },),),
              Container(
                margin: EdgeInsets.only(left: 30,right: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Deposit Amount"),
                  validator: (value){
                    if(value!.isEmpty ){  //|| RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$').hasMatch(value!)
                      return "Please Enter Deposit Amount";
                    }else{
                      depositAmount = value;
                      return null;}
                  },),),

              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tData Submitted!!')),

                      );

                      InsertData();

                      print("Value : $Custname");
                      print("Value : $CustSSN");
                      print("Value : $CustAddresss");
                      print("Value : $CustCity");
                      print("Value : $_dropdownValue");
                      print("account type: $accountType");

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
}