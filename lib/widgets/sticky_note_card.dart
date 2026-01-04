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
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
    final rotation = (random.nextDouble() - 0.5) * 0.03;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Transform.rotate(
          angle: rotation,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.primary,
                    widget.color.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.shadowColor,
                    blurRadius: _isHovered ? 12 : 8,
                    offset:
                        _isHovered ? const Offset(5, 7) : const Offset(3, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  /// TAPE
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 72,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),

                  /// CONTENT
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          widget.note.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.color.textColor,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// ACCENT LINE
                        Container(
                          height: 2,
                          width: 36,
                          decoration: BoxDecoration(
                            color: widget.color.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// CONTENT TEXT
                        Flexible(
                          child: Text(
                            widget.note.content,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: widget.color.textColor.withValues(alpha: 0.85),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// FOOTER
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.color.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatDate(widget.note.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: widget.color.accent,
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: widget.onDelete,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete_outline,
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

                  /// CORNER FOLD
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
                            colors: [
                              widget.color.accent.withValues(alpha: 0.3),
                              widget.color.accent.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}';
  }
}

/// CORNER FOLD CLIPPER
class CornerFoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
