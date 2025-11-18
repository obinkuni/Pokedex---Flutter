import 'package:flutter/material.dart';

Color colorByType(String type) {
  switch (type) {
    case 'grass':
      return const Color(0xFF48D0B0);
    case 'fire':
      return const Color(0xFFFFA756);
    case 'water':
      return const Color(0xFF76BEFE);
    case 'bug':
      return const Color(0xFFACF274);
    case 'poison':
      return const Color(0xFFB97FC9);
    case 'electric':
      return const Color(0xFFFFF176);
    case 'psychic':
      return const Color(0xFFFF80AB);
    case 'normal':
      return const Color(0xFFBDBDBD);
    case 'fighting':
      return const Color(0xFFE57373);
    case 'ground':
      return const Color(0xFFD7CCC8);
    case 'rock':
      return const Color(0xFFBCAAA4);
    case 'fairy':
      return const Color(0xFFF48FB1);
    case 'dragon':
      return const Color(0xFF9575CD);
    case 'ice':
      return const Color(0xFFB3E5FC);
    case 'ghost':
      return const Color(0xFF7E57C2);
    case 'steel':
      return const Color(0xFF90A4AE);
    case 'dark':
      return const Color(0xFF616161);
    case 'flying':
      return const Color(0xFF81D4FA);
    default:
      return const Color(0xFFE0E0E0);
  }
}
