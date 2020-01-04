using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DevExpress.Web.ASPxScheduler;
using DevExpress.XtraScheduler;

public class SchedulerRowInsertionHelper {
    List<Object> lastInsertedIdList = new List<object>();

    public void ProvideRowInsertion(ASPxScheduler control, ObjectDataSource dataSource) {
        control.AppointmentsInserted += control_AppointmentsInserted;
        control.AppointmentCollectionCleared += control_AppointmentCollectionCleared;
        dataSource.Inserted += dataSource_Inserted;
    }

    void control_AppointmentCollectionCleared(object sender, EventArgs e) {
        this.lastInsertedIdList.Clear();
    }
    void dataSource_Inserted(object sender, ObjectDataSourceStatusEventArgs e) {
        this.lastInsertedIdList.Add(e.ReturnValue);
    }
    void control_AppointmentsInserted(object sender, PersistentObjectsEventArgs e) {
        ASPxSchedulerStorage storage = (ASPxSchedulerStorage)sender;
        int count = e.Objects.Count;
        for(int i = 0; i < count; i++) { 
            Appointment apt = (Appointment)e.Objects[i];
            storage.SetAppointmentId(apt, this.lastInsertedIdList[i]);
        }
        this.lastInsertedIdList.Clear();
    }
}

public static class SchedulerData {
    static List<SchedulerResourceObject> _resources;
    static int _nextId = 0;

    static HttpContext Context { get { return HttpContext.Current; } }
    
    static List<SchedulerResourceObject> GenerateResources() {
        var doc = XDocument.Load(Context.Server.MapPath("~/App_Data/Resources.xml"));
        return (from node in doc.Descendants("Resource") select new SchedulerResourceObject {
            ID = Convert.ToInt32(node.Attribute("ID").Value),
            Name = node.Attribute("Name").Value
        }).ToList();
    }

    public static List<SchedulerAppointmentObject> GetAppointments() {
        const string key = "C74C8B5B-5765-460C-B998-43B75246547A";
        if(Context.Session[key] == null)
            Context.Session[key] = new List<SchedulerAppointmentObject>();
        return (List<SchedulerAppointmentObject>)Context.Session[key];
    }

    public static List<SchedulerResourceObject> GetResources() {
        if(_resources == null)
            _resources = GenerateResources();
        return _resources;
    }

    public static SchedulerAppointmentObject Find(object id) {
        return GetAppointments().First(a => a.ID == id);
    }

    public static object Insert(SchedulerAppointmentObject item) {
        item.ID = _nextId++;
        GetAppointments().Add(item);
        return item.ID;
    }

    public static void Update(SchedulerAppointmentObject item) {
        Delete(item);
        GetAppointments().Add(item);
    }

    public static void Delete(SchedulerAppointmentObject item) {
        GetAppointments().Remove(Find(item.ID));        
    }

}

public class SchedulerAppointmentObject {
    public object ID { get; set; }
    public int Type { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public bool AllDay { get; set; }
    public string Subject { get; set; }
    public string Location { get; set; }
    public string Description { get; set; }
    public int Status { get; set; }
    public int Label { get; set; }
    public object ResourceID { get; set; }
    public string RecurrenceInfo { get; set; }
}

public class SchedulerResourceObject {
    public int ID { get; set; }
    public string Name { get; set; }
}

