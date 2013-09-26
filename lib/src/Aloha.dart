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
   * State 
   */
  bool _ready = false;
  get isReady => _ready;
  set isReady(bool state) => _ready = state;
  
  /**
   * Callbacks and stream attachment
   */
  
  /* Ready, NOT a broadcast event, only use one listener for this */
  js.Callback _jsReady;
  final _onReady = new StreamController();
  get readyEvent => _onReady.stream;
 
  /* Commands */
  js.Callback _jsCommandWillExecute;
  final _onCommandWillExecute = new StreamController
                <commandWillExecuteParameters>.broadcast();
  get commandWillExecuteEvent => _onCommandWillExecute.stream;
 
  js.Callback _jsCommandExecuted;
  final _onCommandExecuted = new StreamController<String>.broadcast();
  get commandExecutedEvent => _onCommandExecuted.stream;
  
  /* Logging */
  js.Callback _jsLoggerReady;
  final _onLoggerReady = new StreamController.broadcast();
  get loggerReadyEvent => _onLoggerReady.stream;
  
  js.Callback _jsLoggerFull;
  final _onLoggerFull = new StreamController.broadcast();
  get loggerFullEvent => _onLoggerFull.stream;
  
  /**
   * Construction, create the callbacks and bind them to Aloha events.
   */
  Aloha() {
    
    /* Ready */
    _jsReady = new js.Callback.many((){
      
      _ready = true;
      _onReady.add(null);
      
    });
    _alohaContext.bind('aloha-ready', _jsReady);
    
    /* Commands */
    _jsCommandWillExecute = new js.Callback.many(
        (String commandId, bool preventDefault){
      
          commandWillExecuteParameters params;
          params.commandId = commandId;
          params.preventDefault = preventDefault;
          _onCommandWillExecute.add(params);
          
    });
    _alohaContext.bind('aloha-command-will-execute', _jsCommandWillExecute);
    
    _jsCommandExecuted = new js.Callback.many(
        (String commandId){
          
          _onCommandExecuted.add(commandId);
          
    });
    _alohaContext.bind('aloha-command-executed', _jsCommandExecuted);
    
    /* Logging */
    _jsLoggerReady = new js.Callback.many((){
      
      _onLoggerReady.add(null);
      
    });
    _alohaContext.bind('aloha-logger-ready', _jsLoggerReady);
    
    _jsLoggerFull = new js.Callback.many((){
      
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