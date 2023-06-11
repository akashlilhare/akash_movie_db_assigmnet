

import 'package:flutter/material.dart';

import '../model/movie_model.dart';
import '../pages/main_page/movie_detail_page.dart';

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
