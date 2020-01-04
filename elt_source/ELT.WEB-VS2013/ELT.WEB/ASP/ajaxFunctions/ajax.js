var ajax = {};
ajax.xhr = {}; 

ajax.xhr.Request = function(met,post_parameter,url, callback, field,tmpVal,tWidth,tMaxLength) {
 this.met = met;
 this.post_parameter = post_parameter;
 this.url = url;
 this.callback = callback;
 this.field = field;
 this.tmpVal = tmpVal;
 this.tWidth = tWidth;
 this.tMaxLength = tMaxLength;
 this.send();
} 

ajax.xhr.Request.prototype = {
 getXMLHttpRequest: function() {
  if (window.ActiveXObject) {
   try {
    return new ActiveXObject("Msxml2.XMLHTTP");
   } catch(e) {
    try {
     return new ActiveXObject("Microsoft.XMLHTTP");
    } catch(e1) {
     return null;
    }
   }
  } else if (window.XMLHttpRequest) {
   return new XMLHttpRequest();
  } else {
   return null;
  }
 },
 send: function() {
  this.req = this.getXMLHttpRequest(); 
	
  var met = this.met; 
  var post_parameter = this.post_parameter; 
  var httpUrl = this.url; 

  this.req.open(met, httpUrl, true);
  this.req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); 
  this.req.setRequestHeader('Content-length', post_parameter.length);
  this.req.setRequestHeader('Connection', 'close');
  
  var request = this;
  this.req.onreadystatechange = function() {
   request.onStateChange.call(request,this.field,this.tmpVal,this.tWidth,this.tMaxLength,this.url);
  }

  if (met == 'POST' ) {
	  this.req.send(post_parameter);
  }
  else {
	  this.req.send(null);
  }

 },
 onStateChange: function() {
  this.callback(this.req,this.field,this.tmpVal,this.tWidth,this.tMaxLength,this.url,this.post_parameter);
 }
} 

