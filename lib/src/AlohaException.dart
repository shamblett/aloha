/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class AlohaException implements Exception {
  /* Exception message strings */
  static const HEADER = 'Aloha Exception: ';
  static const NOT_READY = 'Not ready, re-initialise Aloha';

  String _message = 'No Message Supplied';

  /**
   * Aloha'a exception class
   */
  AlohaException([this._message]);

  String toString() => HEADER + "${_message}";
}
