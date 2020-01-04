using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DevExpress.XtraReports.UI;
using System.Collections;

public class ContactReport : XtraReport {
    private XRTableRow tableRow1;
    private XRTableCell tableCell1;
    private XRTableCell tableCell2;
    private XRTableCell tableCell4;
    private XRTableRow tableRow3;
    private XRTableCell tableCell3;
    private XRTableCell tableCell6;
    private XRLabel label1;
    private XRTableRow tableRow2;
    private XRTableCell tableCell5;
    private TopMarginBand TopMargin;
    private ReportHeaderBand ReportHeader;
    private DetailBand Detail;
    private XRTable table1;
    private XRTableRow tableRow4;
    private XRTableCell tableCell7;
    private XRTableCell tableCell8;
    private XRPictureBox pictureBox1;
    private BottomMarginBand BottomMargin;

    public ContactReport(IEnumerable contacts) {
        InitializeComponent();
        this.DataSource = contacts;
    }

    private void InitializeComponent() {
        this.tableRow1 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell1 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell2 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell4 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableRow3 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell3 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell6 = new DevExpress.XtraReports.UI.XRTableCell();
        this.label1 = new DevExpress.XtraReports.UI.XRLabel();
        this.tableRow2 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell5 = new DevExpress.XtraReports.UI.XRTableCell();
        this.TopMargin = new DevExpress.XtraReports.UI.TopMarginBand();
        this.ReportHeader = new DevExpress.XtraReports.UI.ReportHeaderBand();
        this.Detail = new DevExpress.XtraReports.UI.DetailBand();
        this.table1 = new DevExpress.XtraReports.UI.XRTable();
        this.tableRow4 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell7 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell8 = new DevExpress.XtraReports.UI.XRTableCell();
        this.pictureBox1 = new DevExpress.XtraReports.UI.XRPictureBox();
        this.BottomMargin = new DevExpress.XtraReports.UI.BottomMarginBand();
        ((System.ComponentModel.ISupportInitialize)(this.table1)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
        // 
        // tableRow1
        // 
        this.tableRow1.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell1,
            this.tableCell2});
        this.tableRow1.Name = "tableRow1";
        this.tableRow1.Weight = 1D;
        // 
        // tableCell1
        // 
        this.tableCell1.Font = new System.Drawing.Font("Times New Roman", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        this.tableCell1.Name = "tableCell1";
        this.tableCell1.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell1.StylePriority.UseFont = false;
        this.tableCell1.StylePriority.UsePadding = false;
        this.tableCell1.StylePriority.UseTextAlignment = false;
        this.tableCell1.Text = "Name";
        this.tableCell1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell1.Weight = 0.74962134111264145D;
        // 
        // tableCell2
        // 
        this.tableCell2.Name = "tableCell2";
        this.tableCell2.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell2.StylePriority.UsePadding = false;
        this.tableCell2.StylePriority.UseTextAlignment = false;
        this.tableCell2.Text = "[Name]";
        this.tableCell2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell2.Weight = 2.2503786588873589D;
        // 
        // tableCell4
        // 
        this.tableCell4.Font = new System.Drawing.Font("Times New Roman", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        this.tableCell4.Name = "tableCell4";
        this.tableCell4.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell4.StylePriority.UseFont = false;
        this.tableCell4.StylePriority.UsePadding = false;
        this.tableCell4.StylePriority.UseTextAlignment = false;
        this.tableCell4.Text = "Email";
        this.tableCell4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell4.Weight = 0.74962134111264134D;
        // 
        // tableRow3
        // 
        this.tableRow3.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell3,
            this.tableCell6});
        this.tableRow3.Name = "tableRow3";
        this.tableRow3.Weight = 1D;
        // 
        // tableCell3
        // 
        this.tableCell3.Font = new System.Drawing.Font("Times New Roman", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        this.tableCell3.Name = "tableCell3";
        this.tableCell3.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell3.StylePriority.UseFont = false;
        this.tableCell3.StylePriority.UsePadding = false;
        this.tableCell3.StylePriority.UseTextAlignment = false;
        this.tableCell3.Text = "Address";
        this.tableCell3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell3.Weight = 0.74962156339552211D;
        // 
        // tableCell6
        // 
        this.tableCell6.Name = "tableCell6";
        this.tableCell6.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell6.StylePriority.UsePadding = false;
        this.tableCell6.StylePriority.UseTextAlignment = false;
        this.tableCell6.Text = "[Address]";
        this.tableCell6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell6.Weight = 2.2503784366044779D;
        // 
        // label1
        // 
        this.label1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
        this.label1.Font = new System.Drawing.Font("Times New Roman", 16F, System.Drawing.FontStyle.Bold);
        this.label1.LocationFloat = new DevExpress.Utils.PointFloat(0F, 0F);
        this.label1.Name = "label1";
        this.label1.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
        this.label1.SizeF = new System.Drawing.SizeF(639.9999F, 35.875F);
        this.label1.StylePriority.UseBackColor = false;
        this.label1.StylePriority.UseFont = false;
        this.label1.StylePriority.UseTextAlignment = false;
        this.label1.Text = "Contacts List";
        this.label1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
        // 
        // tableRow2
        // 
        this.tableRow2.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell4,
            this.tableCell5});
        this.tableRow2.Name = "tableRow2";
        this.tableRow2.Weight = 1D;
        // 
        // tableCell5
        // 
        this.tableCell5.Name = "tableCell5";
        this.tableCell5.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell5.StylePriority.UsePadding = false;
        this.tableCell5.StylePriority.UseTextAlignment = false;
        this.tableCell5.Text = "[Email]";
        this.tableCell5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell5.Weight = 2.2503786588873584D;
        // 
        // TopMargin
        // 
        this.TopMargin.Name = "TopMargin";
        // 
        // ReportHeader
        // 
        this.ReportHeader.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.label1});
        this.ReportHeader.HeightF = 35.875F;
        this.ReportHeader.Name = "ReportHeader";
        // 
        // Detail
        // 
        this.Detail.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.table1,
            this.pictureBox1});
        this.Detail.HeightF = 198.9583F;
        this.Detail.Name = "Detail";
        // 
        // table1
        // 
        this.table1.LocationFloat = new DevExpress.Utils.PointFloat(203.125F, 33.29166F);
        this.table1.Name = "table1";
        this.table1.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.tableRow1,
            this.tableRow2,
            this.tableRow3,
            this.tableRow4});
        this.table1.SizeF = new System.Drawing.SizeF(411.8749F, 129.1667F);
        this.table1.BeforePrint += new System.Drawing.Printing.PrintEventHandler(this.table1_BeforePrint);
        // 
        // tableRow4
        // 
        this.tableRow4.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell7,
            this.tableCell8});
        this.tableRow4.Name = "tableRow4";
        this.tableRow4.Weight = 1D;
        // 
        // tableCell7
        // 
        this.tableCell7.Font = new System.Drawing.Font("Times New Roman", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
        this.tableCell7.Name = "tableCell7";
        this.tableCell7.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell7.StylePriority.UseFont = false;
        this.tableCell7.StylePriority.UsePadding = false;
        this.tableCell7.StylePriority.UseTextAlignment = false;
        this.tableCell7.Text = "Phone";
        this.tableCell7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell7.Weight = 0.74962156339552211D;
        // 
        // tableCell8
        // 
        this.tableCell8.Name = "tableCell8";
        this.tableCell8.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell8.StylePriority.UsePadding = false;
        this.tableCell8.StylePriority.UseTextAlignment = false;
        this.tableCell8.Text = "[Phone]";
        this.tableCell8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
        this.tableCell8.Weight = 2.2503784366044779D;
        // 
        // pictureBox1
        // 
        this.pictureBox1.LocationFloat = new DevExpress.Utils.PointFloat(23.95833F, 22.87499F);
        this.pictureBox1.Name = "pictureBox1";
        this.pictureBox1.SizeF = new System.Drawing.SizeF(150F, 150F);
        this.pictureBox1.Sizing = DevExpress.XtraPrinting.ImageSizeMode.ZoomImage;
        this.pictureBox1.BeforePrint += new System.Drawing.Printing.PrintEventHandler(this.pictureBox1_BeforePrint);
        // 
        // BottomMargin
        // 
        this.BottomMargin.Name = "BottomMargin";
        // 
        // ContactReport
        // 
        this.Bands.AddRange(new DevExpress.XtraReports.UI.Band[] {
            this.TopMargin,
            this.Detail,
            this.BottomMargin,
            this.ReportHeader});
        this.Version = "13.2";
        ((System.ComponentModel.ISupportInitialize)(this.table1)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

    }

    void table1_BeforePrint(object sender, System.Drawing.Printing.PrintEventArgs e) {
        var table = (XRTable)sender;
        var report = table.Report;
        var address = report.GetCurrentColumnValue<string>("Address");
        var phone = report.GetCurrentColumnValue<string>("Phone");

        if(string.IsNullOrEmpty(address))
            this.tableRow3.Visible = false;
        if(string.IsNullOrEmpty(phone))
            this.tableRow4.Visible = false;
    }

    void pictureBox1_BeforePrint(object sender, System.Drawing.Printing.PrintEventArgs e) {
        var pictureBox = (XRPictureBox)sender;
        pictureBox.ImageUrl = pictureBox.Report.GetCurrentColumnValue<string>("PhotoUrl");
    }
}
