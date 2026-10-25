import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_meal_and_grocery_app/app/data/network/jwt_helper.dart';

void main() {
  test('JwtHelper decodes payload and checks expiration correctly', () {
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTc4MDQxODFkYzA0ZjZiZDU3NWY3ZTAiLCJlbWFpbCI6ImRldi5uYXllZW0wMUBnbWFpbC5jb20iLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc4NjI1MDgzNCwiZXhwIjoxNzg2NjgyODM0fQ.UctLqm9SXzs58u1cHsgNrQnVO20ERLbwUbXk-7wBxbE';

    final payload = JwtHelper.decodePayload(token);
    expect(payload, isNotNull);
    expect(payload!['userId'], '6a7804181dc04f6bd575f7e0');
    expect(payload['email'], 'dev.nayeem01@gmail.com');
    expect(payload['role'], 'USER');

    expect(JwtHelper.getUserId(token), '6a7804181dc04f6bd575f7e0');
    expect(JwtHelper.getEmail(token), 'dev.nayeem01@gmail.com');
    expect(JwtHelper.getRole(token), 'USER');

    // The sample token from postman was from Aug 2026, which is expired by Oct 2026
    expect(JwtHelper.isExpired(token), isTrue);

    // Create a dynamic token valid for 1 hour in the future
    final futureExp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
    final futurePayload = '{"userId":"testUser","exp":$futureExp}';
    final futureBase64 = base64Url.encode(utf8.encode(futurePayload));
    final futureToken = 'header.$futureBase64.sig';

    expect(JwtHelper.isExpired(futureToken), isFalse);
    expect(JwtHelper.isValid(futureToken), isTrue);
    expect(JwtHelper.getUserId(futureToken), 'testUser');

    // Test expired token (exp in past: 1000000000 -> Sep 2001)
    const expiredToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjMiLCJleHAiOjEwMDAwMDAwMDB9.signature';
    expect(JwtHelper.isExpired(expiredToken), isTrue);
    expect(JwtHelper.isValid(expiredToken), isFalse);

    // Test invalid / null token
    expect(JwtHelper.isValid(null), isFalse);
    expect(JwtHelper.isValid(''), isFalse);
    expect(JwtHelper.isValid('invalid.token'), isFalse);
  });
}
