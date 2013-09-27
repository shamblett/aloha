/*
 * Packge : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

import '../lib/aloha.dart';

import 'dart:html';
import 'dart:async';
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
      bool passed = false;  
      alohaEditor.readyEvent.listen( (e) {
      
        alohaEditor.attachEditable('.editable');
        print(">>> Ready - Aloha ready");
        passed = true;
        
      });
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
    }); 
    
    test("Not Ready", () {  
      
      alohaEditor.isReady = false;
      expect(()=> alohaEditor.attachEditable('.editable'),
          throwsA(new isInstanceOf<AlohaException>('Not ready, re-initialise Aloha')));  
      alohaEditor.isReady = true;
      expect(alohaEditor.isReady, isTrue);
      
    });
    
    test("Logging Ready", () {  
      
      bool passed = false;  
      alohaEditor.loggerReadyEvent.listen((e){
        
        passed = true;
        print(">>> Logging Ready OK");
        
      });
      String script = "Aloha.trigger('aloha-logger-ready');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Log Full", () {  
      
      bool passed = false; 
      alohaEditor.loggerFullEvent.listen((e){
        
        print(">>> Logging Full OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-log-full');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Command Will Execute", () {  
      
      bool passed = false;
      alohaEditor.commandWillExecuteEvent.listen((e){
        
        if ( e.commandId != 'Bold') return;
        if ( e.preventDefault ) return;
        print(">>> Command Will Execute OK");
        passed = true;
        
      });
      String script = "var evtObj = {commandId: 'Bold',preventDefault: false};"
                      "Aloha.trigger('aloha-command-will-execute', evtObj);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Command Executed", () {  
      
      bool passed = false;
      alohaEditor.commandExecutedEvent.listen((e){
        
        if ( e != 'Italic') return;
        print(">>> Command Executed OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-command-executed', 'Italic');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
 
  });
  
}