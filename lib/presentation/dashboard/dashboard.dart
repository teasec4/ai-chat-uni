import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final bool isBigScreen;
  const Dashboard({required this.isBigScreen, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isBigScreen
          ? null
          : AppBar(
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
      drawer: Drawer(child: Text("Drawer")),
      body: Row(
        children: [
          if (widget.isBigScreen)
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: _isDrawerOpen ? 72 : 260,
              color: Colors.red,
              child: Column(
                crossAxisAlignment: _isDrawerOpen ? .center : .end,
                children: [
                  IconButton(
                    icon: Icon(Icons.list, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: [
                        if(!_isDrawerOpen)
                        ListTile(title: Text("Item 1")),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Expanded(child: Container(color: Colors.green)),
        ],
      ),
    );
  }
}
