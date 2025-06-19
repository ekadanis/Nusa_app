import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';

import '../../../core/styles.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Styles.mdPadding),
      margin: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primary50,
      ),
      child: Column(
        spacing: Styles.mdSpacing,
        children: [
          Row(
            spacing: Styles.smSpacing,
            children: [
            Container(
                padding: EdgeInsets.all(Styles.xsPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.white.withOpacity(0.1),
                ),
                child: Icon(IconsaxPlusBold.game, color: AppColors.white,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Learn Culture, The Fun Way!", style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.white
                ),),
                Text("Play game and get your point!", style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white, fontStyle: FontStyle.italic
                ),),
              ],
            )
          ],),
          ElevatedButton(onPressed: () {}, 
              child: Container(
                alignment: Alignment(0, 0),
                width: 120,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Styles.mdRadius),
                color: AppColors.white), 
              child: Text("Play Now"),
              ))
        ],
      ),
    );
  }
}
