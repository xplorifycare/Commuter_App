import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final BorderRadius? borderRadiusObject;
  final double opacity;
  final double blur;
  final Color glowColor;
  final Color shadowColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 28.0,
    this.borderRadiusObject,
    this.opacity = 0.95, // 95% opacity as suggested for subtle glassmorphism
    this.blur = 12.0,    // Blur of 12 as suggested
    this.glowColor = const Color(0xFF2563EB),
    this.shadowColor = const Color(0xFF2563EB),
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        // High-end subtle glass gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(widget.opacity),
            Colors.white.withOpacity(widget.opacity * 0.95),
          ],
        ),
        borderRadius: widget.borderRadiusObject ?? BorderRadius.circular(widget.borderRadius),
        // Very subtle white border
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          // Soft blue ambient shadow
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.04),
            blurRadius: 28.0,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
          // Deep soft shadow
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.01),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadiusObject ?? BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: Container(
            color: Colors.transparent,
            padding: widget.padding ?? const EdgeInsets.all(24.0),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: card,
        ),
      );
    }

    return card;
  }
}
