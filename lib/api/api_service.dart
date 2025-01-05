import 'dart:convert'; // Para convertir JSON a objetos Dart y viceversa.
import 'package:movies/api/api.dart'; // Contiene las constantes baseUrl y apiKey.
import 'package:movies/models/actor.dart'; // Modelo para los datos de actores.
import 'package:movies/models/movie.dart'; // Modelo para los datos de películas.
import 'package:http/http.dart' as http; // Biblioteca para realizar solicitudes HTTP.
import 'package:movies/models/review.dart'; // Modelo para los datos de reseñas.

/// Clase para interactuar con la API de TMDb.
class ApiService {
  /// Obtiene las películas mejor valoradas desde la API.
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      // Realiza una solicitud HTTP GET.
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      // Convierte la respuesta en un mapa JSON.
      var res = jsonDecode(response.body);
      // Extrae un subconjunto de los resultados y los transforma en objetos Movie.
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
          Movie.fromMap(m), // Método de fábrica del modelo Movie.
        ),
      );
      return movies; // Retorna la lista de películas.
    } catch (e) {
      return null; // Retorna null en caso de error.
    }
  }

  /// Obtiene una lista de películas personalizadas según el `url` dado.
  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
      await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  /// Busca películas en la API según el `query` proporcionado.
  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
            (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene las reseñas de una película específica según su `movieId`.
  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      // Convierte cada reseña en un objeto Review.
      res['results'].forEach(
            (r) {
          reviews.add(
            Review(
                author: r['author'], // Nombre del autor de la reseña.
                comment: r['content'], // Contenido de la reseña.
                rating: r['author_details']['rating']), // Calificación.
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una lista de actores desde la API.
  static Future<List<Actor>?> getActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => actors.add(
          Actor.fromMap(m),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una lista de actores populares desde la API.
  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (a) => actors.add(
          Actor.fromMap(a),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }
}
