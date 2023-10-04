import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Container(
        width: double.infinity,
        height: 30.0,
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.0)
      ),
    );
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          line, line, line, line, line
        ],
      ),
    );
  }
}