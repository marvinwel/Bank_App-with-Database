import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';





// class EmployeeOption extends StatefulWidget{
//
//   State<EmployeeOption> createState() => EmployeeOptionState();
// }
class BranchReport extends StatefulWidget{

  State<BranchReport> createState() => BranchReportState();
}


class BranchReportState extends State<BranchReport>{


  String? _dropdownValue;
  String? name;
  String? SSN;
  String? date;
  String? phoneNumber;
  String? branch;
  bool checkBoxValue = false,data=false;

  List<String> branchName = [];
  List<String> custName = [];
  List<String> loanAccount = [];
  List<String> loanAmount = [];
  List<String> loanBalance = [];
  List<String> accoutNumber = [];
  List<String> checkings = [];
  List<String> Savings = [];
  List<String> list1 =[];
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

    var result = await pool.execute("Select BranchName from Branch");



    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());
      print(row.colAt(0));

      setState(() {
        branchName.add(row.colAt(0).toString());
        tableCount++;
      });}

    pool.close();
  }


  Future<void> requestData() async{
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "Bank", // optional
    );

    //connect to database
    await conn.connect();

    data=true;
    var result = await conn.execute("select * from Customer c inner join Borrow b ON c.SSN = b.SSN inner join Loan l ON b.LoanNumber = l.LoanNumber inner join Held_Account as h ON c.SSN = h.CSSN inner join Checking as chk ON h.AccountNumber = chk.AccountNumber Left JOIN Savings as s ON h.AccountNumber = s.AccountNumber where BranchName = \'${_dropdownValue}\' order by c.NAME;");

    for (final row in result.rows) {
      print("database info here : \n");
      //print(row.assoc());

     // setState(() {
        print(row.colAt(0));
        custName.add(row.colAt(2).toString());
        loanAccount.add(row.colAt(8).toString());
        loanAmount.add(row.colAt(9).toString());
        loanBalance.add(row.colAt(9).toString());
        accoutNumber.add(row.colAt(17).toString());
        checkings.add(row.colAt(19).toString());
        if(identical(row.colAt(25).toString(), "NULL"))
          {
            Savings.add("0.00");
          }
        else{
          Savings.add(row.colAt(25).toString());
        }

      //});
    }






    conn.close();
  }



  void dropdownCallback(String selectedValue){
    if(selectedValue is String){
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  viewReport(){


    if(!list1.isEmpty){
      list1.clear();
      custName.clear();
      loanAccount.clear();
      loanAmount.clear();
      loanBalance.clear();
      accoutNumber.clear();
      checkings.clear();
    }
      for(int i = 0; i<custName.length;i++){

        list1.add('Customer Name : ${custName.elementAt(i)}'
            '\nLoan Number : ${loanAccount.elementAt(i)}'
            //'\nLoan Amount : ${loanAmount.elementAt(i)}'
            '\nLoan Balance : ${loanBalance.elementAt(i)}'
            '\nAccount Number : ${accoutNumber.elementAt(i)}'
            '\nChecking Account Balance : \$${checkings.elementAt(i)}'
            '\nSavings Account Balance : \$${Savings.elementAt(i)}');
      }



    setState(() {

    });


    //   ListView.builder(
    //     padding: const EdgeInsets.all(8),
    //     itemCount: custName.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //         height: 50,
    //         //color: Colors.amber[colorCodes[index]],
    //         child: Center(child: Text('Customer Name : ${custName.elementAt(index)}'
    //             '\nLoan Number : ${loanAccount.elementAt(index)}'
    //             '\nLoan Amount : ${loanAmount.elementAt(index)}'
    //             '\nLoan Balance : ${loanBalance.elementAt(index)}'
    //             '\nAccount Number : ${accoutNumber.elementAt(index)}'
    //             '\nChecking Account Balance : \$${checkings.elementAt(index)}'
    //             '\nSavings Account Balance : \$${Savings.elementAt(index)}')),
    //       );
    //     }
    // );
 }

  @override
  Widget build(BuildContext context){

    List<DropdownMenuItem> menuItemList = branchName.map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
    List<String> item = list1;

    return Scaffold(
      appBar: AppBar(title: Text("Branch"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 15,),
              Container(margin: EdgeInsets.only(left: 100),
                child: Text("Branch Report",style: TextStyle(fontSize: 22, color: Colors.blue),),
              ),




              SizedBox(height: 20,),
              Container(margin: EdgeInsets.only(left: 30,top: 15),
                child: Text("Choose a Branch",style: TextStyle(fontSize: 15,color: Colors.grey[700]),),),
              Container(
                margin: EdgeInsets.only(left: 40,top: 0,right: 200),
                child: DropdownButton(items:menuItemList,
                  value: _dropdownValue,onChanged: (val) => setState(() => _dropdownValue = val),
                  iconEnabledColor: Colors.blue,isExpanded: true,),

              ),


              Container(
                margin: EdgeInsets.only(left: 150, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(' \t\t\tInformation Requested!!')),);



                      requestData();

                      viewReport();
                     setState(() {

                     });
                    }
                  },
                  child: const Text('View Report'),
                ),),

              //data goes here


              //data ? Expanded(child: viewReport()):Container(),

              for ( var i in item ) Container(margin: EdgeInsets.only(left: 20,bottom: 30),child: Text(i.toString(),style: TextStyle(fontSize: 17, color: Colors.blue),),),


            ],
          ),
        ),
      ),
    );
  }
}