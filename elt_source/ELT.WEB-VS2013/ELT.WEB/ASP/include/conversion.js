
var debug1 = true;
var debug2 = true;
var escapeMap = '';
var CPstring = '';


var hexNum = { 0:1, 1:1, 2:1, 3:1, 4:1, 5:1, 6:1, 7:1, 8:1, 9:1, 
				A:1, B:1, C:1, D:1, E:1, F:1, 
				a:1, b:1, c:1, d:1, e:1, f:1 };
var jEscape = { 0:1, b:1, t:1, n:1, v:1, f:1, r:1 };
var decDigit = { 0:1, 1:1, 2:1, 3:1, 4:1, 5:1, 6:1, 7:1, 8:1, 9:1 };


function dec2hex ( textString ) {
 return (textString+0).toString(16).toUpperCase();
}

function  dec2hex2 ( textString ) {
  var hexequiv = new Array ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
  return hexequiv[(textString >> 4) & 0xF] + hexequiv[textString & 0xF];
}

function  dec2hex4 ( textString ) {
  var hexequiv = new Array ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
  return hexequiv[(textString >> 12) & 0xF] + hexequiv[(textString >> 8) & 0xF] + hexequiv[(textString >> 4) & 0xF] + hexequiv[textString & 0xF];
}

function getCPfromChar ( textString ) {
	// converts a character or sequence of characters to hex codepoint values
	// copes with supplementary characters
	// returned values include a space between each hex value and at the end
	var codepoint = "";
	var haut = 0;
	var n = 0; 
	for (var i = 0; i < textString.length; i++) {
		var b = textString.charCodeAt(i); 
		if (b < 0 || b > 0xFFFF) {
			codepoint += 'Error: Initial byte out of range in getCPfromChar: '+dec2hex(b);
			}
		if (haut != 0) { // we should be dealing with the second part of a supplementary character
			if (0xDC00 <= b && b <= 0xDFFF) {
				codepoint += dec2hex(0x10000 + ((haut - 0xD800) << 10) + (b - 0xDC00)) + ' ';
				haut = 0;
				continue;
				}
			else {
				codepoint += 'Error: Second byte out of range in getCPfromChar: '+dec2hex(haut);
				haut = 0;
				}
			}
		if (0xD800 <= b && b <= 0xDBFF) { //b is the first part of a supplementary character
			haut = b;
			}
		else { // this is not a supplementary character
//			codepoint += dec2hex(b);
			codepoint += b.toString(16).toUpperCase()+' ';
			}
		} 
 //alert('>'+codepoint+'<');
	return codepoint;
	}


function convert2C (value) {
	convertjEsc2CP(value);
	
	var outputString = '';
	if (CPstring == '') { return ""; }
	var listArray = CPstring.split(' ');
	for ( var i = 0; i < listArray.length; i++ ) {
		code = parseInt(listArray[i], 16);

		switch (code) {
			case 0: outputString += '\\0'; break;
			case 7: outputString += '\\a'; break;
			case 8: outputString += '\\b'; break;
			case 9: outputString += '\\t'; break;
			case 10: outputString += '\\n'; break;
			case 11: outputString += '\\v'; break;
			case 12: outputString += '\\f'; break;
			case 13: outputString += '\\r'; break;
			case 27: outputString += '\\e'; break;
			case 34: outputString += '\\\"'; break;
			case 39: outputString += '\\\''; break;
			case 92: outputString += '\\\\'; break;
			default: if (code > 0x1f && code < 0x7F) { outputString += String.fromCharCode(code); }
					else if (code > 0xFFFF) { 
						if (listArray[i].length == 5) { pad = '000'; }
						else if (listArray[i].length == 6) { pad = '00'; }
						else if (listArray[i].length == 7) { pad = '0'; }
						outputString += '\\U'+pad+listArray[i]; 
						}
					else { 
						pad = '';
						if (listArray[i].length == 1) { pad = '000'; }
						else if (listArray[i].length == 2) { pad = '00'; }
						else if (listArray[i].length == 3) { pad = '0'; }
						outputString += '\\u'+pad+listArray[i]; 
						}
			}
		}
	return( outputString );
	}


