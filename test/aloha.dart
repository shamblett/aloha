/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

import '../lib/aloha.dart';

main() {
  
  Aloha alohaEditor = new Aloha();
  
  /* Ready */
  alohaEditor.readyEvent.listen( (e) {
    
    alohaEditor.attachEditable('.editable');
    print("Aloha is ready");
    
  });
  
  alohaEditor.commandWillExecuteEvent.listen ( (e) {
    
    print(e.commandId);
    print(e.preventDefault);
    
  });
  
  alohaEditor.commandExecutedEvent.listen ( (e) {
    
    print(e);
    
  });

  alohaEditor.loggerReadyEvent.listen ( (e) {
    
   print("Aloha logger is ready");
    
  });
  
  alohaEditor.loggerFullEvent.listen ( (e) {
    
   print("Aloha logger is full");
    
  });
  
  
}