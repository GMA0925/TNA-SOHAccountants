using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    public class LocalBufferService
    {
        private readonly string connStr;

        public LocalBufferService(string connectionString)
        {
            connStr = connectionString;
        }

        public int GetLocalTransactionCount()
        {
            using (var conn = new SQLiteConnection(connStr))
            {
                conn.Open();
                var cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT COUNT(*) FROM Transactions";
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

    }
}
