/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

import '../lib/aloha.dart';

import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

Aloha alohaEditor = null;

DivElement buttonSection = query('#aloha-button-section');

ButtonElement createEventButton(String onClickScript){
  
  buttonSection.children.clear();
  ButtonElement theButton = new ButtonElement();
  theButton.attributes['onclick'] = onClickScript;
  buttonSection.children.add(theButton);
  return theButton;
  
}
main() {
  
  /* Setup */
  
  useHtmlConfiguration(true);
  
  /* Group 1 - Core event tests*/
  group("1. Core Events - ", () {
         
    test("Ready", () {  
      
      alohaEditor = new Aloha();
      alohaEditor.readyEvent.listen( (e) {
        
        alohaEditor.attachEditable('.editable');
        print(">>> Ready - Aloha ready");
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
    
    test("Logging Ready", () {  
      
      
      alohaEditor.loggerReadyEvent.listen((e){
        
        expect(true, isTrue);
        print(">>> Logging Ready OK");
        
      });
      String script = "Aloha.trigger('aloha-logger-ready');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      
    });
    
    test("Log Full", () {  
      
      
      alohaEditor.loggerFullEvent.listen((e){
        
        expect(true, isTrue);
        print(">>> Logging Full OK");
        
      });
      String script = "Aloha.trigger('aloha-log-full');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      
    });
    
    test("Command Will Execute", () {  
      
      
      alohaEditor.commandWillExecuteEvent.listen((e){
        
        expect(true, isTrue);
        expect(e.commandId, equals('Boldooo'));
        expect(e.preventDefault, isFalse);
        print(">>> Command Will Execute OK");
        
      });
      String script = "var evtObj = {commandId: 'Bold',preventDefault: false};"
                      "Aloha.trigger('aloha-command-will-execute', evtObj);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      
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