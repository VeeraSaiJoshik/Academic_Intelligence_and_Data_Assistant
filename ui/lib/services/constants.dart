import 'package:flutter/foundation.dart' show kIsWeb;

const GOOGLE_CLIENT_ID_WEB = '679991979782-clj7fh9h98907lhmpvac7ila20k6qajc.apps.googleusercontent.com';

String GoogleClientID() {
  if (kIsWeb) {
    // running on the web!
    return GOOGLE_CLIENT_ID_WEB;
  }
  return '';
}