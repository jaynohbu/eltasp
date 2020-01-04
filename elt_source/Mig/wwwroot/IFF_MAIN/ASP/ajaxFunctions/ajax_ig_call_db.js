function get_mawb_booking_info( mawb_num ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}
      
		var url="../ajaxFunctions/ajax_get_mawb_booking_info.asp?MAWB=" + encodeURIComponent(mawb_num);
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;
	
	return result;
}

function get_mbol_info( mbol_num ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}



		var url="../ajaxFunctions/ajax_get_mbol_booking_info.asp?MBOL=" + encodeURIComponent(mbol_num);
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}

function get_arrival_mawb_info( mawb, type ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

		if ( type == 'A'){
		var url="../ajaxFunctions/ajax_arrival_mawb_info.asp?MAWB=" + mawb;
		}
		else {
		var url="../ajaxFunctions/ajax_arrival_mawb_info_ocean.asp?MAWB="+ mawb;
		}
		xmlHTTP.open("get", encodeURI(url), false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}

function get_mbol_booking_info( book ) 
{ 

      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

		var url="../ajaxFunctions/ajax_get_mbol_booking_info.asp?BOOK="+ encodeURIComponent(book);
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;
	
	return result;
}
function get_organization_info_ar( org ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

		var url="../ajaxFunctions/ajax_get_org_address_info.asp?org="+ org + "&type=ARN";
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}

function get_organization_info_ar_consignee( org ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

		var url="../ajaxFunctions/ajax_get_org_address_info.asp?org="+ org + "&type=N";
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}

function get_organization_info( org ) 
{ 
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}



		var url="../ajaxFunctions/ajax_get_org_address_info.asp?org=" + org;
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	
	return result;
}
function get_organization_info_invoice( org ) {
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}


		var url="../ajaxFunctions/ajax_get_org_address_info.asp?org=" + org + "&type=IV";
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;
	
	return result;
}
function get_organization_info_for_check( org ) {
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}


		var url="../ajaxFunctions/ajax_get_org_address_info.asp?org=" + org + "&type=check";
		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}

function get_organization_info_sed( url ) {
      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}

		
		xmlHTTP.open("get",url,false); 
        xmlHTTP.send(); 
		
		var result = xmlHTTP.responseText;

	return result;
}
