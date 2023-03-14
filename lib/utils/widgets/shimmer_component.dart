import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerComponent extends StatefulWidget {
  const ShimmerComponent({
    super.key,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  final double deviceWidth;
  final double deviceHeight;

  @override
  State<ShimmerComponent> createState() => _ShimmerComponentState();
}

class _ShimmerComponentState extends State<ShimmerComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: ThemeMode.system != ThemeMode.dark
                ? Colors.grey[900] as Color
                : Colors.grey[300] as Color,
            highlightColor: Colors.grey[100] as Color,
            child: Container(
              width: widget.deviceWidth,
              padding: const EdgeInsets.all(3),
              height: widget.deviceHeight / 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 15.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: double.infinity,
                          height: 15.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Container(
                          width: 40.0,
                          height: 15.0,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                width: 40.0,
                                height: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                              child: Divider(),
                            ),
                            Container(
                              width: 40.0,
                              height: 14.0,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: widget.deviceWidth,
            child: const Divider(
              thickness: 0.5,
            ),
          )
        ],
      ),
    );
  }
}
