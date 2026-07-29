import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows how many episodes a character appeared in, expandable into a
/// chip list of episode numbers. Parses the trailing id from each episode
/// URL rather than fetching the Episode endpoint — the episode's own
/// name/air-date isn't required here, so no extra network call is made.
class EpisodesSection extends StatelessWidget {
  final List<String> episodeUrls;

  const EpisodesSection({super.key, required this.episodeUrls});

  String _episodeNumber(String url) {
    final segments = url.split('/');
    return segments.isEmpty ? '?' : segments.last;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.movie_filter_rounded, color: theme.colorScheme.primary),
          title: Text('Episodes', style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp)),
          subtitle: Text(
            '${episodeUrls.length} appearance${episodeUrls.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
          ),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          children: [
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: episodeUrls.map((url) {
                return Chip(
                  label: Text('Ep. ${_episodeNumber(url)}', style: TextStyle(fontSize: 11.sp)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}