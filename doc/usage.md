# Aloha HTML5 Editor Bindings

This package provides bindings for the Aloha HTML5 editor found [here.](http://www.aloha-editor.org)

It allows the Aloha API to be accessed from Dart as though you were calling the Aloha API itself from
javascript on the page. Familiarity with Aloha itself is assumed. 

## Functionality

In this version the core Aloha API is available(see Omissions below), along with the editables API.
Nearly all of the core Aloha events are wrapped, including plugins.

The repository and registry API is not included, however the API provided is more than needed to
interface usefully to Aloha and get edited content for storage via AJAX or locally.


## Setup

The setup of Aloha on the web page in question is as documented on the Aloha site. 

Taking the Aloha.html
file from the test directory we have the following sections :-

    <!-- load the jQuery and require.js libraries -->
    <script type="text/javascript" src="http://cdn.aloha-editor.org/aloha-0.23.12/lib/require.js"></script>
    <script type="text/javascript" src="http://cdn.aloha-editor.org/aloha-0.23.12/lib/vendor/jquery-1.7.2.js"></script>

Loads the required jQuery and require js from Aloha's CDN. You can use a local copy of course and adjust
as needed.

    <script>
        var Aloha = window.Aloha || ( window.Aloha = {} );
        //Settings
        Aloha.settings = {logLevels: {'error': true, 'warn': true, 'info': true, 'debug': false}};                                                    
    </script>

Set Aloha's settings, see the Aloha site for actual settings. Note that the Aloha class only provides 
means to read the settings, not set them, this is inline with how Aloha operates.

    <!-- load the Aloha Editor core and some plugins -->
    <script src="http://cdn.aloha-editor.org/aloha-0.23.12/lib/aloha.js"
    data-aloha-plugins="common/ui,
                        common/format,
                        common/list,
                        common/link,
                        common/highlighteditables">
    </script>           
    <!-- load the Aloha Editor CSS styles -->
    <link href="http://cdn.aloha-editor.org/latest/css/aloha.css" rel="stylesheet" type="text/css" />

Finally load Aloha itself and its associated css if needed.

Ok at this point Aloha setup is done, we can now use it from Dart as shown in the examples below.

## Examples

To set your initial set of editable items attach a callback to the Ready event and use the attachEditable
method with a standard jQuery selector :-


    alohaEditor = new Aloha();
    alohaEditor.readyEvent.listen( (e) { 
        alohaEditor.attachEditable('.editable');
      });


Makes all elements of an 'editable' class Aloha editables.

To process an editable that has been updated and then loses focus i.e deactivated :-

    alohaEditor.editableDeactivatedEvent.listen((e){
        
        //e is an AlohaEditable object
        if ( e.isModified ) {
        
           String contents = e.getContents();
           String elementId = e.id;
           ...... send to server, do what you wish
        
      });

## Omissions

The main omissions in this version for core API functions are the absence of range and selection 
classes along with no Repository/Registry API. This means the following are not yet implemented :-

* The aloha-selection-changed and aloha-context-changed events.
* The aloha-link-href-change event.
* The aloha-drop-files-in-editable event.
* The aloha-upload-progress, aloha-upload-success, aloha-upload-failure, aloha-upload-abort and 
  aloha-upload-error events.
* Link Browser events.

## Testing

Testing is done using usual unittest tests with using the layout variant of htmlConfiguration.

Note that is nearly impossible to generate some events by mimicking screen movement in Dart code,
selections for instance. In these cases the event fired by Aloha is recreated in js on the test page
and simply fired. 

This may seem a bit of a cheat but keep in mind we are testing the Aloha class bindings here for correct
operation, not Aloha itself.

 