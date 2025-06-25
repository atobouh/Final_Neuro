import 'package:flutter/material.dart';
import 'package:ff_t/utils/constants.dart';
import 'package:ff_t/utils/colors.dart';

class ProfileImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final ValueChanged<int> onImageChanged;
  final int initialImageIndex;

  const ProfileImageCarousel({
    super.key,
    required this.imagePaths,
    required this.onImageChanged,
    this.initialImageIndex = 0,
  });

  @override
  State<ProfileImageCarousel> createState() => _ProfileImageCarouselState();
}

class _ProfileImageCarouselState extends State<ProfileImageCarousel> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage =
        widget.initialImageIndex.clamp(0, widget.imagePaths.length - 1);
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.4);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          widget.onImageChanged(index);
        },
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          final bool isSelected = _currentPage == index;
          final double scale = isSelected ? 1.0 : 0.8;
          final double opacity = isSelected ? 1.0 : 0.5;

          return AnimatedScale(
            scale: scale,
            duration: AppConstants.defaultAnimationDuration,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: AppConstants.defaultAnimationDuration,
              curve: Curves.easeOutCubic,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryDark,
                  border: isSelected
                      ? Border.all(color: accentYellow, width: 4)
                      : Border.all(
                          color: mediumText.withOpacity(0.5), width: 2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: accentYellow.withOpacity(0.3),
                              blurRadius: 12)
                        ]
                      : [],
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: errorRed)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
