import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../utils/color_by_type.dart';
import '../services/pokemon_service.dart';

class DetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const DetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final bgColor = colorByType(pokemon.primaryType);
    const double headerHeight = 260; // tinggi area hijau atas

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // ====== HEADER HIJAU + GAMBAR (STACK) ======
              SizedBox(
                height: headerHeight,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(color: bgColor),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pokemon.capitalizedName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                pokemon.formattedId,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: pokemon.types.map((t) {
                              final label = t[0].toUpperCase() + t.substring(1);
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // pokeball bayangan (opsional)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Icon(
                        Icons.catching_pokemon,
                        size: 120,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),

                    // gambar Pokemon
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -30,
                      child: Center(
                        child: Image.network(
                          pokemon.imageUrl,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ====== PANEL PUTIH + TAB ======
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ), 

                      TabBar(
                        isScrollable: false,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                          insets: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        dividerColor: Colors.transparent,

                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          SizedBox(
                            width: 100,
                            child: Tab(child: Text("About")),
                          ),
                          SizedBox(
                            width: 130,
                            child: Tab(child: Text("Base Stats")),
                          ),
                          SizedBox(
                            width: 110,
                            child: Tab(child: Text("Evolution")),
                          ),
                          SizedBox(width: 90, child: Tab(child: Text("Moves"))),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Expanded(
                        child: TabBarView(
                          children: [
                            AboutTab(pokemon: pokemon),
                            BaseStatsTab(pokemon: pokemon),
                            EvolutionTab(pokemon: pokemon),
                            MovesTab(pokemon: pokemon),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////  ABOUT TAB  ////////////////////

class AboutTab extends StatelessWidget {
  final Pokemon pokemon;

  const AboutTab({super.key, required this.pokemon});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final species =
        pokemon.speciesName[0].toUpperCase() + pokemon.speciesName.substring(1);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        _row("Species", species),
        _row("Height", pokemon.heightInMeters),
        _row("Weight", pokemon.weightInKg),
        _row("Abilities", pokemon.abilitiesText),
      ],
    );
  }
}

////////////////////  BASE STATS TAB  ////////////////////
class BaseStatsTab extends StatelessWidget {
  final Pokemon pokemon;

  const BaseStatsTab({super.key, required this.pokemon});

  // Tentukan warna bar berdasarkan nama stat
  Color _barColor(String statName) {
    if (statName == "hp" || statName == "defense") {
      return Colors.red; 
    }
    return Colors.green; 
  }

  Widget _statRow(String label, int value, String keyStat) {
    const max = 160;
    final ratio = (value / max).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Row(
        children: [
          // label
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              maxLines: 1,
            ),
          ),

          // angka value
          SizedBox(
            width: 40,
            child: Text(value.toString(), style: const TextStyle(fontSize: 13)),
          ),

          const SizedBox(width: 8),

          // BAR GAUGE
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: _barColor(keyStat), // warna sesuai stat
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        _statRow("HP", pokemon.statValue("hp"), "hp"),
        _statRow("Attack", pokemon.statValue("attack"), "attack"),
        _statRow("Defense", pokemon.statValue("defense"), "defense"),
        _statRow(
          "Sp. Atk",
          pokemon.statValue("special-attack"),
          "special-attack",
        ),
        _statRow(
          "Sp. Def",
          pokemon.statValue("special-defense"),
          "special-defense",
        ),
        _statRow("Speed", pokemon.statValue("speed"), "speed"),
      ],
    );
  }
}

////////////////////  EVOLUTION TAB  ////////////////////

class EvolutionTab extends StatelessWidget {
  final Pokemon pokemon;

  const EvolutionTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: PokemonService.fetchEvolutionChain(pokemon.speciesUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Gagal memuat evolution: ${snapshot.error}"),
          );
        }

        final chain = snapshot.data ?? [];
        if (chain.isEmpty) {
          return const Center(child: Text("Tidak ada data evolusi"));
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < chain.length; i++) ...[
                  Text(
                    chain[i][0].toUpperCase() + chain[i].substring(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (i != chain.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

////////////////////  MOVES TAB  ////////////////////

class MovesTab extends StatelessWidget {
  final Pokemon pokemon;

  const MovesTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    if (pokemon.moves.isEmpty) {
      return const Center(child: Text("Tidak ada data moves"));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: pokemon.moves.length,
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final m = pokemon.moves[index];
        final name = m[0].toUpperCase() + m.substring(1);
        return Text(name, style: const TextStyle(fontSize: 13));
      },
    );
  }
}
