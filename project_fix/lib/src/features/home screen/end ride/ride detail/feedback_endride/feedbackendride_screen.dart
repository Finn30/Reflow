import 'package:flutter/material.dart';

class FeedBackEndRideScreen extends StatefulWidget {
  const FeedBackEndRideScreen({Key? key}) : super(key: key);

  @override
  _FeedBackEndRideScreenState createState() => _FeedBackEndRideScreenState();
}

class _FeedBackEndRideScreenState extends State<FeedBackEndRideScreen> {
  String? _selectedWorkOrder;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/img/REflowww.png',
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text('operator: Re:Flow',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: Colors.green,
                        size: 30,
                      ),
                      title: Text(
                        'Official Website',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'https://gridwizenm.com',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.amber,
                        size: 30,
                      ),
                      title: Text(
                        'Service Hotline',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '+62995357986000',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '*Work order type',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              children: [
                for (var i = 0; i < _workOrderTypes.length - 3; i += 2)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text(
                            _workOrderTypes[i],
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: _workOrderTypes[i],
                          groupValue: _selectedWorkOrder,
                          activeColor: Colors.green,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity:
                              VisualDensity(horizontal: -4.0, vertical: -4.0),
                          onChanged: (value) {
                            setState(() {
                              _selectedWorkOrder = value as String?;
                            });
                          },
                        ),
                      ),
                      if (i + 1 < _workOrderTypes.length - 3)
                        Expanded(
                          child: RadioListTile(
                            title: Text(
                              _workOrderTypes[i + 1],
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: _workOrderTypes[i + 1],
                            groupValue: _selectedWorkOrder,
                            activeColor: Colors.green,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity:
                                VisualDensity(horizontal: -4.0, vertical: -4.0),
                            onChanged: (value) {
                              setState(() {
                                _selectedWorkOrder = value as String?;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = _workOrderTypes.length - 3;
                        i < _workOrderTypes.length;
                        i++)
                      RadioListTile(
                        title: Text(
                          _workOrderTypes[i],
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: _workOrderTypes[i],
                        groupValue: _selectedWorkOrder,
                        activeColor: Colors.green,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity:
                            VisualDensity(horizontal: -4.0, vertical: -4.0),
                        onChanged: (value) {
                          setState(() {
                            _selectedWorkOrder = value as String?;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '*Detailed Description',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Tell us what's up so we can help you out",
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                // Positioned(
                //   // right: 10,
                //   // bottom: 10,
                //   child: Text(
                //     "${_descriptionController.text.length}/200",
                //     style: TextStyle(color: Colors.grey),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload File',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 100,
              width: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.add, size: 40, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 10)),
                    child: const Text('Send it',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(vertical: 10)),
                    child: const Text('My feedback',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> _workOrderTypes = [
  'Unable to lock',
  'Unable to unlock',
  'Unable to ride',
  'Forgot to lock',
  'Lock still charged',
  'Car feedback',
  'Suggestions and improvements',
  'Already at the parking spot',
  'Other issues',
];
