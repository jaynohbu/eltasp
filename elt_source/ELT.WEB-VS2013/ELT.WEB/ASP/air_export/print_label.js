function actionRequestForZebra() {

   
    try{
	    var mawb = document.getElementById('hMAWB').value;
	    var post_parameter = '';
    	var NoItem = document.getElementsByName("chkHouse").length;
    	
	    for (i=0; i<NoItem; i++) { 
		    post_parameter += 'cCheck' + i + '=' + document.getElementById('chkHouse'+i).checked + '&';	
		    post_parameter += 'txtHAWB' + i + '=' + document.getElementById('txtHouse'+i).value + '&';
		    post_parameter += 'txtNoLabel' + i + '=' + document.getElementById('txtLabelNo'+i).value + '&';
		    post_parameter += 'txtPiece' + i + '=' + document.getElementById('txtHousePCS'+i).value + '&';
		    post_parameter += 'txtFrom' + i + '=' + document.getElementById('txtFrom'+i).value + '&';
		    post_parameter += 'txtDest' + i + '=' + document.getElementById('txtTo'+i).value + '&';	
	    }	
    	
	    post_parameter += 'hMAWB=' + document.getElementById('hMAWB').value + '&';	
	    post_parameter += 'hNoItem=' + NoItem + '&';	
	    post_parameter += 'txtStartNo=' + 1 + '&';	
        
	    var url = "/ASP/ajaxFunctions/ajax_get_label_info.asp?Action=AEGET";
	    
	    new ajax.xhr.Request('POST',encodeURI(post_parameter),url,showResponseForZebra);	
    
    } catch (err) { alert(err.description); }
	
}
var ContentToWrite='';
function ContentWrite(str) {
    ContentToWrite += str;
    //alert(ContentToWrite);
}
function showResponseForZebra(req) {
	if (req.readyState == 4){
		if (req.status == 200){
		    // testing
		    //var openWindow = window.open();
		    //alert(req.responseText);
			ZebraMain(req);
		}
		else{
		    alert('error');
		}
	}	
}

function ZebraMain(xmlHttp) {
  
	var xmlData = xmlHttp.responseXML;  
    var itemNode = xmlData.getElementsByTagName("item");
    var itemLength = itemNode.length;
    ContentToWrite = "";
    make_label_type_1(xmlData);
    //alert(ContentToWrite);
    window.parent.SetPrintLabelText(ContentToWrite);
    	
}

function make_label_type_1(xmlData) {

	try {
	    var itemNode = xmlData.getElementsByTagName("item"); 
	    var itemLength = itemNode.length; 
      
        ContentWrite("^XA" + "\n");
        ContentWrite("^PW900" + "\n");
        ContentWrite("^DFR:SHIPLABEL.GRF^FS" + "\n");
        ContentWrite("^FO0,158^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO0,441^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO0,562^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO400,562^GB2,121,2^FS" + "\n");
        ContentWrite("^FO0,683^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO600,683^GB2,100,2^FS" + "\n");
        ContentWrite("^FO0,784^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO550,784^GB2,100,2^FS" + "\n");
        ContentWrite("^FO0,884^GB830,0,2,^FS" + "\n");
        ContentWrite("^FO33,12^AD,18^FDAir Line^FS" + "\n");
        ContentWrite("^FO33,452^AD,18^FDAir Waybill No.^FS" + "\n");
        ContentWrite("^FO33,574^AD,18^FDDestination^FS" + "\n");
        ContentWrite("^FO410,574^AD,18^FDTotal No. of Pieces^FS" + "\n");
        ContentWrite("^FO610,695^AD,18^FDOrigin^FS" + "\n");
        ContentWrite("^FO33,796^AD,18^FDHAWB No.^FS" + "\n");
        ContentWrite("^FO560,796^AD,18^FDHAWB PCS^FS" + "\n");
        ContentWrite("^FO33,896^AD,18^FDHAWB Weight^FS" + "\n");
        ContentWrite("^XZ" + "\n");

        var elt_account = window.top.$("#h_elt_acct").val();

        
		for (var i=0; i<itemLength; i++) {
		    var codeNode = itemNode[i].getElementsByTagName('itemcode');		    
		    var descNode = itemNode[i].getElementsByTagName("itemdesc");
		    write_primary_data_for_1(codeNode, descNode);
		    if (elt_account == 20007000 || elt_account == 25751000 || elt_account == 74167000) {
                       write_additional_data_for_1(codeNode, descNode);
                    }else{
	          	   
			}				
		}
	} catch (err) { alert(err.description); }
	return;
}

