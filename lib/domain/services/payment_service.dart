import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pr/domain/services/api_parsing.dart';

class Payment {
  Payment({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.raw,
  });

  final String id;
  final String amount;
  final String currency;
  final String status;
  final String createdAt;
  final Map<String, dynamic> raw;

  factory Payment.fromMap(Map<String, dynamic> data) {
    return Payment(
      id: (data['id'] ?? '').toString(),
      amount: (data['amount'] ?? data['price'] ?? data['sum'] ?? '').toString(),
      currency: (data['currency'] ?? data['currency_code'] ?? '').toString(),
      status: (data['status'] ?? data['state'] ?? '').toString(),
      createdAt: (data['created_at'] ?? data['date'] ?? '').toString(),
      raw: data,
    );
  }
}

class PaymentService with ApiParsing {
  PaymentService({
    http.Client? client,
    this.baseUrl = 'https://api.uyguntalim.tsue.uz/api',
    this.csrfToken = 'x9Jv5GBLMZLVyTRu6rFmF2b8uORvppSDOHtWzbixuyB9RmgznaYKyNpuBDv3eOSb',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final String csrfToken;

  Future<List<Payment>> fetchMyPayments(String accessToken) async {
    final uri = Uri.parse('$baseUrl/payments/my/');
    final response = await _client.get(uri, headers: _headers(accessToken));
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'To‘lovlarni olishda xatolik yuz berdi.',
        ),
      );
    }
    final decoded = decodeList(response.body);
    return decoded.map(Payment.fromMap).toList();
  }

  Future<List<Payment>> fetchSuccessPayments(String accessToken) async {
    final uri = Uri.parse('$baseUrl/payments/success/');
    final response = await _client.get(uri, headers: _headers(accessToken));
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'To‘lovlarni olishda xatolik yuz berdi.',
        ),
      );
    }
    final decoded = decodeList(response.body);
    return decoded.map(Payment.fromMap).toList();
  }

  Future<Map<String, dynamic>> fetchPaymentStatus(
    String accessToken,
    String paymentId,
  ) async {
    final uri = Uri.parse('$baseUrl/payments/$paymentId/status/');
    final response = await _client.get(uri, headers: _headers(accessToken));
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'To‘lov statusini olishda xatolik yuz berdi.',
        ),
      );
    }
    return decodeMap(response.body);
  }

  Future<Map<String, dynamic>> createPayment(
    String accessToken,
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse('$baseUrl/payments/create/');
    final response = await _client.post(
      uri,
      headers: {
        ..._headers(accessToken),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        extractErrorMessage(
          response.body,
          fallback: 'To‘lov yaratishda xatolik yuz berdi.',
        ),
      );
    }
    return decodeMap(response.body);
  }

  Map<String, String> _headers(String accessToken) {
    return {
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'X-CSRFTOKEN': csrfToken,
    };
  }
}
