import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/app_state.dart';
import 'falah_dropdown_menu.dart';

class FalahAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? customActions;
  final bool showDropdownMenu;

  const FalahAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.customActions,
    this.showDropdownMenu = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);

  void _openDropdownMenu(BuildContext context, GlobalKey buttonKey) {
    final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Calculate anchor rectangle for the popup menu
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height + 4,
      screenSize.width - (offset.dx + size.width),
      screenSize.height - (offset.dy + size.height),
    );

    FalahDropdownMenu.show(context, position);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final GlobalKey menuButtonKey = GlobalKey();

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.forestHeroGradient,

      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Top-right anchored dropdown menu button (In RTL, this is at the start = Right)
              if (showDropdownMenu)
                InkWell(
                  key: menuButtonKey,
                  onTap: () => _openDropdownMenu(context, menuButtonKey),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.limeBright,
                          child: Text(
                            appState.currentUser.avatarInitials,
                            style: const TextStyle(
                              color: AppColors.forestDarkest,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              // Title & Tagline / Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.limeLight.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Custom actions (e.g. notifications pill or filter)
              ...?customActions,
            ],
          ),
        ),
      ),
    );
  }
}
