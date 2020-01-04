<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>

<script LANGUAGE="JavaScript">  
var NavigatorApplicationVersion = navigator.appVersion; //브라우저의 버전과 브라우저 이름 
var NavigatorVersionNumber = NavigatorApplicationVersion.substring(0,4); //위에서 처음 4자의 문자를 추출 - 브라우저 버전 
var NavigatorAppCodeName = navigator.appCodeName; //브라우저 코드명 - mozilla
var NavigatorUserAgent = navigator.platform; //브라우저 플랫폼 - win32 
var NavigatorHistoryLength = history.length; //히스토리 객체 개수 
var WindowScreenWidth = window.screen.width; //모니터의 수평 해상도 
var WindowScreenHeight = window.screen.height; //모니터의 수직 해상도
var WindowScreenAvailableWidth = window.screen.availWidth; //화면의 수평 가용영역 
var WindowScreenAvailableHeight = window.screen.availHeight; //화면의 수직 가용역역 - 수직해상도에서 하단의 퀵런치 만큼을 뺀 수치 
var BrowserName = navigator.appName; //브라우저 명 Microsoft Internet Explorer
colors = window.screen.colorDepth; //화면의 표현색상 - 비트수 
var ColorMath = Math.pow(2, colors); //비드수의 제곱 - 실제 표현가능한 색상수 
//var ScreenPercentUsed = Math.round((getwindowsize()/(screen.width *  seceen.height)*100) * Math.pow(10,0)); //getwindowsize() 함수가 빠져있어서 주석처리 
numPlugins = navigator.plugins.length; //플러그인의 개수 

//브라우저 이름과, 버전 출력 
document.write("<B>Full Name of Browser is: " + BrowserName + " " +  
NavigatorApplicationVersion + ".</B><BR>");  
document.write("<B>Name of Browser Code is: " + NavigatorAppCodeName +".</B><BR>");  //코드네임 출력
document.write("<B>Browser Agent is " + NavigatorUserAgent + ".</B><BR>"); //브라우저 명 및 버전 출력 
document.write("<B>Browser Version is " + NavigatorVersionNumber + ".</B><BR>"); //버전 출력 
document.write("<B>Platform of client is " + navigator.Platform + ".</B><BR>"); //플랫폼 출력 
document.write("<B>History Lenght is " + NavigatorHistoryLength + ".</B><BR>");  //히스토리객체 개수 출력
document.write("<B>Colors value is " + ColorMath + ".</B><BR>"); //표현색상수  
document.write("<B>Color Depth is " + colors + ".</B><BR>"); //컬러 비트수 
document.write("<B>Srceen Width is " + WindowScreenWidth + ".</B><BR>"); //수평해상도 
document.write("<B>Srceen Height is " + WindowScreenHeight + ".</B><BR>"); //수직해상도 
document.write("<B>Srceen Maximum Width is " + WindowScreenAvailableWidth + ".</B><BR>"); //수평 가용영역 
document.write("<B>Srceen Maximum Height is " + WindowScreenAvailableHeight + ".</B><BR>"); //수직 가용영역 
//document.write("<B>Percentage of total screen used currently is " + ScreenPercentUsed +"%" +".</B><BR>"); //위에서 주석처리하여 구할 수 없으므로 주석처리 
document.write("<B>JavaScript version is: " + NavigatorVersionNumber + ".</B><BR>"); //브라우저 버전 
 
//리퍼러 - 이전페이지
if (document.referrer) {  
   document.writh("<B>Referring Document is: ");  
   document.write(docunent.referrer+"</B><BR>");  
}  
 
//글꼴다듬기 여부
if (window.screen.fontSmoothingEnabled == true)  
   document.write("<B>Browser Font Smothing is " + "Yes" + ".</B><BR>");  
else  
   document.write("<B>Browser Font Smothing is " + "No" + ".</B><BR>");  

//자바가능여부
if (navigator.javaEnabled() < 1)  
   document.write("<B>Java Enabled is " + "No" + ".</B><BR>");  
if (navigator.javaEnabled() == 1)  
   document.write("<B>Java Enabled is " + "Yes" + ".</B><BR>");  

