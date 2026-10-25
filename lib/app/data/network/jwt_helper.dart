import 'dart:convert';

/// Helper utility for decoding and validating JSON Web Tokens (JWT)
class JwtHelper {
  JwtHelper._();

  /// Decodes the payload portion of a JWT string into a `Map<String, dynamic>`.
  /// Returns `null` if the token is invalid, malformed, or cannot be decoded.
  static Map<String, dynamic>? decodePayload(String? token) {
    if (token == null || token.trim().isEmpty) return null;

    final parts = token.trim().split('.');
    if (parts.length < 2) return null;

    try {
      final normalized = base64Url.normalize(parts[1]);
      final decodedBytes = base64Url.decode(normalized);
      final decodedString = utf8.decode(decodedBytes);
      final decodedJson = jsonDecode(decodedString);

      if (decodedJson is Map<String, dynamic>) {
        return decodedJson;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extracts the expiration DateTime from the token payload's `exp` claim.
  /// `exp` in JWT is standard UNIX timestamp in seconds.
  static DateTime? getExpirationDate(String? token) {
    final payload = decodePayload(token);
    if (payload == null || !payload.containsKey('exp')) return null;

    final exp = payload['exp'];
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } else if (exp is num) {
      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
    } else if (exp is String) {
      final parsed = int.tryParse(exp);
      if (parsed != null) {
        return DateTime.fromMillisecondsSinceEpoch(parsed * 1000);
      }
    }
    return null;
  }

  /// Checks if the token is expired.
  ///
  /// Returns `true` if:
  /// - The token is null or empty
  /// - The token cannot be decoded
  /// - The `exp` claim is missing or expired relative to current time
  ///
  /// Provide [margin] (e.g. `Duration(seconds: 30)`) to consider a token expired
  /// slightly before its exact expiration time to prevent edge-case race conditions.
  static bool isExpired(String? token, {Duration margin = Duration.zero}) {
    if (token == null || token.trim().isEmpty) return true;

    final expDate = getExpirationDate(token);
    if (expDate == null) {
      // If there is no exp claim or token is malformed, consider expired/invalid
      return true;
    }

    final compareTime = DateTime.now().add(margin);
    return expDate.isBefore(compareTime);
  }

  /// Returns `true` if the token is present, well-formed, and not yet expired.
  static bool isValid(String? token, {Duration margin = Duration.zero}) {
    if (token == null || token.trim().isEmpty) return false;
    return !isExpired(token, margin: margin);
  }

  /// Extracts user ID from payload (`userId`, `id`, `_id`, or `sub`)
  static String? getUserId(String? token) {
    final payload = decodePayload(token);
    if (payload == null) return null;

    return payload['userId']?.toString() ??
        payload['id']?.toString() ??
        payload['_id']?.toString() ??
        payload['sub']?.toString();
  }

  /// Extracts email from payload
  static String? getEmail(String? token) {
    final payload = decodePayload(token);
    return payload?['email']?.toString();
  }

  /// Extracts role from payload (e.g. "USER", "BUYER", "SELLER", "ADMIN")
  static String? getRole(String? token) {
    final payload = decodePayload(token);
    return payload?['role']?.toString();
  }
}
