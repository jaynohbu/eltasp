using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public class DataSetHelper
{
    public static DataTable SelectDistinct(DataTable sourceTable, string fieldName)
    {
        DataTable dt = new DataTable();
        for (int i = 0; i < sourceTable.Columns.Count; i++)
        {
            dt.Columns.Add(sourceTable.Columns[i].ColumnName, sourceTable.Columns[sourceTable.Columns[i].ColumnName].DataType);
        }
        object lastValue = null;
        if (sourceTable.Rows.Count != 0)
        {
            foreach (DataRow dr in sourceTable.Select("", "Date Issued"))
            {
                if (lastValue == null || !(columnEqual(lastValue, dr[fieldName])))
                {
                    DataRow newRow = dt.NewRow();
                    newRow.ItemArray = dr.ItemArray;
                    dt.Rows.Add(newRow);
                }
            }
        }
        return dt;
    }

    private static bool columnEqual(object a, object b)
    {
        // Compares two values to see if they are equal. Also compares DBNULL.Value.
        // Note: If your DataTable contains object fields, then you must extend this
        // function to handle them in a meaningful way if you intend to group on them.
        if (a == DBNull.Value && b == DBNull.Value) // both are DBNull.Value
            return true;
        if (a == DBNull.Value || b == DBNull.Value) // only one is DBNull.Value
            return false;
        return (a.Equals(b)); // value type standard comparison
    }
}
