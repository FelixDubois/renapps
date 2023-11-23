import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:renapps/functions/functions.dart';
import 'package:renapps/main.dart';

class FriendCard extends StatefulWidget {
  const FriendCard(
      {super.key,
      required this.buque,
      required this.num,
      required this.progress,
      required this.imgUrl});

  final String buque;
  final String num;
  final double progress;
  final String imgUrl;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  Color getColor(double v) {
    return getColorFromGradient(gradient, v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            color: getColor(widget.progress),
                            value: widget.progress,
                            strokeWidth: 10,
                          ),
                        ),
                      ))),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(widget.buque, style: const TextStyle(fontSize: 15)),
          ),
          Text(widget.num, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
