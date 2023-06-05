import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/model/ticket_model.dart';

const String bookingCollection = "booking_data";

class BackupHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveBookingData({required Map<String, dynamic> data}) async {
    await _db.collection(bookingCollection).doc().set(data);
  }

  Future<bool> checkBooking(
      {required Map<String, dynamic> jsonData,
      required BuildContext context}) async {
    var data = await _db
        .collection(bookingCollection)
        .where("movie_id", isEqualTo: jsonData["movie_id"])
        .get();
    if (data.docs.isEmpty) {
      await saveBookingData(data: jsonData);
      return true;
    } else {
      for (var element in data.docs) {
        TicketModel ticketModel = TicketModel.fromJson(element.data());
        if (ticketModel.date == jsonData["date"] &&
            ticketModel.timeSlot == jsonData["time_slot"]) {
          return false;
        }
      }
     await saveBookingData(data: jsonData);
      return true;
    }
  }

  Future<void> getBookingData() async {
    var data = await _db
        .collection(bookingCollection)
        .where("name", isEqualTo: "akash")
        .get();
    print(data.docs.length);
  }
}
