

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/util/extensions.dart';

import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../models/destination_model.dart';
import '../../../routes/router.dart';

@RoutePage()
class SearchResultsPage extends StatelessWidget {
  final String query;
  final List<DestinationModel> results;

  const SearchResultsPage({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: results.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusBold.search_normal,
              size: 50,
              color: AppColors.grey30,
            ),
            SizedBox(height: Styles.mdSpacing),
            Text(
              'No results found',
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.grey40,
              )
            ),
            SizedBox(height: Styles.mdSpacing),
            Text(
              'Try different keywords',
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.grey400,
              )
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(Styles.mdPadding),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final destination = results[index];
          return Card(
            margin: EdgeInsets.only(bottom: Styles.smPadding),
            child: ListTile(
              contentPadding: EdgeInsets.all(Styles.smPadding),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: destination.imageUrl.isNotEmpty
                    ? Image.network(
                  destination.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: AppColors.grey10,
                  child: Icon(
                    IconsaxPlusBold.image,
                    color: AppColors.grey30,
                  ),
                ),
              ),
              title: Text(
                destination.title,
                style: context.textTheme.titleLarge
              ),
              subtitle: Text(
                destination.subcategory,
                style: context.textTheme.titleLarge
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.grey40,
              ),
              onTap: () {
                context.router
                    .push(DetailRouteDestination(destination: destination));
              },
            ),
          );
        },
      ),
    );
  }
}