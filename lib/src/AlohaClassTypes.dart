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

class AlohaCommandWillExecuteParameters {

  /**
   * Command will execute event return parameters
   */
  AlohaCommandWillExecuteParameters(this._commandId, this._preventDefault);

  String _commandId = null;
  /**
   * The command Id e.g 'bold'
   */
  get commandId => _commandId;

  bool _preventDefault = false;
  /**
   * The prevent default state
   */
  get preventDefault => _preventDefault;

}


class AlohaSmartContentChangeParameters {


  /**
   * Smart content change event return parameters
   */
  AlohaSmartContentChangeParameters(this._editableObject, this._keyIdentifier, this._keyCode, this._char, this._triggerType, this._snapshotContent);

  AlohaEditable _editableObject = null;
  /**
   * The editable object
   */
  get editableObject => _editableObject;

  String _keyIdentifier = null;
  /**
   * The key identifier
   */
  get keyIdentifier => _keyIdentifier;

  int _keyCode = null;
  /**
   * The key code
   */
  get keyCode => _keyCode;

  String _char = null;
  /**
   * The character entered
   */
  get char => _char;

  String _triggerType = null;
  /**
   * The trigger type, one of
   * keypress, idle, blur, paste, block-change
   */
  get triggerType => _triggerType;

  String _snapshotContent = null;
  /**
   * Snapshot content
   * The snapshot content of the editable as a HTML String
   */
  get snapshotContent => _snapshotContent;

}
