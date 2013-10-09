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
   
  
  js.Proxy _context  = js.retain(js.context);
  /**
   * The js context
   */
  get jsContext => _context;
  
  final _jQueryContext  = js.retain(js.context.jQuery);
  /**
   * JQuery context
   */
  get jQueryContext => _jQueryContext;
  
  final _alohaContext = js.retain(js.context.Aloha);
  /**
   * Aloha context
   */
  get context => _alohaContext;
  
  final _alohajQueryContext = js.retain(js.context.Aloha.jQuery);
  /**
   * Aloha's extended jQuery context
   */
  get alohajQueryContext => _alohajQueryContext;
  
  bool _ready = false;
  /**
   * Aloha is ready when this is set. The API calls check for this,
   * if Aloha is not ready an AlohaException is raised.
   */
  get isReady => _ready;
  set isReady(bool state) => _ready = state;
  
  
  js.Callback _jsReady = null;
  final _onReady = new StreamController();
  /**
   *  Ready, NOT a broadcast event, only use one listener for this.
   *  This event is triggered when the Aloha Editor is fully initialized, the core, plugins and UI. 
   */
  get readyEvent => _onReady.stream;
 
  /**
   * Commands 
   */
  
 
  js.Callback _jsCommandWillExecute = null;
  final _onCommandWillExecute = new StreamController.broadcast();
  /**
   * This event is triggered before a command will be executed. 
   * Returned parameter is AlohaCommandWillExecuteParameters class.
   */
  get commandWillExecuteEvent => _onCommandWillExecute.stream;
 
  js.Callback _jsCommandExecuted = null;
  final _onCommandExecuted = new StreamController.broadcast();
  /**
   * This event is triggered after a command is executed using the execCommand method
   * Returned parameter is a String, the command executed.
   */
  get commandExecutedEvent => _onCommandExecuted.stream;
  
  js.Callback _jsLoggerReady = null;
  final _onLoggerReady = new StreamController.broadcast();
  /**
   * This event is triggered when the Aloha Editor logger is fully initialized.
   */
  get loggerReadyEvent => _onLoggerReady.stream;
  
  js.Callback _jsLoggerFull = null;
  final _onLoggerFull = new StreamController.broadcast();
  /**
   * This event is triggered when the Aloha Editor log history is full.
   */
  get loggerFullEvent => _onLoggerFull.stream;
  
  js.Callback _jsEditableCreated = null;
  final _onEditableCreated = new StreamController.broadcast();
  /**
   * This event fires after a new editable has been created, eg. via 
   * $( '#editme' ).aloha() in js or via the attachEditable API method
   * Returned parameter is an AlohaEditable class.
   */
  get editableCreatedEvent => _onEditableCreated.stream;
  
  js.Callback _jsEditableDestroyed = null;
  final _onEditableDestroyed = new StreamController.broadcast();
  /**
   * This event fires after a new editable has been destroyed, eg. via 
   * $( '#editme' ).mahalo() in js or via the detachEditable API method.
   */
  get editableDestroyedEvent => _onEditableDestroyed.stream;
  
  
  js.Callback _jsEditableActivated = null;
  
  final _onEditableActivated = new StreamController.broadcast();
  /**
   * This event fires when an editable has been activated 
   * by clicking on it say.
   *
   * Returned parameter is a list of the editable activated and the old 
   * editable that was active, both of AlohaEditable class. If there was
   * no old active editable(e.g first click on the page) none is supplied.
   *  [editable, oldEditable]
   */
  get editableActivatedEvent => _onEditableActivated.stream;
  
  js.Callback _jsEditableDeactivated = null;
  final _onEditableDeactivated = new StreamController.broadcast();
  /**
   * This event fires when an editable has been deactivated by 
   * clicking on a non editable part of the page or on an other editable, or
   * has been specifically deactivated. 
   *
   * Returned parameter is an AlohaEditable class
   */
  get editableDeactivatedEvent => _onEditableDeactivated.stream;
  
  js.Callback _jsSmartContentChange = null;
  final _onSmartContentChange = new StreamController.broadcast();
  /**
   * A smart content change occurs when a special editing action, or a combination of 
   * interactions are performed by the user during the course of editing within an editable.
   * The smart content change event therefore signals that content has been inserted (or changed) 
   * into the editable that may need to be processed in a special way. 
   * It also lets you know when an Aloha Block has changed (i.e. when any of its attributes have 
   * changed). 
   * The smart content change event is also triggered after an idle period that follows rapid, 
   * basic changes to the contents of an editable such as when the user is typing.
   *
   * Returned parameter is a AlohaSmartContentChangeParameters class
   */
  get smartContentChangeEvent => _onSmartContentChange.stream;
  
  js.Callback _jsBlockSelected = null;
  final _onBlockSelectedChange = new StreamController.broadcast();
  /**
   * Processing of cursor keys will currently detect blocks (elements with contenteditable=false) 
   * and selects them (normally the cursor would jump right past them). 
   * This will also trigger the blockSelectedEvent event.
   * 
   * Returned parameter is an HTML element class such as DivElement, ParagraphElement
   * etc. dependent on selection.
   */
  get blockSelectedEvent => _onBlockSelectedChange.stream;
  
  js.Callback _jsImageSelected = null;
  final _onImageSelected = new StreamController.broadcast();
  /**
   * Image selection event
   */
  get imageSelectedEvent => _onImageSelected.stream;
  
  js.Callback _jsImageUnselected = null;
  final _onImageUnselected = new StreamController.broadcast();
  /**
   * Image unselection event
   */
  get imageUnselectedEvent => _onImageUnselected.stream;
  
  js.Callback _jsLinkSelected = null;
  final _onLinkSelected = new StreamController.broadcast();
  /**
   * Link selection event
   */
  get linkSelectedEvent => _onLinkSelected.stream;
  
  js.Callback _jsLinkUnselected = null;
  final _onLinkUnselected = new StreamController.broadcast();
  /**
   * Link unselection event
   */
  get linkUnselectedEvent => _onLinkUnselected.stream;
  
  js.Callback _jsTableSelectionChanged = null;
  final _onTableSelectionChanged = new StreamController.broadcast();
  /**
   * Table activation event
   * After an existing dom-table is transformed into an editable Aloha Editor 
   * table this event is triggered.
   */
  get tableSelectionChangedEvent => _onTableSelectionChanged.stream; 
  
  js.Callback _jsTableActivated = null;
  final _onTableActivated = new StreamController.broadcast();
  /**
   * Table selection change event
   * Triggers when one or more cells of a table are selected or unselected.
   */
  get tableActivatedEvent => _onTableActivated.stream; 
  
  js.Callback _jsDdfAllFilesPrepared = null;
  final _onDdfAllFilesPrepared = new StreamController.broadcast();
  /**
   * All files upload prepared.
   * After all files are prepared for an upload this event is triggered.
   */
  get ddfAllFilesPreparedEvent => _onDdfAllFilesPrepared.stream; 
  
  js.Callback _jsDdfFilesDroppedInPage = null;
  final _onDdfFilesDroppedInPage = new StreamController.broadcast();
  /**
   * Drop files in page
   * This event is triggered when files are dropped into the page and not an editable.
   *
   * Returned parameter is an HTML element class such as DivElement, ParagraphElement
   * etc. dependent on the drop target.
   */
  get ddfFilesDroppedInPageEvent => _onDdfFilesDroppedInPage.stream; 
  
  js.Callback _jsDdfFileUploadPrepared = null;
  final _onDdfFileUploadPrepared = new StreamController.broadcast();
  /**
   * File upload prepared
   * This event is triggered when a single file of many dropped files is ready for uploading.
   *
   * Returned parameter is an HTML element class such as DivElement, ParagraphElement
   * etc. dependent on the drop target.
   */
  get ddfFileUploadPreparedEvent => _onDdfFileUploadPrepared.stream; 
  
  /**
  * A binding class for the Aloha HTML5 editor. Refer to the accompanying documentation
  * for setup and usage information. Omissions from the Aloha API are also documented.
  */
  Aloha() {
    
    /* Ready */
    _jsReady = new js.Callback.many((){
      
      _ready = true;
      _onReady.add(null);
      
    });
    _alohaContext.bind('aloha-ready', _jsReady);
    
    /**
     * The rest of the bindings will always have the jQuery event object as
     * their first parameter, even if Aloha sends nothing, e.g, log ready trigger.
     */
    
    /* Commands */
    _jsCommandWillExecute = new js.Callback.many((js.Proxy event,
                                                 Object jsParams) {
      
          AlohaCommandWillExecuteParameters params = new 
               AlohaCommandWillExecuteParameters(jsParams.commandId,
                                                 jsParams.preventDefault);
          _onCommandWillExecute.add(params);
          
    });
    _alohaContext.bind('aloha-command-will-execute', _jsCommandWillExecute);
    
    _jsCommandExecuted = new js.Callback.many((js.Proxy event,
                                               String commandId){
          
          _onCommandExecuted.add(commandId);
          
    });
    _alohaContext.bind('aloha-command-executed', _jsCommandExecuted);
    
    /* Logging */
    _jsLoggerReady = new js.Callback.many((js.Proxy e){
      
      _onLoggerReady.add(null);
      
    });
    _alohaContext.bind('aloha-logger-ready', _jsLoggerReady);
   
    _jsLoggerFull = new js.Callback.many((js.Proxy e){
      
      _onLoggerFull.add(null);
     
    });
    _alohaContext.bind('aloha-log-full', _jsLoggerFull);
    
    /* Editables */
    _jsEditableCreated = new js.Callback.many((js.Proxy event,
                                               js.Proxy editable){
        
      AlohaEditable theEditable = new AlohaEditable(js.retain(editable), 
                                                    js.retain(event));
     _onEditableCreated.add(theEditable);
     
     });
    _alohaContext.bind('aloha-editable-created', _jsEditableCreated);
    
    _jsEditableDestroyed = new js.Callback.many((js.Proxy event,
                                                 js.Proxy ref){
      
      _onEditableDestroyed.add(null);
      
    });
    _alohaContext.bind('aloha-editable-destroyed', _jsEditableDestroyed);
    
    _jsEditableActivated = new js.Callback.many((js.Proxy event,
                                                 editableObjects){
      
      /* We always have the event and the current active editable */
      List editableList = null;
      js.Proxy editableEvent = js.retain(event);
      js.Proxy activeEditable = js.retain(editableObjects.editable);
      AlohaEditable editable = new AlohaEditable(activeEditable, editableEvent);
      /* See if we have an old editable, if so pass it back. */
      try {
      js.Proxy oldActiveEditable =  js.retain(editableObjects.old);
      AlohaEditable oldEditable = new AlohaEditable(oldActiveEditable, editableEvent);
      editableList = [editable, oldEditable];
      } catch(e) {
        
        editableList = [editable];
        
      }
          
      _onEditableActivated.add(editableList);
      
    });
    _alohaContext.bind('aloha-editable-activated', _jsEditableActivated);
    
    _jsEditableDeactivated = new js.Callback.many((js.Proxy event,
                                                   js.Proxy editable){
      
      AlohaEditable theEditable = new AlohaEditable(js.retain(editable.editable), 
                                                    js.retain(event));
     _onEditableDeactivated.add(theEditable);
     
     });
    _alohaContext.bind('aloha-editable-deactivated', _jsEditableDeactivated);
   
    /* Content changes */
    _jsSmartContentChange = new js.Callback.many((js.Proxy event,
                                                  Object parameters){
      
      AlohaEditable theEditable = new AlohaEditable(js.retain(parameters.editable), 
                                                    js.retain(event));
      AlohaSmartContentChangeParameters params = new AlohaSmartContentChangeParameters(
                                                        theEditable,
                                                        parameters.keyIdentifier,
                                                        parameters.keyCode,
                                                        parameters.char,
                                                        parameters.triggerType,
                                                        parameters.getSnapshotContent());
      _onSmartContentChange.add(params);
     
     });
    _alohaContext.bind('aloha-smart-content-changed',_jsSmartContentChange );
    
    _jsBlockSelected = new js.Callback.many((js.Proxy event,
                                             Object element){
      
      
      _onBlockSelectedChange.add(element);
     
     });
    _alohaContext.bind('aloha-block-selected',_jsBlockSelected );
    
    /* Plugins */
    _jsImageSelected = new js.Callback.many((js.Proxy e){
      
      _onImageSelected.add(null);
      
    });
    _alohaContext.bind('aloha-image-selected', _jsImageSelected);
    
    _jsImageUnselected = new js.Callback.many((js.Proxy e){
      
      _onImageUnselected.add(null);
      
    });
    _alohaContext.bind('aloha-image-unselected', _jsImageUnselected);
    
    _jsLinkSelected = new js.Callback.many((js.Proxy e){
      
      _onLinkSelected.add(null);
      
    });
    _alohaContext.bind('aloha-link-selected', _jsLinkSelected);
    
    _jsLinkUnselected = new js.Callback.many((js.Proxy e){
      
      _onLinkUnselected.add(null);
      
    });
    _alohaContext.bind('aloha-link-unselected', _jsLinkUnselected);
    
    _jsTableSelectionChanged = new js.Callback.many((js.Proxy e){
      
      _onTableSelectionChanged.add(null);
      
    });
    _alohaContext.bind('aloha-table-selection-changed', _jsTableSelectionChanged);
    
    _jsTableActivated = new js.Callback.many((js.Proxy e){
      
      _onTableActivated.add(null);
      
    });
    _alohaContext.bind('aloha-table-activated', _jsTableActivated);
    
    _jsDdfAllFilesPrepared = new js.Callback.many((js.Proxy e){
      
      _onDdfAllFilesPrepared.add(null);
      
    });
    _alohaContext.bind('aloha-allfiles-upload-prepared', _jsDdfAllFilesPrepared);
    
    _jsDdfFilesDroppedInPage = new js.Callback.many((js.Proxy e,
                                                     Object element){
      
      _onDdfFilesDroppedInPage.add(element);
      
    });
    _alohaContext.bind('aloha-drop-files-in-page', _jsDdfFilesDroppedInPage);
    
    _jsDdfFileUploadPrepared = new js.Callback.many((js.Proxy e,
                                                     Object element){
      
      _onDdfFileUploadPrepared.add(element);
      
    });
    _alohaContext.bind('aloha-file-upload-prepared', _jsDdfFileUploadPrepared);
    
    
  }
  
  
  /**
   * Version string
   */
  String get version => _alohaContext.version;
  
  List<AlohaEditable> _getEditablesAsList() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    List editablesList = new List<AlohaEditable>();
    
    try {
      int length = _alohaContext.editables.length;
      for ( int i = 0; i<length; i++) {
      
        AlohaEditable editable = new AlohaEditable(js.retain(_alohaContext.editables[i]));
        editablesList.add(editable);
      }
      
    } catch(e) {
      
      editablesList = null;
      
    }
    
    return editablesList;
  }
  /**
   * List of currently maintained editables as a List of AlohaEditable's.
   */
  get editables => _getEditablesAsList();
  
  AlohaEditable _getActiveEditable() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    try {
      
      AlohaEditable editable = new AlohaEditable(
          js.retain(_alohaContext.activeEditable));
      return editable;
      
    } catch(e) {
      
      return null;
      
    }
     
  }
  /**
   * Currently active editable as an AlohaEditable
   */
  get activeEditable => _getActiveEditable();
  
  /**
   * Settings
   * We have no way of knowing what settings have been applied to Aloha in its js startup
   * so you need to know the settings structure on the client side. The settings are returned
   * as a JSON string.
   */
  get settings =>  _context.JSON.stringify(_alohaContext.settings);
  
  /**
   * Defaults
   * Hardwired startup defaults, returned as a JSON string
   * 
   */
  get defaults => _context.JSON.stringify(_alohaContext.defaults);
  
  /**
   * OS name
   */
  get OSName => _alohaContext.OSName;
  
  /**
   * Loaded plugins, returned a list of plugin name strings
   */
  get loadedPlugins => _alohaContext.loadedPlugins.toString().split(',');
  
  /**
   * Initialization
   * Use to set Aloha back to its original state
   */
  void reinitialise() {
    
    _alohaContext.init();
    
  }
  
  /**
   * Currently loaded plugins
   */
  List getLoadedPlugins() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return loadedPlugins;
    
  }
  
  /**
   * Is a plugin loaded
   */
  bool isPluginLoaded(String pluginName) {
    
    return  _alohaContext.isPluginLoaded(pluginName);
    
  }
  
  /**
   * Get an editable by its id attribute, returns null if none found
   */
  AlohaEditable getEditableById(String id) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    try {
    
      js.Proxy editableProxy = _alohaContext.getEditableById(id);
      AlohaEditable theEditable = new AlohaEditable(js.retain(editableProxy));
      return theEditable;
      
    } catch(e) {
      
      return null;
      
    }
    
  }
  
  /**
   * Activate the specified editable, also deactivates all other editables.
   * 
   * Note this does NOT set the isActive flag on the editable itself, it just
   * deactivates all other editables by setting the active flag to false then 
   * makes the editable supplied the activeEditable.
   */
  void activateEditable(AlohaEditable editable) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    js.Proxy editableProxy = editable.proxy;
    _alohaContext.activateEditable(editableProxy);
    
  }
  
  /**
   * Get the active editable, null if none active
   */
  AlohaEditable getActiveEditable() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    try {
      
      js.Proxy editableProxy = _alohaContext.getActiveEditable();
      AlohaEditable theEditable = new AlohaEditable(js.retain(editableProxy));
      return theEditable;
      
    } catch(e) {
      
      return null;
      
    }
    
  }
  
  /**
   * Deactivate the active editable
   */
  void deactivateActiveEditable() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    _alohaContext.deactivateEditable();
    
  }
  
  /**
   * Check if an object is an editable.
   * 
   * This check is performed in the class, its not passed through to the 
   * Aloha API, Aloha uses javascript object comparison which is not robust,
   * we can better do this ourselves.
   */
  bool isAnEditable(Object  anyObject) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    /* If we are an AlohaEditable then we are an editable */
    if ( anyObject.runtimeType.toString() == 'AlohaEditable' ) return true;
    
    /* We must at least be a Proxy object to be an editable */
    if ( anyObject.runtimeType.toString() != 'Proxy' ) return false;
    
    /* Check if the object is in the editables list */
    int length = _alohaContext.editables.length;
    for ( int i=0; i<length; i++) {
      
      if ( anyObject == _alohaContext.editables[i]) return true;
      
    }
    
  }
  
  /**
   * Get editable host.
   * 
   * Gets the nearest editable parent of the HTML element contained in the
   * element parameter. Returns null if none found.
   */
  AlohaEditable getEditableHost(HtmlElement element) {
    
   if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha'); 
   String jQueryId = '#' + element.id;
   js.Proxy jQueryElement = _alohajQueryContext(jQueryId);
   js.Proxy proxy = _alohaContext.getEditableHost(jQueryElement);
   if ( proxy == null ) return null;
   AlohaEditable editable = new AlohaEditable(js.retain(proxy));
   return editable;
   
    
  }
  
  /**
   * Register an editable. 
   */
  void registerEditable(AlohaEditable editable) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    _alohaContext.registerEditable(editable.proxy);
    
  }
  
  /**
   * Unregister an editable. 
   */
  void unregisterEditable(AlohaEditable editable) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    _alohaContext.unregisterEditable(editable.proxy);
    
  }

  /**
   * Get the Aloha url.
   * 
   * Aloha's baseUrl setting or "" if not set
   */
  String getUrl() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return _alohaContext.getAlohaUrl();
    
  }
  
  /**
   * Gets a plugin's url.
   * 
   * Given the name returns the plugin url as a string
   */
  String getPluginUrl(String name) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return _alohaContext.getPluginUrl(name);
    
  }
  
  /**
   * Logs a message to the console.
   * 
   * Takes the log level, the logging component name and the
   * log message itself.
   */
  void log(String level, String component, String message) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');   
    _alohaContext.log(level, component, message);
    
  }
  
  /**
   * execCommand implements the commands from the commmand manager section
   * See the relevant Mozilla documentation here for details.
   * https://developer.mozilla.org/en/docs/Rich-Text_Editing_in_Mozilla
   */
  void execCommand(String commandId,
                  { bool showUi:false,
                    String value: null}) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    _alohaContext.execCommand(commandId, showUi, value, null);
    
  }
  
  /**
   * Query command enabled.
   * 
   * If the command is available and not disabled or the active range 
   * is not null the command is enabled, True indicates this.
   * 
   * TODO range option needs to be added, uses current range selection. 
   */
  bool queryCommandEnabled(String commandId) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return _alohaContext.queryCommandEnabled(commandId, null);
    
  }
  
  
  /**
   * Query command supported.
   * 
   * Returns true if the command is supported.
   */
  bool queryCommandSupported(String commandId) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return _alohaContext.queryCommandSupported(commandId);
    
  }
  
  /**
   * Return the commands value.
   * 
   * 
   * TODO range option needs to be added, uses current range selection. 
   */
  String queryCommandValue(String commandId) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    return  _alohaContext.queryCommandValue(commandId, null);
    
  }
  
  /**
   * Query supported commands.
   * 
   * Returns a list of supported commands.
   * 
   */
  List querySupportedCommands() {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    
    var proxy = _alohaContext.querySupportedCommands();
    
    List commands = new List<String>();
    
    try {
      int length = proxy.length;
      for ( int i = 0; i<length; i++) {
      
        commands.add(proxy[i]);
      }
      
    } catch(e) {
      
      commands = null;
      
    }
    
    return commands;
    
  }
  
 
  /**
   * Attach jQuery selectors to Aloha to make them editable entities.
   */
  void attachEditable(String selector) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    alohajQueryContext(selector).aloha();
    
  }
  
  /**
   * Detach jQuery selectors from Aloha to make previous editables non-editable 
   * entities.
   * If they were previously editable they will be destroyed.
   */
  void detachEditable(String selector) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    alohajQueryContext(selector).mahalo();
    
  }
  
  /**
   * Disable object resizing if the browser supports this.
   */
  void disableObjectResizing(){
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    _alohaContext.disableObjectResizing();
    
  }
  
  /**
   * To string override
   */
  String toString() {
    
    return 'Aloha';
    
  }
  
  
}