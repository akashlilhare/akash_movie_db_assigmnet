import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movie_app/enums/app_conection_status.dart';
import 'package:movie_app/pages/main_page/search_page.dart';
import 'package:movie_app/provider/auth_provider.dart';
import 'package:movie_app/provider/movie_provider.dart';

import 'package:provider/provider.dart';

import '../../widget/movid_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<MovieProvider>(context, listen: false);
      provider.getMovieList(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, provider, _) {
      if (provider.movieListLoadingStatus == AppConnectionStatus.success) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Movie DB"),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey.shade900,
                          content: Text(
                            "Do you want ot logout",
                            style:
                                TextStyle(color: Colors.white.withOpacity(.8)),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logout(context: context);
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No")),
                          ],
                        );
                      });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade700,
                  child: Text(
                    FirebaseAuth.instance.currentUser == null
                        ? "A"
                        : FirebaseAuth.instance.currentUser!.displayName
                            .toString()[0],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SearchPage();
                    }));
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.grey.shade900,
                  child: Row(
                    children: [
                      Text(
                        "New movie relies on this friday",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            provider.sendNotification(
                              "Movie DB",
                              "You will be notified soon 👀",
                            );
                          },
                          child: provider.sendingNotification
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: CircularProgressIndicator(
                                    color: Colors.black.withOpacity(.8),
                                    strokeWidth: 2,
                                  ))
                              : Text("Notify me"))
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    itemCount: provider.movieModel!.results.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        results: provider.movieModel!.results[index],
                      );
                    }),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
