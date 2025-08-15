import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/login/view/login_page.dart';
import 'package:test_app/signup/controller/signupController.dart';
import 'package:test_app/signup/views/signup_page.dart';
import 'pages/reddit_page.dart';
import 'pages/pubdev_page.dart';
import 'pages/youtube_page.dart';
import 'pages/medium_page.dart';

void main() {
  runApp(FlutterExplorerApp());
}

class FlutterExplorerApp extends StatelessWidget {
  const FlutterExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Signupcontroller());
    return MaterialApp(
      title: 'Flutter Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignupPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    RedditPage(),
    PubDevPage(),
    YouTubePage(),
    MediumPage(),
  ];

  static const List<String> _titles = [
    'Reddit',
    'pub.dev',
    'YouTube',
    'Medium',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Explorer',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.reddit),
            label: 'Reddit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_board),
            label: 'pub.dev',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'YouTube',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Medium',
          ),
        ],
      ),
    );
  }
}
