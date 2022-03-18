import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined ),
            //el showSearch ya esta implementado en flutter. solo hay que pasarle el searchDelegate
            // un delegate no es mas que un widget o una clase que cumple ciertas condiciones
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Tarjetas principales
            CardSwiper( movies: moviesProvider.onDisplayMovies ),

            // Slider de películas
            MovieSlider(
              movies: moviesProvider.popularMovies,// populares,
              title: 'Populares', // opcionald
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            
          ],
        ),
      )
    );
  }
}