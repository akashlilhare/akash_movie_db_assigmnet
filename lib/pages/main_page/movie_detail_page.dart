import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../enums/app_conection_status.dart';
import '../../provider/movie_provider.dart';
import 'booking_page.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<MovieProvider>(context, listen: false);
      provider.getMovie(context: context, movieId: widget.movieId);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    buildDetail({required String title, required String subtitle}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$title : ",
              style:
                  TextStyle(color: Colors.white.withOpacity(.99), fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.amber, fontSize: 16),
            )
          ],
        ),
      );
    }

    return Consumer<MovieProvider>(builder: (context, provider, _) {
      if (provider.movieDetailLoadingStatus == AppConnectionStatus.success &&
          provider.movieDetailModel != null) {
        var data = provider.movieDetailModel!;
        return Scaffold(
          bottomNavigationBar: Container(
            color: Colors.grey.shade900.withOpacity(.8),
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
            height: 75,
            child: ElevatedButton(
              child: Text(
                "Book Ticket",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                  return BookingPage(
                    movieId: data.id.toString(),movieTitle: data.title,
                  );
                }));
              },
            ),
          ),
          appBar: AppBar(
            title: Text(data.title),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  child: Image.network(
                      "https://image.tmdb.org/t/p/w500/${data.posterPath}"),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Overview",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  data.overview,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 24,
                ),
                buildDetail(title: "Runtime", subtitle: "${data.runtime} Min"),
                buildDetail(title: "Release Date", subtitle: data.releaseDate),
                buildDetail(title: "Status", subtitle: data.status),
                buildDetail(title: "Revenue", subtitle: "\$${data.revenue}"),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Genres",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  children: [
                    ...data.genres
                        .map((e) => Container(
                            margin: EdgeInsets.only(right: 12, bottom: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              e.name,
                              style: TextStyle(color: Colors.amber),
                            )))
                        .toList()
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Languages",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  children: [
                    ...data.spokenLanguages
                        .map((e) {

                          return Container(
                            margin: EdgeInsets.only(right: 12, bottom: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              e.name,
                              style: TextStyle(color: Colors.amber),
                            ));
                        })
                        .toList()
                  ],
                )
              ],
            ),
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
