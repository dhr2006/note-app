import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/note_model.dart';

class StickyNoteCard extends StatefulWidget {
  const StickyNoteCard({
    required this.note,
    required this.color,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Note note;
  final NoteColor color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  State<StickyNoteCard> createState() => _StickyNoteCardState();
}

class _StickyNoteCardState extends State<StickyNoteCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _elevationAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = math.Random(widget.note.id.hashCode);
    final rotation = (random.nextDouble() - 0.5) * 0.025;
    final tapeRotation = (random.nextDouble() - 0.5) * 0.05;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: rotation,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.primary,
                        widget.color.secondary,
                      ],
                      stops: const [0, 0.85],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.shadowColor,
                        offset: Offset(
                          4 * _elevationAnimation.value,
                          6 * _elevationAnimation.value,
                        ),
                        blurRadius: 10 * _elevationAnimation.value,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative tape at top
                      Positioned(
                        top: -2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Transform.rotate(
                            angle: tapeRotation,
                            child: Container(
                              width: 70,
                              height: 22,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 28, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title with underline accent
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.note.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.color.textColor,
                                    height: 1.2,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2.5,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: widget.color.accent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Content preview
                            Expanded(
                              child: Text(
                                widget.note.content,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.color.textColor.withValues(alpha: 0.82),
                                  height: 1.5,
                                  letterSpacing: 0.15,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Footer with date and actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Date badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.color.accent.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _formatDate(widget.note.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: widget.color.accent,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),

                                // Delete button - FIXED with proper event handling
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onDelete();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Corner fold effect
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipPath(
                          clipper: CornerFoldClipper(),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.color.accent.withValues(alpha: 0.25),
                                  widget.color.accent.withValues(alpha: 0.08),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Hover indicator
                      if (_isHovered)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: widget.color.accent.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class CornerFoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height * 0.65)
      ..lineTo(size.width * 0.65, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
