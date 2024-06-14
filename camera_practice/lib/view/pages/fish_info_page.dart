import 'package:flutter/material.dart';
import 'package:fishdex/utils.dart';

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


  final Map<String, Map<String, String>> fishInfoMap = {
    'Black Sea Sprat': {
      'kr_name': '흑해 청어',
      'description': '흑해 청어는 흑해와 아조프 해에서 주로 발견되며, 작은 크기의 물고기입니다.',
      'length': '1\' 6\"',
      'weight': '0.2 lbs',
    },
    'Trout': {
      'kr_name': '송어',
      'description': '송어는 민물과 바닷물에서 모두 서식할 수 있는 물고기로, 맛이 좋기로 유명합니다.',
      'length': '2\' 0\"',
      'weight': '4.4 lbs',
    },
    'Striped Red Mullet': {
      'kr_name': '줄무늬 붉은돔',
      'description': '줄무늬 붉은돔은 독특한 줄무늬와 붉은 색을 가진 바닷물고기입니다.',
      'length': '1\' 10\"',
      'weight': '3.1 lbs',
    },
    'Shrimp': {
      'kr_name': '새우',
      'description': '새우는 다양한 크기와 색깔을 가지며, 전 세계적으로 인기 있는 해산물입니다.',
      'length': '0\' 8\"',
      'weight': '0.02 lbs',
    },
    'Sea Bass': {
      'kr_name': '농어',
      'description': '농어는 큰 크기와 강력한 체력으로 유명한 바닷물고기입니다.',
      'length': '3\' 0\"',
      'weight': '15.0 lbs',
    },
    'Red Sea Bream': {
      'kr_name': '참돔',
      'description': '참돔은 일본 요리에서 중요한 재료로 사용되며, 맛이 뛰어납니다.',
      'length': '2\' 2\"',
      'weight': '5.5 lbs',
    },
    'Red Mullet': {
      'kr_name': '붉은 송어',
      'description': '붉은 숭어는 주로 연안 지역에서 발견되며, 독특한 붉은 색을 가지고 있습니다.',
      'length': '2\' 6\"',
      'weight': '8.0 lbs',
    },
    'Horse Mackerel': {
      'kr_name': '전갱이',
      'description': '전갱이는 작은 크기의 바닷물고기로, 전 세계적으로 널리 분포합니다.',
      'length': '1\' 2\"',
      'weight': '0.5 lbs',
    },
    'Gilt-Head Bream': {
      'kr_name': '도미',
      'description': '도미는 고급 어종으로 여겨지며, 다양한 요리에서 사용됩니다.',
      'length': '2\' 8\"',
      'weight': '6.6 lbs',
    },
  };



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF98BAD5),
          title: Text(
            fishInfoMap[fishName]!['kr_name'] ?? '',
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
                  Text(
                    fishInfoMap[fishName]!['description'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Length',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(fishInfoMap[fishName]!['length'] ?? '', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Weight',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(fishInfoMap[fishName]!['weight'] ?? '', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 10,
                ),
                itemCount: fishImageMap.length,
                // itemCount: 50,
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
                                    // child: Image.asset('lib/fish/$value.png'),
                                    child: Image.network('https://final-fishdex.s3.ap-northeast-2.amazonaws.com/00023.png'),
                                  ),
                                  Text(
                                    "날짜: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "길이: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "무게: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
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
                        // child: Image.asset('lib/fish/$value.png'),
                        child: Image.network('https://final-fishdex.s3.ap-northeast-2.amazonaws.com/00023.png'),
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