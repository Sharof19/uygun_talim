import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pr/domain/services/profile_service.dart';
import 'package:pr/domain/services/token_storage_service.dart';
import 'package:pr/ui/pages/certificates_page.dart';
import 'package:pr/ui/pages/payments_page.dart';
import 'package:pr/ui/routes/app_routes.dart';
import 'package:pr/ui/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  bool _isLoading = false;
  ProfileInfo? _profile;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _tokenStorageService.readAccessToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Access token topilmadi.';
          _isLoading = false;
        });
        return;
      }

      final profile = await _profileService.fetchProfile(token);
      if (!mounted) return;
      setState(() {
        _profile = profile;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Profilni olishda xatolik yuz berdi.';
      });
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                _buildProfileCard(),
                const SizedBox(height: 24),
                _buildMenuItem(Icons.settings, "Sozlamalar", () {}),
                _buildMenuItem(
                  Icons.copy_rounded,
                  "Access tokenni nusxalash",
                  () {
                    _copyAccessToken();
                  },
                ),
                _buildMenuItem(Icons.description, "Mening arizalarim", () {
                  Navigator.pushNamed(context, "/myApplications");
                }),
                _buildMenuItem(Icons.verified, "Sertifikatlarim", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CertificatesPage()),
                  );
                }),
                _buildMenuItem(Icons.payments, "To‘lovlarim", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaymentsPage()),
                  );
                }),
                _buildMenuItem(Icons.support_agent, "Texnik yordam", () {}),
                _buildMenuItem(Icons.exit_to_app, "Chiqish", () async {
                  await _tokenStorageService.clearTokens();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final profile = _profile;
    final fullName = profile?.fullName ?? "Foydalanuvchi";
    final phone = _formatPhone(profile?.phoneNumber ?? "");
    final studentId = profile?.studentIdNumber ?? "";
    const fallbackPhone = "+998 90 811 66 71";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 38,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      phone.isNotEmpty ? phone : fallbackPhone,
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Talaba',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.badge, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Talaba ID',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  studentId.isNotEmpty ? studentId : '—',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFD14343), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFD14343),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPhone(String raw) {
    if (raw.isEmpty) return '';
    final digits = raw.replaceAll(RegExp(r'\\D'), '');
    String normalized = digits;
    if (digits.length == 9) {
      normalized = '998$digits';
    }
    if (normalized.length >= 12 && normalized.startsWith('998')) {
      final part1 = normalized.substring(3, 5);
      final part2 = normalized.substring(5, 8);
      final part3 = normalized.substring(8, 10);
      final part4 = normalized.substring(10, 12);
      return '+998 $part1 $part2 $part3 $part4';
    }
    return raw;
  }

  Future<void> _copyAccessToken() async {
    final token = await _tokenStorageService.readAccessToken();
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access token topilmadi.')),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token nusxalandi')),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }
}

class MyApplicationsPage extends StatelessWidget {
  const MyApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleApplications = [
      {"title": "Заявка 1", "status": "На рассмотрении"},
      {"title": "Заявка 2", "status": "Принято"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mening arizalarim"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: sampleApplications.length,
          itemBuilder: (context, index) {
            final app = sampleApplications[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.assignment, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app['status']!,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
