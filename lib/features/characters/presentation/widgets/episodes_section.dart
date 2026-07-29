import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows how many episodes a character appeared in, expandable into a
/// chip list of episode numbers. Parses the trailing id from each episode
/// URL rather than fetching the Episode endpoint — the episode's own
/// name/air-date isn't required here, so no extra network call is made.
///
/// Built as a plain custom expand/collapse (not [ExpansionTile]) so the
/// chevron rotation and content reveal both run on the same deliberate
/// 250ms curve as the rest of the screen's motion, instead of the
/// platform-default instant snap.
class EpisodesSection extends StatefulWidget {
  final List<String> episodeUrls;

  const EpisodesSection({super.key, required this.episodeUrls});

  @override
  State<EpisodesSection> createState() => _EpisodesSectionState();
}

class _EpisodesSectionState extends State<EpisodesSection> {
  bool _expanded = false;

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
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Icon(Icons.movie_filter_rounded, color: theme.colorScheme.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Episodes', style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp)),
                        SizedBox(height: 2.h),
                        Text(
                          '${widget.episodeUrls.length} appearance${widget.episodeUrls.length == 1 ? '' : 's'}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: const Icon(Icons.expand_more_rounded),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: widget.episodeUrls.map((url) {
                  return Chip(
                    label: Text('Ep. ${_episodeNumber(url)}', style: TextStyle(fontSize: 11.sp)),
                  );
                }).toList(),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}