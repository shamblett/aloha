/*
 * Package : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

import '../lib/aloha.dart';

import 'dart:html';
import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:json_object/json_object.dart' as json;


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
  alohaEditor = new Aloha();
  AlohaEditable regEditable = null;

  /* Group 1 - Core event tests*/
  group("1. Core Events - ", () {
         
    test("Ready", () {  
         
      bool passed = false;  
      alohaEditor.readyEvent.listen( (e) {
      
        /* Do this now, we will formally test it later */      
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
    
    test("Editable created", () {  
      
      bool passed = false;
      alohaEditor.editableCreatedEvent.listen((e){
        
        print(">>> Editable Created OK");
        passed = true;
        
      });
      
      /**
       *  Create an editable by adding the noweditable class to a previously
       *  not editable entity and adding it.
       */
      HeadingElement theEditableElement = query('#alohaedit2');
      theEditableElement.classes.remove('noteditable');
      theEditableElement.classes.add('noweditable');
      alohaEditor.attachEditable('.noweditable');
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Editable destroyed", () {  
      
      bool passed = false;
      alohaEditor.editableDestroyedEvent.listen((e){
        
        print(">>> Editable Destroyed OK");
        passed = true;
        
      });
      
      /**
       *  Dedstroy an editable by adding the noteditable class to a previously
       *  editable entity and detaching it.
       */
      HeadingElement theEditableElement = query('#alohaedit2');
      theEditableElement.classes.remove('noweditable');
      theEditableElement.classes.add('noteditable');
      alohaEditor.detachEditable('.noteditable');
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Editable Activated", () {  
      
      bool passed = false;
      alohaEditor.editableActivatedEvent.listen((e){
        
        if ( !e[0].isActive ) return;
        if ( e[0].id != 'alohaedit1') return;
        print(">>> Editable Activated OK");
        passed = true;
        
      });
      
      /* To trigger the activated event we must do this through the page,
       * not any core API calls
       */
      HeadingElement theEditableElement = query('#alohaedit1');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
     
    });
    
    
    test("Editable Deactivated", () {  
      
      bool passed = false;
      alohaEditor.editableDeactivatedEvent.listen((e){
        
        if ( e.isActive ) return;
        if ( e.id != 'alohaedit1') return;
        print(">>> Editable Deactivated OK");
        passed = true;
        
      });
      
      alohaEditor.deactivateActiveEditable();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
     
    });
    
    test("Smart content changed", () {  
      
      bool passed = false;
      alohaEditor.smartContentChangeEvent.listen((e){
        
        if ( e.char != null ) return;
        if ( e.triggerType != 'blur') return;
        if ( e.keyCode != null ) return;
        if ( e.keyIdentifier != null ) return;
        if ( e.snapshotContent != 'Click to edit this paragraph.') return;
        print(">>> Smart Content Change OK");
        passed = true;
        
      });
      /* Re-activate an editable */
      ParagraphElement theEditableElement = query('#alohaedit3');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      /* Do a content change command */
      alohaEditor.execCommand('forwardDelete');
      /* Deactivate the editable to force the content change event */
      alohaEditor.deactivateActiveEditable();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:50), expectAsync0(checkTest));
     
    });
    
    test("Block Selected", () {  
      
      bool passed = false;
      alohaEditor.blockSelectedEvent.listen((e){
        
        if ( e.innerHtml != 'This is an editable div container.') return;
        print(">>> Block Selected OK");
        passed = true;
        
      });
      String script = "var block = \$('#cepara');Aloha.trigger('aloha-block-selected', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Image Selected", () {  
      
      bool passed = false;
      alohaEditor.imageSelectedEvent.listen((e){
        
        print(">>> Image Selected OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-image-selected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Image Unselected", () {  
      
      bool passed = false;
      alohaEditor.imageUnselectedEvent.listen((e){
        
        print(">>> Image Unselected OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-image-unselected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });

    test("Link Selected", () {  
      
      bool passed = false;
      alohaEditor.linkSelectedEvent.listen((e){
        
        print(">>> Link Selected OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-link-selected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Link Unselected", () {  
      
      bool passed = false;
      alohaEditor.linkUnselectedEvent.listen((e){
        
        print(">>> Link Unselected OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-link-unselected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Table Selection Changed", () {  
      
      bool passed = false;
      alohaEditor.tableSelectionChangedEvent.listen((e){
        
        print(">>> Table Selection Changed OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-table-selection-changed');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("Table Activated", () {  
      
      bool passed = false;
      alohaEditor.tableActivatedEvent.listen((e){
        
        print(">>> Table Activated OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-table-activated');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });

    test("DDF All Files Prepared", () {  
      
      bool passed = false;
      alohaEditor.ddfAllFilesPreparedEvent.listen((e){
        
        print(">>> DDF All Files Prepared OK");
        passed = true;
        
      });
      String script = "Aloha.trigger('aloha-allfiles-upload-prepared');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("DDF Files Dropped In Page", () {  
      
      bool passed = false;
      alohaEditor.ddfFilesDroppedInPageEvent.listen((e){
        
        if ( e.innerHtml != 'Files Dropped Text') return;
        print(">>> DDF Files Dropped In Page OK");
        passed = true;
        
      });
      String script = "var block = \$('#filesdropped');Aloha.trigger('aloha-drop-files-in-page', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });
    
    test("DDF File Upload Prepared", () {  
      
      bool passed = false;
      alohaEditor.ddfFileUploadPreparedEvent.listen((e){
        
        if ( e.innerHtml != 'Files Dropped Text') return;
        print(">>> DDF File Upload Prepared OK");
        passed = true;
        
      });
      String script = "var block = \$('#filesdropped');Aloha.trigger('aloha-file-upload-prepared', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      
    });

  });
  
  /* Group 2 - Core API tests*/
  group("2. Core API- ", () {
         
    test("Version", () {  
      
      expect(alohaEditor.version, equals('0.23.12'));
      
    }); 
    
    test("OSName", () {  
      
      String correct = 'Failed';
      String osName = alohaEditor.OSName;
      switch ( osName ) {
        
        case 'Linux' : 
          correct = 'Passed';
          break;
        case 'Win' : 
          correct = 'Passed';
          break;
        case 'Unix' : 
          correct = 'Passed';
          break;
        case 'Unknown' : 
          correct = 'Passed';
          break;
        default:
          correct = "Failed, actual OSName is $osName";
          
      }
      expect(correct, equals('Passed'));
      print(">>> OsName is $osName");
      
    });

    test("Editables List", () {  
      
      var editables = alohaEditor.editables;
      expect(alohaEditor.editables.length, equals(4));
      
    }); 
    
    test("Active Editable - Property", () {  
      
      HeadingElement theEditableElement = query('#alohaedit1');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      AlohaEditable editable = alohaEditor.activeEditable;
      expect(editable.id, equals('alohaedit1'));
      
    }); 
    
    test("Settings", () {  
      
      json.JsonObject settings = new json.JsonObject.fromJsonString(alohaEditor.settings);
      expect(settings.logLevels.debug, isFalse);
      expect(settings.baseUrl, equals('http://cdn.aloha-editor.org/aloha-0.23.12/lib'));
      
    });
    
    test("Defaults", () {  
      
      
      json.JsonObject defaults = new json.JsonObject.fromJsonString(alohaEditor.defaults);
      expect(defaults.contentHandler.getContents[0], equals('blockelement'));
      expect(defaults.contentHandler.initEditable[0], equals('blockelement'));
     
      
    });
    
    test("Loaded Plugins - Property", () {  
      
      List plugins = alohaEditor.loadedPlugins;
      expect(plugins[0], equals('format'));
      expect(plugins[2], equals('link'));
      
    });
    
    test("Reinitialise", () {  
      
      bool passed = false;  
      alohaEditor.loggerReadyEvent.listen((e){
        
        passed = true;
        print(">>> Logging Ready After Initialise OK");
        
      });
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds:20), expectAsync0(checkTest));
      alohaEditor.reinitialise();
    });
    
    test("Loaded Plugins", () {  
      
      List plugins = alohaEditor.getLoadedPlugins();
      expect(plugins[0], equals('format'));
      expect(plugins[2], equals('link'));
      
    });
    
    test("Is Plugin Loaded", () {  
      
      expect(alohaEditor.isPluginLoaded('format'), isTrue);
      expect(alohaEditor.isPluginLoaded('link'), isTrue);
      
    });
    
    test("Get Editable By Id", () {  
      
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(editable.id, equals('alohaedit3'));
      AlohaEditable nullEditable = alohaEditor.getEditableById('alohaedit35');
      expect(nullEditable, isNull);
      
    });
    
    test("Activate Editable", () {  
      
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(editable.id, equals('alohaedit3'));
      alohaEditor.activateEditable(editable);
      expect(alohaEditor.activeEditable.id, equals('alohaedit3'));
      
    });
    
    test("Get Activate Editable", () {  
      
      expect(alohaEditor.getActiveEditable().id, equals('alohaedit3'));
      
    });
    
    test("Deactivate Activate Editable", () {  
      
      alohaEditor.deactivateActiveEditable();
      expect(alohaEditor.getActiveEditable(), isNull);
         
    });
    
    test("Is An Editable", () {  
      
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(alohaEditor.isAnEditable(editable), isTrue);
      List myList;
      expect(alohaEditor.isAnEditable(myList), isFalse);
     
      
    });
    
    test("Get Editable Host", () {  
      
      HtmlElement element = query('#cepara');
      AlohaEditable editable = alohaEditor.getEditableHost(element);
      expect(editable.id, equals('alohaedit4'));
      element = query('#aloha-edit-section');
      editable = alohaEditor.getEditableHost(element);
      expect(editable, isNull);
      
      
    });
    
    test("Unregister Editable", () {  
      
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      regEditable = editable;
      expect(alohaEditor.isAnEditable(regEditable), isTrue);
      alohaEditor.unregisterEditable(regEditable);
      AlohaEditable editable2 = alohaEditor.getEditableById('alohaedit3');
      expect(editable2, isNull);
    
    });
    
    test("Register Editable", () {  
      
      alohaEditor.registerEditable(regEditable);
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(alohaEditor.isAnEditable(editable), isTrue);
    
    });
    
    
    test("Log", () {  
      
      alohaEditor.log("warn", "Dart", ">>> Log Test");
      alohaEditor.log("debug", "Dart", "This won't log");
      
      
    });
    
  });
  
}