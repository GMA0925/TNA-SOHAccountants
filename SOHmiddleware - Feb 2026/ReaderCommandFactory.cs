using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    // Ensure the IReaderCommand interface is defined or imported from the correct namespace
    public interface IReaderCommand
    {
        string Read();
        string Reset();
        void Execute(); // Example method, adjust as per your actual interface definition
    }

    public class ReaderConfig
    {
        public Dictionary<string, string> Commands { get; set; }
        public string Model { get; set; } // Add this property to fix the CS1061 error
    }

    public class ReaderCommandFactory
    {
        public static IReaderCommand GetCommandSet(string make, string model)
        {
            string path = Path.Combine("ReaderSDK", "Configs", $"{make}.json");

            if (!File.Exists(path))
                throw new FileNotFoundException($"SDK config not found for {make}");

            var json = File.ReadAllText(path);
            var config = JsonConvert.DeserializeObject<ReaderConfig>(json);

            if (config.Model != model)
                throw new Exception($"Model mismatch: expected {model}, found {config.Model}");

            return new ReaderCommand(config);
        }
    }

}
