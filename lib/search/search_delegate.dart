

import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';


// extiende de SearchDelegate

// si se pone el nombre de la clase, ctrol+"." implementar los 4 overrides  faltantes
class MovieSearchDelegate extends SearchDelegate {


  //  se pueden sobreescribir variables!!! en este caso para cambiar a que el texto sea en español
  @override
  String get searchFieldLabel => 'Buscar película';


  // el sistema solo agrega los 4 metodos. el primero devuelve una lista de widgets. los otros 3, un widget

  // override 1: Action
  @override
  List<Widget> buildActions(BuildContext context) {

      //devuelve lista de widgets (ver corchetes). en este caso, solo un widget: un boton que limpia la variable "query" de la clase "SearchDelegate"
      return [
        IconButton(
          icon: Icon( Icons.clear ),
          onPressed: () => query = '', // variable query ya existente en la clase SearchDelegate
        )
      ];
  }
  

   // override 2: Leading . aqui se pone el boton para cerrar la busqueda. 
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon( Icons.arrow_back ),
        onPressed: () {
          close(context, null ); // metodo close ya existente en la clase SearchDelegate
        },
      );
    }
  

    // override 3: Results
    @override
    Widget buildResults(BuildContext context) {
      
      return Text('no implementado');
    }

    //widget de fernando para devolver un container con solo un icono cuando no hay query de busqueda
    Widget _emptyContainer() {
      //recordar: siempre debe devolver un widget, en este caso un container (casi) vacio
      return Container(
          child: Center(
            child: Icon( Icons.movie_creation_outlined, color: Colors.indigo[800], size: 130, ),
          ),
        );
    }
  
     // override 4: Suggestions
    @override
    Widget buildSuggestions(BuildContext context) {
    
      if( query.isEmpty ) {
        return _emptyContainer();
      }

      final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
      moviesProvider.getSuggestionsByQuery( query );


      return StreamBuilder(
        stream: moviesProvider.suggestionStream,
        builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
          
          if( !snapshot.hasData ) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: ( _, int index ) => _MovieItem( movies[index])
          );
        },
      );

  }

}


class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem( this.movie );

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${ movie.id }';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'), 
          image: NetworkImage( movie.fullPosterImg ),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text( movie.originalTitle ),
      onTap: () {
        
        Navigator.pushNamed(context, 'details', arguments: movie );
      },
    );
  }
}