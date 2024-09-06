import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductCategory(),
    );
  }
}
TextStyle commonLabelTextStyle =
    TextStyle(color: Colors.black, fontSize: 14.5, fontWeight: FontWeight.w100);

TextStyle textStyle =
    TextStyle(color: Color.fromARGB(255, 73, 72, 72), fontSize: 14.5);

TextStyle AmountTextStyle =
    TextStyle(color: Color.fromARGB(255, 73, 72, 72), fontSize: 18);

const TextStyle HeadingStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
);

const TextStyle DropdownTextStyle = TextStyle(
  color: Color.fromARGB(255, 73, 72, 72),
  fontSize: 13,
);

const TextStyle commonWhiteStyle = TextStyle(
  color: Color.fromARGB(255, 243, 234, 234),
  fontSize: 14,
);

BoxDecoration TableHeaderColor = BoxDecoration(
  color: Colors.grey[200],
);

const TextStyle TableRowTextStyle = TextStyle(
  color: Color.fromARGB(255, 73, 72, 72),
  fontSize: 14,
);

void successfullySavedMessage(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green, width: 2),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.greenAccent.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully Saved..!!',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}

void successfullyDeleteMessage(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green, width: 2),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.greenAccent.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully Deleted..!!',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}

void WarninngMessage(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.yellow, width: 2),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.yellowAccent.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.yellow, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kindly fill all the fields..!!',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}

void successfullyUpdateMessage(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green, width: 2),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.greenAccent.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully Updated..!!',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}

class ProductCategory extends StatefulWidget {
  @override
  _ProductCategoryState createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  List<Map<String, dynamic>> tableData = [];
  double totalAmount = 0.0;
  int currentPage = 1;
  int pageSize = 10;
  bool hasNextPage = false;
  bool hasPreviousPage = false;
  int totalPages = 1;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchProductCategory();

  }

  List<Map<String, dynamic>> getFilteredData() {
    if (searchText.isEmpty) {
      return tableData;
    }

    String searchTextLower = searchText.toLowerCase();

    List<Map<String, dynamic>> filteredData = tableData
        .where((data) =>
            (data['cat'] ?? '').toLowerCase().contains(searchTextLower))
        .toList();

    return filteredData;
  }


  Future<void> fetchProductCategory() async {
    // Replace with your machine's actual IP address
    String apiUrl = 'http://localhost:8000/items/';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the response is a list of objects like the one you provided
        List<Map<String, dynamic>> results =
            List<Map<String, dynamic>>.from(jsonData);

        setState(() {
          tableData = results;
          print("Table data: $results");
        });
      } else {
        // Handle the case where the server responds with an error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error: $e');
    }
  }


  String Productid = '';
  String productcategory = '';
  String PrinterName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Category',
                          style: HeadingStyle,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manage and view product categories with ease.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(height: 20),
                        _buildTable(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }

  void loadNextPage() {
    setState(() {
      currentPage++;
    });
    fetchProductCategory();
  }

  void loadPreviousPage() {
    setState(() {
      currentPage--;
    });
    fetchProductCategory();
  }

  Widget _buildTable() {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      height: 400,
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 13, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    height: 30,
                    decoration: TableHeaderColor,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              size: 15,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 5),
                            Text("Name",
                                textAlign: TextAlign.center,
                                style: commonLabelTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height:  30,
                    decoration: TableHeaderColor,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.print,
                              size: 15,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 5),
                            Text("Email",
                                textAlign: TextAlign.center,
                                style: commonLabelTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                  Flexible(
                  child: Container(
                    height:  30,
                    decoration: TableHeaderColor,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 5),
                            Text("Action",
                                textAlign: TextAlign.center,
                                style: commonLabelTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
           ],
            ),
          ),
          if (getFilteredData().isNotEmpty)
            ...getFilteredData().map((data) {
              var productcategory = data['Name'].toString();
              var PrinterName = data['Email'].toString();
              bool isEvenRow = tableData.indexOf(data) % 2 == 0;
              Color? rowColor = isEvenRow
                  ? Color.fromARGB(224, 255, 255, 255)
                  : Color.fromARGB(224, 255, 255, 255);

              return GestureDetector(
                onTap: () {
                  // Open dialog with selected data
                 
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: rowColor,
                            border: Border.all(
                              color: Color.fromARGB(255, 226, 225, 225),
                            ),
                          ),
                          child: Center(
                            child: Text(productcategory,
                                textAlign: TextAlign.center,
                                style: TableRowTextStyle),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: rowColor,
                            border: Border.all(
                              color: Color.fromARGB(255, 226, 225, 225),
                            ),
                          ),
                          child: Center(
                            child: Text(PrinterName,
                                textAlign: TextAlign.center,
                                style: TableRowTextStyle),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: rowColor,
                            border: Border.all(
                              color: Color.fromARGB(255, 226, 225, 225),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  onPressed: () {
                              
                                  },
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
        ]),
      ),
    );
  }


}