function convertHexNCR2Ascii () {
	convertHexNCR2CP(hexNCRs.value);
	
	var outputString = "";
	CPstring = CPstring.replace(/^\s+/, '');
	if (CPstring.length == 0) { return ""; }
	CPstring = CPstring.replace(/\s+/g, ' ');
	var listArray = CPstring.split(' ');
	
	for ( var i = 0; i < listArray.length; i++ ) {
		var n = parseInt(listArray[i], 16); 
		if (n > 0x1f && n < 0x7F) { outputString += String.fromCharCode(n); }
		else { outputString += '&#x' + dec2hex(n) + ';'; }
		}
	hexNCRs.value = outputString;
	}



function convertDecNCR2Ascii () {
	convertDecNCR2CP(decNCRs.value);
	
	var outputString = "";
	CPstring = CPstring.replace(/^\s+/, '');
	if (CPstring.length == 0) { return ""; }
	CPstring = CPstring.replace(/\s+/g, ' ');
	var listArray = CPstring.split(' ');
	
	for ( var i = 0; i < listArray.length; i++ ) {
		var n = parseInt(listArray[i], 16); 
		if (n > 0x1f && n < 0x7F) { outputString += String.fromCharCode(n); }
		else { outputString += '&#' + n + ';'; }
		}
	decNCRs.value = outputString;
	}



// ================ CP to XX ============================

function convertCP2Char ( textString ) {
  var outputString = '';
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  	textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var n = parseInt(listArray[i], 16);
    if (n <= 0xFFFF) {
      outputString += String.fromCharCode(n);
    } else if (n <= 0x10FFFF) {
      n -= 0x10000
      outputString += String.fromCharCode(0xD800 | (n >> 10)) + String.fromCharCode(0xDC00 | (n & 0x3FF));
    } else {
      outputString += 'convertCP2Char error: Code point out of range: '+dec2hex(n);
    }
  }
  return( outputString );
}


function convertCP2XML ( textString ) {
	var outputString = '';
	textString = textString.replace(/^\s+/, '');
	if (textString.length == 0) { return ""; }
	
	textString = textString.replace(/\s+/g, ' ');
	var listArray = textString.split(' ');
	for ( var i = 0; i < listArray.length; i++ ) {
		var n = parseInt(listArray[i], 16);
		if (n <= 0xFFFF) { 
			switch (n) {
				case 34: outputString += '&quot;'; break;
				case 38: outputString += '&amp;'; break;
				case 60: outputString += '&lt;'; break;
				case 62: outputString += '&gt;'; break;
				default: outputString += String.fromCharCode(n);
				}
			} 
		else if (n <= 0x10FFFF) {
			n -= 0x10000;
			outputString += String.fromCharCode(0xD800 | (n >> 10)) + String.fromCharCode(0xDC00 | (n & 0x3FF));
			} 
		else {
			outputString += 'convertCP2Char error: Code point out of range: '+dec2hex(n);
			}
		}
	return( outputString );
	}

	
function convertCP2Unicode () {
	var outputString = '';
	var pad = '';
	if (CPstring == '') { return ""; }
	var listArray = CPstring.split(' ');
	for ( var i = 0; i < listArray.length; i++ ) {
			pad = '';
			if (listArray[i].length == 1) { pad = '000'; }
			else if (listArray[i].length == 2) { pad = '00'; }
			else if (listArray[i].length == 3) { pad = '0'; }
			outputString += 'U+'+pad+listArray[i]+' ';
		}
	return( outputString );
	}


