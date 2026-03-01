using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware.ReaderSDKs
{
    public class ReaderConfig
    {
        public string make { get; set; }   // lowercase
        public string model { get; set; }  // lowercase

        // Auto-property for JSON deserialization
        public Dictionary<string, string> Commands { get; set; } = new Dictionary<string, string>();
    }
}
