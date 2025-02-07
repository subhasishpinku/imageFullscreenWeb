import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Fullscreen Web',
      theme: ThemeData.dark(),
      home: ImageScreen(),
    );
  }
}

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? imageUrl;
  bool isMenuOpen = false;

  void _toggleFullScreen() {
    if (html.document.fullscreenElement == null) {
      html.document.documentElement?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

  void _exitFullScreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: imageUrl != null
                ? GestureDetector(
                    onDoubleTap: _toggleFullScreen,
                    child: Image.network(imageUrl!, fit: BoxFit.contain),
                  )
                : Text('Enter a URL and press Show Image', style: TextStyle(fontSize: 18)),
          ),
          if (isMenuOpen)
            GestureDetector(
              onTap: () => setState(() => isMenuOpen = false),
              child: Container(
                color: Colors.black54,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isMenuOpen)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem('Enter Fullscreen', _toggleFullScreen),
                        _buildMenuItem('Exit Fullscreen', _exitFullScreen),
                      ],
                    ),
                  ),
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildUrlInput(),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback onTap) {
    return ListTile(
      title: Text(text, style: TextStyle(color: Colors.white)),
      onTap: () {
        onTap();
        setState(() => isMenuOpen = false);
      },
    );
  }

  Widget _buildUrlInput() {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Enter image URL',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            child: Text('Show Image'),
            onPressed: () => setState(() => imageUrl = _urlController.text),
          ),
        ],
      ),
    );
  }
}
