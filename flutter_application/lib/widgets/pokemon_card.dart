import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../utils/color_by_type.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types.first : '';
    final bgColor = colorByType(primaryType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Nama Pokémon
            Text(
              pokemon.capitalizedName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Badge tipe (vertical)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pokemon.types.map((t) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t[0].toUpperCase() + t.substring(1),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                Image.network(
                  pokemon.imageUrl,
                  height: 75,
                  width: 75,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
