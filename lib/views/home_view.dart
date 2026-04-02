import 'dart:math' as math;
import 'package:dragoturkey_alarm/views/stats/abreuvoir_view.dart';
import 'package:dragoturkey_alarm/views/stats/baffeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/caresseur_view.dart';
import 'package:dragoturkey_alarm/views/stats/dragofesse_view.dart';
import 'package:dragoturkey_alarm/views/stats/foudroyeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/mangeoire_view.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background.jpeg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // la colonne prendra seulement la hauteur nécessaire
              children: [
                GridView.count(
                  shrinkWrap: true, // la grille s'ajuste à son contenu
                  physics: const NeverScrollableScrollPhysics(), // pas de scroll interne
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    SvgOptionCard(
                      title: 'Caresseur',
                      svgAssets: ['assets/icons/feather-icon.svg'],
                      backgroundImage: 'assets/images/background_purple.jpeg', // <-- image JPEG en fond pour la première carte
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CaresseurView()),
                      ), colors: [],
                    ),
                    SvgOptionCard(
                      title: 'Baffeur',
                      svgAssets: ['assets/icons/slap-icon.svg'],
                      backgroundImage: 'assets/images/background_orange.jpeg', // <-- image JPEG en fond pour la deuxième carte
                      colors: [],
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BaffeurView()),
                      ),
                    ),
                    SvgOptionCard(
                      title: 'Dragofesse',
                      svgAssets: ['assets/icons/heart-icon.svg'],
                      backgroundImage: 'assets/images/background_red.png',
                      colors: [],
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DragofesseView()),
                      ),
                    ),
                    SvgOptionCard(
                      title: 'Foudroyeur',
                      svgAssets: ['assets/icons/thunder-icon.svg'],
                      backgroundImage: 'assets/images/background_yellow.png',
                      colors: [],
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FoudroyeurView()),
                      ),
                    ),
                    SvgOptionCard(
                      title: 'Abreuvoir',
                      svgAssets: ['assets/icons/droplet-icon.svg'],
                      backgroundImage: 'assets/images/background_blue.png',
                      colors: [],
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AbreuvoirView()),
                      ),
                    ),
                    SvgOptionCard(
                      title: 'Mangeoire',
                      svgAssets: ['assets/icons/wheat-icon.svg'],
                      backgroundImage: 'assets/images/background_green.png',
                      colors: [],
                      iconsPerRow: 1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MangeoireView()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
  final String? backgroundImage; // ajouté

  const SvgOptionCard({
    super.key,
    required this.title,
    required this.svgAssets,
    required this.colors,
    required this.onTap,
    this.iconsPerRow = 2,
    this.backgroundImage, // ajouté
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
          // Retire la hauteur fixe afin que la carte s'adapte dans la grille.
          constraints: const BoxConstraints(minHeight: 140),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            // si backgroundImage est fourni, on utilise l'image ; sinon on conserve le gradient
            image: backgroundImage != null
                ? DecorationImage(
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: backgroundImage == null
                ? LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              // Titre en haut, taille réduite
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20, // réduit
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Remonte les SVG : on aligne la zone d'icônes vers le haut pour qu'elles soient plus hautes dans la carte
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
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
