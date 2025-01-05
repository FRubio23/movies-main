import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/widgets/infos.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(34.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Back to home',
                  onPressed: () =>
                      Get.find<BottomNavigatorController>().setIndex(0),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Favorite Actors',  // Cambié el texto para que sea más relevante para actores
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  width: 33,
                  height: 33,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            // Aquí estamos utilizando el controlador de actores en vez de películas.
            if (Get.find<ActorsController>().favoriteActors.isNotEmpty)
              ...Get.find<ActorsController>().favoriteActors.map(
                    (actor) => Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(DetailsScreen(item: actor)), // Asegúrate de que DetailsScreen pueda manejar actores
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              Api.imageBaseUrl + actor.profilePath, // Usamos profilePath para actores
                              height: 180,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                size: 180,
                              ),
                              loadingBuilder: (_, __, ___) {
                                if (___ == null) return __;
                                return const FadeShimmer(
                                  width: 150,
                                  height: 150,
                                  highlightColor: Color(0xff22272f),
                                  baseColor: Color(0xff20252d),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Infos(item: actor) // Asegúrate de que Infos pueda manejar actores
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            if (Get.find<ActorsController>().favoriteActors.isEmpty)
              const Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    'No actors in your watch list', // Cambié el texto para actores
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ));
  }
}