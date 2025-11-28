import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final lastJob = st.currentJob;
    final lastStatus = lastJob?.status ?? 'created';
    final progress = (lastJob?.progress ?? 0.0).clamp(0.0, 100.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Visora AI',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // TODO: Open profile page (implement if route exists)
              // Navigator.pushNamed(context, '/profile');
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFF2F2F6),
                    child: Icon(Icons.person, color: Colors.black54, size: 18),
                  ),
                  SizedBox(width: 8),
                  Text('Profile', style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: Column(
            children: [
              // Create Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () async {
                  // Create Video flow: call backend create-video
                  try {
                    // optional: simple feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Creating job...')),
                    );
                    final resp = await st.startCreateJob();
                    // resp should set state.currentJob inside AppState
                    if (st.currentJob != null) {
                      // go to status screen
                      Navigator.pushNamed(context, '/status');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Create Video',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),

              const SizedBox(height: 22),

              // Last Job Status card
              Card(
                elevation: 0,
                color: const Color(0xFFF9F7FB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
                  child: Row(
                    children: [
                      // left: text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last Job Status',
                                style: TextStyle(
                                    color: Colors.black87, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(lastStatus,
                                style: const TextStyle(color: Colors.black54, fontSize: 14)),
                          ],
                        ),
                      ),

                      // right: progress + open status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${progress.toStringAsFixed(0)}%',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/status');
                            },
                            child: const Text('Status', style: TextStyle(color: Colors.black87)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Quick actions grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.8,
                  children: [
                    _ActionCard(
                      icon: Icons.people_2_outlined,
                      title: 'Characters',
                      subtitle: 'Manage characters',
                      onTap: () => Navigator.pushNamed(context, '/characters'),
                    ),
                    _ActionCard(
                      icon: Icons.photo_library_outlined,
                      title: 'Scenes',
                      subtitle: 'Build scenes',
                      onTap: () => Navigator.pushNamed(context, '/scenes'),
                    ),
                    _ActionCard(
                      icon: Icons.settings_suggest_outlined,
                      title: 'Render Settings',
                      subtitle: 'Resolution, style',
                      onTap: () => Navigator.pushNamed(context, '/render'),
                    ),
                    _ActionCard(
                      icon: Icons.info_outline,
                      title: 'Status',
                      subtitle: 'Job & queue',
                      onTap: () => Navigator.pushNamed(context, '/status'),
                    ),
                    // optional extra buttons (profile, player)
                    _ActionCard(
                      icon: Icons.play_circle_outline,
                      title: 'Player',
                      subtitle: 'Last rendered',
                      onTap: () => Navigator.pushNamed(context, '/player'),
                    ),
                    _ActionCard(
                      icon: Icons.more_horiz,
                      title: 'More',
                      subtitle: 'Settings & help',
                      onTap: () {
                        // TODO: implement settings route or dialog
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('App', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ListTile(
                                  leading: const Icon(Icons.brightness_6_outlined),
                                  title: const Text('Toggle theme'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // optional: st.toggleTheme();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.logout),
                                  title: const Text('Logout'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // optional: st.logout();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F7FB),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38)
            ],
          ),
        ),
      ),
    );
  }
}
