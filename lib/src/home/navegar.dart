
// main.dart
import 'package:flutter/material.dart';
class HomeScreenTestna extends StatefulWidget {
  const HomeScreenTestna({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenTestna> {
  // The contents of views
  // Only the content associated with the selected tab is displayed on the screen
  final List<Widget> _mainContents = [
    // Content for Home tab
    Container(
      color: Colors.yellow.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Homessss',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Feed tab
    Container(
      color: Colors.purple.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Feed',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Favorites tab
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Settings tab
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];

  // The index of the selected tab
  // In the beginning, the Home tab is selected
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      // Show the bottom tab bar if screen width < 640
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.indigoAccent,
          // called when one tab is selected
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          // bottom tab items
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.feed), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ])
          : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Show the navigaiton rail if screen width >= 640
                 // Main content
          // This part is always shown
          // You will see it on both small and wide screen
          Expanded(child: _mainContents[_selectedIndex]),
        ],
      ),
    );
  }
}