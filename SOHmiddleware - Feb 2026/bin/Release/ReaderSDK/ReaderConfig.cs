using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware.ReaderSDKs
{
    public class ReaderConfig
    {
        public string Model { get; set; }

        // Auto-property for JSON deserialization
        public Dictionary<string, string> Commands { get; set; } = new Dictionary<string, string>();
    }
}
