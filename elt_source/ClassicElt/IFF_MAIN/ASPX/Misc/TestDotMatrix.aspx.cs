using System;
using System.Collections;
using System.Drawing;
using System.Windows.Forms;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using J4L.TextPrinter;
using J4L.TextPrinter.Ports;
using J4L.TextPrinter.Printers; 

public partial class ASPX_Misc_TestDotMatrix : System.Web.UI.Page
{
    WindowsPrinter port;
    TextPrinter printer;

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            WindowsPrinter port = new WindowsPrinter(TextBox1.Text.ToString());
            printer = PrinterFactory.getPrinter(DropDownList1.SelectedValue.ToString());
            JobProperties job = printer.getDefaultJobProperties();
            printer.startJob(port, job);

            TextProperties prop = printer.getDefaultTextProperties();
            printer.printString("This must be NORMAL", prop);
            printer.newLine();

            printer.endJob();
        }
        catch(Exception ex)
        {
            Response.Write(ex.Message.ToString());
        }
    }
}
