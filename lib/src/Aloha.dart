/*
 * Package : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 * 
 * A binding class for the Aloha HTML5 editor. Refer to the accompanying docuumentation
 * for setup and usage information. Omissions from the Aloha API are also documented.
 */

part of aloha;

class Aloha {
  /// A binding class for the Aloha HTML5 editor. Refer to the accompanying documentation
  /// for setup and usage information. Omissions from the Aloha API are also documented.
  Aloha() {
    /* Ready */
    void _jsReady() {
      _ready = true;
      _onReady.add(null);
    }

    _alohaContext.callMethod('bind', ['aloha-ready', _jsReady]);

    /// The rest of the bindings will always have the jQuery event object as
    /// their first parameter, even if Aloha sends nothing, e.g, log ready trigger.
    ///
    void _jsCommandWillExecute(js.JsObject event, js.JsObject jsParams) {
      final params = AlohaCommandWillExecuteParameters(
          jsParams['commandId'], jsParams['preventDefault']);
      _onCommandWillExecute.add(params);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-command-will-execute', _jsCommandWillExecute]);

    void _jsCommandExecuted(js.JsObject event, String commandId) {
      _onCommandExecuted.add(commandId);
    }

    _alohaContext
        .callMethod('bind', ['aloha-command-executed', _jsCommandExecuted]);

    /* Logging */
    void _jsLoggerReady(js.JsObject e) {
      _onLoggerReady.add(null);
    }

    _alohaContext.callMethod('bind', ['aloha-logger-ready', _jsLoggerReady]);

    void _jsLoggerFull(js.JsObject e) {
      _onLoggerFull.add(null);
    }

    _alohaContext.callMethod('bind', ['aloha-log-full', _jsLoggerFull]);

    /* Editables */
    void _jsEditableCreated(js.JsObject event, js.JsObject editable) {
      final theEditable = AlohaEditable(editable, event);
      _onEditableCreated.add(theEditable);
    }

    _alohaContext
        .callMethod('bind', ['aloha-editable-created', _jsEditableCreated]);

    void _jsEditableDestroyed(js.JsObject event, js.JsObject ref) {
      _onEditableDestroyed.add(null);
    }

    _alohaContext
        .callMethod('bind', ['aloha-editable-destroyed', _jsEditableDestroyed]);

    void _jsEditableActivated(js.JsObject event, editableObjects) {
      /* We always have the event and the current active editable */
      List editableList;
      final editableEvent = event;
      final activeEditable = editableObjects['editable'];
      final editable = AlohaEditable(activeEditable, editableEvent);
      /* See if we have an old editable, if so pass it back. */
      try {
        final oldActiveEditable = editableObjects['old'];
        final oldEditable = AlohaEditable(oldActiveEditable, editableEvent);
        editableList = [editable, oldEditable];
      } on Exception {
        editableList = [editable];
      }

      _onEditableActivated.add(editableList);
    }

    _alohaContext
        .callMethod('bind', ['aloha-editable-activated', _jsEditableActivated]);

    void _jsEditableDeactivated(js.JsObject event, js.JsObject editable) {
      final theEditable = AlohaEditable(editable['editable'], event);
      _onEditableDeactivated.add(theEditable);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-editable-deactivated', _jsEditableDeactivated]);

    /* Content changes */
    void _jsSmartContentChange(js.JsObject event, js.JsObject parameters) {
      final theEditable = AlohaEditable(parameters['editable'], event);
      final params = AlohaSmartContentChangeParameters(
          theEditable,
          parameters['keyIdentifier'],
          parameters['keyCode'],
          parameters['char'],
          parameters['triggerType'],
          parameters.callMethod('getSnapshotContent'));
      _onSmartContentChange.add(params);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-smart-content-changed', _jsSmartContentChange]);

    void _jsBlockSelected(js.JsObject event, Object element) {
      _onBlockSelectedChange.add(element);
    }

    _alohaContext
        .callMethod('bind', ['aloha-block-selected', _jsBlockSelected]);

    void _jsImageSelected(js.JsObject e) {
      _onImageSelected.add(null);
    }

    _alohaContext
        .callMethod('bind', ['aloha-image-selected', _jsImageSelected]);

    void _jsImageUnselected(js.JsObject e) {
      _onImageUnselected.add(null);
    }

    _alohaContext
        .callMethod('bind', ['aloha-image-unselected', _jsImageUnselected]);

    void _jsLinkSelected(js.JsObject e) {
      _onLinkSelected.add(null);
    }

    _alohaContext.callMethod('bind', ['aloha-link-selected', _jsLinkSelected]);

    void _jsLinkUnselected(js.JsObject e) {
      _onLinkUnselected.add(null);
    }

    _alohaContext
        .callMethod('bind', ['aloha-link-unselected', _jsLinkUnselected]);

    void _jsTableSelectionChanged(js.JsObject e) {
      _onTableSelectionChanged.add(null);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-table-selection-changed', _jsTableSelectionChanged]);

    void _jsTableActivated(js.JsObject e) {
      _onTableActivated.add(null);
    }

    _alohaContext
        .callMethod('bind', ['aloha-table-activated', _jsTableActivated]);

    void _jsDdfAllFilesPrepared(js.JsObject e) {
      _onDdfAllFilesPrepared.add(null);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-allfiles-upload-prepared', _jsDdfAllFilesPrepared]);

    void _jsDdfFilesDroppedInPage(js.JsObject e, Object element) {
      _onDdfFilesDroppedInPage.add(element);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-drop-files-in-page', _jsDdfFilesDroppedInPage]);

    void _jsDdfFileUploadPrepared(js.JsObject e, Object element) {
      _onDdfFileUploadPrepared.add(element);
    }

    _alohaContext.callMethod(
        'bind', ['aloha-file-upload-prepared', _jsDdfFileUploadPrepared]);
  }

  /// Aloha context
  final _alohaContext = js.context['Aloha'];
  js.JsObject? get context => _alohaContext;

  /// Aloha is ready when this is set. The API calls check for this,
  /// if Aloha is not ready an AlohaException is raised.
  bool _ready = true;
  // ignore: unnecessary_getters_setters
  bool get isReady => _ready;
  // ignore: unnecessary_getters_setters
  set isReady(bool state) => _ready = state;

  /// Ready, NOT a broadcast event, only use one listener for this.
  /// This event is triggered when the Aloha Editor is fully initialized, the core, plugins and UI.
  final _onReady = StreamController();
  Stream get readyEvent => _onReady.stream;

  /// This event is triggered before a command will be executed.
  /// Returned parameter is AlohaCommandWillExecuteParameters class.
  final _onCommandWillExecute = StreamController.broadcast();
  Stream get commandWillExecuteEvent => _onCommandWillExecute.stream;

  /// This event is triggered after a command is executed using the execCommand method
  /// Returned parameter is a String, the command executed.
  final _onCommandExecuted = StreamController.broadcast();
  Stream get commandExecutedEvent => _onCommandExecuted.stream;

  /// This event is triggered when the Aloha Editor logger is fully initialized.
  final _onLoggerReady = StreamController.broadcast();
  Stream get loggerReadyEvent => _onLoggerReady.stream;

  /// This event is triggered when the Aloha Editor log history is full.
  final _onLoggerFull = StreamController.broadcast();
  Stream get loggerFullEvent => _onLoggerFull.stream;

  /// This event fires after a editable has been created, eg. via
  /// $( '#editme' ).aloha() in js or via the attachEditable API method
  /// Returned parameter is an AlohaEditable class.
  final _onEditableCreated = StreamController.broadcast();
  Stream get editableCreatedEvent => _onEditableCreated.stream;

  /// This event fires after a editable has been destroyed, eg. via
  /// $( '#editme' ).mahalo() in js or via the detachEditable API method.
  final _onEditableDestroyed = StreamController.broadcast();
  Stream get editableDestroyedEvent => _onEditableDestroyed.stream;

  /// This event fires when an editable has been activated
  /// by clicking on it say.
  ///
  /// Returned parameter is a list of the editable activated and the old
  /// editable that was active, both of AlohaEditable class. If there was
  /// no old active editable(e.g first click on the page) none is supplied.
  ///  [editable, oldEditable]
  final _onEditableActivated = StreamController.broadcast();
  Stream get editableActivatedEvent => _onEditableActivated.stream;

  /// This event fires when an editable has been deactivated by
  /// clicking on a non editable part of the page or on an other editable, or
  /// has been specifically deactivated.
  ///
  /// Returned parameter is an AlohaEditable class
  final _onEditableDeactivated = StreamController.broadcast();
  Stream get editableDeactivatedEvent => _onEditableDeactivated.stream;

  /// A smart content change occurs when a special editing action, or a combination of
  /// interactions are performed by the user during the course of editing within an editable.
  /// The smart content change event therefore signals that content has been inserted (or changed)
  /// into the editable that may need to be processed in a special way.
  /// It also lets you know when an Aloha Block has changed (i.e. when any of its attributes have
  /// changed).
  /// The smart content change event is also triggered after an idle period that follows rapid,
  /// basic changes to the contents of an editable such as when the user is typing.
  ///
  /// Returned parameter is a AlohaSmartContentChangeParameters class
  final _onSmartContentChange = StreamController.broadcast();
  Stream get smartContentChangeEvent => _onSmartContentChange.stream;

  /// Processing of cursor keys will currently detect blocks (elements with contenteditable=false)
  /// and selects them (normally the cursor would jump right past them).
  /// This will also trigger the blockSelectedEvent event.
  ///
  /// Returned parameter is an HTML element class such as DivElement, ParagraphElement
  /// etc. dependent on selection.
  final _onBlockSelectedChange = StreamController.broadcast();
  Stream get blockSelectedEvent => _onBlockSelectedChange.stream;

  /// Image selection event
  final _onImageSelected = StreamController.broadcast();
  Stream get imageSelectedEvent => _onImageSelected.stream;

  /// Image unselection event
  final _onImageUnselected = StreamController.broadcast();
  Stream get imageUnselectedEvent => _onImageUnselected.stream;

  /// Link selection event
  final _onLinkSelected = StreamController.broadcast();
  Stream get linkSelectedEvent => _onLinkSelected.stream;

  /// Link unselection event
  final _onLinkUnselected = StreamController.broadcast();
  Stream get linkUnselectedEvent => _onLinkUnselected.stream;

  /// Table activation event
  /// After an existing dom-table is transformed into an editable Aloha Editor
  /// table this event is triggered.
  final _onTableSelectionChanged = StreamController.broadcast();
  Stream get tableSelectionChangedEvent => _onTableSelectionChanged.stream;

  /// Table selection change event
  /// Triggers when one or more cells of a table are selected or unselected.
  final _onTableActivated = StreamController.broadcast();
  Stream get tableActivatedEvent => _onTableActivated.stream;

  /// All files upload prepared.
  /// After all files are prepared for an upload this event is triggered.
  final _onDdfAllFilesPrepared = StreamController.broadcast();
  Stream get ddfAllFilesPreparedEvent => _onDdfAllFilesPrepared.stream;

  /// Drop files in page
  /// This event is triggered when files are dropped into the page and not an editable.
  /// Returned parameter is an HTML element class such as DivElement, ParagraphElement
  /// etc. dependent on the drop target.
  final _onDdfFilesDroppedInPage = StreamController.broadcast();
  Stream get ddfFilesDroppedInPageEvent => _onDdfFilesDroppedInPage.stream;

  /// File upload prepared
  /// This event is triggered when a single file of many dropped files is ready for uploading.
  /// Returned parameter is an HTML element class such as DivElement, ParagraphElement
  /// etc. dependent on the drop target.
  final _onDdfFileUploadPrepared = StreamController.broadcast();
  Stream get ddfFileUploadPreparedEvent => _onDdfFileUploadPrepared.stream;

  /// Version string
  String? get version => _alohaContext['version'];

  List<AlohaEditable>? _getEditablesAsList() {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    List? editablesList = <AlohaEditable>[];

    try {
      final jsEditablesList = _alohaContext['editables'];
      final int length = _alohaContext['editables'].length;
      for (var i = 0; i < length; i++) {
        final editable = AlohaEditable(jsEditablesList[i]);
        editablesList.add(editable);
      }
    } on Exception {
      editablesList = null;
    }

    return editablesList as List<AlohaEditable>?;
  }

  /// List of currently maintained editables as a List of AlohaEditable's.
  List<AlohaEditable>? get editables => _getEditablesAsList();

  AlohaEditable? _getActiveEditable() {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    try {
      final editable = AlohaEditable(_alohaContext['activeEditable']);
      return editable;
    } on Exception {
      return null;
    }
  }

  /// Currently active editable as an AlohaEditable
  AlohaEditable? get activeEditable => _getActiveEditable();

  /// Settings
  /// We have no way of knowing what settings have been applied to Aloha in its js startup
  /// so you need to know the settings structure on the client side.
  js.JsObject? get settings => _alohaContext['settings'];

  /// Defaults
  /// Hardwired startup defaults.
  ///
  js.JsObject? get defaults => _alohaContext['defaults'];

  /// OS name
  String? get osName => _alohaContext['OSName'];

  /// Loaded plugins, returned a list of plugin name strings
  js.JsObject? get loadedPlugins => _alohaContext['loadedPlugins'];

  /// Initialization
  /// Use to set Aloha back to its original state
  void reinitialise() {
    _alohaContext.callMethod('init');
  }

  /// Is a plugin loaded
  bool? isPluginLoaded(String pluginName) =>
      _alohaContext.callMethod('isPluginLoaded', [pluginName]);

  /// Get an editable by its id attribute, returns null if none found
  AlohaEditable? getEditableById(String id) {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    try {
      final editableProxy = _alohaContext.callMethod('getEditableById', [id]);
      if (editableProxy == null) return null;
      final theEditable = AlohaEditable(editableProxy);
      return theEditable;
    } on Exception {
      return null;
    }
  }

  /// Activate the specified editable, also deactivates all other editables.
  ///
  /// Note this does NOT set the isActive flag on the editable itself, it just
  /// deactivates all other editables by setting the active flag to false then
  /// makes the editable supplied the activeEditable.
  void activateEditable(AlohaEditable editable) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    final editableProxy = editable.proxy;
    _alohaContext.callMethod('activateEditable', [editableProxy]);
  }

  /// Get the active editable, null if none active
  AlohaEditable? getActiveEditable() {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    try {
      final editableProxy = _alohaContext.callMethod('getActiveEditable');
      if (editableProxy == null) return null;
      final theEditable = AlohaEditable(editableProxy);
      return theEditable;
    } on Exception {
      return null;
    }
  }

  /// Deactivate the active editable
  void deactivateActiveEditable() {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('deactivateEditable');
  }

  /// Check if an object is an editable.
  ///
  /// This check is performed in the class, its not passed through to the
  /// Aloha API, Aloha uses javascript object comparison which is not robust,
  /// we can better do this ourselves.
  bool isAnEditable(Object? anyObject) {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    /* If we are an AlohaEditable then we are an editable */
    if (anyObject.runtimeType.toString() == 'AlohaEditable') return true;

    /* We must at least be a JsObject object to be an editable */
    if (anyObject.runtimeType.toString() != 'JsObject') return false;

    /* Check if the object is in the editables list */
    final int length = _alohaContext['editables'].length;
    final jsEditableList = _alohaContext['editables'];
    for (var i = 0; i < length; i++) {
      if (anyObject == _alohaContext[jsEditableList[i]]) return true;
    }

    return false;
  }

  /// Get editable host.
  ///
  /// Gets the nearest editable parent of the HTML element contained in the
  /// element parameter. Returns null if none found.
  AlohaEditable? getEditableHost(HtmlElement element) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    final jQueryId = '#${element.id}';
    final jQueryElement = js.context.callMethod(r'$', [jQueryId]);
    final proxy = _alohaContext.callMethod('getEditableHost', [jQueryElement]);
    if (proxy == null) return null;
    final editable = AlohaEditable(proxy);
    return editable;
  }

  /// Register an editable.
  void registerEditable(AlohaEditable editable) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('registerEditable', [editable.proxy]);
  }

  /// Unregister an editable.
  void unregisterEditable(AlohaEditable editable) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('unregisterEditable', [editable.proxy]);
  }

  /// Get the Aloha url.
  ///
  /// Aloha's baseUrl setting or "" if not set
  String? getUrl() {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    return _alohaContext.callMethod('getAlohaUrl');
  }

  /// Gets a plugin's url.
  ///
  /// Given the name returns the plugin url as a string
  String? getPluginUrl(String name) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    return _alohaContext.callMethod('getPluginUrl', [name]);
  }

  /// Logs a message to the console.
  ///
  /// Takes the log level, the logging component name and the
  /// log message itself.
  void log(String level, String component, String message) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('log', [level, component, message]);
  }

