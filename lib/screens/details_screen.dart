import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/review.dart';
import 'package:movies/utils/utils.dart';

// Pantalla de detalles para mostrar información de películas o actores.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.item,
  });

  final dynamic item; // Puede ser un objeto Movie o Actor.

  @override
  Widget build(BuildContext context) {
    final bool isMovie = item is Movie; // Verifica si el elemento es una película.

    if (isMovie) {
      ApiService.getMovieReviews(item.id); // Llama al servicio para obtener reseñas de películas.
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView( // Permite desplazamiento en caso de contenido largo.
          child: Column(
            children: [
              // Barra superior con título, botón de regreso y acciones de favoritos.
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home', // Tooltip para accesibilidad.
                      onPressed: () => Get.back(), // Regresa a la pantalla anterior.
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isMovie ? 'Movie Details' : 'Actor Details', // Muestra el tipo de detalles.
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    // Botón de favorito o lista de seguimiento basado en el tipo de elemento.
                    if (isMovie)
                      Tooltip(
                        message: 'Save this movie to your watch list',
                        triggerMode: TooltipTriggerMode.tap,
                        child: IconButton(
                          onPressed: () {
                            Get.find<MoviesController>().addToWatchList(item); // Añade película a lista.
                          },
                          icon: Obx( // Observa cambios en la lista de seguimiento.
                                () => Get.find<MoviesController>()
                                .isInWatchList(item)
                                ? const Icon(
                              Icons.bookmark,
                              color: Colors.white,
                              size: 33,
                            )
                                : const Icon(
                              Icons.bookmark_outline,
                              color: Colors.white,
                              size: 33,
                            ),
                          ),
                        ),
                      )
                    else
                      Tooltip(
                        message: 'Save this actor to favorites',
                        triggerMode: TooltipTriggerMode.tap,
                        child: IconButton(
                          onPressed: () {
                            Get.find<ActorsController>().toggleFavorite(item); // Alterna favoritos.
                          },
                          icon: Obx( // Observa cambios en los favoritos.
                                () => Get.find<ActorsController>()
                                .isInFavorites(item)
                                ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 33,
                            )
                                : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 33,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Espaciado.

              // Imagen principal del elemento (fondo y/o poster).
              SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    // Imagen de fondo o perfil.
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        Api.imageBaseUrl +
                            (isMovie ? item.backdropPath : item.profilePath), // Rutas de imagen según tipo.
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, __, ___) {
                          if (___ == null) return __; // Muestra imagen si ya cargó.
                          return FadeShimmer(
                            width: Get.width,
                            height: 250,
                            highlightColor: const Color(0xff22272f),
                            baseColor: const Color(0xff20252d),
                          ); // Efecto shimmer mientras carga.
                        },
                        errorBuilder: (_, __, ___) => const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 250,
                          ), // Icono de error si falla la carga.
                        ),
                      ),
                    ),
                    // Poster adicional para películas.
                    if (isMovie)
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${item.posterPath}', // URL del poster.
                              width: 110,
                              height: 140,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, __, ___) {
                                if (___ == null) return __;
                                return const FadeShimmer(
                                  width: 110,
                                  height: 140,
                                  highlightColor: Color(0xff22272f),
                                  baseColor: Color(0xff20252d),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    // Título de la película o nombre del actor.
                    Positioned(
                      top: 255,
                      left: isMovie ? 155 : 30,
                      child: SizedBox(
                        width: isMovie ? 230 : Get.width - 60,
                        child: Text(
                          isMovie ? item.title : item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25), // Espaciado.

              // Detalles adicionales (fecha, género, etc.).
              if (isMovie)
                Opacity(
                  opacity: .6,
                  child: SizedBox(
                    width: Get.width / 1.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Fecha de lanzamiento.
                        Row(
                          children: [
                            SvgPicture.asset('assets/calender.svg'),
                            const SizedBox(width: 5),
                            Text(
                              item.releaseDate.split('-')[0], // Año de lanzamiento.
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const Text('|'), // Separador.
                        // Géneros de la película.
                        Row(
                          children: [
                            SvgPicture.asset('assets/Ticket.svg'),
                            const SizedBox(width: 5),
                            Text(
                              Utils.getGenres(item), // Utilidad para obtener géneros.
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              // TabBar para navegar entre detalles adicionales.
              Padding(
                padding: const EdgeInsets.all(24),
                child: DefaultTabController(
                  length: isMovie ? 3 : 1, // Tabs diferentes según el tipo.
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: const Color(0xFF3A3F47),
                        tabs: isMovie
                            ? const [
                          Tab(text: 'About Movie'), // Información general.
                          Tab(text: 'Reviews'), // Reseñas.
                          Tab(text: 'Cast'), // Reparto.
                        ]
                            : const [
                          Tab(text: 'About Actor'), // Información del actor.
                        ],
                      ),
                      // Contenido de los tabs.
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: isMovie
                              ? [
                            // Información general de la película.
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                item.overview, // Sinopsis.
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                            // Reseñas de la película.
                            FutureBuilder<List<Review>?>(
                              future: ApiService.getMovieReviews(item.id), // Llamada a la API.
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!.isEmpty
                                      ? const Padding(
                                    padding: EdgeInsets.only(top: 30.0),
                                    child: Text(
                                      'No review', // Sin reseñas.
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                      : ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (_, index) =>
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Icono del avatar del autor.
                                              Column(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/avatar.svg',
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    snapshot.data![index].rating.toString(),
                                                    style: const TextStyle(
                                                      color: Color(0xff0296E5),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              // Información de la reseña.
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index].author, // Autor.
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    width: 245,
                                                    child: Text(
                                                      snapshot.data![index].comment, // Comentario.
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Wait...'), // Cargando.
                                  );
                                }
                              },
                            ),
                            // Tab vacío para el reparto (puedes completarlo).
                            Container(),
                          ]
                              : [
                            // Información del actor.
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                (item as Actor).biography ?? 'No biography available.', // Biografía.
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
