import 'package:flutter/material.dart'; // Importa el paquete para usar componentes básicos de Flutter.
import 'package:flutter_svg/flutter_svg.dart'; // Paquete para manejar imágenes SVG.
import 'package:get/get.dart'; // Paquete para gestión de estado con GetX.
import 'package:movies/controllers/bottom_navigator_controller.dart'; // Importa el controlador que maneja el estado de la navegación.

/// Pantalla principal que contiene la navegación y gestión de vistas en la aplicación.
class Main extends StatelessWidget {
  Main({super.key});
  // Se crea una instancia del controlador 'BottomNavigatorController' usando GetX.
  final BottomNavigatorController controller = Get.put(BottomNavigatorController());

  @override
  Widget build(BuildContext context) {
    // Usando un widget "Obx" de GetX para escuchar cambios en el estado reactivo.
    return Obx(
          () => GestureDetector(
        onTap: () {
          // Al tocar cualquier parte de la pantalla, se cierra el teclado (si está abierto).
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: IndexedStack(
              // Utiliza IndexedStack para mostrar la vista correspondiente según el índice en el controlador.
              index: controller.index.value,
              children: Get.find<BottomNavigatorController>().screens,
            ),
          ),
          bottomNavigationBar: Container(
            height: 78,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF0296E5), // Color del borde superior.
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.index.value, // El índice actual de la barra de navegación.
              onTap: (index) =>
                  Get.find<BottomNavigatorController>().setIndex(index), // Cambia el índice al tocar un ítem.
              backgroundColor: const Color(0xFF242A32), // Color de fondo de la barra.
              selectedItemColor: const Color(0xFF0296E5), // Color de los ítems seleccionados.
              unselectedItemColor: const Color(0xFF67686D), // Color de los ítems no seleccionados.
              selectedFontSize: 12, // Tamaño de fuente para los ítems seleccionados.
              unselectedFontSize: 12, // Tamaño de fuente para los ítems no seleccionados.
              items: [
                // Primer ítem (Home)
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6), // Margen inferior para separar íconos del texto.
                    child: SvgPicture.asset(
                      'assets/Home.svg', // Ruta al archivo SVG de Home.
                      height: 21,
                      width: 21,
                    ),
                  ),
                  label: 'Home', // Texto del ítem.
                ),
                // Segundo ítem (Search)
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Search.svg', // Ruta al archivo SVG de Search.
                      height: 21,
                      width: 21,
                    ),
                  ),
                  label: 'Search', // Texto del ítem.
                  tooltip: 'Search Movies', // Tooltip que aparece al pasar el ratón por encima.
                ),
                // Tercer ítem (Watch list)
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Save.svg', // Ruta al archivo SVG de Save (Watch list).
                      height: 21,
                      width: 21,
                    ),
                  ),
                  label: 'Watch list', // Texto del ítem.
                  tooltip: 'Your WatchList', // Tooltip.
                ),
                // Cuarto ítem (Favorite List)
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Heart.svg', // Ruta al archivo SVG de Favorite List.
                      height: 21,
                      width: 21,
                    ),
                  ),
                  label: 'Favorite List', // Texto del ítem.
                  tooltip: 'Your Favorite Movies', // Tooltip.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
