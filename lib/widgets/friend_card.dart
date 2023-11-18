import 'package:flutter/material.dart';

class FriendCard extends StatefulWidget {
  const FriendCard(
      {Key? key,
      required this.buque,
      required this.num,
      required this.progress})
      : super(key: key);

  final String buque;
  final String num;
  final double progress;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  Color getColor(double v) {
    if (v < 0.5) {
      return Colors.green;
    } else if (v < 0.8) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
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
              child: CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage('assets/images/test_photo.jpeg'),
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: getColor(widget.progress),
                value: widget.progress,
                strokeWidth: 10,
              ),
            ),
          )),
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
