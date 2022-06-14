import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart';

final _newlineRegExp = RegExp(r'\r\n|\r|\n');

class MultipartRequestEx extends BaseRequest {
  static const int _boundaryLength = 70;

  static final Random _random = Random();

  final fields = <String, MultipartField>{};

  final files = <MultipartFile>[];

  MultipartRequestEx(String method, Uri url) : super(method, url);

  @override
  int get contentLength {
    var length = 0;

    fields.forEach((name, value) {
      length += '--'.length +
          _boundaryLength +
          '\r\n'.length +
          utf8.encode(_headerForField(name, value)).length +
          utf8.encode(value.value).length +
          '\r\n'.length;
    });

    for (var file in files) {
      length += '--'.length +
          _boundaryLength +
          '\r\n'.length +
          utf8.encode(_headerForFile(file)).length +
          file.length +
          '\r\n'.length;
    }

    return length + '--'.length + _boundaryLength + '--\r\n'.length;
  }

  @override
  set contentLength(int? value) {
    throw UnsupportedError('Cannot set the contentLength property of '
        'multipart requests.');
  }

  @override
  ByteStream finalize() {
    // TODO: freeze fields and files
    final boundary = _boundaryString();
    headers['content-type'] = 'multipart/form-data; boundary=$boundary';
    super.finalize();
    return ByteStream(_finalize(boundary));
  }

  Stream<List<int>> _finalize(String boundary) async* {
    const line = [13, 10]; // \r\n
    final separator = utf8.encode('--$boundary\r\n');
    final close = utf8.encode('--$boundary--\r\n');

    for (var field in fields.entries) {
      yield separator;
      yield utf8.encode(_headerForField(field.key, field.value));
      yield utf8.encode(field.value.value);
      yield line;
    }

    for (final file in files) {
      yield separator;
      yield utf8.encode(_headerForFile(file));
      yield* file.finalize();
      yield line;
    }
    yield close;
  }

  String _headerForField(String name, MultipartField value) {
    var header =
        'content-disposition: form-data; name="${_browserEncode(name)}"';
    value.headers.forEach((key, value) {
      header += '\r\n' + key + ': ' + value;
    });

    if (!isPlainAscii(value.value)) {
      header = '$header\r\n'
          'content-type: text/plain; charset=utf-8\r\n'
          'content-transfer-encoding: binary';
    }
    return '$header\r\n\r\n';
  }

  String _headerForFile(MultipartFile file) {
    var header = 'content-type: ${file.contentType}\r\n'
        'content-disposition: form-data; name="${_browserEncode(file.field)}"';

    if (file.filename != null) {
      header = '$header; filename="${_browserEncode(file.filename!)}"';
    }
    return '$header\r\n\r\n';
  }

  String _browserEncode(String value) =>
  value.replaceAll(_newlineRegExp, '%0D%0A').replaceAll('"', '%22');

  String _boundaryString() {
    var prefix = 'dart-http-boundary-';
    var list = List<int>.generate(
        _boundaryLength - prefix.length,
            (index) =>
        boundaryCharacters[_random.nextInt(boundaryCharacters.length)],
        growable: false);
    return '$prefix${String.fromCharCodes(list)}';
  }
}

class MultipartField {
  final String value;
  final Map<String, dynamic> headers;

  MultipartField(this.value, {this.headers = const {}});
}

final _asciiOnly = RegExp(r'^[\x00-\x7F]+$');

bool isPlainAscii(String string) => _asciiOnly.hasMatch(string);

const List<int> boundaryCharacters = <int>[
  43,
  95,
  45,
  46,
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  88,
  89,
  90,
  97,
  98,
  99,
  100,
  101,
  102,
  103,
  104,
  105,
  106,
  107,
  108,
  109,
  110,
  111,
  112,
  113,
  114,
  115,
  116,
  117,
  118,
  119,
  120,
  121,
  122
];