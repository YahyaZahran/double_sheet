import 'package:flutter/material.dart';
import 'package:double_sheet/double_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Double Sheet Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _showFreezeCardSheet() {
    showDoubleSheet(
      context: context,
      title: "Freeze card?",
      initialChildSize: 0.5,
      maxChildSize: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Freezing the card means you can't use it to pay for things until you unfreeze it",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Never mind"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Card frozen!")),
                      );
                    },
                    child: const Text("Freeze"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShoppingListSheet() {
    showDoubleSheet(
      context: context,
      title: "Shopping List",
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text('Item ${index + 1}'),
              subtitle: const Text('Tap to mark as purchased'),
              trailing: const Icon(Icons.shopping_cart_outlined),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item ${index + 1} purchased!')),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showSettingsSheet() {
    showDoubleSheet(
      context: context,
      title: "Settings",
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      headerBackgroundColor: Colors.indigo,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('English'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showFullscreenSheet() {
    showDoubleSheet(
      context: context,
      title: "Fullscreen Mode",
      initialChildSize: 0.3,
      allowFullScreen: true,
      headerBackgroundColor: Colors.green,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fullscreen, color: Colors.green, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Fullscreen Sheet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "This sheet can expand to fullscreen! Watch how:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text("1. 📱 The header slides up as you drag"),
                  Text("2. 🔧 Border radius disappears when fullscreen"),
                  Text("3. 🖱️ Tap outside the sheet to dismiss"),
                  Text("4. ⬆️ Drag all the way up for fullscreen mode"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text('Scrollable Item ${index + 1}'),
                      subtitle: Text('This content scrolls inside the sheet'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomSheet() {
    showDoubleSheet(
      context: context,
      title: "Custom Example",
      initialChildSize: 0.4,
      maxChildSize: 0.85,
      isDismissible: false,
      allowFullScreen: true,
      backgroundColor: Colors.purple.shade50,
      headerBackgroundColor: Colors.purple,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Custom Content",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This sheet has custom styling and is not dismissible by tapping outside.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Features:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text("• Custom background colors"),
            const Text("• Custom header style"),
            const Text("• Non-dismissible"),
            const Text("• Draggable"),
            const Text("• Can expand to fullscreen!"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "💡 Try dragging this sheet all the way up to see fullscreen mode!",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Double Sheet Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.layers,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Double Sheet Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showFreezeCardSheet,
                      icon: const Icon(Icons.credit_card_off),
                      label: const Text('Freeze Card Example'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showShoppingListSheet,
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Shopping List Example'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showSettingsSheet,
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings Example'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showCustomSheet,
                      icon: const Icon(Icons.palette),
                      label: const Text('Custom Styling Example'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showFullscreenSheet,
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('Fullscreen Sheet Example'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Button pressed $_counter times',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
          _showFreezeCardSheet();
        },
        tooltip: 'Show Double Sheet',
        child: const Icon(Icons.add),
      ),
    );
  }
}