/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class Aloha {
   
  /**
   * Context and Aloha object proxies
   */
  
  js.Proxy _context  = js.retain(js.context);
  get jsContext => _context;
  
  js.Proxy _jQueryContext  = js.retain(js.context.jQuery);
  get jQueryContext => _jQuerycontext;
  
  js.Proxy _alohaContext = js.retain(js.context.Aloha);
  get context => _alohaContext;
  
  js.Proxy _alohajQueryContext = js.retain(js.context.Aloha.jQuery);
  get alohajQueryContext => _alohajQueryContext;
  
  /**
   * State 
   */
  bool _isReady = false;
  get isReady => _isReady;
  
  /**
   * Callbacks and stream attachment
   */
  js.Callback _jsReady;
  final _onReady = new StreamController();
  get ready => _onReady.stream;
  
  /**
   * Construction
   */
  Aloha() {
    
    _jsReady = new js.Callback.many((){
      
      _isReady = true;
      _onReady.add(null);
      
    });
    _alohaContext.bind('aloha-ready', _jsReady);
    
  }
  
  /**
   * Destruction
   */
  void _onDispose() {
    _onReady.close();
    
  }
  
  /**
   * Attach jQuery selectors to Aloha to make them editable entities
   */
  void attachEditable(String selector) {
    
    alohajQueryContext(selector).aloha();
    
  }
}