/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class Aloha {
   
  /**
   * Contexts and Aloha object proxies
   */
  
  js.Proxy _context  = js.retain(js.context);
  get jsContext => _context;
  
  js.Proxy _jQueryContext  = js.retain(js.context.jQuery);
  get jQueryContext => _jQueryContext;
  
  js.Proxy _alohaContext = js.retain(js.context.Aloha);
  get context => _alohaContext;
  
  js.Proxy _alohajQueryContext = js.retain(js.context.Aloha.jQuery);
  get alohajQueryContext => _alohajQueryContext;
  
  /**
   * State, the API calls check for this, if Aloha is not ready
   * an AlohaException is raised.
   */
  bool _ready = false;
  get isReady => _ready;
  set isReady(bool state) => _ready = state;
  
  /**
   * Callbacks and stream attachment for the Core events
   */
  
  /**
   *  Ready, NOT a broadcast event, only use one listener for this 
   */
  js.Callback _jsReady = null;
  final _onReady = new StreamController();
  get readyEvent => _onReady.stream;
 
  /**
   * Commands 
   */
  js.Callback _jsCommandWillExecute = null;
  final _onCommandWillExecute = new StreamController.broadcast();
  /**
   * Returned parameter is commandWillExecuteParameters class
   */
  get commandWillExecuteEvent => _onCommandWillExecute.stream;
 
  js.Callback _jsCommandExecuted = null;
  final _onCommandExecuted = new StreamController.broadcast();
  /**
   * Returned parameter is String
   */
  get commandExecutedEvent => _onCommandExecuted.stream;
  
  /**
   *  Logging 
   */
  js.Callback _jsLoggerReady = null;
  final _onLoggerReady = new StreamController.broadcast();
  get loggerReadyEvent => _onLoggerReady.stream;
  
  js.Callback _jsLoggerFull = null;
  final _onLoggerFull = new StreamController.broadcast();
  get loggerFullEvent => _onLoggerFull.stream;
  
  /**
   * Editables
   */
  js.Callback _jsEditableCreated = null;
  final _onEditableCreated = new StreamController.broadcast();
  /**
   * Returned parameter is an AlohaEditable class
   */
  get editableCreatedEvent => _onEditableCreated.stream;
  
  js.Callback _jsEditableDestroyed = null;
  final _onEditableDestroyed = new StreamController.broadcast();
  get editableDestroyedEvent => _onEditableDestroyed.stream;
  
  js.Callback _jsEditableActivated = null;
  final _onEditableActivated = new StreamController.broadcast();
  /**
   * Returned parameter is a list of the editable activated and the old 
   * editable that was active, both of AlohaEditable class. if there was
   * no old active editable(e.g first click on the page) none is supplied.
   *  [editable, oldEditable]
   */
  get editableActivatedEvent => _onEditableActivated.stream;
  
  /**
   * Construction, create and bind the callbacks for the core Aloha events. 
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
      
          commandWillExecuteParameters params = new commandWillExecuteParameters();
          params.commandId = jsParams.commandId;
          params.preventDefault = jsParams.preventDefault;
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
    
  }
  
  /**
   * Destruction
   */
  void _onDispose() {
    
    _onReady.close();
    _onCommandWillExecute.close();
    _onCommandExecuted.close();
    _onLoggerReady.close();
    _onLoggerFull.close();
    _onEditableCreated.close();
    _onEditableDestroyed.close();
    _onEditableActivated.close();
    
  }
  
  
  /**
   * Aloha core API
   */
  
  /**
   * Editables
   */
  AlohaEditable getEditableById(String id) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    js.Proxy editableProxy = _alohaContext.getEditableById(id);
    AlohaEditable theEditable = new AlohaEditable(editableProxy);
    return theEditable;
    
  }
  
  void activateEditable(AlohaEditable editable) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    js.Proxy editableProxy = editable.editableProxy();
    _alohaContext.activateEditable(editableProxy);
    
  }
  /**
   * Helper methods for Aloha object manipulation
   */
  
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
}