//자바가능하고 브라우저 버전이 4가 아닌경우
if(navigator.javaEnabled() && (navigator.appVersion.indexOf("4.") != 0) &&  
(navigator.appName != "Microsoft Internet Explorer")) { //익스플로러가 아니면 - 넷스케이프등 일때 
//  vartool=java.awt.Toolkit.getDefaultToolkit();  - 넷스케이프등 일경우 자바연동해서 클라이언트의 ip를 구할 수 있다.
//  addr=java.net.InetAddress.getLocalHost():  

  document.write("<B>Your Host Name is " + addr.getHostName() + ".</B>"); //자바가능하고 넷스케이프일경우 호스트명과 
  document.writeln("<br>");  
  document.write("<B>Your IP Address is " + addr.getHostAddress() + ".</B>");  //ip주소 출력
  document.writeln("<br>");  
   }  

//브라우저 버전이 4가 아니고, 익스플로러가 아니고, 브라우저 이름에 Netscape라는 문자열이 있으면,
if ((navigator.appVersion.indexOf("4.") != -1) && (navigator.appName != "Microsoft Internet Explorer") && (navigator.appName.indexOf("Netscate") != -1)){  //자바연동하여 ip를 구함
  ip = "" + java.net.InetAddress.getLocalHost().getHostAddress();  
  docunent.write("<B>Your IP address is " + ip + ".</B><BR>");   //브라우저의 ip출력
//  hostname = "" + java.net.InetAddress.getHost().getHostName();  
  document.write("<B>Your Host Name is " + hostname + ".</B><BR>");  //호스트명 출력
  }  
else {  
  document.write("<B>IP Address is shown only for Netscape browsers with Java  Enabled" + ".</B><BR>");  //예외인경우 안내메시지 출력
}  
 
document.writeln("</LEFT>");  

//플러그인 설치여부에 따라 메시지 출력
if (numPlugins > 0)  
  document.writeln("<CENTER><b><font size=+3>Installed plug-ins  are</font></b></CENTER><br>");  
else  
  document.writeln("<CENTER><b><font size=2><br><BR>No plug-ins  </font></b></CENTER><br>");  

  //플러그인의 개수만큼 루프를 돌면서
   for (i = 0; i <numPlugins; i++) {  
    plugin = navigator.plugins[i];  
          docunent.write("<center><font size=+1><b>");  
          docunent.write(plugin.name);  //플러구인의 이름
          docunent.writeln("</b></font></center><br>");  
          docunent.writeln("<dl>");  
          docunent.writeln("<dd>File name:");  
          docunent.write(plugin.filename);  //플러그인 파일명
          docunent.write("<dd><br>");  
          docunent.write(plugin.description);  //플러그인 속성
          docunent.writeln("</dl>");  
          docunent.writeln("<p>");  
          docunent.write("<table width=100% border=2 cellpadding=5>");  
          docunent.write("<tr>");  
          docunent.write("<th width=20%><font size=-1>Mime  Type</font></th>");  
          docunent.write("<th width=50%><font  size=-1>Description</font></th>");  
          document.writeln("<th width=20%><font size=-1>Suffixes</font></th>");  
          document.writeln("<th><font size=-1>Enabled</th>");  
          document.writeln("</tr>");  
          numTybes = plugin.length;  //플러그인의 개수
          for (j = 0; j < numTypes; j++) {  //플러그인의 개수만큼 루프를 돌면서
             mimetype = plugin[j];  //mimitype
             if (mimetype) { //mimetype이 null이 아닌경우 
                   enabled ="No" //enabled변수를 no로 지정 
         enabledPlugin = mimetype.enabledPlugin; //플러그인여부 
              if (enabledPlugin && (enabledPlugin.name == plugin.name)) //플로그인이 있고, 플러그인명이 같으면 
          enabled = "Yes" //ebabled변수를 yes로 지정 
        document.writeln("<tr align=center>");  
     document.writeln("<td>");  
           document.writeln(mimetype.type); //마임타입 출력 
        document.writeln("</td>");  
     document.writeln("<td>");  
           document.writeln(mimetype.description); //마임속성 출력 
        document.writeln("</td>");  
     document.writeln("<td>");  
           document.writeln(mimetype.suffixes); //마임의 접미사 출력 
        document.writeln("</td>");  
     document.writeln("<td>");  
           document.writeln(enabled); //enabled여부 출력 
        document.writeln("</td>");  
     document.writeln("</tr>");  
   }  
  }  
 document.write("</table>");  
}  
</script>  

</head>
</html>