function convertCP2pEsc ( textString ) {
	// textstring: sequence of Unicode code points, derived from convertChar2CP()
	var outputString = "";
	// remove initial spaces
	textString = textString.replace(/^\s+/, '');
	if (textString.length == 0) { return ""; }
	// make all multiple spaces a single space
	textString = textString.replace(/\s+/g, ' ');
	var listArray = textString.split(' ');
	// process each codepoint
	for ( var i = 0; i < listArray.length; i++ ) {
		var n = parseInt(listArray[i], 16);
		//if (i > 0) { outputString += ' ';}
		if (n == 0x20) { outputString += '%20'; }
		else if (n >= 0x41 && n <= 0x5A) { outputString += String.fromCharCode(n); } // alpha
		else if (n >= 0x61 && n <= 0x7A) { outputString += String.fromCharCode(n); } // alpha
		else if (n >= 0x30 && n <= 0x39) { outputString += String.fromCharCode(n); } // digits
		else if (n == 0x2D || n == 0x2E || n == 0x5F || n == 0x7E) { outputString += String.fromCharCode(n); } // - . _ ~
		else if (n <= 0x7F) { outputString += '%'+dec2hex2(n); }
		else if (n <= 0x7FF) { outputString += '%'+dec2hex2(0xC0 | ((n>>6) & 0x1F)) + '%' + dec2hex2(0x80 | (n & 0x3F)); } 
		else if (n <= 0xFFFF) { outputString += '%'+dec2hex2(0xE0 | ((n>>12) & 0x0F)) + '%' + dec2hex2(0x80 | ((n>>6) & 0x3F)) + '%' + dec2hex2(0x80 | (n & 0x3F)); } 
		else if (n <= 0x10FFFF) {outputString += '%'+dec2hex2(0xF0 | ((n>>18) & 0x07)) + '%' + dec2hex2(0x80 | ((n>>12) & 0x3F)) + '%' + dec2hex2(0x80 | ((n>>6) & 0x3F)) + '%' + dec2hex2(0x80 | (n & 0x3F)); } 
		else { outputString += '!Error ' + dec2hex(n) +'!'; }
		}
		return( outputString );
	}


function convertCP2HexNCR ( textString ) {
  var outputString = "";
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var n = parseInt(listArray[i], 16);
    outputString += '&#x' + dec2hex(n) + ';';
  }
  return( outputString );
}


function convertCP2DecNCR ( textString ) {
  var outputString = "";
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var n = parseInt(listArray[i], 16);
    outputString += ('&#' + n + ';');
  }
  return( outputString );
}


function convertCP2Dec ( textString ) {
  var outputString = "";
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    if (i > 0) { outputString += ' ';}
    var n = parseInt(listArray[i], 16);
    outputString += (n);
  }
  return( outputString );
}


function convertCP2UTF8 ( textString ) {
  var outputString = "";
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var n = parseInt(listArray[i], 16);
    if (i > 0) { outputString += ' ';}
    if (n <= 0x7F) {
      outputString += dec2hex2(n);
    } else if (n <= 0x7FF) {
      outputString += dec2hex2(0xC0 | ((n>>6) & 0x1F)) + ' ' + dec2hex2(0x80 | (n & 0x3F));
    } else if (n <= 0xFFFF) {
      outputString += dec2hex2(0xE0 | ((n>>12) & 0x0F)) + ' ' + dec2hex2(0x80 | ((n>>6) & 0x3F)) + ' ' + dec2hex2(0x80 | (n & 0x3F));
    } else if (n <= 0x10FFFF) {
      outputString += dec2hex2(0xF0 | ((n>>18) & 0x07)) + ' ' + dec2hex2(0x80 | ((n>>12) & 0x3F)) + ' ' + dec2hex2(0x80 | ((n>>6) & 0x3F)) + ' ' + dec2hex2(0x80 | (n & 0x3F));
    } else {
      outputString += '!erreur ' + dec2hex(n) +'!';
    }
  }
  return( outputString );
}


function convertCP2UTF16 ( textString ) {
  var outputString = "";
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var n = parseInt(listArray[i], 16);
    if (i > 0) { outputString += ' ';}
    if (n <= 0xFFFF) {
      outputString += dec2hex4(n);
    } else if (n <= 0x10FFFF) {
      n -= 0x10000
      outputString += dec2hex4(0xD800 | (n >> 10)) + ' ' + dec2hex4(0xDC00 | (n & 0x3FF));
    } else {
      outputString += '!erreur ' + dec2hex(n) +'!';
    }
  }
  return( outputString );
}


