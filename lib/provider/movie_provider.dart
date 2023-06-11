import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/constant.dart';
import 'package:movie_app/enums/app_conection_status.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/healper/backup_healper.dart';
import 'package:movie_app/healper/shared_prefrences_helper.dart';
import 'package:movie_app/model/movie_model.dart';
import '../model/movie_detail_model.dart';
import '../model/search_suggestion_model.dart';

class MovieProvider with ChangeNotifier {
  AppConnectionStatus movieListLoadingStatus = AppConnectionStatus.none;
  AppConnectionStatus movieDetailLoadingStatus = AppConnectionStatus.none;
  AppConnectionStatus movieSearchStatus = AppConnectionStatus.none;
  AppConnectionStatus ticketBookingStatus = AppConnectionStatus.none;
  MovieModel? movieModel;
  MovieModel? searchModel;
  MovieDetailModel? movieDetailModel;
  List<MovieSuggestionModel> movieList = [];
  bool showLocalList = true;
  bool sendingNotification = false;
  final Constants _constants = Constants();


  getMovieList({required BuildContext context, int? pageIdx}) async {
    try {
      movieListLoadingStatus = AppConnectionStatus.loading;
      notifyListeners();
      String url =
          "https://api.themoviedb.org/3/movie/popular?api_key=${Constants.apiKey}";
      var response = await http.get(
        Uri.parse(url),
      );
      movieModel = MovieModel.fromJson(jsonDecode(response.body));
      movieListLoadingStatus = AppConnectionStatus.success;
    } catch (e) {
      movieListLoadingStatus = AppConnectionStatus.error;
    } finally {
      notifyListeners();
    }
  }

  getMovie({required BuildContext context, required int movieId}) async {
    try {
      movieDetailLoadingStatus = AppConnectionStatus.loading;
      notifyListeners();
      String url =
          "https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}";
      var response = await http.get(
        Uri.parse(url),
      );
      movieDetailModel = MovieDetailModel.fromJson(jsonDecode(response.body));
      movieDetailLoadingStatus = AppConnectionStatus.success;
    } catch (e) {
      movieDetailLoadingStatus = AppConnectionStatus.error;
    } finally {
      notifyListeners();
    }
  }

  bookTicket(
      {required BuildContext context,
      required Map<String, dynamic> jsonData}) async {
    try {
      ticketBookingStatus = AppConnectionStatus.loading;
      notifyListeners();
      bool ticketBooked = await BackupHelper()
          .checkBooking(jsonData: jsonData, context: context);
      ticketBookingStatus = AppConnectionStatus.success;
      if (ticketBooked) {
        Constants().getToast("Ticket booked successfully");
        Navigator.of(context).pop();
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: Text(
                  "No ticket available",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  "Please select some other time slot",
                  style: TextStyle(color: Colors.white.withOpacity(.8)),
                ),
                actions: [
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (e) {
      ticketBookingStatus = AppConnectionStatus.error;
    } finally {
      notifyListeners();
    }
  }

 Future<List<MovieSuggestionModel>> searchMovie(
      {required BuildContext context, required String searchTerm}) async {
    searchModel = null;
    movieList =[];
    try {
      movieSearchStatus = AppConnectionStatus.loading;

      notifyListeners();
      String url =
          "https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=$searchTerm";

      var response = await http.get(
        Uri.parse(url),
      );
      searchModel = MovieModel.fromJson(jsonDecode(response.body));
      movieSearchStatus = AppConnectionStatus.success;
      if (searchModel != null) {
        for (var element in searchModel!.results) {
          movieList
              .add(MovieSuggestionModel(title: element.title, id: element.id));
        }
      }
      return movieList;
    } catch (e) {
      movieSearchStatus = AppConnectionStatus.error;
      return [];
    } finally {
      notifyListeners();
    }
  }

  getSearchResult({required BuildContext context, required String? searchTerm})async{
    print("get res");
    if(showLocalList || searchTerm == null){
      print("here 1");
      movieList =await SharedPreferencesHelper().getSearchList();
    }else{
      movieList = await searchMovie(context: context,searchTerm: searchTerm);
    }
    notifyListeners();
  }

  switchOnLocal() {
    showLocalList = true;

    notifyListeners();
  }

  switchOffLocal() {
    showLocalList = false;
    notifyListeners();
  }

  saveResultToLocal({required MovieSuggestionModel searchItem}){
    SharedPreferencesHelper().saveData(searchItem);
  }

  sendNotification(
      final String title, final String message) async {
    try {
      sendingNotification = true;
      notifyListeners();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      var postBody = {"title": title, "message": message, "deviceToken": fcmToken};
      var response = await http.post(
        Uri.parse("https://node-push-notification.vercel.app/send-notification"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(postBody),
      );
      sendingNotification = false;
      notifyListeners();
      _constants.getToast("Request submitted successfully");
      print(response.body);
    } catch (e) {
      _constants.getToast("Something went wrong");
      sendingNotification = false;
      notifyListeners();
    }
  }
}
