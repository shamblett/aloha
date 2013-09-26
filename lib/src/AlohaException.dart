/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class AlohaException implements Exception {
  String _message = 'No Message Supplied';
  AlohaException([this._message]);
  
  String toString() => "AlohaException: message = ${_message}";
}