function convertCP2jEsc () {
	var outputString = '';
	if (CPstring == '') { return ""; }
	var listArray = CPstring.split(' ');
	for ( var i = 0; i < listArray.length; i++ ) {
		code = parseInt(listArray[i], 16);

		switch (code) {
			case 0: outputString += '\\0'; break;
			case 8: outputString += '\\b'; break;
			case 9: outputString += '\\t'; break;
			case 10: outputString += '\\n'; break;
			case 13: outputString += '\\r'; break;
			case 11: outputString += '\\v'; break;
			case 12: outputString += '\\f'; break;
			case 34: outputString += '\\\"'; break;
			case 39: outputString += '\\\''; break;
			case 92: outputString += '\\\\'; break;
			default: if (code > 0x1f && code < 0x7F) { outputString += String.fromCharCode(code); }
					else if (code > 0xFFFF) { 
						code -= 0x10000
						outputString += '\\u'+ dec2hex4(0xD800 | (code >> 10)) +'\\u'+ dec2hex4(0xDC00 | (code & 0x3FF));
						}
					else { 
						pad = '';
						if (listArray[i].length == 1) { pad = '000'; }
						else if (listArray[i].length == 2) { pad = '00'; }
						else if (listArray[i].length == 3) { pad = '0'; }
						outputString += '\\u'+pad+listArray[i]; 
						}
			}
		}
	return( outputString );
	}


function oldconvertCP2CSS () {
	var outputString = '';
	if (CPstring == '') { return ""; }
	var listArray = CPstring.split(' ');
	for ( var i = 0; i < listArray.length; i++ ) {
		code = parseInt(listArray[i], 16);

		if (code == 0x5C) { outputString += '\\\\'; }
		else if (code > 0x1f && code < 0x7F) { outputString += String.fromCharCode(code); }
		else { 
			pad = '';
			if (listArray[i].length == 1) { pad = '00000'; }
			else if (listArray[i].length == 2) { pad = '0000'; }
			else if (listArray[i].length == 3) { pad = '000'; }
			else if (listArray[i].length == 4) { pad = '00'; }
			else if (listArray[i].length == 5) { pad = '0'; }
			outputString += '\\'+pad+listArray[i]; 
			}
		}
	return( outputString );
	}


function convertCP2CSS () {
	var outputString = '';
	if (CPstring == '') { return ""; }
	var listArray = CPstring.split(' ');
	for ( var i=0; i<listArray.length; i++ ) {
		code = parseInt(listArray[i], 16);
		pad = '';
		
		if (code == 0x5C) { outputString += '\\\\'; }
		else if (code > 0x1f && code < 0x7F) { outputString += String.fromCharCode(code); }
		else if (code > 0x7E && code < 0x10000) { 
			if (listArray[i].length == 1) { pad = '000'; }
			else if (listArray[i].length == 2) { pad = '00'; }
			else if (listArray[i].length == 3) { pad = '0'; }
			outputString += '\\'+pad+listArray[i]+' '; 
			}
		else { 
			if (listArray[i].length == 1) { pad = '00000'; }
			else if (listArray[i].length == 2) { pad = '0000'; }
			else if (listArray[i].length == 3) { pad = '000'; }
			else if (listArray[i].length == 4) { pad = '00'; }
			else if (listArray[i].length == 5) { pad = '0'; }
			outputString += '\\'+pad+listArray[i]+' '; 
			}
		}
	return( outputString );
	}




// ================ XX to CP  ============================

