import 'dart:math' as math;
import 'package:dragoturkey_alarm/views/alarm_view.dart';
import 'package:dragoturkey_alarm/views/serenity_ui_view.dart';
import 'package:dragoturkey_alarm/views/stats_ui_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Dragoturkey Alarm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.terminal_sharp, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AlarmView()),
              );
            }
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SvgOptionCard(
                      title: 'Sérénité',
                      svgAssets: const [
                        'assets/icons/feather-icon.svg',
                        'assets/icons/slap-icon.svg',
                      ],
                      colors: const [Color(0xFF8EC5FF), Color(0xFFE0C3FC)],
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SerenityUiView()),
                      ),
                      iconsPerRow: 2, // ligne horizontale centrée
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SvgOptionCard(
                      title: 'Statistiques',
                      svgAssets: const [
                        'assets/icons/thunder-icon.svg',
                        'assets/icons/droplet-icon.svg',
                        'assets/icons/heart-icon.svg',
                        'assets/icons/wheat-icon.svg',
                      ],
                      colors: const [Color(0xFFFFD194), Color(0xFF70E1F5)],
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => StatsUiView()),
                      ),
                      iconsPerRow: 2, // affichage en grille 2x2
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SvgOptionCard extends StatelessWidget {
  final String title;
  final List<String> svgAssets;
  final List<Color> colors;
  final VoidCallback onTap;
  final int iconsPerRow;

  const SvgOptionCard({
    super.key,
    required this.title,
    required this.svgAssets,
    required this.colors,
    required this.onTap,
    this.iconsPerRow = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 300, // hauteur fixe pour centrer verticalement les icônes
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50
              ),
              // Titre en haut
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // Espace dédié aux icônes, centré verticalement
              Expanded(
                child: Center(
                  child: _buildIconsLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconsLayout() {
    // Utilise LayoutBuilder pour adapter la taille des icônes à la grille disponible.
    final int crossCount = math.min(iconsPerRow, svgAssets.length);

    return LayoutBuilder(builder: (context, constraints) {
      const double crossAxisSpacing = 12;
      const double mainAxisSpacing = 8;

      final int rows = (svgAssets.length / crossCount).ceil();
      final double totalWidth = constraints.maxWidth;
      // si la hauteur n'est pas contrainte, on prend une valeur raisonnable par défaut
      final double totalHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 180;

      final double cellWidth = (totalWidth - (crossCount - 1) * crossAxisSpacing) / crossCount;
      final double cellHeight = (totalHeight - (rows - 1) * mainAxisSpacing) / rows;
      final double cellSize = math.min(cellWidth, cellHeight);
      final double iconSize = cellSize * 0.65; // ajuster le ratio si besoin

      return GridView.count(
        crossAxisCount: crossCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1,
        padding: EdgeInsets.zero,
        children: svgAssets.map((p) => Center(
          child: SizedBox(
            width: iconSize,
            height: iconSize,
            child: SvgPicture.asset(
              p,
              fit: BoxFit.contain,
              // Retiré le colorFilter qui convertissait systématiquement les SVG en blanc.
              // Si vous voulez forcer le noir, décommentez la ligne suivante :
              // colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        )).toList(),
      );
    });
  }
}
