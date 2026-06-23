import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Home view displaying navigation pills for different features.
///
/// This view presents the main menu with options to access different
/// timer and stat management features (Caresseur, Baffeur, etc.).
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Build the home view UI with navigation pills.
  ///
  /// Returns: Widget representing the home screen.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Define menu options with titles, icons, and routes
    final options = [
      {
        'title': 'Caresseur',
        'subtitle': 'Gestion de la jauge de sérénité',
        'icon': 'assets/icons/feather-icon.svg',
        'bg': 'assets/images/background_purple.jpeg',
        'route': 'caresseur',
        'gradient': [Color(0xFF2E8B57), Color(0xFF6FCF97)],
      },
      {
        'title': 'Baffeur',
        'subtitle': 'Gestion de la jauge de sérénité',
        'icon': 'assets/icons/slap-icon.svg',
        'bg': 'assets/images/background_orange.jpeg',
        'route': 'baffeur',
        'gradient': [Color(0xFF6A4FB0), Color(0xFFB58FF0)],
      },
      {
        'title': 'Dragofesse',
        'subtitle': 'Gestion de la jauge d\'amour',
        'icon': 'assets/icons/heart-icon.svg',
        'bg': 'assets/images/background_red.png',
        'route': 'dragofesse',
        'gradient': [Color(0xFF2B6EA3), Color(0xFF7BC6FF)],
      },
      {
        'title': 'Foudroyeur',
        'subtitle': 'Gestion de la jauge d\'endurance',
        'icon': 'assets/icons/thunder-icon.svg',
        'bg': 'assets/images/background_yellow.png',
        'route': 'foudroyeur',
        'gradient': [Color(0xFFB86B2A), Color(0xFFFFC38A)],
      },
      {
        'title': 'Abreuvoir',
        'subtitle': 'Gestion de la jauge de maturité',
        'icon': 'assets/icons/droplet-icon.svg',
        'bg': 'assets/images/background_blue.png',
        'route': 'abreuvoir',
        'gradient': [Color(0xFFB65D8A), Color(0xFFFF9AC7)],
      },
      {
        'title': 'Mangeoire',
        'subtitle': 'Gestion de l\'expérience',
        'icon': 'assets/icons/wheat-icon.svg',
        'bg': 'assets/images/background_green.png',
        'route': 'mangeoire',
        'gradient': [Color(0xFF2E9BBF), Color(0xFFA7E0FF)],
      },
    ];

    /// Build a single navigation pill widget.
    ///
    /// Parameters:
    /// - item: Map containing pill configuration (title, icon, route, etc).
    ///
    /// Returns: Widget - A styled pill button.
    Widget buildPill(Map item) {
      final gradientColors = List<Color>.from(item['gradient']);
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to the selected feature
            Navigator.pushNamed(context, '/${item['route']}');
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: gradientColors.map((c) => c.withOpacity(0.95)).toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              image: DecorationImage(
                image: AssetImage(item['bg']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15),
                  BlendMode.overlay,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.06),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, -1),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1.2,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.14),
                      width: 1.6,
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: SvgPicture.asset(
                        item['icon'],
                        color: Colors.white.withOpacity(0.95),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                // Texts
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        item['subtitle'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.9),
                  size: 36,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_white.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Column(
              children: [
                SizedBox(height: 26),
                // Build menu pills list
                Column(
                  children: options
                      .map(
                        (o) => Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: buildPill(o),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
