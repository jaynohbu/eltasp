using System;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for DataELT
/// </summary>
/// 
namespace FreightEasy.DataManager
{
    [Serializable]
    public class FreightEasyData : DataSet
    {
        protected SqlDataAdapter Adap = null;
        protected ConnectELT eltCon = null;
        protected string lastError = "";

        public FreightEasyData()
        {
            SetDBConnect();
        }

        public void AddToDataSet(string tableName, string sqlText)
        {
            SqlConnection thisCon = eltCon.OpenConnection();

            if (sqlText != null && sqlText.Trim() != "")
            {
                try
                {
                    DataTable tempTable = new DataTable(tableName);
                    Adap = new SqlDataAdapter();
                    thisCon.Open();
                    SqlCommand cmd = new SqlCommand(sqlText.ToString(), thisCon);
                    Adap.SelectCommand = cmd;
                    Adap.Fill(tempTable);
                    this.Tables.Add(tempTable);
                }
                catch(Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    if (Adap != null)
                    {
                        Adap.Dispose();
                    }
                    if (thisCon != null)
                    {
                        thisCon.Close();
                    }
                }
            }
        }

        public void RemoveFromDataSet(string tableName)
        {
            try
            {
                this.RemoveFromDataSet(tableName);
            }
            catch
            {
            }
        }

        public string GetResultString(string queryStr)
        {
            string resultStr = "";
            SqlConnection thisCon = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                SqlCommand Cmd = new SqlCommand(queryStr, thisCon);
                SqlDataReader reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    resultStr = reader[0].ToString();
                }
            }
            catch
            {
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return resultStr;
        }

        public bool DataTransaction(string commandStr)
        {
            bool returnVal = true;
            SqlConnection thisCon = null;
            SqlTransaction trans = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                trans = thisCon.BeginTransaction();
                SqlCommand Cmd = new SqlCommand(commandStr, thisCon, trans);
                try
                {
                    Cmd.ExecuteNonQuery();
                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    returnVal = false;
                }
            }
            catch (SqlException e)
            {
                lastError = e.Message;
                returnVal = false;
                if (trans != null)
                {
                    trans.Rollback();
                }
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return returnVal;
        }

        public bool DataTransactions(string[] commandStr)
        {
            bool returnVal = true;
            SqlConnection thisCon = null;
            SqlTransaction trans = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                trans = thisCon.BeginTransaction();
                SqlCommand Cmd = new SqlCommand();
                Cmd.Connection = thisCon;
                Cmd.Transaction = trans;

                try
                {
                    for (int i = 0; i < commandStr.Length; i++)
                    {
                        Cmd.CommandText = commandStr[i];
                        Cmd.ExecuteNonQuery();
                    }
                    trans.Commit();
                }
                catch (SqlException e)
                {
                    lastError = e.Message;
                    trans.Rollback();
                    returnVal = false;
                }
            }
            catch
            {
                returnVal = false;
                if (trans != null)
                {
                    trans.Rollback();
                }
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return returnVal;
        }

        public bool AddToSQLTable(string selectStr, DataTable dataTable)
        {
            bool returnVal = true;
            SqlConnection thisCon = null;
            SqlTransaction trans = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                trans = thisCon.BeginTransaction();

                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = new SqlCommand(selectStr, thisCon, trans);

                DataTable resultTable = new DataTable();
                Adap.Fill(resultTable);

                Adap.Update(dataTable);
                trans.Commit();
            }
            catch
            {
                returnVal = false;
                if (trans != null)
                {
                    trans.Rollback();
                }
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return returnVal;
        }


        public bool PreparedDataTransaction(string updateStr, DataTable dataTable)
        {
            bool returnVal = true;
            SqlConnection thisCon = null;
            SqlTransaction trans = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                trans = thisCon.BeginTransaction();
                SqlCommand Cmd = new SqlCommand(updateStr, thisCon, trans);
                SqlDataAdapter Adap = new SqlDataAdapter();

                for (int i = 0; i < dataTable.Rows.Count; i++)
                {
                    for (int j = 0; j < dataTable.Columns.Count; j++)
                    {
                        Cmd.Parameters.AddWithValue("@" + dataTable.Columns[j].ColumnName, dataTable.Rows[i][j]);
                    }
                }

                Adap.UpdateCommand = Cmd;
                Adap.Update(dataTable);
                trans.Commit();
            }
            catch
            {
                returnVal = false;
                if (trans != null)
                {
                    trans.Rollback();
                }
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return returnVal;
        }

        public bool PreparedDataTransactionInsert(string insertStr, DataTable dataTable)
        {
            bool returnVal = true;
            SqlConnection thisCon = null;
            SqlTransaction trans = null;
            try
            {
                thisCon = eltCon.OpenConnection();
                thisCon.Open();
                trans = thisCon.BeginTransaction();
                SqlCommand Cmd = new SqlCommand(insertStr, thisCon, trans);
                SqlDataAdapter Adap = new SqlDataAdapter();

                for (int i = 0; i < dataTable.Rows.Count; i++)
                {
                    for (int j = 0; j < dataTable.Columns.Count; j++)
                    {
                        Cmd.Parameters.AddWithValue("@" + dataTable.Columns[j].ColumnName, dataTable.Rows[i][j]);
                    }
                }

                Adap.InsertCommand = Cmd;
                Adap.Update(dataTable);
                trans.Commit();
            }
            catch
            {
                returnVal = false;
                if (trans != null)
                {
                    trans.Rollback();
                }
            }
            finally
            {
                if (thisCon != null)
                {
                    thisCon.Close();
                }
            }
            return returnVal;
        }

        public string GetLastTransactionError()
        {
            return lastError;
        }

        public void AddRelation(string relName, string parentTableName, string parentCol, string childTableName, string childCol)
        {
            char[] splitter = { ',' };
            string[] parentCols = parentCol.Split(splitter);
            string[] childCols = childCol.Split(splitter);
            int colSize = parentCols.Length;

            DataColumn[] parentDataCols = new DataColumn[colSize];
            DataColumn[] childDataCols = new DataColumn[colSize];

            for (int i = 0; i < colSize; i++)
            {
                parentDataCols[i] = this.Tables[parentTableName].Columns[parentCols[i]];
                childDataCols[i] = this.Tables[childTableName].Columns[childCols[i]];
            }
            try
            {
                this.Relations.Add(relName, parentDataCols, childDataCols);
            }
            catch (Exception e)
            {
                lastError = e.Message;
            }
        }

        protected void SetDBConnect()
        {
            eltCon = new ConnectELT();
        }

        protected void DisposeDBConnect()
        {
            eltCon.CloseConnection();
            eltCon = null;
        }
    }
}
