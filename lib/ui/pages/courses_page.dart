import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pr/domain/services/course_service.dart';
import 'package:pr/domain/services/token_storage_service.dart';
import 'package:pr/ui/pages/course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final CourseService _courseService = CourseService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  static const Color _pageBackground = Color(0xFFF3F5F4);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _surfaceTint = Color(0xFFEAF2EE);
  static const Color _stroke = Color(0xFFD8E2DD);
  static const Color _textPrimary = Color(0xFF1F2A24);
  static const Color _textSecondary = Color(0xFF728078);
  static const Color _brand = Color(0xFF57A57C);
  static const Color _brandDark = Color(0xFF4A936F);
  static const Color _brandSoft = Color(0xFFDDF0E6);

  bool _isLoading = false;
  String? _errorMessage;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _tokenStorageService.readAccessToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Access token topilmadi.';
          _courses = [];
        });
        return;
      }

      final courses = await _courseService.fetchCourses(token);
      if (!mounted) return;
      setState(() {
        _courses = courses;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Kurslarni yuklashda xatolik yuz berdi.';
        _courses = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: RefreshIndicator(
                color: _brandDark,
                backgroundColor: Colors.white,
                onRefresh: _loadCourses,
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _surfaceTint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _stroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kurslar',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Uyg\'un ta\'lim kurslari',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.6),
        ),
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildInfoBanner(_errorMessage!),
        ],
      );
    }

    if (_courses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildInfoBanner('Kurslar topilmadi.'),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= 760) {
          final crossAxisCount = width >= 1120 ? 3 : 2;
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 382,
            ),
            itemBuilder: (context, index) => _buildCourseCard(_courses[index]),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return _buildCourseCard(course);
          },
        );
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    final imageUrl = _normalizeImageUrl(course.image);
    final price = _priceText(course);
    final categoryTitle = (course.category?.title ?? '').trim();
    final subject = course.subject.trim();
    final authorName = (course.author?.firstName ?? '')
        .replaceAll('null', '')
        .trim();
    final isPurchased = course.enrollment?.isPaid == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openCourse(course),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _stroke),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF101A14).withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseImage(
                url: imageUrl,
                categoryTitle: categoryTitle,
                subject: subject,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textPrimary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetaLabel(
                            icon: Icons.person_outline,
                            text: authorName.isNotEmpty ? authorName : '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _brandDark,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (isPurchased)
                          _buildStatusPill("To'langan", _brandDark)
                        else
                          _buildCartAction(),
                      ],
                    ),
                    if (isPurchased) ...[
                      const SizedBox(height: 10),
                      _buildOpenButton(course),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage({
    required String url,
    required String categoryTitle,
    required String subject,
  }) {
    final imageBadge = subject.isNotEmpty
        ? subject
        : (categoryTitle.isNotEmpty ? categoryTitle : 'Kurs');
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE5EFEA), Color(0xFFF7F9F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: _brandDark,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.menu_book_outlined, color: _brandDark),
                )
              else
                const Icon(Icons.menu_book_outlined, color: _brandDark),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _brandSoft.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
                  ),
                  child: Text(
                    imageBadge.toLowerCase(),
                    style: const TextStyle(
                      color: _brandDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaLabel({
    required IconData icon,
    required String text,
    bool trailingOnly = false,
  }) {
    return Row(
      mainAxisSize: trailingOnly ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Icon(icon, size: 14, color: _textSecondary),
        if (text.isNotEmpty) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOpenButton(Course course) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_brand, _brandDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _brandDark.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _openCourse(course),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 9),
              child: Text(
                'Kursga kirish',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartAction() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_brand, _brandDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _brandDark.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStatusPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _stroke),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: _brandDark, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );
  }

  String _normalizeImageUrl(String url) {
    if (url.startsWith('/')) {
      return 'https://api.uyguntalim.tsue.uz$url';
    }
    if (url.isNotEmpty && !url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://api.uyguntalim.tsue.uz/$url';
    }
    if (url.startsWith('http://api.uyguntalim.tsue.uz/')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  String _priceText(Course course) {
    if (!course.isPaid) return 'Bepul';
    final price = course.price.isNotEmpty ? course.price : '0';
    final currency = course.currency.isNotEmpty ? course.currency : '';
    return '$price $currency'.trim();
  }

  String _statusText(Course course) {
    final enrollment = course.enrollment;
    if (enrollment == null) return 'Sotib olinmagan';
    return enrollment.isPaid ? "To'langan" : "To'lanmagan";
  }

  Color _statusColor(Course course) {
    final enrollment = course.enrollment;
    if (enrollment == null) return const Color(0xFF9A6A00);
    return enrollment.isPaid ? const Color(0xFF0A7AC2) : const Color(0xFF9A6A00);
  }
}
