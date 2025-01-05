import 'package:flutter/material.dart'; // Importa los componentes básicos de Flutter.
import 'package:get/get.dart'; // Paquete para la gestión de estado y navegación.
import 'package:movies/api/api.dart'; // Archivo de configuración de la API.
import 'package:movies/api/api_service.dart'; // Servicio para realizar solicitudes a la API.
import 'package:movies/controllers/bottom_navigator_controller.dart'; // Controlador para la navegación inferior.
import 'package:movies/controllers/movies_controller.dart'; // Controlador para manejar películas.
import 'package:movies/controllers/search_controller.dart'; // Controlador para manejar búsquedas.
import 'package:movies/widgets/search_box.dart'; // Widget personalizado para la barra de búsqueda.
import 'package:movies/widgets/tab_builder.dart'; // Widget para construir vistas en pestañas.
import 'package:movies/widgets/top_rated_item.dart'; // Widget para mostrar actores mejor calificados.
import 'package:movies/controllers/actors_controller.dart'; // Controlador para manejar actores.

/// Pantalla principal de inicio que muestra contenido dinámico y elementos interactivos.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Controladores que gestionan diferentes aspectos de la pantalla.
  final MoviesController controller = Get.put(MoviesController());
  final ActorsController act_controller = Get.put(ActorsController());
  final SearchController1 searchController = Get.put(SearchController1());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24, // Espaciado horizontal.
          vertical: 42, // Espaciado vertical.
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Título principal de la pantalla.
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What do you want to watch?', // Texto para captar interés del usuario.
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 24), // Espaciador vertical.

            // Barra de búsqueda personalizada.
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text; // Obtiene el texto de búsqueda.
                Get.find<SearchController1>().searchController.text = ''; // Limpia el campo de búsqueda.
                Get.find<SearchController1>().search(search); // Realiza la búsqueda.
                Get.find<BottomNavigatorController>().setIndex(1); // Cambia a la pestaña de búsqueda.
                FocusManager.instance.primaryFocus?.unfocus(); // Cierra el teclado.
              },
            ),
            const SizedBox(height: 34), // Espaciador vertical.

            // Lista horizontal de actores populares.
            Obx(
                  () => act_controller.isLoading.value // Verifica si está cargando datos.
                  ? const CircularProgressIndicator() // Muestra un indicador de carga.
                  : SizedBox(
                height: 300, // Altura del contenedor.
                child: ListView.separated(
                  itemCount: act_controller.mainPopularActors.length, // Cantidad de ítems.
                  shrinkWrap: true, // Ajusta el tamaño al contenido.
                  scrollDirection: Axis.horizontal, // Scroll horizontal.
                  separatorBuilder: (_, __) => const SizedBox(width: 24), // Separador entre ítems.
                  itemBuilder: (_, index) => TopRatedItem(
                    item: act_controller.mainPopularActors[index], // Actor actual.
                    index: index + 1, // Índice del actor.
                  ),
                ),
              ),
            ),

            // Pestañas para explorar películas según categorías.
            DefaultTabController(
              length: 4, // Número de pestañas.
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barra de pestañas.
                  const TabBar(
                    indicatorWeight: 3, // Grosor del indicador.
                    indicatorColor: Color(0xFF3A3F47), // Color del indicador.
                    labelStyle: TextStyle(fontSize: 11.0), // Estilo del texto de las pestañas.
                    tabs: [
                      Tab(text: 'Now playing'), // Películas en emisión.
                      Tab(text: 'Upcoming'), // Próximas películas.
                      Tab(text: 'Top rated'), // Películas mejor calificadas.
                      Tab(text: 'Popular'), // Películas populares.
                    ],
                  ),

                  // Contenido asociado a cada pestaña.
                  SizedBox(
                    height: 400, // Altura del contenedor de pestañas.
                    child: TabBarView(
                      children: [
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
