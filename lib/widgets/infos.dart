import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart'; // Para importar la clase Actor
import 'package:movies/utils/utils.dart';

class Infos extends StatelessWidget {
  const Infos({super.key, required this.item});
  final dynamic item; // Puede ser una película o un actor.

  @override
  Widget build(BuildContext context) {
    final bool isMovie = item is Movie;

    return SizedBox(
      height: 250, // Ajustamos la altura para acomodar los actores
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              isMovie ? item.title : item.name, // Se ajusta dependiendo de si es una película o actor.
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMovie) ...[
                Row(
                  children: [
                    SvgPicture.asset('assets/Star.svg'),
                    const SizedBox(width: 5),
                    Text(
                      item.voteAverage == 0.0 ? 'N/A' : item.voteAverage.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFFFF8700),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/Ticket.svg'),
                    const SizedBox(width: 5),
                    Text(
                      Utils.getGenres(item), // Método para obtener géneros
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/calender.svg'),
                    const SizedBox(width: 5),
                    Text(
                      item.releaseDate.split('-')[0], // Año de lanzamiento
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    SvgPicture.asset('assets/Star.svg'),
                    const SizedBox(width: 5),
                    Text(
                      item.popularity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFFFF8700),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              if (isMovie) ...[
                // Aquí se pueden agregar más detalles específicos de la película si es necesario
              ] else ...[
                // Información sobre el actor
                const Text(
                  'Biography:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.biography ?? 'No biography available.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
