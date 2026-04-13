import 'package:flutter/material.dart';
import 'package:pr/domain/services/certificate_service.dart';
import 'package:pr/domain/services/token_storage_service.dart';
import 'package:pr/ui/pages/json_detail_page.dart';
import 'package:pr/ui/theme/app_colors.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sertifikatlar'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mening'),
              Tab(text: 'Barchasi'),
            ],
          ),
        ),
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
          child: const SafeArea(
            child: TabBarView(
              children: [
                _CertificatesList(mode: _CertificateMode.mine),
                _CertificatesList(mode: _CertificateMode.all),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _CertificateMode { mine, all }

class _CertificatesList extends StatefulWidget {
  const _CertificatesList({required this.mode});

  final _CertificateMode mode;

  @override
  State<_CertificatesList> createState() => _CertificatesListState();
}

class _CertificatesListState extends State<_CertificatesList> {
  final CertificateService _service = CertificateService();
  final TokenStorageService _tokenStorage = TokenStorageService();

  bool _isLoading = false;
  String? _errorMessage;
  List<Certificate> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _tokenStorage.readAccessToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Access token topilmadi.';
          _items = [];
        });
        return;
      }

      final items = widget.mode == _CertificateMode.mine
          ? await _service.fetchMyCertificates(token)
          : await _service.fetchCertificates(token);
      if (!mounted) return;
      setState(() {
        _items = items;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        _items = [];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openDetail(Certificate certificate) async {
    try {
      final token = await _tokenStorage.readAccessToken();
      if (!mounted) return;
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access token topilmadi.')),
        );
        return;
      }
      final detail = await _service.fetchCertificate(token, certificate.id);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => JsonDetailPage(
            title: certificate.title.isNotEmpty
                ? certificate.title
                : 'Sertifikat',
            data: detail,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildInfoBanner(_errorMessage!),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _load,
            child: const Text('Qayta yuklash'),
          ),
        ],
      );
    }

    if (_items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildInfoBanner('Sertifikatlar topilmadi.'),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final title = item.title.isNotEmpty ? item.title : 'Sertifikat';
          final subtitle = item.issuedAt.isNotEmpty ? item.issuedAt : '—';
          return _buildCard(
            title: title,
            subtitle: subtitle,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openDetail(item),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
