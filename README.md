# 🏛️ Nusa App - Indonesian Cultural Heritage Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

Nusa App adalah platform mobile untuk menjelajahi dan melestarikan warisan budaya Indonesia. Aplikasi ini menggabungkan teknologi modern dengan kekayaan budaya Nusantara, menyediakan pengalaman interaktif untuk menemukan destinasi wisata budaya, artikel edukatif, dan komunitas pecinta budaya.

## 🚀 Features

### 🏠 **Homepage**
- **Categories Section**: Jelajahi berbagai kategori budaya (Situs Budaya, Seni & Budaya, Alat Musik Tradisional, dll.)
- **Featured Destinations**: Destinasi wisata budaya pilihan
- **Search Functionality**: Pencarian destinasi dan konten budaya
- **Location-based Recommendations**: Rekomendasi berdasarkan lokasi user

### 🗺️ **Katalog Destination**
- **Category-based Browsing**: Filter destinasi berdasarkan kategori
- **Dynamic Loading**: Data fetching dari Firebase dengan loading state
- **Subcategory Filters**: Filter lanjutan untuk pencarian yang lebih spesifik
- **Real-time Search**: Pencarian real-time dengan debouncing

### 📱 **Forum & Feeds**
- **Community Forum**: Platform diskusi komunitas budaya
- **Article Sharing**: Berbagi artikel dan konten edukatif
- **Like System**: Sistem like dengan subcollection untuk performa optimal
- **Comment System**: Sistem komentar dengan counter yang akurat

### 🤖 **NusaBot**
- **AI Assistant**: Bot pintar untuk informasi budaya Indonesia
- **Gemini Integration**: Menggunakan Google Gemini API untuk response yang cerdas

### 🔍 **Image Analyzer**
- **Cultural Recognition**: Analisis gambar objek budaya menggunakan AI
- **Information Extraction**: Ekstrak informasi dari gambar budaya

### 👤 **User Profile**
- **Google Authentication**: Login mudah dengan akun Google
- **Personalized Experience**: Pengalaman yang dipersonalisasi
- **Like History**: Riwayat konten yang disukai

## 🔥 Firebase Services Integration

### **🔐 Authentication**
```dart
// Google Sign-In Authentication
GoogleAuthService.signInWithGoogle()
GoogleAuthService.currentUserId  // Get authenticated user ID
GoogleAuthService.isSignedIn     // Check authentication status
```

### **🗄️ Cloud Firestore Database Structure**
```
📂 Collections:
├── users/                    # User profiles
│   └── {userId}/
│       ├── likedDestinations/    # User's liked destinations
│       ├── likedArticles/        # User's liked articles
│       └── likedForumPosts/      # User's liked forum posts
├── categories/              # Cultural categories
├── destinations/           # Cultural destinations
├── articles/              # Cultural articles
├── feeds/                 # Forum posts
└── comments/              # Forum comments
```

### **📊 Firestore Service Methods**

#### **User Operations**
```dart
FirestoreService.getUserById(String userId)
FirestoreService.getUserByEmail(String email)
```

#### **Content Retrieval**
```dart
FirestoreService.getCategories()
FirestoreService.getDestinationsByCategory(categoryId, limit: 50)
FirestoreService.getArticles(limit: 10)
FirestoreService.getForumPosts(limit: 15)
```

#### **Like System**
```dart
FirestoreService.toggleDestinationLike(userId, destinationId)
FirestoreService.toggleArticleLike(userId, articleId)
FirestoreService.toggleForumLike(userId, forumId)
FirestoreService.hasUserLikedDestination(userId, destinationId)
```

#### **Comment System**
```dart
FirestoreService.addComment(comment)
FirestoreService.getCommentsByForumId(forumId)
FirestoreService.getCommentsCount(forumId)
```

#### **Performance Optimizations**
```dart
// Pagination for large datasets
FirestoreService.getDestinationsByCategoryPaginated(
  categoryId, 
  limit: 10, 
  lastDocument: lastDoc
)

// Atomic operations for counters
FieldValue.increment(1)  // Like counter
FieldValue.increment(-1) // Unlike counter
```

## 🛠️ Tech Stack

