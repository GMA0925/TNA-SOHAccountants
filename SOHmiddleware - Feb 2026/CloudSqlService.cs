using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    public  class CloudSqlService
    {
        private readonly string connStr;

        public CloudSqlService(string connectionString)
        {
            connStr = connectionString;
        }

        public int GetCloudTransactionCount()
        {
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT COUNT(*) FROM Transactions", conn);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}
