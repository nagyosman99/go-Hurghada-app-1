import 'package:flutter/material.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';

class HotelDescription extends StatefulWidget {
  final String description;

  const HotelDescription({super.key, required this.description});

  @override
  State<HotelDescription> createState() => _HotelDescriptionState();
}

class _HotelDescriptionState extends State<HotelDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(height: 1.5);

        // Calculate if text exceeds max lines
        final span = TextSpan(text: widget.description, style: style);
        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: Directionality.of(context),
        );
        tp.layout(maxWidth: constraints.maxWidth);
        final isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.aboutSection,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: style,
            ),
            if (isOverflowing)
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _isExpanded
                        ? AppLocalizations.of(context)!.showLess
                        : AppLocalizations.of(context)!.showMore,
                    style: const TextStyle(
                      color: Color(0xFF0084ff),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
