/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class AlohaException implements Exception {
  /// Aloha'a exception class
  AlohaException([this._message = 'No Message Supplied']);

  static const String header = 'Aloha Exception: ';
  static const String notReady = 'Not ready, re-initialise Aloha';

  final String _message;

  @override
  String toString() => '$header$_message';
}
