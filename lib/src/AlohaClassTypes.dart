/*
 * Package : aloha
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
// ignore_for_file: always_specify_types
// ignore_for_file: unnecessary_getters_setters
// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: flutter_style_todos

/// Commands

class AlohaCommandWillExecuteParameters {
  /// Command will execute event return parameters
  // ignore: avoid_positional_boolean_parameters
  AlohaCommandWillExecuteParameters(this._commandId, this._preventDefault);

  final String _commandId;

  /// The command Id e.g 'bold'
  String get commandId => _commandId;

  final bool _preventDefault;

  /// The prevent default state
  bool get preventDefault => _preventDefault;
}

class AlohaSmartContentChangeParameters {
  /// Smart content change event return parameters
  AlohaSmartContentChangeParameters(this._editableObject, this._keyIdentifier,
      this._keyCode, this._char, this._triggerType, this._snapshotContent);

  final AlohaEditable _editableObject;

  /// The editable object
  AlohaEditable get editableObject => _editableObject;

  final String _keyIdentifier;

  /// The key identifier
  String get keyIdentifier => _keyIdentifier;

  final int _keyCode;

  /// The key code
  int get keyCode => _keyCode;

  final String _char;

  /// The character entered
  String get char => _char;

  final String _triggerType;

  /// The trigger type, one of
  /// keypress, idle, blur, paste, block-change
  String get triggerType => _triggerType;

  final String _snapshotContent;

  /// Snapshot content
  /// The snapshot content of the editable as a HTML String
  String get snapshotContent => _snapshotContent;
}
