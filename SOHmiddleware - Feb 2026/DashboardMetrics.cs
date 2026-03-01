using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    public class DashboardMetrics
    {
        private DateTime sessionStart;


        public DashboardMetrics()
        {
            sessionStart = DateTime.Now;
        }

        public List<int> GetSqlBufferTransactions()
        {
            // Replace with real DB query later
            return new List<int> { 15, 22, 18, 30, 25, 28, 35 };
        }

        public (int valid, int invalid) GetConfigValidationStatus()
        {
            string configPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ReaderSDK", "Configs");
            int valid = 0, invalid = 0;

            foreach (var file in Directory.GetFiles(configPath, "*.json"))
            {
                try
                {
                    var json = File.ReadAllText(file);
                    var config = JsonConvert.DeserializeObject<ReaderConfig>(json);
                    if (config != null && !string.IsNullOrWhiteSpace(config.Model) && config.Commands?.Count > 0)
                        valid++;
                    else
                        invalid++;
                }
                catch
                {
                    invalid++;
                }
            }

            return (valid, invalid);
        }

        public (int success, int failure) GetSdkCommandResults()
        {
            // Replace with real SDK log parsing later
            return (87, 13);
        }

        public List<(string label, int minutes)> GetUptimeSeries()
        {
            var now = DateTime.Now;
            var uptime = (now - sessionStart).TotalMinutes;
            var points = new List<(string, int)>();

            for (int i = 0; i <= 60; i += 10)
            {
                points.Add(($"{i} min", Math.Min(i, (int)uptime)));
            }

            return points;
        }
    }

}
