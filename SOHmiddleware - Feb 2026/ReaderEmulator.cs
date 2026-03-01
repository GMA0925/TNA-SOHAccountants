using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    public class ReaderEmulator
    {
        private int counter = 0;
        public class ReaderData
        {
            public string ReaderId { get; set; }           // e.g., "DS-K1T341CMFW"
            public DateTime Timestamp { get; set; }        // UTC or local time of event
            public string EventType { get; set; }          // e.g., "AccessGranted", "CardSwipe", "FaceMatch"
            public string PayloadRaw { get; set; }         // Raw JSON or XML from device
            public string CardNumber { get; set; }         // Optional: if RFID/card used
            public string PersonName { get; set; }         // Optional: if face recognition
            public string DeviceIP { get; set; }           // Useful for multi-device setups
            public bool IsEmulated { get; set; }           // Flag to distinguish r                                        
            // 🔧 Add this missing property:
            public string Value { get; set; }
            public string SiteId { get; set; }
        }

        public ReaderData GetNextReading()
        {
            counter++;
            return new ReaderData
            {
                ReaderId = "EMULATOR-01",
                Timestamp = DateTime.Now,
                EventType = "FaceMatch",                     // ✅ Correct event type
                Value = $"TestValue-{counter}",
                PayloadRaw = "{ \"match\": true }",
                CardNumber = "TEST12345",
                PersonName = "Test User",
                DeviceIP = "127.0.0.1",
                IsEmulated = true,                           // ✅ Will insert as 1 in SQL
                SiteId = Properties.Settings.Default.SiteID.ToString() // ✅ Pull from settings
            };
        }


    }
}