  /// execCommand implements the commands from the commmand manager section
  /// See the relevant Mozilla documentation here for details.
  /// https://developer.mozilla.org/en/docs/Rich-Text_Editing_in_Mozilla
  void execCommand(String commandId, {bool showUi = false, String? value}) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('execCommand', [commandId, showUi, value, null]);
  }

  /// Query command enabled.
  ///
  /// If the command is available and not disabled or the active range
  /// is not null the command is enabled, True indicates this.
  ///
  /// TODO range option needs to be added, uses current range selection.
  bool? queryCommandEnabled(String commandId) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    return _alohaContext.callMethod('queryCommandEnabled', [commandId, null]);
  }

  /// Query command supported.
  ///
  /// Returns true if the command is supported.
  bool? queryCommandSupported(String commandId) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    return _alohaContext.callMethod('queryCommandSupported', [commandId]);
  }

  /// Return the commands value.
  ///
  ///
  /// TODO range option needs to be added, uses current range selection.
  String? queryCommandValue(String commandId) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    return _alohaContext.callMethod('queryCommandValue', [commandId, null]);
  }

  /// Query supported commands.
  ///
  /// Returns a list of supported commands.
  ///
  List? querySupportedCommands() {
    if (!_ready) throw AlohaException(AlohaException.notReady);

    final js.JsArray proxy = _alohaContext.callMethod('querySupportedCommands');

    List? commands = <String>[];

    try {
      final length = proxy.length;
      for (var i = 0; i < length; i++) {
        commands.add(proxy[i]);
      }
    } on Exception {
      commands = null;
    }

    return commands;
  }

  /// Attach jQuery selectors to Aloha to make them editable entities.
  void attachEditable(String selector) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    js.context.callMethod(r'$', [selector]).callMethod('aloha');
  }

  /// Detach jQuery selectors from Aloha to make previous editables non-editable
  /// entities.
  /// If they were previously editable they will be destroyed.
  void detachEditable(String selector) {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    js.context.callMethod(r'$', [selector]).callMethod('mahalo');
  }

  /// Disable object resizing if the browser supports this.
  void disableObjectResizing() {
    if (!_ready) throw AlohaException(AlohaException.notReady);
    _alohaContext.callMethod('disableObjectResizing');
  }

  /// To string override
  @override
  String toString() => 'Aloha';
}
