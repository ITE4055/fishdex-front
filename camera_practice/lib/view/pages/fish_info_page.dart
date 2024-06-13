import 'package:flutter/material.dart';

class FishInfoPage extends StatelessWidget {
  final String fishName;
  // final String imageUrl;

  // const FishInfoPage({required this.fishName, required this.imageUrl, Key? key}) : super(key: key);
  FishInfoPage({required this.fishName, Key? key}) : super(key: key);

  final Map<String, String> fishImageMap = {
    'Black Sea Sprat': 'fish-1',
    'Trout': 'fish-2',
    'Striped Red Mullet': 'fish-3',
    'Shrimp': 'fish-4',
    'Sea Bass': 'fish-5',
    'Red Sea Bream': 'fish-6',
    'Red Mullet': 'fish-7',
    'Horse Mackerel': 'fish-8',
    'Gilt-Head Bream': 'fish-9',
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF98BAD5),
          title: Text(
            fishName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Collection'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('lib/fish/${fishImageMap[fishName]}.png'),

                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'About',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Description of the fish goes here...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Length',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('2\' 04\"', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Weight',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('15.2 lbs', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    // crossAxisSpacing: 10,
                    // mainAxisSpacing: 10,
                ),
                itemCount: fishImageMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = fishImageMap.keys.elementAt(index);
                  String value = fishImageMap[key]!;
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset('lib/fish/$value.png'),
                                  ),
                                  const Text(
                                    "날짜: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "길이: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "무게: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "위치: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            );
                          },
                      );
                    },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset('lib/fish/$value.png'),
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
}