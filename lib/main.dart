import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MacOSDock(),
    );
  }
}

class MacOSDock extends StatefulWidget {
  const MacOSDock({super.key});

  @override
  State<MacOSDock> createState() => _MacOSDockState();
}

class _MacOSDockState extends State<MacOSDock> {
  // Reduced number of icons to fit screen better
  List<IconData> icons = [
    // Icons.web_browser,
    Icons.mail_outline,
    Icons.message_outlined,
    Icons.calendar_today,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: icons.asMap().entries.map((entry) {
                return Draggable<int>(
                  data: entry.key,
                  feedback: Icon(
                    entry.value,
                    size: 40,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  childWhenDragging: Icon(
                    entry.value,
                    size: 40,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: DragTarget<int>(
                    onAccept: (draggedIndex) {
                      if (draggedIndex != entry.key) {
                        setState(() {
                          // Only swap if dragged horizontally
                          final draggedIcon = icons[draggedIndex];
                          icons[draggedIndex] = icons[entry.key];
                          icons[entry.key] = draggedIcon;
                        });
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return DockIcon(
                        key: ValueKey(entry.value),
                        icon: entry.value,
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity != 0) {
                            setState(() {
                              // Reset to original order
                              icons = [
                                // Icons.web_browser,
                                Icons.mail_outline,
                                Icons.message_outlined,
                                Icons.calendar_today,
                                Icons.settings,
                              ];
                            });
                          }
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DockIcon extends StatefulWidget {
  final IconData icon;
  final Function(DragEndDetails) onVerticalDragEnd;

  const DockIcon({
    required Key key,
    required this.icon,
    required this.onVerticalDragEnd,
  }) : super(key: key);

  @override
  State<DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: widget.onVerticalDragEnd,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            size: isHovered ? 48 : 40,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}