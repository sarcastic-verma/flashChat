import 'package:carousel_slider/carousel_slider.dart';
import 'package:flash_chat/components/CarouselContent.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static String id = "/intro";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 600,
              enableInfiniteScroll: false,
              reverse: false,
              enlargeCenterPage: true,
            ),
            items: [
              Content(
                imageName: "logo",
                title: "Eh Eh boiii",
                desc: "Lets get you familiar with the super this world's best app...",
                showImage: true,
                width: 200,
                height: 200,
              ),
              Content(
                width: 300,
                height: 190,
                imageName: "dislike",
                showImage: true,
                title: "Don't Like a message??",
                desc:
                    "Show that!! , cause this ain't no facebook..\nJust swipe left on that msg!! To undo that just press on dislike button.",
              ),
              Content(
                imageName: "like",
                showImage: true,
                title: "Like a message??",
                desc:
                    "Yes, by double tapping on it as many times as you want.\nTo undo that just press on the like button.",
              ),
              Content(
                imageName: "del",
                showImage: true,
                title: "But can you delete a msg??",
                desc:
                    "why not?? Isn't this the best feature!, just long press to delete, tap on it to hide the delete menu!!",
              ),
              Content(
                title: "Noice, wasn't it!!",
                desc: "Hasta La'Vista Now :)",
                showImage: true,
                imageName: "logo",
                showButton: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
