function getInfo() {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso) {
	    alert('Please enable ActiveX Control!');
	    return;
	}
	
	var f = null;

	if (!fso.FolderExists("C:\\TEMP"))
	{
	    f = fso.CreateFolder("C:\\TEMP");
	} 
    
    if(!fso.FolderExists("C:\\TEMP\\Eltdata")) 
    {  
	   f = fso.CreateFolder("C:\\TEMP\\Eltdata");
	}
	
	var MyClient = new ActiveXObject("ELTSoft.ELTClient");
    if(!MyClient) 
    {
        install();
    }
	
	MyClient = new ActiveXObject("ELTSoft.ELTClient");
    
    if(MyClient)
    { 
      MyClient.ELT_Execute("command.com /c ipconfig > C:\\TEMP\\Eltdata\\ELTSoft.txt");
	}

    Sleep(3);
	var filename = 'C:\\TEMP\\Eltdata\\ELTSoft.txt';
    
//	var s = null;

    var arr=new Array();
    var i=0;
    var delim="\t";
	
	if (fso.FileExists(filename))
        {
            f=fso.OpenTextFile(filename,1);
            while(!f.AtEndOfStream) {
                arr[i++]=f.ReadLine().split(delim);
            }

//            s=f.ReadAll();
        }
            
    f.Close();
    fso = null;

    MyClient = null;
    
    var k = 0;
    while (k < arr.length) {    
        if( arr[k].toString().indexOf('IP Address') >= 0)
        {
           var indx1= arr[k].toString().indexOf(':'); 
           document.Form1.txtIP.value = arr[k].toString().substring(indx1+1);
        }
        k++;
    }
}
