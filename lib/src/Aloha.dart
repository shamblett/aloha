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
  
  /* Logging */
  js.Callback _jsLoggerReady = null;
  final _onLoggerReady = new StreamController.broadcast();
  get loggerReadyEvent => _onLoggerReady.stream;
  
  js.Callback _jsLoggerFull = null;
  final _onLoggerFull = new StreamController.broadcast();
  get loggerFullEvent => _onLoggerFull.stream;
  
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
    _jsCommandWillExecute = new js.Callback.many((js.Proxy e,
                                                 Object jsParams) {
      
          commandWillExecuteParameters params = new commandWillExecuteParameters();
          params.commandId = jsParams.commandId;
          params.preventDefault = jsParams.preventDefault;
          _onCommandWillExecute.add(params);
          
    });
    _alohaContext.bind('aloha-command-will-execute', _jsCommandWillExecute);
    
    _jsCommandExecuted = new js.Callback.many((js.Proxy e,
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
    
  }
  
  /**
   * Helper methods for Aloha object manipulation
   */
  
  /**
   * Attach jQuery selectors to Aloha to make them editable entities
   */
  void attachEditable(String selector) {
    
    if ( !_ready ) throw new AlohaException('Not ready, re-initialise Aloha');
    alohajQueryContext(selector).aloha();
    
  }
}