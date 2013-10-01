/*
 * Package : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

/**
 * Commands 
 */

/**
 * Command will execute event return paramters
 */
class AlohaCommandWillExecuteParameters {
    
  AlohaCommandWillExecuteParameters(this._commandId,
                               this._preventDefault);
  /**
   * The command Id e.g 'bold'
   */
  String _commandId = null;
  get commandId => _commandId;
 
  /**
   * The prevent default state
   */
  bool _preventDefault = false;
  get preventDefault => _preventDefault;
  
}

/**
 * Smart content change event return parameters
 */
class AlohaSmartContentChangeParameters {
  
  
  AlohaSmartContentChangeParameters(this._editableObject,
                               this._keyIdentifier,
                               this._keyCode,
                               this._char,
                               this._triggerType,
                               this._snapshotContent);
  /**
   * The editable object
   */
  AlohaEditable _editableObject = null;
  get editableObject => _editableObject;
  
  /**
   * The key identifier
   */
  String _keyIdentifier = null;
  get keyIdentifier => _keyIdentifier;
  
  /**
   * The key code
   */
  int _keyCode = null;
  get keyCode => _keyCode;
  
  /**
   * The character entered
   */
  String _char = null;
  get char => _char;
  
  /**
   * The trigger type, one of
   * keypress, idle, blur, paste, block-change
   */
  String _triggerType = null;
  get triggerType => _triggerType;
  
  
  /**
   * Snapshot content
   * The snapshot content of the editable as a HTML String
   */
  String _snapshotContent = null;
  get snapshotContent => _snapshotContent;
  
}
