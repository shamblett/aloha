/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

// ignore_for_file: file_names
// ignore_for_file: omit_local_variable_types
// ignore_for_file: unnecessary_final
// ignore_for_file: cascade_invocations
// ignore_for_file: avoid_print
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: public_member_api_docs

class AlohaException implements Exception {
  /// Aloha'a exception class
  AlohaException([this._message = 'No Message Supplied']);

  static const String header = 'Aloha Exception: ';
  static const String notReady = 'Not ready, re-initialise Aloha';

  final String _message;

  @override
  String toString() => '$header$_message';
}
