import '../models/models.dart';
import '../services/firestore_service.dart';

class ForumSeeder {
  static Future<void> seedForums(String userId) async {
    final forums = [
      ForumModel(
        content: '''Hey everyone! I'm planning to visit Borobudur for the first time next month. Any tips on the best time to go? I've heard sunrise is amazing but is it worth the early wake-up call? 🌅

Also, what should I know about the dress code and cultural etiquette when visiting?''',
        date: DateTime(2024, 3, 1, 9, 30),
        userId: userId,
        like: 23,
      ),

      ForumModel(
        content: '''Just came back from an incredible wayang kulit performance in Yogyakarta! The dalang was absolutely mesmerizing - I had no idea one person could control so many puppets while telling such a complex story.

For anyone interested in experiencing this art form, I highly recommend catching a performance at Kraton Yogyakarta. The traditional setting really adds to the atmosphere. 🎭''',
        date: DateTime(2024, 3, 2, 14, 15),
        userId: userId,
        like: 18,
      ),

      ForumModel(
        content: '''Can anyone recommend a good place to learn batik-making in Jakarta? I'm fascinated by this art form and would love to try creating my own piece. Looking for beginner-friendly workshops that teach traditional techniques.

Bonus points if they explain the cultural significance behind different patterns! 🎨''',
        date: DateTime(2024, 3, 3, 11, 45),
        userId: userId,
        like: 31,
      ),

      ForumModel(
        content: '''PSA: If you're visiting Prambanan Temple, definitely hire a local guide! I went there yesterday thinking I could just walk around and appreciate the architecture, but having someone explain the Hindu mythology behind all the carvings made the experience so much richer.

The stories of Ramayana come alive when you understand what you're looking at! 🏛️''',
        date: DateTime(2024, 3, 4, 16, 20),
        userId: userId,
        like: 27,
      ),

      ForumModel(
        content: '''Gamelan music has completely captured my heart! Started taking lessons last month and it's unlike any musical experience I've had before. The way all the instruments layer together to create this ethereal sound is just magical.

Any fellow gamelan enthusiasts here? Would love to connect and maybe form a study group! 🎵''',
        date: DateTime(2024, 3, 5, 19, 10),
        userId: userId,
        like: 15,
      ),

      ForumModel(
        content: '''Made rendang for the first time today following my Indonesian friend's grandmother's recipe. It took 4 hours of constant stirring but WOW, the result was incredible! 🍛

The depth of flavor from all those spices slow-cooking together is something else. Already planning my next batch - this time maybe with some minor tweaks to the spice levels.''',
        date: DateTime(2024, 3, 6, 20, 30),
        userId: userId,
        like: 42,
      ),

      ForumModel(
        content: '''Quick question for the cultural fashion experts: I have a friend's wedding coming up and I want to wear a kebaya to honor Indonesian traditions. Any advice on choosing the right style and color?

I want to be respectful and appropriate - should I stick to certain colors or avoid others? 👗''',
        date: DateTime(2024, 3, 7, 13, 25),
        userId: userId,
        like: 19,
      ),

      ForumModel(
        content: '''Just discovered the amazing world of Indonesian keris daggers! The craftsmanship is absolutely incredible - each blade is like a work of art with its own unique pattern and spiritual significance.

Visited a museum exhibition about traditional weapons and was blown away by the skill required to create these pieces. Anyone know where I can learn more about the different pamor patterns? ⚔️''',
        date: DateTime(2024, 3, 8, 10, 15),
        userId: userId,
        like: 22,
      ),

      ForumModel(
        content: '''Angklung workshop was such a fun experience! Who knew that playing bamboo instruments could be so relaxing and meditative? The way everyone has to work together to create a melody really embodies the spirit of gotong royong.

Perfect activity for team building or just connecting with Indonesian culture. Highly recommend! 🎋''',
        date: DateTime(2024, 3, 9, 15, 45),
        userId: userId,
        like: 16,
      ),

      ForumModel(
        content: '''Gado-gado has officially become my comfort food! There's something so satisfying about that perfect balance of fresh vegetables, protein, and that amazing peanut sauce. Every warung seems to have their own special twist on the recipe.

What's your favorite gado-gado spot? I'm always hunting for new places to try! 🥗''',
        date: DateTime(2024, 3, 10, 12, 00),
        userId: userId,
        like: 28,
      ),

      ForumModel(
        content: '''For those interested in traditional textiles: just learned that different regions of Indonesia have their own distinct batik and songket patterns, each with deep cultural meanings.

It's fascinating how clothing can tell stories about identity, status, and regional heritage. Planning a textile tour of Java and Sumatra soon! 🧵''',
        date: DateTime(2024, 3, 11, 17, 30),
        userId: userId,
        like: 34,
      ),

      ForumModel(
        content: '''Reminder that many Indonesian cultural sites offer special programs during certain times of the year. Borobudur has their Vesak Day celebrations, traditional villages often have harvest festivals, and various regions celebrate unique local traditions.

Always worth checking cultural calendars when planning your visits! 📅''',
        date: DateTime(2024, 3, 12, 8, 45),
        userId: userId,
        like: 21,
      ),

      ForumModel(
        content: '''Indonesian cuisine is so much more than just the famous dishes we all know! Today I tried gudeg for the first time - young jackfruit curry from Yogyakarta. The sweet and savory combination was absolutely delicious.

What are some lesser-known Indonesian dishes that you think more people should try? 🍽️''',
        date: DateTime(2024, 3, 13, 19, 20),
        userId: userId,
        like: 37,
      ),

      ForumModel(
        content: '''Learning traditional Indonesian dances as an adult has been such a rewarding experience! The grace and storytelling in Javanese and Balinese dance forms is incredible.

It's not just about the movements - each gesture has meaning and connects to spiritual and cultural traditions. Never too late to start! 💃''',
        date: DateTime(2024, 3, 14, 14, 10),
        userId: userId,
        like: 26,
      ),

      ForumModel(
        content: '''Coffee lovers, have you explored the world of Indonesian coffee? From the famous kopi luwak to the amazing arabica from Toraja and the robust robusta from Lampung - this country has such diverse coffee culture.

Each region has its own brewing methods and traditions too. What's your favorite Indonesian coffee origin? ☕''',
        date: DateTime(2024, 3, 15, 11, 00),
        userId: userId,
        like: 33,
      ),    ];

    for (final forum in forums) {
      final existingForum = await FirestoreService.forumsCollection
          .where('content', isEqualTo: forum.content)
          .get();

      if (existingForum.docs.isEmpty) {
        await FirestoreService.forumsCollection.add(forum.toFirestore());
      }
    }
  }
}