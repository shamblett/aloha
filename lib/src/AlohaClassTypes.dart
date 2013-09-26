/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

/**
 * Commands 
 */
class commandWillExecuteParameters {
    
  String _commandId = null;
  get commandId => _commandId;
  set commandId(String commandId) => _commandId = commandId;
 
  bool _preventDefault = false;
  get preventDefault => _preventDefault;
  set preventDefault(bool preventDefault) => _preventDefault = preventDefault;
  
}
