function actionRequestForZebra(vPrintPort,add_address,label_type) {
	
try
{
	var mawb = document.getElementById('hMAWB').value;
	if (mawb=="")  {
		alert("Please select a MAWB No.");
		return false;
	}	
	var NoItem = document.getElementById('hNoItem').value;
	if (NoItem=="")  {
		return false;
	}	

	var iCnt = 0;
	
    for (i=0; i<NoItem; i++) { 
		if (document.all("Check").item(i+1).checked) {
			iCnt = iCnt + 1;
		}
	}

	if (iCnt == 0) {
		alert('Please select item to print.');
		return false;
	}
	
	var startNo;
	var post_parameter = '';
	
	for (i=0; i<NoItem; i++) { 
		post_parameter += 'cCheck' + i + '=' + document.getElementById('cCheck'+i).checked + '&';	
		post_parameter += 'txtHAWB' + i + '=' + document.getElementById('txtHAWB'+i).value + '&';
		post_parameter += 'txtNoLabel' + i + '=' + document.getElementById('txtNoLabel'+i).value + '&';
		post_parameter += 'txtPiece' + i + '=' + document.getElementById('txtPiece'+i).value + '&';
		post_parameter += 'txtFrom' + i + '=' + document.getElementById('txtFrom'+i).value + '&';
		post_parameter += 'txtDest' + i + '=' + document.getElementById('txtDestCode'+i).value + '&';			
	}	
	
	post_parameter += 'hMAWB=' + document.getElementById('hMAWB').value + '&';	
	post_parameter += 'hNoItem=' + document.getElementById('hNoItem').value + '&';	
	post_parameter += 'txtStartNo=' + document.getElementById('txtStartNo').value + '&';	


	var url = "/ASP/ajaxFunctions/ajax_get_label_info.asp" 
			+"?Action=get";
	new ajax.xhr.Request('POST',encodeURI(post_parameter),url,showResponseForZebra,vPrintPort,add_address,label_type);	
} catch (f) {}
	
}

function showResponseForZebra(req,vPrintPort,add_address,label_type) {
	if (req.readyState == 4) {
		if (req.status == 200) {
			////////////////////////////////// Printing function for Zebra
			////////////////////////////////// 
			////////////////////////////////// 
			ZebraMain(req,vPrintPort,add_address,label_type);
			////////////////////////////////// 
		}
		else
		{
			alert('error');
		}
	}	
}

function ZebraMain(xmlHttp,vPrintPort,add_address,label_type) {
	var xmlData = xmlHttp.responseXML;  
    var itemNode = xmlData.getElementsByTagName("item"); 
    var itemLength = itemNode.length;    

// for debug
//	alert(xmlHttp.responseText);

	if (itemLength == 0) {
//		alert(xmlHttp.responseText);
	}
	
	try {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	} catch(f) { 
	alert('Your security configuration protected the creating file for Shipping Label.\nPlease change the security level of your browser!');
	return;
	}
	
	if(!fso) {
	    alert('Please enable ActiveX Control!');
	    return false;
	}
	var f;
	if (!fso.FolderExists("D:\\TEMP"))
	{
	    f = fso.CreateFolder("D:\\TEMP");
	} 
    
    if(!fso.FolderExists("D:\\TEMP\\Eltdata")) 
    {  
	   f = fso.CreateFolder("D:\\TEMP\\Eltdata");
	}
	var filename = 'D:\\TEMP\\Eltdata\\shippingLabel.txt';
	var file = fso.CreateTextFile(filename,true);

	if(!file) {
	    alert('Shipping file creation error!');
	    return false;	
	}
	
	if(!file) return false;

	switch(label_type) {
		case '1' :

///////////////////////////////////////////////////////// 

			make_label_type_1(file,xmlData,add_address);

			break;
		default :
			break;
	}		
	file.Close();

	try
	{
/*
	if (vPrintPort == "LPT1" || vPrintPort == "LPT2" || vPrintPort == "LPT3" 
		|| vPrintPort == "LPT4" || vPrintPort == "LPT5" || vPrintPort == "LPT6" 
		|| vPrintPort == "LPT7" || vPrintPort == "LPT8") 
	{*/
		EltClient.ELTPrintForm(filename,vPrintPort);
/*		
	} else {
		EltClient.ELTPrintFormWithNetwork(filename,vPrintPort);
	}
*/
	} catch(f) {}


}

function make_label_type_1(file,xmlData,add_address) {

	try {
		file.Write("===============================================" + "\n");
		file.Write("Format for Shipping Label" + "\n");
		file.Write("===============================================" + "\n");
		file.Write("^XA" + "\n");
		file.Write("^PW900" + "\n");
		file.Write("^DFR:SHIPLABEL.GRF^FS" + "\n");
		file.Write("^FO0,158^GB830,0,2,^FS" + "\n");
		file.Write("^FO0,441^GB830,0,2,^FS" + "\n");
		file.Write("^FO0,562^GB830,0,2,^FS" + "\n");
		file.Write("^FO400,562^GB2,121,2^FS" + "\n");
		file.Write("^FO0,683^GB830,0,2,^FS" + "\n");
		file.Write("^FO600,683^GB2,100,2^FS" + "\n");
		file.Write("^FO0,784^GB830,0,2,^FS" + "\n");
		file.Write("^FO550,784^GB2,100,2^FS" + "\n");
		file.Write("^FO0,884^GB830,0,2,^FS" + "\n");
		file.Write("^FO33,12^AD,18^FDAir Line^FS" + "\n");
		file.Write("^FO33,452^AD,18^FDAir Waybill No.^FS" + "\n");
		file.Write("^FO33,574^AD,18^FDDestination^FS" + "\n");
		file.Write("^FO410,574^AD,18^FDTotal No. of Pieces^FS" + "\n");
		file.Write("^FO610,695^AD,18^FDOrigin^FS" + "\n");
		file.Write("^FO33,796^AD,18^FDHAWB No.^FS" + "\n");
		file.Write("^FO560,796^AD,18^FDHAWB PCS^FS" + "\n");
		file.Write("^FO33,896^AD,18^FDHAWB Weight^FS" + "\n");
		file.Write("^XZ" + "\n");

		var itemNode = xmlData.getElementsByTagName("item"); 
		var itemLength = itemNode.length; 
		for (var i=0; i<itemLength; i++) { 
				var codeNode = itemNode[i].getElementsByTagName('itemcode');
				var descNode = itemNode[i].getElementsByTagName("itemdesc");	
				if(add_address == 'I' || add_address == 'X') {
					write_primary_data_for_1(file,codeNode,descNode);		
				}
				if(add_address == 'A' || add_address == 'X' ) {	
					write_additional_data_for_1(file,codeNode,descNode);
				}
		}
	} catch(f) {}
	return;
}

