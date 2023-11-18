import 'package:flutter/material.dart';
import 'package:renapps/widgets/friend_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                children: [
                  const Header(),
                  const FriendListView(),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _value,
                          onChanged: (double value) {
                            setState(() {
                              _value = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            setState(() {
                              // TODO : Send value to the server
                              //_value = value;
                            });
                          },
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        color: Colors.grey[500],
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Buque num fam',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "OldLondon",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: null, // TODO : Open camera
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: null, // TODO : Open QR code
                icon: Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ));
  }
}

class FriendListView extends StatelessWidget {
  const FriendListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: const [
            FriendCard(buque: '1', num: '1 - 1', progress: 0.1),
            FriendCard(buque: '2', num: '2 - 2', progress: 0.8),
            FriendCard(buque: '3', num: '3 - 3', progress: 0.4),
            FriendCard(buque: '4', num: '4 - 4', progress: 0.9),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.7),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.1),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.8),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.4),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.6),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.2),
            FriendCard(buque: '5', num: '5 - 5', progress: 0.8),
          ],
        ),
      )),
    );
  }
}
