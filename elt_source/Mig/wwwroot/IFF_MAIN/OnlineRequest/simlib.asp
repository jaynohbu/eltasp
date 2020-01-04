<!--#INCLUDE FILE="md5.asp"-->

<script type="text/jscript" language="jscript" runat="server">

/*
 * Library functions to assist in integration using SIM method
 *
 * Main Interfaces:
 *
 * function InsertFP (loginid, txnkey, amount, sequence) - Insert HTML form elements required for SIM
 * function CalculateFP (loginid, txnkey, amount, sequence, tstamp) - Returns Fingerprint.
 * function GetSecondsSince1970 () - Returns the number of seconds since 1970 Jan 1 UTC.
 *
 * DISCLAIMER:
     This code is distributed in the hope that it will be useful, but without any warranty;
     without even the implied warranty of merchantability or fitness for a particular purpose.
 *
 */

function binl2byt(binarray)
{
  var hex_tab = "0123456789abcdef";
  var  bytarray = new Array(binarray.length * 4);
  var str = "";
  for(var i = 0; i < binarray.length * 4; i++)
  {
    bytarray[i] = (binarray[i>>2] >> ((i%4)*8+4) & 0xF) << 4 |
		   binarray[i>>2] >> ((i%4)*8) & 0xF;
  }
  return bytarray;
}


function bytarray2word (barray)
{

  var blks = new Array(barray.length / 4);
  for(var i = 0; i < blks.length; i++) blks[i] = 0
  for(var i = 0; i < barray.length; i++)
    blks[i>>2] |= (barray[i] & 0xFF) << ((i%4) * 8)
  //blks[i>>2] |= 0x80 << ((i%4) * 8)
  //blks[nblk*16-2] = barray.length * 8
  return blks
}

function bytarray2binl (barray)
{

  var nblk = ((barray.length + 8) >> 6) + 1 // number of 16-word blocks
  var blks = new Array(nblk * 16)
  for(var i = 0; i < nblk * 16; i++) blks[i] = 0
  for(var i = 0; i < barray.length; i++)
    blks[i>>2] |= (barray[i] & 0xFF) << ((i%4) * 8)
  blks[i>>2] |= 0x80 << ((i%4) * 8)
  blks[nblk*16-2] = barray.length * 8
  return blks
}

function b_calcMD5(barray) { return coreMD5(bytarray2binl(barray)) }


function HMAC (key, text)
{
var hkey;
var ipad= new Array(64);
var opad= new Array (64);
var idata;
var odata;

idata = new Array (64 + text.length);
odata = new Array (64 + 16);
if (key.length > 64) {
	hkey = calcMD5(key);
}
else
	hkey = key;

for (i=0;i<64;i++) {
	idata[i] = ipad[i] = 0x36;
	odata[i] = opad[i] = 0x5C;
}

for (i=0;i<hkey.length; i++) {
	 ipad[i] ^= hkey.charCodeAt(i);
	 opad[i] ^= hkey.charCodeAt(i);

	idata[i]= ipad[i] & 0xFF;
	odata[i] = opad[i] & 0xFF;
}

for (i=0;i<text.length;i++) {
	idata[64+i] = text.charCodeAt(i) & 0xFF;
}

var innerhashout = binl2byt(b_calcMD5(idata));
for (i=0;i<16;i++) {
odata[64+i] = innerhashout[i];
}


return binl2hex(b_calcMD5(odata));
}

/* Return the number of seconds elapsed since Jan 1, 1970 UTC */
function GetSecondsSince1970 ()
{
var d = new Date();
var secs= Math.floor(d.getTime() / 1000)  ;

return (secs);
}

/* Returns the fingerprint */
/* Use this when you need control of HTML output */
/* Currency is optional. If you send x_currency_code then you must pass the same currency code here */
function CalculateFP (loginid, txnkey, amount, sequence, tstamp, currency)
{

if (currency == null) currency = "";

var fingerprint = HMAC (txnkey, loginid + "^" + sequence + "^" + tstamp + "^" + amount + "^" + currency);

return (fingerprint);

}

/* Insert the HTML form elements needed for SIM */
/* currency is optional. */
function InsertFP (loginid, txnkey, amount, sequence, currency)
{
    var tstamp = GetSecondsSince1970 ();

    var fingerprint = CalculateFP (loginid, txnkey, amount, sequence, tstamp, currency);
    Response.Write ('<input type="hidden" name="x_login" value="' + loginid + '" />\n' );
    Response.Write ('\t<input type="hidden" name="x_fp_sequence" value="' + sequence + '" />\n' );
    Response.Write ('\t<input type="hidden" name="x_fp_timestamp" value="' + tstamp + '" />\n' );
    Response.Write ('\t<input type="hidden" name="x_fp_hash" value="' + fingerprint + '" />' );
    return (fingerprint);
}

</script>

