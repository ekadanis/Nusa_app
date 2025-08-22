import '../models/models.dart';
import '../services/firestore_service.dart';

class ArticleSeeder {
  static Future<void> seedArticles(Map<String, String> categoryIds) async {
    final articles = [
      // Cultural Sites Articles
      ArticleModel(
        title: 'Exploring Borobudur: A Journey Through Time',
        date: DateTime(2024, 1, 15),
        categoryId: categoryIds['Cultural Sites']!,
        content: '''Borobudur Temple, located in Central Java, Indonesia, stands as one of the world's greatest Buddhist monuments. Built in the 8th and 9th centuries during the reign of the Sailendra Dynasty, this magnificent structure represents the pinnacle of ancient Javanese architecture.

The temple complex consists of nine stacked platforms, six square and three circular, topped by a central dome. The monument is decorated with 2,672 relief panels and 504 Buddha statues. The central dome is surrounded by 72 Buddha statues, each seated inside a perforated stupa.

Visitors to Borobudur can experience the spiritual journey intended by its builders. The path follows the Buddhist cosmology, starting from the base representing the world of desire, moving through the world of forms, and finally reaching the world of formlessness at the top.

The best time to visit is during sunrise, when the temple is bathed in golden light and the surrounding landscape of volcanic peaks and lush valleys creates a breathtaking panorama.''',
        imageUrl: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 245,
      ),
      
      ArticleModel(
        title: 'The Majesty of Prambanan Temple Complex',
        date: DateTime(2024, 1, 20),
        categoryId: categoryIds['Cultural Sites']!,
        content: '''The Prambanan Temple Complex is a magnificent collection of Hindu temples in Central Java, Indonesia. Built in the 9th century, it is dedicated to the Hindu trinity: Brahma, Vishnu, and Shiva.

The main temple, dedicated to Shiva, stands 47 meters tall and is surrounded by eight smaller temples. The intricate stone carvings tell the story of the Ramayana epic, with each relief panel displaying remarkable artistic detail.

What makes Prambanan truly special is its architectural harmony. The vertical emphasis of the towers creates a sense of reaching toward the divine, while the horizontal layout represents the earthly realm.

The temple complex was abandoned in the 10th century and lay hidden for centuries before being rediscovered. Today, it stands as a UNESCO World Heritage Site and a testament to Indonesia's rich cultural heritage.''',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 189,
      ),

      // Arts & Culture Articles
      ArticleModel(
        title: 'Wayang Kulit: The Ancient Art of Shadow Puppetry',
        date: DateTime(2024, 1, 25),
        categoryId: categoryIds['Arts & Culture']!,
        content: '''Wayang Kulit, literally meaning "leather puppet," is one of Indonesia's most celebrated traditional art forms. This ancient form of storytelling combines intricate puppetry, gamelan music, and oral tradition to create a mesmerizing theatrical experience.

The dalang (puppet master) is the heart of the performance, manipulating dozens of intricately crafted leather puppets while providing all the voices and narrating the story. These performances often last throughout the night, telling epic tales from the Ramayana and Mahabharata.

Each puppet is a work of art, meticulously carved from buffalo hide and painted with traditional pigments. The designs follow centuries-old conventions, with specific colors and forms representing different character types and personalities.

UNESCO recognized Wayang Kulit as a Masterpiece of Oral and Intangible Heritage of Humanity, acknowledging its profound cultural significance and artistic value.''',
        imageUrl: 'https://images.unsplash.com/photo-1582047193019-7d0eb9e2bcd8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 156,
      ),

      ArticleModel(
        title: 'Batik: Indonesia\'s Living Art Form',
        date: DateTime(2024, 2, 1),
        categoryId: categoryIds['Arts & Culture']!,
        content: '''Batik is more than just a textile technique; it is a living art form that embodies the soul of Indonesian culture. This ancient method of fabric decoration uses wax-resist dyeing to create intricate patterns and designs.

The word "batik" comes from the Javanese "amba" (to write) and "tik" (dot), reflecting the meticulous process of creating these beautiful textiles. Traditional batik is made using a tool called "canting," which allows artisans to apply hot wax with precision.

Different regions of Indonesia have developed their own distinctive batik styles. Yogyakarta and Solo are known for their classic geometric patterns, while coastal areas like Pekalongan feature more naturalistic designs influenced by Chinese and European aesthetics.

In 2009, UNESCO recognized Indonesian batik as an Intangible Cultural Heritage of Humanity, cementing its status as a world-class art form.''',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 203,
      ),

      // Folk Instruments Articles
      ArticleModel(
        title: 'Gamelan: The Orchestra of the Gods',
        date: DateTime(2024, 2, 5),
        categoryId: categoryIds['Folk Instruments']!,
        content: '''Gamelan, often called the "orchestra of the gods," is a traditional Indonesian musical ensemble that creates some of the most ethereal and complex sounds in world music. Predominantly made up of percussive instruments, gamelan orchestras vary by region but typically include metallophones, xylophones, drums, and gongs.

The music of gamelan is based on intricate interlocking rhythmic patterns that create a shimmering, layered sound. Unlike Western music, gamelan doesn't rely on harmony but rather on the interplay between different melodic layers and rhythmic cycles.

In Javanese and Balinese cultures, gamelan is considered sacred. The instruments are believed to possess spiritual power, and musicians often perform barefoot and treat the instruments with great reverence.

Learning gamelan is a communal experience that emphasizes listening, cooperation, and respect. It's not just about individual virtuosity but about how each player contributes to the collective sound.''',
        imageUrl: 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 178,
      ),

      ArticleModel(
        title: 'Angklung: The Bamboo Music of Sunda',
        date: DateTime(2024, 2, 10),
        categoryId: categoryIds['Folk Instruments']!,
        content: '''The angklung is a traditional Indonesian musical instrument made from bamboo tubes suspended in a bamboo frame. When shaken, it produces a distinctive resonant sound that has captivated audiences for centuries.

Originating from the Sundanese culture of West Java, the angklung has deep cultural significance. Traditionally, it was used in rice harvesting ceremonies and other agricultural rituals, believed to bring good fortune and harmony with nature.

In the 20th century, Daeng Soetigna revolutionized the angklung by arranging it according to Western musical scales, making it possible to play international songs. This innovation led to the formation of angklung orchestras that can perform complex musical arrangements.

Today, angklung education is promoted worldwide as a tool for character building and cultural understanding. The instrument teaches cooperation, as each player typically holds one or two angklung that produce different pitches, requiring coordination to create melodies.''',
        imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 134,
      ),

      // Traditional Wear Articles
      ArticleModel(
        title: 'Kebaya: Elegance in Traditional Indonesian Fashion',
        date: DateTime(2024, 2, 15),
        categoryId: categoryIds['Traditional Wear']!,
        content: '''The kebaya is perhaps the most recognizable traditional garment in Indonesia, representing grace, elegance, and cultural identity. This traditional blouse, typically worn with a sarong or batik cloth, has evolved over centuries while maintaining its distinctive charm.

Originally influenced by Arab, Chinese, and European styles, the kebaya has been adapted by various Indonesian ethnic groups, each adding their own unique touches. The Javanese kebaya is known for its fitted silhouette and intricate embroidery, while the Balinese version often features elaborate lace and beadwork.

Modern kebaya designers have successfully bridged tradition and contemporary fashion, creating pieces that are both culturally authentic and fashion-forward. Many Indonesian women wear kebaya for formal occasions, weddings, and cultural celebrations.

The garment has also gained international recognition, with Indonesian flight attendants of Garuda Indonesia wearing beautifully designed kebaya as their uniform, showcasing Indonesian culture to the world.''',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 167,
      ),

      ArticleModel(
        title: 'Batik Sarong: The Versatile Traditional Cloth',
        date: DateTime(2024, 2, 20),
        categoryId: categoryIds['Traditional Wear']!,
        content: '''The sarong, a large tube of fabric worn around the waist, is one of the most versatile traditional garments in Indonesian culture. When combined with batik patterns, it becomes both a practical piece of clothing and a work of art.

Different regions of Indonesia have their own styles of sarong. In Java, the batik sarong features intricate geometric patterns and symbolic motifs. In Sumatra, the songket sarong incorporates gold and silver threads, creating a luxurious textile fit for royalty.

The way a sarong is worn can indicate social status, regional origin, and even marital status. Traditional Javanese culture has specific rules for how different patterns should be worn for various occasions and ceremonies.

Today, fashion designers are reimagining the sarong for modern wear, creating contemporary pieces that honor traditional craftsmanship while appealing to younger generations.''',
        imageUrl: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 142,
      ),

      // Crafts & Artifacts Articles
      ArticleModel(
        title: 'Keris: The Sacred Blade of Indonesia',
        date: DateTime(2024, 2, 25),
        categoryId: categoryIds['Crafts & Artifacts']!,
        content: '''The keris is more than just a weapon; it is a sacred object that embodies the spiritual and cultural essence of Indonesian civilization. This asymmetrical dagger, with its distinctive wavy blade, holds deep significance in Javanese, Balinese, and Malay cultures.

Each keris is believed to possess its own spirit and magical powers. The crafting of a keris is a sacred process, often involving rituals and spiritual ceremonies. The empu (master craftsman) must possess not only technical skill but also spiritual knowledge.

The blade's pattern, created through a complex process of folding and welding different types of metal, is called pamor. Each pamor pattern has its own meaning and is believed to bring specific benefits to the owner, such as protection, prosperity, or wisdom.

UNESCO recognized the Indonesian keris as a Masterpiece of Oral and Intangible Heritage of Humanity, acknowledging its cultural significance and the traditional skills required for its creation.''',
        imageUrl: 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 198,
      ),

      // Local Foods Articles
      ArticleModel(
        title: 'Rendang: The King of Indonesian Cuisine',
        date: DateTime(2024, 3, 1),
        categoryId: categoryIds['Local Foods']!,
        content: '''Rendang, originating from the Minangkabau ethnic group of West Sumatra, is often considered the king of Indonesian cuisine. This rich, complex dish of beef slowly cooked in coconut milk and spices has captured the hearts and palates of food lovers worldwide.

The cooking process of rendang is an art form in itself. The meat is simmered for hours in a mixture of coconut milk and a paste made from various spices including chili, galangal, garlic, turmeric, ginger, and lemongrass. As the liquid reduces, the meat absorbs the flavors and develops its characteristic dark, caramelized exterior.

Traditional rendang can be stored for weeks without refrigeration, making it ideal for long journeys. This preservation quality made it perfect for Minangkabau traders who traveled across the archipelago.

In 2011, rendang was ranked as the world's most delicious food by CNN International, bringing global recognition to this exceptional Indonesian dish.''',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 289,
      ),

      ArticleModel(
        title: 'Gado-Gado: Indonesia\'s Beloved Salad',
        date: DateTime(2024, 3, 5),
        categoryId: categoryIds['Local Foods']!,
        content: '''Gado-gado, literally meaning "mixed-mixed," is Indonesia's most famous salad and a perfect representation of the country's culinary diversity. This colorful dish combines various vegetables, tofu, tempeh, and hard-boiled eggs, all brought together by a rich peanut sauce.

The beauty of gado-gado lies in its versatility. Each region and even each vendor has their own version, using locally available vegetables and their own secret peanut sauce recipe. Common ingredients include blanched spinach, bean sprouts, cabbage, green beans, and cucumber.

The peanut sauce is the star of the dish, typically made from ground peanuts, palm sugar, tamarind water, salt, and chili. Some versions include coconut milk for added richness. The sauce should balance sweet, salty, sour, and spicy flavors.

Gado-gado represents the Indonesian philosophy of unity in diversity. Just as the nation brings together different ethnic groups, this dish harmoniously combines various ingredients into one delicious, nutritious meal.''',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        like: 156,
      ),    ];

    for (final article in articles) {final existingArticle = await FirestoreService.articlesCollection
          .where('title', isEqualTo: article.title)
          .get();

      if (existingArticle.docs.isEmpty) {
        await FirestoreService.articlesCollection.add(article.toFirestore());
      }
    }
  }
}