function write_additional_data_for_1(codeNode,descNode){
    
	try {
		//ContentWrite("===============================================");
		//ContentWrite("Addtional Data");
		//ContentWrite("===============================================");
	    ContentWrite("^XA" + "\n");
	    ContentWrite("^FO0,924^GB830,0,2,^FS" + "\n");
	    ContentWrite("^FO550,924^GB2,100,2^FS" + "\n");
	    ContentWrite("^FO33,936^AD,18^FDHAWB No.^FS" + "\n");
	    ContentWrite("^FO560,936^AD,18^FDHAWB PCS^FS" + "\n");		
			for (var j=0; j<codeNode.length; j++) { 
		
				var cd = ''
				var ds = '';
				
				try { 
					 cd = codeNode[j].firstChild.nodeValue;
					 ds = descNode[j].firstChild.nodeValue;

					
				} catch (e) {ds = "";}

				switch(cd) {
						case 'shipper' :
						    ContentWrite("^FO33,12^AD,18^FDShipper address^FS" + "\n");		
							var aDs = ds.split('::');
							var aP = 74;
							for( k=0; k < aDs.length; k++ ) {
							    ContentWrite("^FO52," + aP + "^AS^FD" + aDs[k] + "^FS" + "\n");		
								aP += 50;
							}
				            ContentWrite("^FO0,445^GB840,0,2,^FS" + "\n");																		
							break;
						case 'consignee' :
						    ContentWrite("^FO33,467^AD,18^FDConsignee address^FS" + "\n");		
							var aDs = ds.split('::');
							var aP = 529;
							for(var k=0; k<aDs.length; k++) {
							    ContentWrite("^FO52," + aP + "^AS^FD" + aDs[k] + "^FS" + "\n");		
								aP += 50;
							}
							break;
						case 'HAWB' :
						    ContentWrite("^FO95,950^AV,64^FD" + ds + "^FS" + "\n");
							break;
						case 'hawb_piece' :
						    ContentWrite("^FO650,950^AV,24^FD" + ds + "^FS" + "\n");
							break;
						default :
							break;
				}					
			}		
			ContentWrite("^XZ");		
		} catch (err) { alert(err.description); }		
	return;		

}
function write_primary_data_for_1(codeNode,descNode) {

	try {
	
			ContentWrite("^XA");
			ContentWrite("^XFR:SHIPLABEL.GRF");

			for (var j=0; j<codeNode.length; j++) { 
		
				var cd = ''
				var ds = '';
				
						try { 
							 cd = codeNode[j].firstChild.nodeValue;
							 ds = descNode[j].firstChild.nodeValue;
							 
						} catch (e) {ds = ""}
		
						switch(cd) {
							case 'airline' :
								var strContext = make_center_text(ds);
								ContentWrite("^FO0,55^FB880,1,,C" + strContext);
								break;
							case 'MAWB' :
								var long_mawb = make_long_mawb_no(ds);
								ContentWrite("^FO170,212^BY4^BCN,170,Y,N,N" + "\n");
								ContentWrite("^FD>;" + long_mawb + "^FS" + "\n"); // >; to start without character
								ContentWrite("^FO100,492^AG,64^FD" + ds + "^FS" + "\n");
								break;
							case 'destination' :
							    ContentWrite("^FO150,605^AV,64^FD" + ds + "^FS" + "\n");
								break;
							case 'mawb_piece' :
								var NotPrintTotal = document.getElementById('chkShowTotal').value;
								if (NotPrintTotal == 'Y') {
								    ContentWrite("^FO515,605^AV,24^FD" + ds + "^FS" + "\n");
								}
								break;
							case 'agentName' :
								var strContext = make_center_text_for_agent(ds);
								ContentWrite(strContext+ "\n");
								break;
							case 'origin' :
							    ContentWrite("^FO660,714^AV,64^FD" + ds + "^FS" + "\n");
								break;
							case 'HAWB' :
							    ContentWrite("^FO95,810^AV,64^FD" + ds + "^FS" + "\n");
								break;
							case 'hawb_piece' :
							    ContentWrite("^FO590,810^AV,24^FD" + ds + "^FS" + "\n");
								break;
							case 'HAWB_weight' :
							    ContentWrite("^FO310,910^BCN,90,N,N,N" + "\n");
							    ContentWrite("^FD" + ds + "^FS" + "\n");
								break;
							default :
								break;
						}	
				
			}

        ContentWrite("^XZ" + "\n");
		} catch (err) { alert(err.description); }		

	return;	
}


function make_center_text(ds) {
	var str =  '';
	if(ds) {
		if(ds.length < 15) {
			str = '^AUN,120,120^FD' + ds + '^FS';
		}
		//else if(ds.length >= 15 && ds.length < 20) {
		//	str = '^AUN,120,90^FD' + ds + '^FS';
		//}
		else {
			str = '^AV,82^FD' + ds + '^FS';
		}
	}
	return str;
}

function make_center_text_for_agent(ds) {
	var str =  '';

	if(ds) {
		if(ds.length < 18) {
			str = '^FO20,700^FB590,1,,C' + '^AU,92^FD' + ds + '^FS';
		}
		else if(ds.length < 20) {
			str = '^FO20,710^FB590,1,,C' + '^AUN,74,62^FR^FD' + ds + '^FS';
		}
		else {
			str = '^FO20,720^FB590,1,,C' + '^AS^FR^FD' + ds + '^FS';
		}
	}
	return str;
}

function make_long_mawb_no(ds) {
	var long_mawb = ds;
	while(long_mawb.indexOf('-') != -1) { long_mawb = long_mawb.replace('-','');	}	
	while(long_mawb.indexOf(' ') != -1) { long_mawb = long_mawb.replace(' ','');	}	
	return long_mawb + '00000';
}