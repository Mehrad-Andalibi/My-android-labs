import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Browse Categories", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between sections
            children: [
              Text(
                "Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.",
                textAlign: TextAlign.center,
              ),

              // By Meat Section
              Align(
                alignment: Alignment.topCenter,
                child: Text("BY MEAT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  categoryItem("images/beef.jpg", "BEEF"),
                  categoryItem("images/chicken.jpg", "CHICKEN"),
                  categoryItem("images/pork.jpg", "PORK"),
                  categoryItem("images/seafood.jpg", "SEAFOOD"),
                ],
              ),

              // By Course Section
              Text("BY COURSE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  categoryItemBottomText("images/main_dish.jpg", "Main Dishes"),
                  categoryItemBottomText("images/salad.jpg", "Salad Recipes"),
                  categoryItemBottomText("images/side_dish.jpg", "Side Dishes"),
                  categoryItemBottomText("images/crockpot.jpg", "Crockpot"),
                ],
              ),

              // By Dessert Section
              Text("BY DESSERT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  categoryItemBottomText("images/ice_cream.jpg", "Ice Cream"),
                  categoryItemBottomText("images/brownies.jpg", "Brownies"),
                  categoryItemBottomText("images/pies.jpg", "Pies"),
                  categoryItemBottomText("images/cookies.jpg", "Cookies"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function for Stack Layout with Text in the Center of Image
  Widget categoryItem(String imagePath, String label) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 80,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, backgroundColor: Colors.black54),
        ),
      ],
    );
  }

  // Function for Stack Layout with Text at Bottom of Image
  Widget categoryItemBottomText(String imagePath, String label) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 80,
        ),
        Container(
          padding: EdgeInsets.all(5),
          color: Colors.black54,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
