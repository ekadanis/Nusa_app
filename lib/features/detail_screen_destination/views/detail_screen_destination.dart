import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/features/detail_screen_destination/widgets/ask_nusabot_floating.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import '../../../models/destination_model.dart';
import '../widgets/destination_header.dart';
import '../widgets/destination_overview.dart';
import '../widgets/destination_content.dart';
import '../../../widgets/loading_screen.dart';
import '../../../services/gemini_service.dart';

@RoutePage()
class DetailScreenDestination extends StatefulWidget {
  final DestinationModel destination;

  const DetailScreenDestination({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  State<DetailScreenDestination> createState() =>
      _DetailScreenDestinationState();
}

class _DetailScreenDestinationState extends State<DetailScreenDestination> {
  Map<String, String>? _generatedContent;
  bool _isGeneratingContent = false;
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _generateContent();
  }

  Future<void> _generateContent() async {
    setState(() {
      _isGeneratingContent = true;
    });

    // Mapping manual dari categoryId ke nama kategori
    String mapCategoryIdToName(String? id) {
      switch (id) {
        case 'cultural-sites':
          return 'Cultural Sites';
        case 'arts-culture':
          return 'Arts & Culture';
        case 'folk-instruments':
          return 'Folk Instruments';
        case 'traditional-wear':
          return 'Traditional Wear';
        case 'crafts-artifacts':
          return 'Crafts & Artifacts';
        case 'local-foods':
          return 'Local Foods';
        default:
          return 'Indonesian Culture';
      }
    }

    try {
      final content = await _geminiService.generateDestinationContent(
        widget.destination.title,
        mapCategoryIdToName(widget.destination.categoryId),
        widget.destination.subcategory,
        widget.destination.address,
      );

      setState(() {
        _generatedContent = content;
        _isGeneratingContent = false;
      });
    } catch (e) {
      print('Error generating content: $e');
      setState(() {
        _generatedContent = {
          'overview':
              '${widget.destination.title} stands as a remarkable ${widget.destination.subcategory} showcasing Indonesia\'s rich cultural heritage in ${widget.destination.address}. This extraordinary destination provides visitors with an immersive experience into traditional Indonesian artistry and historical significance.',
          'history':
              'The historical journey of ${widget.destination.title} spans multiple centuries, witnessing the evolution of Indonesian civilization. This magnificent structure has endured through various historical periods, serving as a testament to the craftsmanship and cultural values of past generations.',
          'cultural_significance':
              '${widget.destination.title} holds profound cultural meaning within Indonesian society, serving as a vital link to ancestral traditions. This sacred space continues to play an important role in preserving cultural practices, spiritual beliefs, and community identity for current and future generations.',
          'architecture':
              'The architectural brilliance of ${widget.destination.title} demonstrates exceptional Indonesian design principles through its intricate structural elements. The building showcases traditional construction methods, artistic decorations, and spatial arrangements that reflect the sophisticated understanding of form and function.',
          'visitor_info':
              'The symbolic philosophy embedded within ${widget.destination.title} represents deep spiritual and cultural concepts central to Indonesian worldview. Every architectural element carries meaningful symbolism, reflecting philosophical teachings about harmony, balance, and the relationship between humanity and the divine.',
          'conservation':
              'Traditional materials used in constructing ${widget.destination.title} highlight the resourcefulness and expertise of Indonesian craftsmen. Local timber, stone, and natural materials were carefully selected and skillfully employed using time-honored techniques passed down through generations.',
          'modern_development':
              'Contemporary enhancements at ${widget.destination.title} thoughtfully integrate modern amenities while preserving its historical authenticity. Recent developments include improved visitor facilities, educational programs, and conservation technologies that ensure this cultural treasure remains accessible for future appreciation.',
          'visitor_guide':
              'For visiting ${widget.destination.title}, travelers can access the site through various transportation options. The destination offers essential facilities including parking areas, restrooms, and information centers. Visitors are advised to check opening hours, respect local customs, and follow photography guidelines for an enriching cultural experience.',
        };
        _isGeneratingContent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while generating content
    if (_isGeneratingContent) {
      return const LoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              DestinationHeader(destination: widget.destination),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: DestinationOverview(
                  overviewContent: _generatedContent?['overview'],
                  subcategory: widget.destination.subcategory,
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: DestinationContent(generatedContent: _generatedContent),
              ),
              SizedBox(height: 3.h),
            ],
          ),

          const AskNusaBotFloating(),
        ],
      ),
    );
  }
}
