class JwtToken {
  final String refresh;
  final String access;

  JwtToken({required this.refresh, required this.access});

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
    };
  }
}