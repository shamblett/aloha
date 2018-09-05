/*
 * Package : aloha
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 23/09/2013
 * Copyright :  S.Hamblett@OSCF
 */

@TestOn("browser")

import 'package:aloha/aloha.dart';

import 'dart:html';
import 'dart:async';
import 'dart:js' as js;
import 'package:test/test.dart';

Aloha alohaEditor = null;

DivElement buttonSection = querySelector('#aloha-button-section');

ButtonElement createEventButton(String onClickScript) {
  buttonSection.children.clear();
  ButtonElement theButton = new ButtonElement();
  theButton.attributes['onclick'] = onClickScript;
  buttonSection.children.add(theButton);
  return theButton;
}

main() {
  /* Setup */
  alohaEditor = new Aloha();
  AlohaEditable regEditable = null;

  /* Group 1 - Core event tests*/
  group("1. Core Events - ", () {
    test("Ready", () {
      print("1.1");

      bool passed = false;
      alohaEditor.editableCreatedEvent.listen((e) {
        passed = true;
      });

      alohaEditor.readyEvent.listen((e) {
        /* Do this now, we will formally test it later */
        alohaEditor.attachEditable('.editable');
      });
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Not Ready", () {
      alohaEditor.isReady = false;
      expect(() => alohaEditor.attachEditable('.editable'),
          throwsA(const TypeMatcher<AlohaException>()));
      alohaEditor.isReady = true;
      expect(alohaEditor.isReady, isTrue);
    }, skip: false);

    test("Logging Ready", () {
      print("1.2");

      bool passed = false;
      alohaEditor.loggerReadyEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-logger-ready');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Log Full", () {
      print("1.3");

      bool passed = false;
      alohaEditor.loggerFullEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-log-full');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Command Will Execute", () {
      print("1.4");

      bool passed = false;
      alohaEditor.commandWillExecuteEvent.listen((e) {
        if (e.commandId != 'Bold') return;
        if (e.preventDefault) return;
        passed = true;
      });

      String script = "var evtObj = {commandId: 'Bold',preventDefault: false};"
          "Aloha.trigger('aloha-command-will-execute', evtObj);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Command Executed", () {
      print("1.5");

      bool passed = false;
      alohaEditor.commandExecutedEvent.listen((e) {
        if (e != 'Italic') return;
        passed = true;
      });

      String script = "Aloha.trigger('aloha-command-executed', 'Italic');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Editable created", () {
      print("1.6");

      bool passed = false;
      alohaEditor.editableCreatedEvent.listen((e) {
        passed = true;
      });

      /**
       *  Create an editable by adding the noweditable class to a previously
       *  not editable entity and adding it.
       */
      HeadingElement theEditableElement = querySelector('#alohaedit2');
      theEditableElement.classes.remove('noteditable');
      theEditableElement.classes.add('noweditable');
      alohaEditor.attachEditable('.noweditable');
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Editable destroyed", () {
      print("1.7");

      bool passed = false;
      alohaEditor.editableDestroyedEvent.listen((e) {
        passed = true;
      });

      /**
       *  Destroy an editable by adding the noteditable class to a previously
       *  editable entity and detaching it.
       */
      HeadingElement theEditableElement = querySelector('#alohaedit2');
      theEditableElement.classes.remove('noweditable');
      theEditableElement.classes.add('noteditable');
      alohaEditor.detachEditable('.noteditable');
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Editable Activated", () {
      print("1.8");

      bool passed = false;
      alohaEditor.editableActivatedEvent.listen((e) {
        if (!e[0].isActive) return;
        if (e[0].id != 'alohaedit1') return;
        passed = true;
      });

      /* To trigger the activated event we must do this through the page,
       * not any core API calls
       */
      HeadingElement theEditableElement = querySelector('#alohaedit1');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 50), expectAsync0(checkTest));
    }, skip: false);

    test("Editable Deactivated", () {
      print("1.9");

      bool passed = false;
      alohaEditor.editableDeactivatedEvent.listen((e) {
        if (e.isActive) return;
        if (e.id != 'alohaedit1') return;
        passed = true;
      });

      alohaEditor.deactivateActiveEditable();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Smart content changed", () {
      print("1.10");

      bool passed = false;
      alohaEditor.smartContentChangeEvent.listen((e) {
        if (e.char != null) return;
        if (e.triggerType != 'blur') return;
        if (e.keyCode != null) return;
        if (e.keyIdentifier != null) return;
        if (e.snapshotContent != 'Click to edit this paragraph.') return;
        passed = true;
      });
      /* Re-activate an editable */
      ParagraphElement theEditableElement = querySelector('#alohaedit3');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      /* Do a content change command */
      alohaEditor.execCommand('forwardDelete');
      /* Deactivate the editable to force the content change event */
      alohaEditor.deactivateActiveEditable();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 50), expectAsync0(checkTest));
    }, skip: false);

    test("Block Selected", () {
      print("1.11");

      bool passed = false;
      alohaEditor.blockSelectedEvent.listen((e) {
        if (e.innerHtml != 'This is an editable div container.') return;
        passed = true;
      });

      String script =
          "var block = \$('#cepara');Aloha.trigger('aloha-block-selected', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Image Selected", () {
      bool passed = false;
      alohaEditor.imageSelectedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-image-selected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Image Unselected", () {
      bool passed = false;
      alohaEditor.imageUnselectedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-image-unselected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Link Selected", () {
      print("1.12");

      bool passed = false;
      alohaEditor.linkSelectedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-link-selected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Link Unselected", () {
      print("1.13");

      bool passed = false;
      alohaEditor.linkUnselectedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-link-unselected');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Table Selection Changed", () {
      print("1.14");

      bool passed = false;
      alohaEditor.tableSelectionChangedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-table-selection-changed');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("Table Activated", () {
      print("1.15");

      bool passed = false;
      alohaEditor.tableActivatedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-table-activated');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("DDF All Files Prepared", () {
      print("1.16");

      bool passed = false;
      alohaEditor.ddfAllFilesPreparedEvent.listen((e) {
        passed = true;
      });

      String script = "Aloha.trigger('aloha-allfiles-upload-prepared');";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("DDF Files Dropped In Page", () {
      print("1.17");

      bool passed = false;
      alohaEditor.ddfFilesDroppedInPageEvent.listen((e) {
        if (e.innerHtml != 'Files Dropped Text') return;

        passed = true;
      });

      String script =
          "var block = \$('#filesdropped');Aloha.trigger('aloha-drop-files-in-page', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);

    test("DDF File Upload Prepared", () {
      print("1.18");

      bool passed = false;
      alohaEditor.ddfFileUploadPreparedEvent.listen((e) {
        if (e.innerHtml != 'Files Dropped Text') return;
        passed = true;
      });

      String script =
          "var block = \$('#filesdropped');Aloha.trigger('aloha-file-upload-prepared', block);";
      ButtonElement theButton = createEventButton(script);
      theButton.click();
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
    }, skip: false);
  });

  /* Group 2 - Core API tests*/
  group("2. Core API - ", () {
    test("Version", () {
      expect(alohaEditor.version, equals('0.23.27-SNAPSHOT'));
      print(">>> Aloha Version is ${alohaEditor.version}");
    });

    test("OSName", () {
      print("2.1");

      String correct = 'Failed';
      String osName = alohaEditor.OSName;
      switch (osName) {
        case 'Linux':
          correct = 'Passed';
          break;
        case 'Win':
          correct = 'Passed';
          break;
        case 'Unix':
          correct = 'Passed';
          break;
        case 'Unknown':
          correct = 'Passed';
          break;
        default:
          correct = "Failed, actual OSName is $osName";
      }
      expect(correct, equals('Passed'));
      print(">>> OsName is $osName");
    }, skip: false);

    test("Editables List", () {
      print("2.2");
      expect(alohaEditor.editables.length, equals(4));
    }, skip: false);

    test("Active Editable - Property", () {
      print("2.3");
      HeadingElement theEditableElement = querySelector('#alohaedit1');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      AlohaEditable editable = alohaEditor.activeEditable;
      expect(editable.id, equals('alohaedit1'));
    }, skip: false);

    test("Settings", () {
      print("2.4");
      expect(alohaEditor.settings['logLevels']['debug'], isFalse);
      expect(alohaEditor.settings['baseUrl'],
          equals('http://cdn.aloha-editor.org/latest/lib'));
    }, skip: false);

    test("Defaults", () {
      print("2.5");
      expect(alohaEditor.defaults['contentHandler']['getContents'][0],
          equals('blockelement'));
      expect(alohaEditor.defaults['contentHandler']['initEditable'][0],
          equals('blockelement'));
    }, skip: false);

    test("Loaded Plugins - Property", () {
      print("2.6");
      js.JsObject plugins = alohaEditor.loadedPlugins;
      expect(plugins[0], equals('format'));
      expect(plugins[2], equals('link'));
    }, skip: false);

    test("Reinitialise", () {
      print("2.7");

      bool passed = false;
      alohaEditor.loggerReadyEvent.listen((e) {
        passed = true;
      });
      void checkTest() => expect(passed, isTrue);
      new Timer(new Duration(milliseconds: 20), expectAsync0(checkTest));
      alohaEditor.reinitialise();
    }, skip: false);

    test("Loaded Plugins", () {
      print("2.8");
      js.JsObject plugins = alohaEditor.loadedPlugins;
      expect(plugins[0], equals('format'));
      expect(plugins[2], equals('link'));
    }, skip: false);

    test("Is Plugin Loaded", () {
      print("2.9");
      expect(alohaEditor.isPluginLoaded('format'), isTrue);
      expect(alohaEditor.isPluginLoaded('link'), isTrue);
    }, skip: false);

    test("Get Editable By Id", () {
      print("2.10");
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(editable.id, equals('alohaedit3'));
      AlohaEditable nullEditable = alohaEditor.getEditableById('alohaedit35');
      expect(nullEditable, isNull);
    }, skip: false);

    test("Activate Editable", () {
      print("2.11");
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(editable.id, equals('alohaedit3'));
      alohaEditor.activateEditable(editable);
      expect(alohaEditor.activeEditable.id, equals('alohaedit3'));
    }, skip: false);

    test("Get Activate Editable", () {
      print("2.12");
      expect(alohaEditor.getActiveEditable().id, equals('alohaedit3'));
    }, skip: false);

    test("Deactivate Activate Editable", () {
      print("2.13");
      alohaEditor.deactivateActiveEditable();
      expect(alohaEditor.getActiveEditable(), isNull);
    }, skip: false);

    test("Is An Editable", () {
      print("2.14");
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(alohaEditor.isAnEditable(editable), isTrue);
      List myList;
      expect(alohaEditor.isAnEditable(myList), isFalse);
    }, skip: false);

    test("Get Editable Host", () {
      print("2.15");
      HtmlElement element = querySelector('#cepara');
      AlohaEditable editable = alohaEditor.getEditableHost(element);
      expect(editable.id, equals('alohaedit4'));
      element = querySelector('#aloha-edit-section');
      editable = alohaEditor.getEditableHost(element);
      expect(editable, isNull);
    }, skip: false);

    test("Unregister Editable", () {
      print("2.16");
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      regEditable = editable;
      expect(alohaEditor.isAnEditable(regEditable), isTrue);
      alohaEditor.unregisterEditable(regEditable);
      AlohaEditable editable2 = alohaEditor.getEditableById('alohaedit3');
      expect(editable2, isNull);
    }, skip: false);

    test("Register Editable", () {
      print("2.17");
      alohaEditor.registerEditable(regEditable);
      AlohaEditable editable = alohaEditor.getEditableById('alohaedit3');
      expect(alohaEditor.isAnEditable(editable), isTrue);
    }, skip: false);

    test("URL", () {
      print("2.18");
      String url = alohaEditor.getUrl();
      expect(url, equals('http://cdn.aloha-editor.org/latest/lib'));
    }, skip: false);

    test("Plugin URL", () {
      print("2.19");
      String url = alohaEditor.getPluginUrl('format');
      expect(
          url,
          equals(
              'http://cdn.aloha-editor.org/latest/lib/../plugins/common/format'));
    }, skip: false);

    test("Log", () {
      print("2.20");
      alohaEditor.log("warn", "Dart", ">>> Log Test");
      alohaEditor.log("debug", "Dart", "This won't log");
    }, skip: false);

    test("Disable Object Resizing", () {
      print("2.21");
      alohaEditor.disableObjectResizing();
    }, skip: false);

    test("To String", () {
      print("2.22");
      String name = alohaEditor.toString();
      expect(name, 'Aloha');
    }, skip: false);
  });

  /* Group 3 - Command tests*/
  group("3.Commands - ", () {
    test("Query Command Enabled", () {
      print("3.1");
      ParagraphElement theEditableElement = querySelector('#alohaedit3');
      /* Focus, then click, need this sequence for Aloha */
      theEditableElement.focus();
      theEditableElement.click();
      bool state = alohaEditor.queryCommandEnabled('forwardDelete');
      expect(state, isTrue);
    }, skip: false);

    test("Execute Command", () {
      print("3.2");
      alohaEditor.execCommand('forwardDelete');
    }, skip: false);

    test("Query Command Supported", () {
      print("3.3");
      bool res = alohaEditor.queryCommandSupported('forwardDelete');
      expect(res, isTrue);
    }, skip: false);

    test("Query Command Value", () {
      print("3.4");
      String res = alohaEditor.queryCommandValue('forwardDelete');
      expect(res, isEmpty);
    }, skip: false);

    test("Query Supported Commands", () {
      print("3.5");
      List res = alohaEditor.querySupportedCommands();
      expect(res.length, isPositive);
    }, skip: false);
  });
}
