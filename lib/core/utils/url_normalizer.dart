abstract class UrlNormalizer {
  static String normalize(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('/')) {
      return 'https://api.uyguntalim.tsue.uz$url';
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://api.uyguntalim.tsue.uz/$url';
    }
    if (url.startsWith('http://api.uyguntalim.tsue.uz/')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
