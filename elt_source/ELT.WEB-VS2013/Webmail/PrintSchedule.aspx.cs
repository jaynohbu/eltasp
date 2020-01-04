using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.XtraScheduler.iCalendar;
using DevExpress.XtraScheduler;
using DevExpress.Web.ASPxEditors;
using System.Globalization;

public partial class PrintSchedule : System.Web.UI.Page {
    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }

    protected DateTime StartDate {
        get {
            string dateString = null;
            if(Utils.TryGetClientStateValue<string>(this, "StartDate", out dateString))
                return DateTime.Parse(dateString, CultureInfo.InvariantCulture);
            return DateTime.Now;
        }
    }

    protected DateTime EndDate {
        get {
            string dateString = null;
            if(Utils.TryGetClientStateValue<string>(this, "EndDate", out dateString))
                return DateTime.Parse(dateString, CultureInfo.InvariantCulture);
            return DateTime.Now.AddMonths(1);
        }
    }

    protected void Page_Load(object sender, EventArgs e) {
        var report = new ScheduleReport();
        report.SchedulerAdapter = PrintAdapter.SchedulerAdapter;
        report.SchedulerAdapter.TimeInterval = new TimeInterval(StartDate, EndDate);
        ScheduleReportViewer.Report = report;
    }

    protected void StartDateEdit_Load(object sender, EventArgs e) {
        if(!IsPostBack)
            ((ASPxDateEdit)sender).Date = StartDate;
    }

    protected void EndDateEdit_Load(object sender, EventArgs e) {
        if(!IsPostBack)
            ((ASPxDateEdit)sender).Date = EndDate;
    }
}
