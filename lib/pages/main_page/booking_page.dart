import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/constant.dart';
import 'package:movie_app/enums/app_conection_status.dart';
import 'package:movie_app/healper/backup_healper.dart';
import 'package:movie_app/model/ticket_model.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  final String movieTitle;
  final String movieId;

  const BookingPage(
      {super.key, required this.movieId, required this.movieTitle});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _movieController = TextEditingController();
  TextEditingController _ticketsController = TextEditingController();

  DateTime? selectedDate;
  int selectedSlot = -1;

  initData() {
    var user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName);
    _emailController = TextEditingController(text: user?.email);
    _idController = TextEditingController(text: user?.uid);
    _movieController = TextEditingController(text: widget.movieTitle);
  }

  List<String> slots = [
    "12AM-3AM",
    "3AM-6AM",
    "6AM-9AM",
    "9AM-12PM",
    "12PM-3PM",
    "3PM-6PM",
    "6PM-9PM",
    "9PM-12AM"
  ];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDecoration({required String title}) {
      return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.amber)),
        hintText: title,
        hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        helperStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.amber),
      );
    }

    getTitle({required String title}) {
      return Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white.withOpacity(.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400)));
    }

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey.shade900.withOpacity(.8),
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
        height: 75,
        child: Consumer<MovieProvider>(
          builder: (context,data, _) {
            return ElevatedButton(
              child: data.ticketBookingStatus == AppConnectionStatus.loading? CircularProgressIndicator(): Text(
                "Book Ticket",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Constants constants = Constants();
                if(_formKey.currentState!.validate()){
                  if(selectedDate == null){
                    constants.getToast("Please select date");
                  }else if(selectedSlot == -1){
                    constants.getToast("Please select movie time slot");

                  }else{
                    Map<String, dynamic> jsonData = TicketModel(
                        name: _nameController.text,
                        email: _emailController.text,
                        customerId: _idController.text,
                        movieId: widget.movieId,
                        date: selectedDate!.toIso8601String(),
                        timeSlot: slots[selectedSlot],
                        movieTitle: _movieController.text,
                        ticketCount: int.parse(_ticketsController.text),
                        contactNo: _contactController.text)
                        .toJson();
                    data.bookTicket(context: context,  jsonData:  jsonData);
                  }
                }
              },
            );
          }
        ),
      ),
      appBar: AppBar(
        title: Text('Booking Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              getTitle(title: "Name"),
              TextFormField(
                  validator: (val) {
                    if (val == null || val == "") {
                      return "Please enter your name";
                    } else {
                      return null;
                    }
                  },
                  controller: _nameController,
                  style: TextStyle(color: Colors.amber),
                  decoration: getDecoration(title: "Name")),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Email"),
              TextFormField(
                validator: (val) {
                  if (val == null || val == "") {
                    return "Please enter email";
                  } else {
                    return null;
                  }
                },
                controller: _emailController,
                style: TextStyle(color: Colors.amber),
                decoration: getDecoration(title: "email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Customer ID"),
              AbsorbPointer(

                child: TextFormField(
                  controller: _idController,
                  validator: (val) {
                    if (val == null || val == "") {
                      return "Please enter email";
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(color: Colors.amber),
                  decoration: getDecoration(title: "Customer ID"),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Contact No."),
              TextFormField(
                validator: (val) {
                  if (val == null || val == "") {
                    return "Please enter contact no";
                  } else {
                    return null;
                  }
                },
                controller: _contactController,
                decoration: getDecoration(title: "Contact No."),
                style: TextStyle(color: Colors.amber),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Movie Title"),
              AbsorbPointer(
                child: TextFormField(
                  controller: _movieController,
                  decoration: getDecoration(title: "Movie Title"),
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "No. Of tickets required"),
              TextFormField(
                validator: (val) {
                  if (val == null || val == "") {
                    return "Enter No. Of tickets required";
                  } else {
                    return null;
                  }
                },
                controller: _ticketsController,
                decoration: getDecoration(title: "No. Of tickets required"),
                style: TextStyle(color: Colors.amber),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Select Date"),
              InkWell(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022, 08, 12),
                      lastDate: DateTime.now());

                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    selectedDate == null
                        ? "Select Date"
                        : selectedDate.toString().substring(0, 10),
                    style: TextStyle(
                        color: selectedDate == null
                            ? Colors.white.withOpacity(.6)
                            : Colors.amber,
                        fontSize: 16),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              getTitle(title: "Select time slot"),
              Container(
                child: Wrap(
                  children: [
                    ...slots.map((time) {
                      int idx = slots.indexOf(time);
                      bool isSelected = selectedSlot == idx;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedSlot = idx;
                          });
                        },
                        child: Container(
                          width: 110,
                          height: 50,
                          margin: EdgeInsets.only(right: 8, bottom: 8),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Center(
                              child: Text(
                            time,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Theme.of(context).primaryColor),
                          )),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