function convertChar2CP ( textString ) { 
	var haut = 0;
	var n = 0;
	CPstring = '';
	for (var i = 0; i < textString.length; i++) {
		var b = textString.charCodeAt(i); 
		if (b < 0 || b > 0xFFFF) {
			CPstring += 'Error ' + dec2hex(b) + '!';
			}
		if (haut != 0) {
			if (0xDC00 <= b && b <= 0xDFFF) {
				CPstring += dec2hex(0x10000 + ((haut - 0xD800) << 10) + (b - 0xDC00)) + ' ';
				haut = 0;
				continue;
				}
			else {
				CPstring += '!erreur ' + dec2hex(haut) + '!';
				haut = 0;
				}
			}
		if (0xD800 <= b && b <= 0xDBFF) {
			haut = b;
			}
		else {
			CPstring += dec2hex(b) + ' ';
			}
		}
	CPstring = CPstring.substring(0, CPstring.length-1);

	codePoints.value = CPstring;
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertUnicode2CP ( textString ) { 
	// convert whole string to chars before starting (allows for mixed strings)
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';
	
	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		if (i<textString.length-3 && textString.charAt(i) == 'U' 
			&& textString.charAt(i+1) == '+' && textString.charAt(i+2) in hexNum) { // U+A
			tempString = '';
			i += 2;
			while (i<textString.length-1 && textString.charAt(i) in hexNum) { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			charStr += convertCP2Char(tempString); i--;
//			if (!(textString.charAt(i) in hexNum)) {
//				charStr += convertCP2Char(tempString);
//				}
//			else { charStr += 'U+'+tempString; i--; }
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	codePoints.value = CPstring;
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertpEsc2CP ( textString ) {
	// textstring: sequence of percent-escaped text
  CPstring = '';
	var outputString = "";
	var compte = 0;
	var n = 0;
	// remove all leading spaces
	textString = textString.replace(/^\s+/, '');
	if (textString.length == 0) { return ""; }
	// normalize all multiple spaces to a single space - note: there shouldn't be any spaces!
	textString = textString.replace(/\s+/g, ' ');
	// convert the whole string to percent escaped forms (to reduce work in coding)
	for ( var j = 0; j < textString.length; j++ ) {
		if (textString.charAt(j) == '%') { outputString += textString.slice(j, j+3); j += 2; }
		else { outputString += '%'+dec2hex(textString.charCodeAt(j)); }
		}
	textString = outputString; outputString = '';
	var listArray = textString.split('%');
	for ( var i = 1; i < listArray.length; i++ ) { // runs from 1 to eliminate first % (produces null array item)
		var b = parseInt(listArray[i], 16);   // alert('b:'+dec2hex(b));
		switch (compte) {
			case 0:
			if (0 <= b && b <= 0x7F) {  // 0xxxxxxx
				outputString += dec2hex(b) + ' '; } 
			else if (0xC0 <= b && b <= 0xDF) {  // 110xxxxx
				compte = 1;
				n = b & 0x1F; }
			else if (0xE0 <= b && b <= 0xEF) {  // 1110xxxx
				compte = 2;
				n = b & 0xF; } 
			else if (0xF0 <= b && b <= 0xF7) {  // 11110xxx
				compte = 3;
				n = b & 0x7; } 
			else {
				outputString += '!erreur ' + dec2hex(b) + '! ';
				}
			break;
			case 1:
			if (b < 0x80 || b > 0xBF) {
				outputString += '!erreur ' + dec2hex(b) + '! ';
				}
			compte--;
			outputString += dec2hex((n << 6) | (b-0x80)) + ' ';
			n = 0;
			break;
			case 2: case 3:
			if (b < 0x80 || b > 0xBF) {
				outputString += '!erreur ' + dec2hex(b) + '! ';
				}
			n = (n << 6) | (b-0x80);
			compte--;
			break;
		}
	}
	CPstring = outputString.replace(/ $/, '');
	
	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}

	
function convertHexNCR2CP ( textString ) {
	// convert whole string to chars before starting (allows for mixed strings)
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';
	
	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		if (i<textString.length-4 && textString.charAt(i) == '&' 
			&& textString.charAt(i+1) == '#' && textString.charAt(i+2) == 'x'
			&& textString.charAt(i+3) in hexNum) { // &#x
			tempString = '';
			i += 3;
			while (i<textString.length-1 && textString.charAt(i) in hexNum) { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			if (textString.charAt(i) == ';') {
				charStr += convertCP2Char(tempString);
				}
			else { charStr += '&#x'+tempString; i--; }
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertDecNCR2CP ( textString ) {
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';
	
	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		if (i<textString.length-3 && textString.charAt(i) == '&' 
			&& textString.charAt(i+1) == '#' && textString.charAt(i+2) in decDigit) { // &#1
			tempString = '';
			i += 2;
			while (i<textString.length-1 && textString.charAt(i) in decDigit) { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			if (textString.charAt(i) == ';') { 
				charStr += convertCP2Char(parseInt(tempString).toString(16));
//alert(tempString);
				}
			else { charStr += '&#'+tempString; i--;}
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertHex2CP ( textString ) {
	CPstring = textString;
  
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertDec2CP ( textString ) {
	CPstring = '';
	var outputString = '';
	textString = textString.replace(/^\s+/, '');
	if (textString.length == 0) { return ""; }
	textString = textString.replace(/\s+/g, ' ');
	var listArray = textString.split(' ');
	for (var i = 0; i < listArray.length; i++) {
		if (i > 0) { outputString += ' ';}
		var n = parseInt(listArray[i], 10);
		outputString += dec2hex(n);
		}
	CPstring = outputString;
  
	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertUTF82CP ( textString ) {
  var outputString = "";
  CPstring = '';
  var compte = 0;
  var n = 0;
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var b = parseInt(listArray[i], 16);  // alert('b:'+dec2hex(b));
    switch (compte) {
      case 0:
        if (0 <= b && b <= 0x7F) {  // 0xxxxxxx
          outputString += dec2hex(b) + ' ';
        } else if (0xC0 <= b && b <= 0xDF) {  // 110xxxxx
          compte = 1;
          n = b & 0x1F;
        } else if (0xE0 <= b && b <= 0xEF) {  // 1110xxxx
          compte = 2;
          n = b & 0xF;
        } else if (0xF0 <= b && b <= 0xF7) {  // 11110xxx
          compte = 3;
          n = b & 0x7;
        } else {
          outputString += '!erreur ' + dec2hex(b) + '! ';
        }
        break;
      case 1:
        if (b < 0x80 || b > 0xBF) {
          outputString += '!erreur ' + dec2hex(b) + '! ';
        }
        compte--;
        outputString += dec2hex((n << 6) | (b-0x80)) + ' ';
        n = 0;
        break;
      case 2: case 3:
        if (b < 0x80 || b > 0xBF) {
          outputString += '!erreur ' + dec2hex(b) + '! ';
        }
        n = (n << 6) | (b-0x80);
        compte--;
        break;
    }
  }
    CPstring = outputString.replace(/ $/, '');
  
 	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}


function convertUTF162CP ( textString ) {
  CPstring = '';
  var outputString = "";
  var haut = 0;
  var n = 0;
  textString = textString.replace(/^\s+/, '');
  if (textString.length == 0) { return ""; }
  textString = textString.replace(/\s+/g, ' ');
  var listArray = textString.split(' ');
  for ( var i = 0; i < listArray.length; i++ ) {
    var b = parseInt(listArray[i], 16);  // alert('b:'+dec2hex(b));
    if (b < 0 || b > 0xFFFF) {
      outputString += '!erreur ' + dec2hex(b) + '!';
    }
    if (haut != 0) {
      if (0xDC00 <= b && b <= 0xDFFF) {
        outputString += dec2hex(0x10000 + ((haut - 0xD800) << 10) + (b - 0xDC00)) + ' ';
        haut = 0;
        continue;
      } else {
        outputString += '!erreur ' + dec2hex(haut) + '!';
        haut = 0;
      }
    }
    if (0xD800 <= b && b <= 0xDBFF) {
      haut = b;
    } else {
      outputString += dec2hex(b) + ' ';
    }
  }
  CPstring = outputString.replace(/ $/, '');
  
   	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}



function convertjEsc2CP ( textString ) { 
	// convert whole string to chars before starting (allows for mixed strings)
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';

	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		if (i<textString.length-8 && textString.charAt(i) == '\\' 
			&& textString.charAt(i+1) == 'U' && textString.charAt(i+2) in hexNum
			&& textString.charAt(i+3) in hexNum && textString.charAt(i+4) in hexNum
			&& textString.charAt(i+5) in hexNum && textString.charAt(i+6) in hexNum
			&& textString.charAt(i+7) in hexNum && textString.charAt(i+8) in hexNum
			&& textString.charAt(i+9) in hexNum) { // \Uxxxxxxxx
			tempString = '';
			i += 2;
			for (var j=0; j<8; j++) {
				tempString += textString.charAt(i+j);
				}
			i += 7;
			charStr += convertCP2Char(tempString); 
			}
		else if (i<textString.length-6 && textString.charAt(i) == '\\' 
			&& textString.charAt(i+1) == 'u' && textString.charAt(i+2) in hexNum
			&& textString.charAt(i+3) in hexNum && textString.charAt(i+4) in hexNum
			&& textString.charAt(i+5) in hexNum) { // \uxxxx
			tempString = '';
			i += 2;
			for (var j=0; j<4; j++) {
				tempString += textString.charAt(i+j);
				}
			i += 3;
			charStr += convertCP2Char(tempString); 
			}
		else if (i<textString.length-2 && textString.charAt(i) == '\\' 
			&& (textString.charAt(i+1) in jEscape || textString.charAt(i+1) == "\""
			 || textString.charAt(i+1) == "\'"  || textString.charAt(i+1) == "\\")) { // \x
			switch (textString.charAt(i+1)) {
				case '0': charStr += '\0'; break;
				case 'b': charStr += '\b'; break;
				case 't': charStr += '\t'; break;
				case 'n': charStr += '\n'; break;
				case 'v': charStr += '\v'; break;
				case 'f': charStr += '\f'; break;
				case 'r': charStr += '\r'; break;
				case '\'': charStr += '\''; break;
				case '\"': charStr += '\"'; break;
				case '\\': charStr += '\\'; break;
				}
			i += 1;
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	codePoints.value = CPstring;
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}






function convertCSS2CP ( textString ) { 
	// convert whole string to chars before starting (allows for mixed strings)
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';

	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		// look for an escape with 6 hex digits
		if (i<textString.length-8 && textString.charAt(i) == '\\' 
			&& textString.charAt(i+1) in hexNum && textString.charAt(i+2) in hexNum
			&& textString.charAt(i+3) in hexNum && textString.charAt(i+4) in hexNum
			&& textString.charAt(i+5) in hexNum && textString.charAt(i+6) in hexNum) { // \xxxxxx
			tempString = '';
			i++;
			for (var j=0; j<6; j++) {
				tempString += textString.charAt(i+j);
				}
			// consume any following space
			if (i<textString.length-1 && textString.charAt(i+j) == ' ') { i += 6; }
			else { i += 5; }
			charStr += convertCP2Char(tempString); 
			}
		// look for an escape shorter than 6 digits
		else if (i<textString.length-2 && textString.charAt(i) == '\\' 
			&& textString.charAt(i+1) in hexNum) { // \x...
			tempString = '';
			i++; j=0;
			while (i < textString.length-1 && textString.charAt(i+j) in hexNum
					&& j < 6) {
				tempString += textString.charAt(i+j);
				j++;
				} //alert('>'+tempString+'<'+textString.charAt(i+j));
			// consume any following space
			if (i+j<textString.length-1 && textString.charAt(i+j) == ' ') { i = i+j; }
			else { i = i+j-1; }
			charStr += convertCP2Char(tempString); 
			}
		else if ( i<textString.length-2 && textString.charAt(i) == '\\' && textString.charAt(i+1) == '\\') {
			charStr += '\\';
			i++;
			}
		else if ( textString.charAt(i) == '\\' ) {
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	chars.value = convertCP2Char( CPstring );
	XML.value = convertCP2XML( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	codePoints.value = CPstring;
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	}

	
function convertXML2CP ( textString ) {
	// convert whole string to chars before starting (allows for mixed strings)
	CPstring = '';
	textString += ' ';
	var tempString = '';
	var charStr = '';
	
	// first convert whole string to characters
	for (var i=0; i<textString.length-1; i++) {   
		// check for hex ncrs
		if (i<textString.length-4 && textString.charAt(i) == '&' 
			&& textString.charAt(i+1) == '#' && textString.charAt(i+2) == 'x'
			&& textString.charAt(i+3) in hexNum) { // &#x
			tempString = '';
			i += 3;
			while (i<textString.length-1 && textString.charAt(i) in hexNum) { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			if (textString.charAt(i) == ';') {
				charStr += convertCP2Char(tempString);
				}
			else { charStr += '&#x'+tempString; i--; }
			}
		// check for dec ncrs
		else if (i<textString.length-3 && textString.charAt(i) == '&' 
			&& textString.charAt(i+1) == '#' 
			&& textString.charAt(i+2) in hexNum) { 
			tempString = '';
			i += 2;
			while (i<textString.length-1 && textString.charAt(i) in hexNum) { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			if (textString.charAt(i) == ';') {
				charStr += convertCP2Char(parseInt(tempString).toString(16));
				}
			else { charStr += '&#'+tempString; i--; }
			}
		// check for character entities
		else if (i<textString.length-2 && textString.charAt(i) == '&' 
			&& textString.charAt(i+1) != ' ') { 
			tempString = '';
			i++;
			while (i<textString.length-1 && textString.charAt(i) != ';'
				 && textString.charAt(i) != '&') { 
				tempString += textString.charAt(i); 
				i++;
				}
			// only convert sequence to character if terminated by ;
			if (textString.charAt(i) == ';') {
				if (tempString in entities) { //alert(entities[tempString]);
					charStr += entities[tempString];
					} 
				else { charStr += '&'+tempString; i--; }
				}
			else { charStr += '&'+tempString; i--; }
			}
		else { 
			charStr += textString.charAt(i);
			}
		} 
//alert('charStr='+charStr+'<'+charStr.length);
		
	CPstring = getCPfromChar( charStr ); 
	CPstring = CPstring.substring(0, CPstring.length-1);
//alert('CPstring='+CPstring+'<'+CPstring.length);


	codePoints.value = CPstring;
	chars.value = convertCP2Char( CPstring );
	decCodePoints.value = convertCP2Dec( CPstring );
	UTF8.value = convertCP2UTF8( CPstring );
	UTF16.value = convertCP2UTF16( CPstring );
	decNCRs.value = convertCP2DecNCR( CPstring );
	hexNCRs.value = convertCP2HexNCR( CPstring );
	jEsc.value = convertCP2jEsc( CPstring );
	pEsc.value = convertCP2pEsc( CPstring );
	Unicode.value = convertCP2Unicode( CPstring );
	CSS.value = convertCP2CSS( CPstring );
	}

    function getAJAXParam(formObj){

        var querystring = "";
        var count = formObj.elements.length; 
        
        for(var i = 0; i < count; i++) {
            if(formObj.elements[i].name != "")
            {
                querystring += formObj.elements[i].name + "=";
                if(i < count-1)
                { 
                    querystring += encodeURIComponent(getAJAXParam_Sub(formObj.elements[i].value)) + "&";
                }
                else 
                {
                    querystring += encodeURIComponent(getAJAXParam_Sub(formObj.elements[i].value)); 
                }
            }
        }
        return querystring;
    }

    function getAJAXParam_Sub(textString){
        var haut = 0;
        var n = 0;
        CPstring = '';
        for (var i = 0; i < textString.length; i++) {
	        var b = textString.charCodeAt(i); 
	        if (b < 0 || b > 0xFFFF) {
		        CPstring += 'Error ' + dec2hex(b) + '!';
		        }
	        if (haut != 0) {
		        if (0xDC00 <= b && b <= 0xDFFF) {
			        CPstring += dec2hex(0x10000 + ((haut - 0xD800) << 10) + (b - 0xDC00)) + ' ';
			        haut = 0;
			        continue;
			        }
		        else {
			        CPstring += '!erreur ' + dec2hex(haut) + '!';
			        haut = 0;
			        }
		        }
	        if (0xD800 <= b && b <= 0xDBFF) {
		        haut = b;
		        }
	        else {
		        CPstring += dec2hex(b) + ' ';
		        }
	        }
        CPstring = CPstring.substring(0, CPstring.length-1);

        return convertCP2DecNCR( CPstring );
    }