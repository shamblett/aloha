/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

import '../lib/aloha.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

Aloha alohaEditor = null;

main() {
  
  /* Setup */
  
  useHtmlConfiguration(true);
  
  /* Group 1 - Core event tests*/
  group("1. Core Events - ", () {
         
    test("Ready", () {  
      
      alohaEditor = new Aloha();
      alohaEditor.readyEvent.listen( (e) {
        
        alohaEditor.attachEditable('.editable');
        expect(true, isTrue);
      });   
      
    }); 
    
    test("Not Ready", () {  
      
      alohaEditor.isReady = false;
      expect(()=> alohaEditor.attachEditable('.editable'),
          throwsA(new isInstanceOf<AlohaException>('Not ready, re-initialise Aloha')));  
      alohaEditor.isReady = true;
      expect(alohaEditor.isReady, isTrue);
      
    });
 
  });
  

  /*
  
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
  
  */
}