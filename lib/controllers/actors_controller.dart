import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var mainPopularActors = <Actor>[].obs;
  var favoriteActors = <Actor>[].obs;
  @override
  void onInit() async {
    isLoading.value = true;
    mainPopularActors.value = (await ApiService.getPopularActors())!;
    isLoading.value = false;
    super.onInit();
  }

  bool isInFavorites(Actor actor) {
    return favoriteActors.any((a) => a.id == actor.id);
  }

  void toggleFavorite(Actor actor) {
    if (isInFavorites(actor)) {
      favoriteActors.removeWhere((a) => a.id == actor.id);
      Get.snackbar('Success', '${actor.name} removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      favoriteActors.add(actor);
      Get.snackbar('Success', '${actor.name} added to favorites',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}
