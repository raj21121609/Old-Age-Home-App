import 'package:flutter/material.dart';

class FacilityImage extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  const FacilityImage({
    super.key,
    this.imageUrl,
    required this.name,
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'F';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getColor(String name) {
    if (name.trim().isEmpty) return Colors.grey;
    final colors = [
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.orange.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
      Colors.indigo.shade700,
      Colors.pink.shade700,
      Colors.red.shade700,
    ];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty && imageUrl != 'null';
    
    final resolvedRadius = borderRadius ?? BorderRadius.circular(0);

    if (hasImage) {
      return ClipRRect(
        borderRadius: resolvedRadius,
        child: Image.network(
          imageUrl!,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(resolvedRadius),
        ),
      );
    }

    return ClipRRect(
      borderRadius: resolvedRadius,
      child: _buildFallback(resolvedRadius),
    );
  }

  Widget _buildFallback(BorderRadiusGeometry radius) {
    final color = _getColor(name);
    
    double fontSize = 24.0;
    if (height != null) {
      fontSize = height! * 0.4;
    } else if (width != null) {
      fontSize = width! * 0.4; // Fallback to width-based sizing
    }

    return Container(
      height: height,
      width: width,
      color: color.withOpacity(0.12),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
