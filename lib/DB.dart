import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'stories.db');

    // حذف قاعدة البيانات أثناء التطوير
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute("DROP TABLE IF EXISTS stories");
        await _onCreate(db, newVersion);
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        image TEXT
      )
    ''');

    await db.insert('stories', {
      'title': 'قصة الأسد والفأر',
      'content': '''
في يومٍ من الأيام، كان هناك أسدٌ نائمٌ في الغابة، وفأرٌ صغيرٌ يمر فوقه دون قصد
استيقظ الأسد غاضبًا وأمسك بالفأر وهمَّ بأن يأكله.
توسل الفأر قائلاً: "أرجوك لا تأكلني، ربما أستطيع مساعدتك يومًا ما!"
ضحك الأسد من كلام الفأر، لكنه أطلق سراحه
وبعد أيام، وقع الأسد في شبكة صياد وظل يزأر ويستغيث حتى سمعه الفأر
أسرع الفأر وبدأ يقرض الشبكة بأسنانه حتى حرر الأسد
قال الأسد متأثرًا: "لم أكن أظن أن فأرًا صغيرًا مثلك يمكن أن ينقذني!"
وهكذا تعلم الأسد ألا يستهين بأي مخلوق مهما كان صغيرًا
''',
      'image': 'images/lien.webp',
    });

    await db.insert('stories', {
      'title': 'القطة الذكية',
      'content': '''
في قرية صغيرة كانت تعيش قطة تبحث يوميًا عن الطعام.
وذات يوم دخلت إلى منزل مهجور ووجدت فأرًا صغيرًا.
وبدلًا من أن تصطاده قررت أن تراقبه من بعيد.
لاحظت القطة أن الفأر يعرف طريقًا إلى المطبخ حيث الطعام الوفير.
فكرت بخطة ذكية وأقامت سلامًا مع الفأر ليساعدها.
وبالفعل أصبحت القطة تحصل على الطعام كل يوم دون عناء.
وهكذا استخدمت القطة ذكاءها لتعيش بسعادة وسلام.
''',
      'image': 'images/cat.png',
    });

    await db.insert('stories', {
      'title': 'الأرنب والسلحفاة',
      'content': '''
تحدت السلحفاة الأرنب في سباق رغم بطئها.
ضحك الأرنب ساخرًا وقال: "أنا أسرع منك بكثير، لن تفوزي أبدًا!"
بدأ السباق وركض الأرنب بسرعة كبيرة ثم توقف ليرتاح لأنه كان واثقًا من الفوز.
أما السلحفاة فواصلت السير ببطء وثبات دون أن تتوقف.
استغرق الأرنب في النوم وعندما استيقظ وجد السلحفاة قد وصلت إلى خط النهاية.
فازت السلحفاة وأدرك الأرنب أن الغرور والتكاسل يؤديان إلى الخسارة.
''',
      'image': 'images/rubet.jpg',
    });

    await db.insert('stories', {
      'title': 'العصفور والحبة',
      'content': '''
في صباح جميل وجد عصفور صغير حبة قمح كبيرة.
حاول أن يحملها لكنه لم يستطع لأن حجمها كان أكبر منه.
جلس يفكر ثم قرر أن يطلب المساعدة من أصدقائه.
جاءت العصافير الأخرى وساعدته في حمل الحبة إلى العش.
قسموها بينهم واستمتعوا بها جميعًا.
فرح العصفور لأنه تعلم أن التعاون يجلب السعادة ويجعل المستحيل ممكنًا.
''',
      'image': 'images/bird.jpg',
    });
  }

  Future<List<Map<String, dynamic>>> getAllStories() async {
    final db = await database;
    return await db.query('stories');
  }
}
