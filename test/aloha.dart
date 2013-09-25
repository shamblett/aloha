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
  alohaEditor.ready.listen( (e) {
    
    alohaEditor.attachEditable('.editable');
    
  });
    
}