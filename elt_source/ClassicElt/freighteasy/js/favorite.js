
function listboxscript()
{
	selectedVal=document.forms.inputs.listbox.value;
	if(selectedVal=="1")//Customer Care
	{
		document.getElementById("features").innerHTML="<img src='images/feature_customer.gif' width='202' height='52' /><ul id='highlight'> <li>No additional charges for Support</li> <li>Friendly and Helpful Personnel</li> <li>Free Automatic Updates</li><li>Shipping Industry Knowledge</li></ul><h4>Always striving to be helpful to our members, we provide superior Support that comes free with the FreightEasy package.</h4> <h5><a href='../freighteasy/feature_story.asp'>< Read More ></a></h5>";
	}
	if(selectedVal=="2")//Mobility
	{
		document.getElementById("features").innerHTML="<img src='images/feature_mobility.gif' width='202' height='52' /> <ul id='highlight'> <li>Any computer with Internet Explorer</li> <li>Anywhere with Internet Access</li><li>Any time of the Day</li> </ul><h4>You don't have to be tethered to your office any more. FreightEasy will set you free.</h4> <h5><a href='../freighteasy/feature_story.asp#mobility'>< Read More ></a></h5>";
	}
	if(selectedVal=="3")//Accounting
	{
		document.getElementById("features").innerHTML="<img src='images/feature_accounting.gif' width='202' height='52' /> <ul id='highlight'> <li>Data pulled from shipment info</li> <li>Full Reporting</li><li>Invoice Queue</li><li>Built for Freight Forwarding</li> </ul> <h4>FreightEasy makes separate accounting and freight systems obsolete.  Go right from shipment entry to invoicing in a few clicks.</h4><h5><a href='../freighteasy/feature_story.asp#accounting'>< Read More ></a></h5>";
	}
	if(selectedVal=="4")//SaaS
	{
		document.getElementById("features").innerHTML="<img src='images/feature_saas.gif' width='202' height='52' /> <ul id='highlight'><li>Professionally Maintained</li><li>Predictable IT costs</li><li>No costly hardware</li></ul><h4>Software as a Service is the latest trend in the software industry because it is the best way to provide great service with minimal hassle at the lowest cost to the customer.</h4> <h5><a href='../freighteasy/feature_story.asp#saas'>< Read More ></a></h5>";
	}
	if(selectedVal=="5")//System Design
	{
		document.getElementById("features").innerHTML="<img src='images/feature_system.gif' width='202' height='52' /> <ul id='highlight'> <li>Modern, sleek, efficient</li> <li>Screens based on actual documents</li><li>Fast performance</li> <li>Easy to learn</li></ul><h4>We have used the latest in technology to create a system that is robust, user-friendly, and fast enough to keep pace.</h4> <h5><a href='../freighteasy/feature_story.asp#system'>< Read More ></a></h5>";
	}
}




function tabscript(s)
{
	var z = s.id;
	
	if(z=="T1")//Trial Account
	{
		document.getElementById("tabbody").innerHTML="<div id='tabbodyleft'><img src='images/tab_trial_img.gif' width='98' height='98' /></div><div id='tabbodyright'><h2>Want to know how FreightEasy works? Free Trial Accounts are available.</h2><ul class='psmall'><li><img src='images/tabbutton1.gif' width='18' height='11' align='absmiddle' />Instant account setup</li><li><img src='images/tabbutton2.gif' width='18' height='11' align='absmiddle' />A full version of the system</li></ul><ul class='psmallbottom'><li><img src='images/tabbutton3.gif' width='18' height='11' align='absmiddle' />No installation required</li></ul><h2 class='buttonlink'><a href='account_setup.asp'><img src='images/button_trial.gif' border='0' /></a></h2></div>";
		s.style.backgroundImage = "url(/freighteasy/images/tabnavback_over.gif)";
		document.getElementById("T2").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
		document.getElementById("T3").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
		document.getElementById("T4").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
		
	}

	if(z=="T2")//Downloads
	{
		document.getElementById("tabbody").innerHTML="<div id='tabbodyleft'><img src='images/tab_download_img.gif' width='98' height='98' /></div><div id='tabbodyright'><h2>Download a manual to learn how to use FreightEasy. </h2><ul class='psmallbottom'><li><img src='images/tabbutton1.gif' width='18' height='11' align='absmiddle' />FreightEasy User's manual </li></ul><ul class='psmallsub'><li><img src='images/spacer.gif' width='18' height='11' align='absmiddle' /><a href='../manual.html' target='_blank'>HTML</a> (will open in a new window)<img src='images/button_info.gif' alt='Download HTML file for screen viewing.' width='25' height='16' align='absmiddle' /></li><li><img src='images/spacer.gif' width='18' height='11' align='absmiddle' /><a href='http://www.freighteasy.net/freighteasy/images/FreightEasy-Guide.pdf' target='_blank'>PDF</a> (will open in a new window)<img src='images/button_info.gif' alt='Download PDF to print and read. ' width='25' height='16' align='absmiddle' /></li></ul><div id='devider'></div><ul class='psmallbottom'><li><img src='images/tabbutton2.gif' width='18' height='11' align='absmiddle' />See our latest mailer campaign</li></ul><ul class='psmallsub'><li><img src='images/spacer.gif' width='18' height='16' align='absmiddle' /><a href='images/mailer_campaign1.pdf' target='_blank'>Download Mailer</a> (will open in a new window)</li></ul></div>";
		s.style.backgroundImage = "url(/freighteasy/images/tabnavback_over.gif)";
		document.getElementById("T1").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
		document.getElementById("T3").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
	    document.getElementById("T4").style.backgroundImage = "url(/freighteasy/images/tabnavback_line.gif)";
	}
}