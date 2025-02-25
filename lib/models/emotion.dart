class Emotion {
  final int id;
  final String name;
  final String category; // 긍정적 또는 부정적
  final String imagePath;

  Emotion({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
    };
  }

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imagePath: map['imagePath'],
    );
  }
}

final List<Emotion> predefinedEmotions = [
  // 긍정적 감정
  Emotion(id: 1, name: '행복한', category: '긍정', imagePath: 'assets/images/emotions/happy.png'),
  Emotion(id: 2, name: '기쁜', category: '긍정', imagePath: 'assets/images/emotions/joy.png'),
  Emotion(id: 3, name: '만족한', category: '긍정', imagePath: 'assets/images/emotions/satisfied.png'),
  Emotion(id: 4, name: '감사한', category: '긍정', imagePath: 'assets/images/emotions/grateful.png'),
  Emotion(id: 5, name: '평화로운', category: '긍정', imagePath: 'assets/images/emotions/peaceful.png'),
  Emotion(id: 6, name: '차분한', category: '긍정', imagePath: 'assets/images/emotions/calm.png'),
  Emotion(id: 7, name: '편안한', category: '긍정', imagePath: 'assets/images/emotions/comfortable.png'),
  Emotion(id: 8, name: '활기찬', category: '긍정', imagePath: 'assets/images/emotions/energetic.png'),
  Emotion(id: 9, name: '열정적인', category: '긍정', imagePath: 'assets/images/emotions/passionate.png'),
  Emotion(id: 10, name: '자신감 있는', category: '긍정', imagePath: 'assets/images/emotions/confident.png'),
  Emotion(id: 11, name: '용기 있는', category: '긍정', imagePath: 'assets/images/emotions/brave.png'),
  Emotion(id: 12, name: '강한', category: '긍정', imagePath: 'assets/images/emotions/strong.png'),
  Emotion(id: 13, name: '희망찬', category: '긍정', imagePath: 'assets/images/emotions/hopeful.png'),
  Emotion(id: 14, name: '낙관적인', category: '긍정', imagePath: 'assets/images/emotions/optimistic.png'),
  Emotion(id: 15, name: '신뢰하는', category: '긍정', imagePath: 'assets/images/emotions/trusting.png'),
  Emotion(id: 16, name: '축복받은', category: '긍정', imagePath: 'assets/images/emotions/blessed.png'),
  Emotion(id: 17, name: '고마운', category: '긍정', imagePath: 'assets/images/emotions/thankful.png'),
  Emotion(id: 18, name: '감동받은', category: '긍정', imagePath: 'assets/images/emotions/touched.png'),
  Emotion(id: 19, name: '놀라운', category: '긍정', imagePath: 'assets/images/emotions/amazed.png'),
  Emotion(id: 20, name: '경이로운', category: '긍정', imagePath: 'assets/images/emotions/wonderful.png'),
  Emotion(id: 21, name: '황홀한', category: '긍정', imagePath: 'assets/images/emotions/ecstatic.png'),
  Emotion(id: 22, name: '자유로운', category: '긍정', imagePath: 'assets/images/emotions/free.png'),
  Emotion(id: 23, name: '영감받은', category: '긍정', imagePath: 'assets/images/emotions/inspired.png'),
  Emotion(id: 24, name: '생기 넘치는', category: '긍정', imagePath: 'assets/images/emotions/vibrant.png'),
  Emotion(id: 25, name: '만족스러운', category: '긍정', imagePath: 'assets/images/emotions/content.png'),
  Emotion(id: 26, name: '새로워진', category: '긍정', imagePath: 'assets/images/emotions/renewed.png'),
  
  // 부정적 감정
  Emotion(id: 27, name: '슬픈', category: '부정', imagePath: 'assets/images/emotions/sad.png'),
  Emotion(id: 28, name: '화난', category: '부정', imagePath: 'assets/images/emotions/angry.png'),
  Emotion(id: 29, name: '두려운', category: '부정', imagePath: 'assets/images/emotions/fear.png'),
  Emotion(id: 30, name: '불안한', category: '부정', imagePath: 'assets/images/emotions/anxious.png'),
  Emotion(id: 31, name: '걱정되는', category: '부정', imagePath: 'assets/images/emotions/worried.png'),
  Emotion(id: 32, name: '좌절된', category: '부정', imagePath: 'assets/images/emotions/frustrated.png'),
  Emotion(id: 33, name: '짜증난', category: '부정', imagePath: 'assets/images/emotions/annoyed.png'),
  Emotion(id: 34, name: '실망한', category: '부정', imagePath: 'assets/images/emotions/disappointed.png'),
  Emotion(id: 35, name: '외로운', category: '부정', imagePath: 'assets/images/emotions/lonely.png'),
  Emotion(id: 36, name: '부끄러운', category: '부정', imagePath: 'assets/images/emotions/ashamed.png'),
  Emotion(id: 37, name: '죄책감 든', category: '부정', imagePath: 'assets/images/emotions/guilty.png'),
  Emotion(id: 38, name: '후회하는', category: '부정', imagePath: 'assets/images/emotions/regretful.png'),
  Emotion(id: 39, name: '무력한', category: '부정', imagePath: 'assets/images/emotions/helpless.png'),
  Emotion(id: 40, name: '지친', category: '부정', imagePath: 'assets/images/emotions/tired.png'),
  Emotion(id: 41, name: '스트레스 받은', category: '부정', imagePath: 'assets/images/emotions/stressed.png'),
  Emotion(id: 42, name: '긴장된', category: '부정', imagePath: 'assets/images/emotions/tense.png'),
  Emotion(id: 43, name: '혼란스러운', category: '부정', imagePath: 'assets/images/emotions/confused.png'),
  Emotion(id: 44, name: '당혹스러운', category: '부정', imagePath: 'assets/images/emotions/embarrassed.png'),
  Emotion(id: 45, name: '무감각한', category: '부정', imagePath: 'assets/images/emotions/numb.png'),
  Emotion(id: 46, name: '공허한', category: '부정', imagePath: 'assets/images/emotions/empty.png'),
  Emotion(id: 47, name: '절망적인', category: '부정', imagePath: 'assets/images/emotions/hopeless.png'),
  Emotion(id: 48, name: '비통한', category: '부정', imagePath: 'assets/images/emotions/grief.png'),
  Emotion(id: 49, name: '질투하는', category: '부정', imagePath: 'assets/images/emotions/jealous.png'),
  Emotion(id: 50, name: '억울한', category: '부정', imagePath: 'assets/images/emotions/resentful.png'),
  Emotion(id: 51, name: '불편한', category: '부정', imagePath: 'assets/images/emotions/uncomfortable.png'),
  Emotion(id: 52, name: '우울한', category: '부정', imagePath: 'assets/images/emotions/depressed.png'),
];
