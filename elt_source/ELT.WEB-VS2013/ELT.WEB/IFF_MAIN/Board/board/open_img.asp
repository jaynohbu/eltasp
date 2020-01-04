<% Option Explicit %>
<% response.buffer = true %>

 

<html>
<head>
<title>Image View</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

</head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<a href="javascript:close();"><img src="<%=request("img_file")%>" border="0"></a>
</body>
</html>