function write_additional_data_for_1(file,codeNode,descNode){

	try {
		file.Write("===============================================" + "\n");
		file.Write("Addtional Data" + "\n");
		file.Write("===============================================" + "\n");
		file.Write("^XA" + "\n");	
		file.Write("^FO0,924^GB830,0,2,^FS" + "\n");
		file.Write("^FO550,924^GB2,100,2^FS" + "\n");
		file.Write("^FO33,936^AD,18^FDHAWB No.^FS" + "\n");
		file.Write("^FO560,936^AD,18^FDHAWB PCS^FS" + "\n");		
			for (var j=0; j<codeNode.length; j++) { 
		
				var cd = ''
				var ds = '';
				
				try { 
					 cd = codeNode[j].firstChild.nodeValue; 
					 ds = descNode[j].firstChild.nodeValue; 
				} catch (e) {ds = ""}

				switch(cd) {
						case 'shipper' :
							file.Write("^FO33,12^AD,18^FDShipper address^FS" + "\n");		
							var aDs = ds.split('::');
							var aP = 74;
							for( k=0; k < aDs.length; k++ ) {
								file.Write("^FO52,"+ aP +"^AS^FD" + aDs[k] + "^FS" + "\n");		
								aP += 50;
							}
							file.Write("^FO0,445^GB840,0,2,^FS" + "\n");																		
							break;
						case 'consignee' :
							file.Write("^FO33,467^AD,18^FDConsignee address^FS" + "\n");		
							var aDs = ds.split('::');
							var aP = 529;
							for(var k=0; k<aDs.length; k++) {
								file.Write("^FO52,"+ aP +"^AS^FD" + aDs[k] + "^FS" + "\n");		
								aP += 50;
							}

							break;
						case 'HAWB' :
							file.Write("^FO95,950^AV,64^FD" +ds+ "^FS" + "\n");
							break;
						case 'hawb_piece' :
							file.Write("^FO650,950^AV,24^FD" +ds+ "^FS" + "\n");
							break;
						default :
							break;
				}					
			}		
			file.Write("^XZ" + "\n");		
		} catch(f) {}			
	return;		

}
function write_primary_data_for_1(file,codeNode,descNode) {

	try {

			file.Write("===============================================" + "\n");
			file.Write("Data" + "\n");
			file.Write("===============================================" + "\n");
	
			file.Write("^XA" + "\n");
			file.Write("^XFR:SHIPLABEL.GRF" + "\n");

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
								file.Write("^FO0,55^FB880,1,,C" + strContext + "\n");
								break;
							case 'MAWB' :
								var long_mawb = make_long_mawb_no(ds);
								file.Write("^FO170,212^BY4^BCN,170,Y,N,N" + "\n");
								file.Write("^FD>;" +long_mawb+ "^FS" + "\n");
								file.Write("^FO100,492^AG,64^FD" +ds+ "^FS" + "\n");
								break;
							case 'destination' :
								file.Write("^FO150,605^AV,64^FD" +ds+ "^FS" + "\n");
								break;
							case 'mawb_piece' :
								//alert( ds );	
								var NotPrintTotal = document.getElementById('NotPrintTotal').value;
								if (NotPrintTotal == 'Y') {
									file.Write("^FO515,605^AV,24^FD" +ds+ "^FS" + "\n");
								}
								break;
							case 'agentName' :
								var strContext = make_center_text_for_agent(ds);
								file.Write(strContext+ "\n");
								break;
							case 'origin' :
								file.Write("^FO660,714^AV,64^FD" +ds+ "^FS" + "\n");
								break;
							case 'HAWB' :
								file.Write("^FO95,810^AV,64^FD" +ds+ "^FS" + "\n");
								break;
							case 'hawb_piece' :
								file.Write("^FO650,810^AV,24^FD" +ds+ "^FS" + "\n");
								break;
							case 'HAWB_weight' :
								file.Write("^FO310,910^BCN,90,N,N,N" + "\n");
								file.Write("^FD" +ds+ "^FS" + "\n");
								break;
							default :
								break;
						}	
				
			}

			file.Write("^XZ" + "\n");
		} catch(f) {}			

	return;	
}


function make_center_text(ds) {
	var str =  '';
	if(ds) {
		if(ds.length < 15) {
			str = '^AUN,120,120^FD' + ds + '^FS';
		}
		else if(ds.length > 15 && ds.length < 20) {
			str = '^AUN,120,90^FD' + ds + '^FS';
		}
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