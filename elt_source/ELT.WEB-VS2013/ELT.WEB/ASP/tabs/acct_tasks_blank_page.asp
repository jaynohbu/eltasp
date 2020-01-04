<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title></title>
<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
<meta name=ProgId content=VisualStudio.HTML>
<meta name=Originator content="Microsoft Visual Studio .NET 7.1">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}
//-->
</script>

<link href="/ASP/css/defaultpage.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background-image: url(/ASP/Images/defaultpage_back.gif);
	background-repeat: repeat-y;
	background-position: right top;
}
.style1 {color: #ff6600}
-->
    </style>
</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../images/acc_ta_ci_over.gif','../images/acc_ta_ei_over.gif','../images/acc_ta_si.gif','../images/acc_ta_rp.gif','../images/acc_ta_eb.gif','../images/acc_ta_wc.gif','../images/acc_ta_pc.gif','../images/acc_ta_mc.gif','../images/acc_ta_ca.gif','../images/acc_ta_ei.gif','../images/acc_ta_eci.gif','../images/acc_ta_gje.gif','../images/acc_ta_pb.gif','../images/acc_ta_gje_over.gif','../images/acc_ta_ci.gif','../images/acc_ta_si_over.gif','../images/acc_ta_rp_over.gif','../images/acc_ta_eb_over.gif','../images/acc_ta_pb_over.gif','../images/acc_ta_wc_over.gif','../images/acc_ta_pc_over.gif','../images/acc_ta_ca_over.gif','../images/acc_ta_eci_over.gif')">
<div id="wrap">
<div id=whiterule></div>
    <div id="rightnavi">
    <h2> Accounting Tasks </h2>
    <p>This Tab is where most Accounting functions are performed.  You can edit and confirm invoices automatically generated by the system from shipments and add invoice that may not relate to a specific shipment.  You can also enter your payable amounts and reconcile both payables and receivables.  Writing and printing checks is also possible here, among other functions.</p>
	<!--  will add function later
	<h3 class="bold">Recent Works </h3>
	<ul class="recentworks">
	<li><a href="#">File name 1</a></li>
	<li><a href="#">File name 2</a></li>
	<li><a href="#">File name 3</a></li>
	<li><a href="#">File name 4</a></li>
	</ul>-->

	<div id="linebreak"></div>
    <h2>getting started </h2>
    <h3>User's Handbook</h3>
    <p>A first time user or want to learn how to use FreightEasy? <a href="/images/freighteasy/images/FreightEasy-Guide.pdf" target="_blank">Download</a> a User's Handbook.      
    <h3>Support Center </h3>
    <p>We are ready to help you. For technical support, email to <a href="mailto:support@e-logitech.net?subject=Support for FreightEasy-Accounting Tasks">support@e-logitech.net</a> or call us at 1-877-680-EASY(3279).</p>
    </div>
<div id="leftfloat">
<div id="report">
    <p><span class="bold"><a href="/ASP/acct_tasks/create_invoi.asp" target="_self">Invoice Queue </a></span> - This area is where the system places invoices that have been automatically generated from shipment information.  They are queued here for review by the user before actual creation and entrance into further accounting processes.  </p>
</div>
		
<div id="report2"><p><span class="bold"><a href="/ASP/acct_tasks/edit_invoice.asp">Add Invoices</a></span> - This area is where the user may add Invoices that may not relate to a shipment.  Anything that needs invoicing, and will not be adding automatically by the system can be manually added here.</p>
</div>
<div id="report3"><p><span class="bold"><a href="/iff_main/ASPX/Reports/Accounting/searchinvoiceselection.aspx" target="_self">Search Invoices</a></span> - This area is where the user may search for and access any existing Invoice.</p>
</div>
<div id="report4">
    <p><span class="bold"><a href="/ASP/acct_tasks/receiv_pay.asp" target="_self">Accounts Receivable </a></span> - This area is where the user can receive payments against outstanding Invoices.</p>
</div>
<div id="report5">
    <p><span class="bold"><a href="/ASP/acct_tasks/enter_bill.asp" target="_self">Payable Queue </a></span> - This area is where the user can review payables that have been automatically generated during the shipment process.  Payables not automatically generated can be added manually here also.</p>
</div>
<div id="report6">
    <p><span class="bold"><a href="/ASP/acct_tasks/pay_bills.asp" target="_self">Accounts Payable </a> </span> - This area is where the user can make payments on their payables.  The funds can be pulled from any of the bank or other accounts they have set up in the system.  Payables can also be edited to match actual invoices.  And change will be automatically updated backwards to the shipment info.</p>
</div>
<div id="report7"><p><span class="bold"><a href="/ASP/acct_tasks/write_chk.asp" target="_self">Write Checks</a></span> - This area is where the user may write checks from their bank accounts when those checks are not for any specific payable.  Miscellaneous payments can be made from here.</p>
</div>
<div id="report8"><p><span class="bold"><a href="/ASP/acct_tasks/print_chk.asp" target="_self">Print Checks</a> </span> - This are is where the user can print any checks that they did not print immediately after writing them.  This allows the user to print in batches if they do not have a dedicated check printer.</p>
</div>
<div id="report9"><p><span class="bold"><a href="/ASP/acct_tasks/chart_acct.asp" target="_self">Chart of Accounts,</a><a href="/ASP/acct_tasks/edit_ch_items.asp" target="_self"> Edit Charge Items,</a> <a href="/ASP/acct_tasks/edit_co_items.asp" target="_self">Edit Cost Items</a></span> - These areas are where the user sets up the types of accounts, charges, and cost items that will be used in their accounting system.</p>
</div>
<div id="report10"><p><span class="bold"><a href="/ASP/acct_tasks/gj_entry.asp" target="_self">General Journal Entry</a> </span> - Any general entry can be made here.</p>
</div>
<div id="reportbottom"><p><span class="bold"><a href="/ASP/acct_tasks/fiscalClose.asp" target="_self">Account Summary</a> </span> - Account Summaries may be pulled up here.  They are filterable by time period and type of account.</p>
</div></div>
</div>
</body>



</html>