### **📱 Frontend**
- **Flutter 3.x**: Cross-platform mobile development
- **Dart**: Programming language
- **Auto Route**: Navigation and routing
- **Sizer**: Responsive design
- **Loading Animation Widget**: Beautiful loading animations
- **IconSax Plus**: Modern icon pack

### **☁️ Backend Services**
- **Firebase Authentication**: User authentication with Google Sign-In
- **Cloud Firestore**: NoSQL database for real-time data
- **Firebase Storage**: File storage (if needed)

### **🤖 AI & ML**
- **Google Gemini API**: AI chatbot for cultural information
- **Image Analysis**: Cultural object recognition

### **📊 State Management**
- **Stateful Widgets**: Local state management
- **Firebase Streams**: Real-time data updates

## 🏗️ Project Structure

```
lib/
├── app/                    # App configuration
├── core/                   # Core utilities (colors, styles, constants)
├── database/              # Database helpers and constants
├── features/              # Feature-based modules
│   ├── account/           # User profile and settings
│   ├── dashboard/         # Main navigation
│   ├── feeds/            # Forum and articles
│   ├── homepage/         # Home screen
│   ├── katalog_destination/ # Destination catalog
│   └── nusabot/          # AI chatbot
├── models/               # Data models
├── routes/              # App routing configuration
├── services/            # Firebase and external services
├── widgets/             # Reusable UI components
└── main.dart           # App entry point
```

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account
- Google Cloud account (for Gemini API)

### **Installation**

1. **Clone the repository**
```powershell
git clone <repository-url>
cd Nusa_app
```

2. **Install dependencies**
```powershell
flutter pub get
```

3. **Firebase Setup**
```powershell
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure Flutter for Firebase
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Environment Configuration**
Create `env.txt` file in root directory:
```
GEMINI_API_KEY=your_gemini_api_key_here
```

5. **Run the app**
```powershell
flutter run
```

## 🔧 Firebase Configuration

### **1. Authentication Setup**
```dart
// Configure Google Sign-In
GoogleSignIn(scopes: ['email', 'profile'])

// Firebase Auth initialization
FirebaseAuth.instance
```

### **2. Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User subcollections (likes)
      match /{subcollection=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Public read access for content
    match /categories/{document} {
      allow read: if true;
    }
    
    match /destinations/{document} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /feeds/{document} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    match /comments/{document} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

### **3. Database Initialization**
```dart
// Seed database with initial data
await FirestoreService.initializeDatabase();

// Seed specific collection
await FirestoreService.initializeCollection('categories');
```

## 📱 Key Features Implementation

### **🔄 Real-time Data Loading**
```dart
// Example: Loading destinations with loading state
class _KatalogProdukPageState extends State<KatalogProdukPage> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    
    final destinations = await FirestoreService.getDestinationsByCategory(
      categoryId, 
      limit: 50
    );
    
    setState(() {
      _destinationsList = destinations;
      _isLoading = false;
    });
  }
}
```

### **❤️ Optimized Like System**
```dart
// Efficient like system using subcollections
await FirestoreService.toggleDestinationLike(userId, destinationId);

// Atomic counter updates
await _firestore.collection('destinations').doc(destinationId).update({
  'like': FieldValue.increment(1),
});
```

### **💬 Forum with Comments**
```dart
// Create forum post
final forumPost = ForumModel(
  content: content,
  date: DateTime.now(),
  userId: currentUserId,
);
await FirebaseFirestore.instance.collection('feeds').add(forumPost.toFirestore());

// Add comment with counter update
await FirestoreService.addComment(comment);
```

## 🔐 Security & Performance

### **Security Measures**
- Authentication required for write operations
- User-specific data isolation
- Input validation and sanitization
- Firestore security rules implementation

### **Performance Optimizations**
- Pagination for large datasets
- Efficient subcollection structure for likes
- Atomic operations for counters
- Loading states for better UX
- Image optimization and caching

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Development Team**: GSC Semester 4 Students
- **Institution**: [Your Institution Name]
- **Academic Year**: 2024/2025

## 📞 Support

For support and questions:
- 📧 Email: [your-email@domain.com]
- 📱 WhatsApp: [your-whatsapp-number]
- 🐛 Issues: [GitHub Issues](repository-url/issues)

---

<div align="center">

**🏛️ Preserving Indonesian Cultural Heritage Through Technology 🇮🇩**

Made with ❤️ for Indonesia

</div>
