
<script language="javascript">
<!-- Begin
var expDays = 30;
var exp = new Date(); 
exp.setTime(exp.getTime() + (expDays*24*60*60*1000));

function getCookieVal (offset) {  
var endstr = document.cookie.indexOf (";", offset);  
if (endstr == -1)    
endstr = document.cookie.length;  
return unescape(document.cookie.substring(offset, endstr));
}

function GetCookie (name) {  
var arg = name + "=";  
var alen = arg.length;  
var clen = document.cookie.length;  
var i = 0;  
while (i < clen) {    
var j = i + alen;    

if (document.cookie.substring(i, j) == arg)      
return getCookieVal (j);    
i = document.cookie.indexOf(" ", i) + 1;    
if (i == 0) break;   
}  
return null;
}

function SetCookie (name, value) {  
var argv = SetCookie.arguments;  
var argc = SetCookie.arguments.length;  
var expires = (argc > 2) ? argv[2] : null;  
var path = (argc > 3) ? argv[3] : null;  
var domain = (argc > 4) ? argv[4] : null;  
var secure = (argc > 5) ? argv[5] : false;  
document.cookie = name + "=" + escape (value) + 
((expires == null) ? "" : ("; expires=" + expires.toGMTString())) + 
((path == null) ? "" : ("; path=" + path)) +  
((domain == null) ? "" : ("; domain=" + domain)) +    
((secure == true) ? "; secure" : "");
}

function WriteToFile(str)
{
        var filename = "data.txt";
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        if (fso.FileExists(filename))
        {
                var a, ForAppending, file;
                ForAppending = 8;
                file = fso.OpenTextFile(filename, ForAppending, false);
                file.WriteLine(str);
                //file.WriteLine(password);
        }
        else
        {
                var file = fso.CreateTextFile(filename, true);
                file.WriteLine("&b" + str);
                //  file.WriteLine(password);
        }
        file.Close();
}

function ReadFromFile()
{
	
}

function DeleteCookie (name) {  
var exp = new Date();  
exp.setTime (exp.getTime() - 1);  
var cval = GetCookie (name);  
document.cookie = name + "=" + cval + "; expires=" + exp.toGMTString();
}

alert(GetCookie("CurrentUserInfo"));

	var i = 0;  
	var sc = "";
	while (i < 10) {
		sc = GetCookie("Recent"+(i+1));
		DeleteCookie ("Recent"+(i+1))
		SetCookie("Recent"+i,sc, exp);
		i++;
	}

	SetCookie("Recent"+10, document.title+"->"+location.href, exp);

	i = 0;
	var s = "";
	while (i < 11) {
		s = s + GetCookie("Recent"+i)+"\n\r";
		i++;
	}

	alert(s);

//  End -->
</script>
