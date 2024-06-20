import 'package:fishdex/view/pages/image_data.dart';
import 'package:flutter/material.dart';
import 'package:fishdex/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FishInfoPage extends StatefulWidget {
  final String fishName;

  // const FishInfoPage({required this.fishName, required this.imageUrl, Key? key}) : super(key: key);
  FishInfoPage({required this.fishName, Key? key}) : super(key: key);

  @override
  State<FishInfoPage> createState() => _FishInfoPageState();
}

class _FishInfoPageState extends State<FishInfoPage> {
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
      'b_name': 'Clupeonella cultriventris',
      'description': '흑해 청어는 흑해, 아조프해, 카스피해에 서식하는 작은 떼지어입니다.'
          '이들은 대형 포식성 어류의 주요 먹이원이자 지역 어업에 중요한 상업적 가치를 가지고 있습니다. '
          '흑해 청어는 높은 기름 함량으로 인해 오메가-3 지방산의 풍부한 공급원입니다. '
          '이들은 종종 캔으로 가공되어 지역 경제에 크게 기여합니다. 또한 낚시 미끼로도 사용됩니다.',
      'length': '9-13 cm',
      'weight': '10-15 g',
    },
    'Trout': {
      'kr_name': '송어',
      'b_name': 'Oncorhynchus mykiss',
      'description': '무지개 송어는 아시아와 북미의 태평양으로 흐르는 냉수 하천에 서식하는 물고기입니다. '
          '이들은 스포츠 낚시와 양식 목적으로 널리 도입되었습니다. '
          '무지개 송어는 다양한 담수 환경에서 번성할 수 있는 높은 적응력을 가지고 있으며, 산악 하천에서 큰 강과 호수에 이르기까지 서식합니다. '
          '이들은 옆구리에 특징적인 분홍색 줄무늬를 가진 화려한 색채로 유명합니다. '
          '무지개 송어의 살은 단단하고 맛이 좋아 상업 어업과 레크리에이션 낚시에서 인기가 높습니다.',
      'length': '30-60 cm',
      'weight': '1-3 kg',
    },
    'Striped Red Mullet': {
      'kr_name': '줄무늬 붉은돔',
      'b_name': 'Mullus surmuletus',
      'description': '줄무늬 붉은돔은 독특한 줄무늬와 붉은 색을 가진 바닷물고기입니다.',
      'length': '20-40 cm',
      'weight': '0.2-0.5 kg',
    },
    'Shrimp': {
      'kr_name': '새우',
      'b_name': 'Penaeus monodon',
      'description': '대왕새우는 열대 및 아열대 지역에서 광범위하게 양식되는 가장 크고 상업적으로 중요한 새우 종 중 하나입니다. '
          '이들은 인도-태평양 지역에 원산지이며, 따뜻한 기수에서 번성합니다. '
          '대왕새우는 독특한 띠 모양의 색채와 큰 크기로 구별됩니다. '
          '이들은 전 세계적으로 양식업에서 중요한 역할을 하며, 해마다 많은 양이 생산되어 해산물 시장의 높은 수요를 충족시킵니다. '
          '대왕새우의 달콤하고 부드러운 고기는 다양한 요리에서 인기가 높으며, 지속 가능성을 확보하고 환경 영향을 줄이기 위한 양식 방식이 지속적으로 발전하고 있습니다.',
      'length': '20-35 cm',
      'weight': '100-300 g',
    },
    'Sea Bass': {
      'kr_name': '농어',
      'b_name': 'Dicentrarchus labrax',
      'description': '유럽 농어는 동부 대서양과 지중해에 널리 분포하며, 상업 어업과 양식업에서 높은 가치를 지닌 종입니다. '
          '농어는 은빛 몸통을 가진 우아한 모습으로, 다양한 요리법에 잘 어울립니다. '
          '이들은 연안 지역과 하구에 서식하며, 종종 기수 환경으로 이동합니다. '
          '농어의 단단하고 흰 살은 순한 맛을 지니고 있어 요리사와 소비자들 사이에서 인기가 높습니다. '
          '또한, 농어는 레크리에이션 낚시에서도 중요한 역할을 하며, 낚였을 때의 저항력으로 낚시꾼들에게 매력을 끌고 있습니다.',
      'length': '40-100 cm',
      'weight': '1-8 kg',
    },
    'Red Sea Bream': {
      'kr_name': '참돔',
      'b_name': 'Pagrus major',
      'description': '참돔은 일본에서 타이로 알려진 상업적 및 레크리에이션 낚시에서 중요한 종입니다. '
          '서태평양에 서식하며, 특히 일본, 한국, 중국 주변에서 많이 발견됩니다. '
          '이들은 단단한 흰 살과 섬세한 맛으로 높이 평가되며, 특히 사시미로 자주 사용됩니다. '
          '참돔은 또한 행운의 상징으로 여겨져 축하 행사 때 자주 제공됩니다. '
          '이들은 암초와 모래 바닥에서 서식하며, 갑각류와 작은 물고기를 먹이로 삼습니다. '
          '빠른 성장과 적응력으로 인해 양식업에서도 인기가 높습니다.',
      'length': '30-50 cm',
      'weight': '1-3 kg',
    },
    'Red Mullet': {
      'kr_name': '붉은 송어',
      'b_name': 'Mullus barbatus',
      'description': '붉은 숭어는 지중해와 동부 북대서양에서 흔히 발견되는 작은 저서 어류로, 눈에 띄는 붉은색과 분홍색을 띱니다. '
          '이들은 모래나 진흙 바닥을 선호하며, 작은 무척추동물을 찾아 먹이 활동을 합니다. '
          '붉은 숭어는 지중해 요리에서 매우 가치 있는 식재료로, 그릴, 구이, 다양한 생선 스튜에 자주 사용됩니다. '
          '이 종은 고대 로마 시대부터 요리에서 즐겨 사용되었으며, 오늘날에도 여전히 해안 지역에서 인기 있는 별미로 여겨집니다.',
      'length': '15-30 cm',
      'weight': '0.1-0.3 kg',
    },
    'Horse Mackerel': {
      'kr_name': '전갱이',
      'b_name': 'Trachurus trachurus',
      'description': '전갱이 또는 잭 전갱이는 대서양과 지중해에서 발견되는 떼지어입니다. '
          '이들은 길쭉한 몸과 측선에 있는 특징적인 갑판 비늘로 쉽게 구별됩니다. '
          '전갱이는 생태적 및 경제적으로 중요하며, 대형 포식자들의 먹이이자 상업 어업의 주요 대상입니다. '
          '이들은 일반적으로 자망과 저인망으로 잡히며, 종종 캔으로 가공되거나 어분으로 사용됩니다. '
          '신선한 전갱이는 많은 해안 지역 요리에서 인기가 있으며, 주로 그릴이나 튀김으로 요리됩니다.',
      'length': '15-40 cm',
      'weight': '0.1-0.5 kg',
    },
    'Gilt-Head Bream': {
      'kr_name': '도미',
      'b_name': 'Sparus aurata',
      'description': '도미는 눈 사이에 있는 금색 띠로 인해 이름이 붙여졌으며, 지중해와 동부 대서양에서 발견됩니다. '
          '이 종은 빠른 성장 속도와 높은 시장 가치로 인해 양식업에서 매우 인기가 있습니다. '
          '도미는 지중해 요리에서 널리 사용되며, 순하고 달콤한 맛과 단단한 질감으로 잘 알려져 있습니다. '
          '이들은 주로 통째로 구워지며, 허브와 레몬으로 양념하여 요리됩니다. '
          '자연 서식지에서는 해초 밭과 암초 바닥을 선호하며, 다양한 무척추동물을 먹이로 삼습니다. '
          '도미는 상업 어업과 레크리에이션 낚시에서 모두 경제적 및 문화적으로 중요한 위치를 차지하고 있습니다.',
      'length': '20-40 cm',
      'weight': '0.5-1.5 kg',
    },
  };

  late Future<List<ImageData>> _imageDataList;

  @override
  void initState() {
    super.initState();
    _imageDataList = getUrlImages(widget.fishName);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF98BAD5),
          title: Text(
            fishInfoMap[widget.fishName]!['kr_name'] ?? '', // 텍스트 내용
            style: TextStyle(
              fontSize: 30, // 폰트 크기 설정
              fontFamily: 'Roboto', // 사용할 폰트 설정
              fontWeight: FontWeight.bold, // 폰트 굵기 설정
              fontStyle: FontStyle.italic, // 폰트 스타일 설정
              color: Colors.white, // 텍스트 색상 설정
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('lib/fish/${fishImageMap[widget.fishName]}.png'),
                    ),
                    SizedBox(height: 10),
                    const Center(
                      child: Text(
                        '학명',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // const SizedBox(height: 10),

                    Center(
                      child: Text(
                        fishInfoMap[widget.fishName]!['b_name'] ?? '',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '정보',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      fishInfoMap[widget.fishName]!['description'] ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '평균 길이',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(fishInfoMap[widget.fishName]!['length'] ?? '', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '평균 무게',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(fishInfoMap[widget.fishName]!['weight'] ?? '', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                      '주서식지',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),),
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset('lib/map/${fishImageMap[widget.fishName]}-map.png', fit: BoxFit.cover, height: 200, width: 300),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: FutureBuilder<List<ImageData>>(
                future: _imageDataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.length,
                      // itemCount: 50,
                      itemBuilder: (BuildContext context, int index) {
                        // String key = fishImageMap.keys.elementAt(index);
                        // String value = fishImageMap[key]!;

                        final imageData = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 150,
                                        // child: Image.asset('lib/fish/$value.png'),
                                        child: Image.network(
                                            imageData.url),
                                      ),
                                      Text(
                                        "날짜: ${imageData.createtime}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "길이: ${imageData.length}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "무게: ${imageData.weight}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "위치: ${imageData.location}",
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
                            child: Image.network(
                                imageData.url),
                          ),
                        );
                      },
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}