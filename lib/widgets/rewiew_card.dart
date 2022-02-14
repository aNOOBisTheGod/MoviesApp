import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class ReviewCard extends StatelessWidget {
  Map review;
  ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(
              review['updated_at'].replaceAll('T', ' ').replaceAll('Z', ''),
              style: TextStyle(
                  color: Colors.grey[500], fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: review['author_details']['rating'] != null
                    ? List.filled(
                        (review['author_details']['rating']) ~/ 2,
                        GlowIcon(Icons.star,
                            color: Theme.of(context).primaryColor,
                            glowColor: Theme.of(context).primaryColor),
                      )
                    : [
                        GlowText(
                          'No rating provided',
                          glowColor: Theme.of(context).primaryColor,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25),
                        )
                      ],
              ),
            ),
            Text(
              this.review['content'],
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
