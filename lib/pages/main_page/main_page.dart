import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movie_app/enums/app_conection_status.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/pages/main_page/booking_page.dart';
import 'package:movie_app/pages/main_page/search_page.dart';
import 'package:movie_app/provider/auth_provider.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:search_page/search_page.dart' as search;

import 'package:provider/provider.dart';

import 'movie_detail_page.dart';

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
                          title: Text("Logout",style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.grey.shade900,
                          content: Text("Do you want ot logout",style: TextStyle(color: Colors.white.withOpacity(.8)),),
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
          body: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              itemCount: provider.movieModel!.results.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  results: provider.movieModel!.results[index],
                );
              }),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.close))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class MovieCard extends StatelessWidget {
  final Results results;

  const MovieCard({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
              return MovieDetailPage(
                movieId: results.id,
              );
            }));
          },
          child: Container(
            height: 350,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  child: Image.network(
                      "https://image.tmdb.org/t/p/w500/${results.backdropPath}"),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      results.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      results.overview,
                      style: TextStyle(color: Colors.white70),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Released on: " + results.releaseDate.toString(),
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.w500),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
