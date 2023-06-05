import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:provider/provider.dart';

import 'movie_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<MovieProvider>(context, listen: false);
      provider.switchOnLocal();
      provider.getSearchResult(searchTerm: null,context: context);
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            controller: _searchController,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),
            onChanged: (val) {
              provider.switchOffLocal();
              provider.searchMovie(context: context, searchTerm: val);
            },
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.close))],
        ),
        body: ListView.builder(
            itemCount:
                provider.movieList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  provider.saveResultToLocal(searchItem:  provider.movieList[index]);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                    return MovieDetailPage(movieId:provider.movieList[index].id ,);
                  }));
                },
                title: Text(
                   provider.movieList[index].title,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }),
      );
    });
  }
}
