class QuranAudioOption {
  final String id;
  final String name;
  final String englishName;
  final String type;
  final String language;
  final int quality;

  const QuranAudioOption({
    required this.id,
    required this.name,
    required this.englishName,
    required this.type,
    required this.language,
    required this.quality,
  });
}

const List<QuranAudioOption> quranAudios = [
  QuranAudioOption(
    id: "ar.abdulbasitmurattal",
    name: "عبد الباسط عبد الصمد المرتل",
    englishName: "Abdul Basit",
    type: "translation",
    language: "ar",
    quality: 192,
  ),
  QuranAudioOption(
    id: "ar.abdullahbasfar",
    name: "عبد الله بصفر",
    englishName: "Abdullah Basfar",
    type: "versebyverse",
    language: "ar",
    quality: 192,
  ),
  QuranAudioOption(
    id: "ar.abdurrahmaansudais",
    name: "عبدالرحمن السديس",
    englishName: "Abdurrahmaan As-Sudais",
    type: "versebyverse",
    language: "ar",
    quality: 192,
  ),
  QuranAudioOption(
    id: "ar.abdulsamad",
    name: "عبدالباسط عبدالصمد",
    englishName: "Abdul Samad",
    type: "versebyverse",
    language: "ar",
    quality: 64,
  ),
  QuranAudioOption(
    id: "ar.shaatree",
    name: "أبو بكر الشاطري",
    englishName: "Abu Bakr Ash-Shaatree",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.ahmedajamy",
    name: "أحمد بن علي العجمي",
    englishName: "Ahmed ibn Ali al-Ajamy",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.alafasy",
    name: "مشاري العفاسي",
    englishName: "Alafasy",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.hanirifai",
    name: "هاني الرفاعي",
    englishName: "Hani Rifai",
    type: "versebyverse",
    language: "ar",
    quality: 192,
  ),
  QuranAudioOption(
    id: "ar.husary",
    name: "محمود خليل الحصري",
    englishName: "Husary",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.husarymujawwad",
    name: "محمود خليل الحصري (المجود)",
    englishName: "Husary (Mujawwad)",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.hudhaify",
    name: "علي بن عبدالرحمن الحذيفي",
    englishName: "Hudhaify",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.ibrahimakhbar",
    name: "إبراهيم الأخضر",
    englishName: "Ibrahim Akhdar",
    type: "versebyverse",
    language: "ar",
    quality: 32,
  ),
  QuranAudioOption(
    id: "ar.mahermuaiqly",
    name: "ماهر المعيقلي",
    englishName: "Maher Al Muaiqly",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.minshawi",
    name: "محمد صديق المنشاوي",
    englishName: "Minshawi",
    type: "translation",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.minshawimujawwad",
    name: "محمد صديق المنشاوي (المجود)",
    englishName: "Minshawy (Mujawwad)",
    type: "translation",
    language: "ar",
    quality: 64,
  ),
  QuranAudioOption(
    id: "ar.muhammadayyoub",
    name: "محمد أيوب",
    englishName: "Muhammad Ayyoub",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.muhammadjibreel",
    name: "محمد جبريل",
    englishName: "Muhammad Jibreel",
    type: "versebyverse",
    language: "ar",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.saoodshuraym",
    name: "سعود الشريم",
    englishName: "Saood bin Ibraaheem Ash-Shuraym",
    type: "versebyverse",
    language: "ar",
    quality: 64,
  ),
  QuranAudioOption(
    id: "en.walk",
    name: "Ibrahim Walk",
    englishName: "Ibrahim Walk",
    type: "versebyverse",
    language: "en",
    quality: 192,
  ),
  QuranAudioOption(
    id: "fa.hedayatfarfooladvand",
    name: "Fooladvand - Hedayatfar",
    englishName: "Fooladvand - Hedayatfar",
    type: "translation",
    language: "fa",
    quality: 40,
  ),
  QuranAudioOption(
    id: "ar.parhizgar",
    name: "شهریار پرهیزگار",
    englishName: "Parhizgar",
    type: "versebyverse",
    language: "ar",
    quality: 48,
  ),
  QuranAudioOption(
    id: "ur.khan",
    name: "Shamshad Ali Khan",
    englishName: "Shamshad Ali Khan",
    type: "versebyverse",
    language: "ur",
    quality: 64,
  ),
  QuranAudioOption(
    id: "zh.chinese",
    name: "中文",
    englishName: "Chinese",
    type: "versebyverse",
    language: "zh",
    quality: 128,
  ),
  QuranAudioOption(
    id: "fr.leclerc",
    name: "Youssouf Leclerc",
    englishName: "Youssouf Leclerc",
    type: "versebyverse",
    language: "fr",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ar.aymanswoaid",
    name: "أيمن سويد",
    englishName: "Ayman Sowaid",
    type: "versebyverse",
    language: "ar",
    quality: 64,
  ),
  QuranAudioOption(
    id: "ru.kuliev-audio",
    name: "Elmir Kuliev by 1MuslimApp",
    englishName: "Elmir Kuliev by 1MuslimApp",
    type: "versebyverse",
    language: "ru",
    quality: 128,
  ),
  QuranAudioOption(
    id: "ru.kuliev-audio-2",
    name: "Elmir Kuliev 2 by 1MuslimApp",
    englishName: "Elmir Kuliev 2 by 1MuslimApp",
    type: "versebyverse",
    language: "ru",
    quality: 320,
  ),
];

QuranAudioOption? findQuranAudioById(String id) {
  for (final a in quranAudios) {
    if (a.id == id) return a;
  }
  return null;
}

