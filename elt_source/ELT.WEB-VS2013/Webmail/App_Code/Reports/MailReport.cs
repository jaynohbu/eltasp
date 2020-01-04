using System;
using System.Collections.Generic;
using DevExpress.XtraReports.UI;
using DevExpress.XtraScheduler;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Collections;

public class MailReport : XtraReport {
    private TopMarginBand TopMargin;
    private XRTable table2;
    private XRTableRow tableRow2;
    private XRTableCell tableCell4;
    private XRTableCell tableCell5;
    private XRTableCell tableCell6;
    private XRTable table1;
    private XRTableRow tableRow1;
    private XRTableCell tableCell1;
    private XRTableCell tableCell2;
    private XRTableCell tableCell3;
    private BottomMarginBand BottomMargin;
    private DetailBand Detail;

    public MailReport(IEnumerable messages) {
        InitializeComponent();
        this.DataSource = messages;
    }

    private void InitializeComponent() {
        this.TopMargin = new DevExpress.XtraReports.UI.TopMarginBand();
        this.table2 = new DevExpress.XtraReports.UI.XRTable();
        this.tableRow2 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell4 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell5 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell6 = new DevExpress.XtraReports.UI.XRTableCell();
        this.table1 = new DevExpress.XtraReports.UI.XRTable();
        this.tableRow1 = new DevExpress.XtraReports.UI.XRTableRow();
        this.tableCell1 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell2 = new DevExpress.XtraReports.UI.XRTableCell();
        this.tableCell3 = new DevExpress.XtraReports.UI.XRTableCell();
        this.BottomMargin = new DevExpress.XtraReports.UI.BottomMarginBand();
        this.Detail = new DevExpress.XtraReports.UI.DetailBand();
        ((System.ComponentModel.ISupportInitialize)(this.table2)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this.table1)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
        // 
        // TopMargin
        // 
        this.TopMargin.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.table2});
        this.TopMargin.HeightF = 133.3333F;
        this.TopMargin.Name = "TopMargin";
        // 
        // table2
        // 
        this.table2.AnchorVertical = DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom;
        this.table2.LocationFloat = new DevExpress.Utils.PointFloat(10.00001F, 97.50001F);
        this.table2.Name = "table2";
        this.table2.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.tableRow2});
        this.table2.SizeF = new System.Drawing.SizeF(630F, 35.8333F);
        // 
        // tableRow2
        // 
        this.tableRow2.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell4,
            this.tableCell5,
            this.tableCell6});
        this.tableRow2.Name = "tableRow2";
        this.tableRow2.Weight = 1D;
        // 
        // tableCell4
        // 
        this.tableCell4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(192)))));
        this.tableCell4.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top)
        | DevExpress.XtraPrinting.BorderSide.Right)));
        this.tableCell4.CanGrow = false;
        this.tableCell4.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold);
        this.tableCell4.Name = "tableCell4";
        this.tableCell4.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell4.StylePriority.UseBackColor = false;
        this.tableCell4.StylePriority.UseBorders = false;
        this.tableCell4.StylePriority.UseFont = false;
        this.tableCell4.StylePriority.UsePadding = false;
        this.tableCell4.Text = "From";
        this.tableCell4.Weight = 1D;
        // 
        // tableCell5
        // 
        this.tableCell5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(192)))));
        this.tableCell5.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top)
        | DevExpress.XtraPrinting.BorderSide.Right)));
        this.tableCell5.CanGrow = false;
        this.tableCell5.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold);
        this.tableCell5.Name = "tableCell5";
        this.tableCell5.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell5.StylePriority.UseBackColor = false;
        this.tableCell5.StylePriority.UseBorders = false;
        this.tableCell5.StylePriority.UseFont = false;
        this.tableCell5.StylePriority.UsePadding = false;
        this.tableCell5.Text = "Subject";
        this.tableCell5.Weight = 1.461309523809524D;
        // 
        // tableCell6
        // 
        this.tableCell6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(192)))));
        this.tableCell6.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top)
        | DevExpress.XtraPrinting.BorderSide.Right)));
        this.tableCell6.CanGrow = false;
        this.tableCell6.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold);
        this.tableCell6.Name = "tableCell6";
        this.tableCell6.Padding = new DevExpress.XtraPrinting.PaddingInfo(10, 5, 5, 5, 100F);
        this.tableCell6.StylePriority.UseBackColor = false;
        this.tableCell6.StylePriority.UseBorders = false;
        this.tableCell6.StylePriority.UseFont = false;
        this.tableCell6.StylePriority.UsePadding = false;
        this.tableCell6.Text = "Date";
        this.tableCell6.Weight = 0.53869047619047616D;
        // 
        // table1
        // 
        this.table1.LocationFloat = new DevExpress.Utils.PointFloat(10F, 0F);
        this.table1.Name = "table1";
        this.table1.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.tableRow1});
        this.table1.SizeF = new System.Drawing.SizeF(630F, 25F);
        // 
        // tableRow1
        // 
        this.tableRow1.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.tableCell1,
            this.tableCell2,
            this.tableCell3});
        this.tableRow1.Name = "tableRow1";
        this.tableRow1.Weight = 1D;
        // 
        // tableCell1
        // 
        this.tableCell1.Borders = DevExpress.XtraPrinting.BorderSide.Top;
        this.tableCell1.Name = "tableCell1";
        this.tableCell1.StylePriority.UseBorders = false;
        this.tableCell1.Text = "[From]";
        this.tableCell1.Weight = 2.1000004577636715D;
        // 
        // tableCell2
        // 
        this.tableCell2.Borders = DevExpress.XtraPrinting.BorderSide.Top;
        this.tableCell2.Name = "tableCell2";
        this.tableCell2.StylePriority.UseBorders = false;
        this.tableCell2.Text = "[Subject]";
        this.tableCell2.Weight = 3.068749389648437D;
        // 
        // tableCell3
        // 
        this.tableCell3.Borders = DevExpress.XtraPrinting.BorderSide.Top;
        this.tableCell3.Name = "tableCell3";
        this.tableCell3.StylePriority.UseBorders = false;
        this.tableCell3.Text = "[Date]";
        this.tableCell3.Weight = 1.1312501525878913D;
        // 
        // BottomMargin
        // 
        this.BottomMargin.Name = "BottomMargin";
        // 
        // Detail
        // 
        this.Detail.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.table1});
        this.Detail.HeightF = 35.00001F;
        this.Detail.Name = "Detail";
        // 
        // MailReport
        // 
        this.Bands.AddRange(new DevExpress.XtraReports.UI.Band[] {
            this.TopMargin,
            this.Detail,
            this.BottomMargin});
        this.Margins = new System.Drawing.Printing.Margins(100, 100, 133, 100);
        this.Version = "13.2";
        ((System.ComponentModel.ISupportInitialize)(this.table2)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this.table1)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

    }
}
