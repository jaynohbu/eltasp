function getInfo() {
if(!val()) return false;
	var err = false;
try
{
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso) {
	    alert('Please enable ActiveX Control!');
	    return;
	}
	
	var f = null;

	if (!fso.FolderExists("D:\\TEMP"))
	{
	    f = fso.CreateFolder("D:\\TEMP");
	} 
    
    if(!fso.FolderExists("D:\\TEMP\\Eltdata")) 
    {  
	   f = fso.CreateFolder("D:\\TEMP\\Eltdata");
	}
	
	var MyClient = new ActiveXObject("ELTSoft.ELTClient");
    
    if(MyClient)
    { 
      MyClient.ELT_Execute("command.com /c hostname > D:\\TEMP\\Eltdata\\ELTSoft.txt");
	}

    Sleep(2);
	var filename = 'D:\\TEMP\\Eltdata\\ELTSoft.txt';
    
	var s = null;

//    var arr=new Array();
 //   var i=0;
  //  var delim="\t";
	
	if (fso.FileExists(filename))
     {
            f=fso.OpenTextFile(filename,1);
            s=f.ReadAll();
		    f.Close();
      }
            
    fso = null;

    MyClient = null;
	if(s==null || s=='') s = 'ActiveX Error';
    document.form1.txtIP.value = s;
}
catch (e)
{
	s = 'ActiveX Error';
	document.form1.txtIP.value = s;
}	

if (s == 'ActiveX Error')
{

}
return true;
}
