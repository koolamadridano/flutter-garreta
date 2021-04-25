// `Grid loader`
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

SliverPadding gridLoading = SliverPadding(
  padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
  sliver: SliverGrid.count(
    crossAxisCount: 2,
    childAspectRatio: 0.8,
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
    children: [
      for (var i = 0; i < 5; i++)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          width: 200.0,
          height: 200.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                color: Colors.white,
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
    ],
    // Use a delegate to build items as they're scrolled on screen.
  ),
);
