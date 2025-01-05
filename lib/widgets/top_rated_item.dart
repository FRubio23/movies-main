import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/details_screen.dart';  // Importa la pantalla de detalles
import 'package:movies/widgets/index_number.dart';

class TopRatedItem extends StatelessWidget {
  const TopRatedItem({
    super.key,
    required this.item,
    required this.index,
  });

  final dynamic item; // Puede ser una película o un actor
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool isMovie = item is Movie;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Si es una película, navega a la pantalla de detalles de la película
            // Si es un actor, navega a la pantalla de detalles del actor
            Get.to(DetailsScreen(item: item)); // Navegar a la pantalla de detalles para ambos casos
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                Api.imageBaseUrl + (isMovie ? item.posterPath : (item as Actor).profilePath),
                fit: BoxFit.cover,
                height: 250,
                width: 180,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 180,
                ),
                loadingBuilder: (_, __, ___) {
                  if (___ == null) return __;
                  return const FadeShimmer(
                    width: 180,
                    height: 250,
                    highlightColor: Color(0xff22272f),
                    baseColor: Color(0xff20252d),
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: IndexNumber(number: index),
        ),
        if (!isMovie)
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              (item as Actor).name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}
