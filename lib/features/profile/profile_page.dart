import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tube_lens/shared/widgets/header_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Local toggle states
  bool _verboseLogs = false;
  bool _glowEffects = true;
  bool _autoCacheRefresh = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF0B0F1A),
      body: Stack(
        children: [
          // Background glows (if enabled)
          if (_glowEffects) ...[
            Positioned(
              top: -150,
              left: -150,
              child: _glow(const Color(0xFF8B5CF6).withValues(alpha: 0.35)),
            ),
            Positioned(
              bottom: -150,
              right: -150,
              child: _glow(const Color(0xFF3B82F6).withValues(alpha: 0.35)),
            ),
          ],
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(
                    header: "Settings",
                    subHeader: "Manage your local config, API limits, and open-source preferences",
                  ),
                  const SizedBox(height: 30),
                  _buildDeveloperProfileCard(),
                  const SizedBox(height: 24),
                  _buildQuotaTrackerCard(),
                  const SizedBox(height: 24),
                  _buildDeveloperControlsSection(),
                  const SizedBox(height: 24),
                  _buildLocalConfigSection(),
                  const SizedBox(height: 100), // bottom navigation spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131926).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
              ),
            ),
            child: const Text(
              "BK",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bilal Khalifa",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Local Host / Developer",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        "v1.0.0",
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaTrackerCard() {
    const int consumedUnits = 120;
    const int dailyLimit = 10000;
    const double usagePercentage = consumedUnits / dailyLimit;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131926).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "YOUTUBE DATA API QUOTA",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Self-Hosted Key",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$consumedUnits / $dailyLimit units used today",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "1.2%",
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usagePercentage,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "API quotas reset daily at midnight PST. The default developer key allows up to 10,000 units.",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "System Utilities",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildUtilityButton(
          title: "Clear Database Search Cache",
          subtitle: "Remove all cached MongoDB channel analytics",
          icon: Icons.cached_rounded,
          color: Colors.redAccent,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF131926),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.2)),
                ),
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text(
                      "Local cache wiped successfully!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildRepositoryTile(
          repoName: "tube_lens_frontend",
          url: "https://github.com/BilalKhalifa/tube_lens_frontend",
          icon: Icons.laptop_chromebook_rounded,
        ),
        const SizedBox(height: 10),
        _buildRepositoryTile(
          repoName: "tube_lens_backend",
          url: "https://github.com/BilalKhalifa/tube_lens_backend",
          icon: Icons.dns_rounded,
        ),
        const SizedBox(height: 10),
        _buildRepositoryTile(
          repoName: "tube_lens_ai_service",
          url: "https://github.com/BilalKhalifa/tube_lens_ai_service",
          icon: Icons.psychology_rounded,
        ),
      ],
    );
  }

  Widget _buildUtilityButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131926).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepositoryTile({
    required String repoName,
    required String url,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131926).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: url));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF131926),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.0),
                ),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Copied: $repoName URL to clipboard!",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF8B5CF6), size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repoName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        url,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.copy_rounded, color: Colors.white38, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocalConfigSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Local Preferences",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF131926).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildConfigSwitch(
                title: "Verbose Console Logging",
                subtitle: "Outputs raw API JSON data to debug console",
                value: _verboseLogs,
                onChanged: (val) {
                  setState(() {
                    _verboseLogs = val;
                  });
                },
              ),
              const Divider(color: Colors.white12, height: 1),
              _buildConfigSwitch(
                title: "Dynamic Glow Effects",
                subtitle: "Enables heavy blur backdrop radial glow filters",
                value: _glowEffects,
                onChanged: (val) {
                  setState(() {
                    _glowEffects = val;
                  });
                },
              ),
              const Divider(color: Colors.white12, height: 1),
              _buildConfigSwitch(
                title: "Auto-Cache Optimization",
                subtitle: "Automatically refresh local database cache",
                value: _autoCacheRefresh,
                onChanged: (val) {
                  setState(() {
                    _autoCacheRefresh = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF8B5CF6),
        activeTrackColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.white38,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _glow(Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
