/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

part of aloha;

class AlohaEditable {
  
  /**
   * The context for the editable
   */
  js.Proxy _context = null;
  get proxy => _context;
  
  /**
   * The event that triggered the creation of the editable, e.g 
   * the event from editableActivatedEvent. This is optional for this
   * class but if not supplied some API calls will throw an exception.
   */
  js.Proxy _event = null;
  set event(js.Proxy event) => _event = event;
  
  /**
   * Construction
   */
  AlohaEditable(this._context,
                [this._event]);
  
  /**
   * State
   */
  
  /* True, if this editable is active for editing */
  get isActive => _context.isActive;
  
  /**
   * Check if the editable has been modified during the edit process
   * Return boolean true if the editable has been modified.
   */
  get isModified => _context.isModified();
  
  /**
   * Marks the editables current state as unmodified. Use this method to inform the editable
   * that it's contents have been saved
   */
  void setUnmodified() {
     
    _context.setUnmodified();
    
  }
   
  /**
  * Check whether the editable has been disabled
  */
  get isDisabled => _context.isDisabled();
  
  /**
   * Disable this editable
   * A disabled editable cannot be written on by keyboard
   */
  void disable() {
     
    _context.disable();
     
  }
   
  /**
    * Enable this editable
    * Reenables a disabled editable to be writeable again
    */
  void enable() {
    
    _context.enable();
    
  }
  
  /**
   * API methods
   */
  
  /**
   * Check if object can be edited by Aloha Editor
   * return true if Aloha Editor can handle it.
   */
  bool get check => _context.check();
    
  /**
   * Initialise the placeholder
   */
  void initPlaceholder() {
    
    _context.initPlaceholder();
    
  }
  
  /**
   * Add placeholder in editable
   */
  void addPlaceholder() {
    
    _context.addPlaceholder();
    
  }
  
  /**
   * Remove placeholder from the content. If setCursor is true,
   * will also set the cursor to the start of the selection. However,
   * this will be ASYNCHRONOUS, so if you rely on the fact that
   * the placeholder is removed after calling this method, setCursor
   * should be false ( or not set )
   */
  void removePlaceholder([bool setCursor = false]) {
    
    _context.removePlaceholder(_context, setCursor);
    
  }
  /**
   * Check if the content is empty.
   */
  bool get isEmpty => _context.isEmpty();
 
  /**
   * String representation of the object
   */
  /**
   * For now, we can't pass toString through yet,
   * asked on SO
   */
  //TODO
  String toString() => 'Aloha.Editable';
    
    
    
  
  /**
   * Activates an editable for editing, disables all other active items
   */
  void activate() {
    
    if ( _event == null ) throw new AlohaException("AlohaEditable - Activate, no event specified");
    _context.activate(_event);
    
  }
  
  /**
   * Blur the editable
   */
  void blur() {
    
    _context.blur();
    
  }
  
  /**
   * Check if the string is empty as far as Aloha is concerned
   */
  bool empty(String str) {
    
    return _context.empty(str);
    
  }
  
  /**
   * Get the contents of this editable as a HTML string or child node DOM
   * objects.
   *
   * Boolean asObject Whether or not to retreive the contents of
   *                           this editable as child node objects or as
   *                           HTML string
   * defaults to string                          .
   * return {string|jQuery.<HTMLElement>} Contents of the editable as
   *                                       DOM objects or an HTML string.
   */
  dynamic getContents([bool asObject = false]) {
    
    return _context.getContents(asObject);
    
  }
  
  /**
   * Set the contents of this editable as a HTML string
   * String content as html
   * Boolean asObject return object is as object or html string, default is HTML.
   */
  dynamic setContents(String content, 
                      [bool asObject = false]) {
    
    return _context.setContents(content, asObject);
    
  }
  
  /**
   * Get the id of this editable
   */
  String get id => _context.getId();
    
  
  /**
   * Get a snapshot of the active editable as a HTML string
   */
  String get snapshotContent => _context.getSnapshotContent();
    
  
  /**
   * Sets the content serializer function.
   *
   * The default content serializer will just call the jQuery.html()
   * function on the editable element (which gets the innerHTML property).
   *
   * This method is a static class method and will affect the result
   * of editable.getContents() for all editables that have been or
   * will be constructed.
   *
   * Dynamic serializerFunction
   *        A function that accepts a DOM element and returns the serialized
   *        XHTML of the element contents (excluding the start and end tag of
   *        the passed element).
   * js.Proxy context, the aAloha editable context ,usually Aloha.Editable
   */
  static void setContentSerializer(dynamic serializerFunction,
                                   js.Proxy context) {
    
    context.contentSerializer = serializerFunction;
    
  }
  
  /**
   * Gets the content serializer function.
   * 
   * js.Proxy context, the Aloha editable context ,usually Aloha.Editable
   */
  static dynamic getContentSerializer(js.Proxy context) {
    
    return context.contextSerializer;
    
  }
  
  /**
   * Destroy the editable
   */
  void destroy() {
    
    _context.destroy();
    js.release(_context);
    if (  _event != null ) js.release(_event);
    
  }
  
  
  
}
