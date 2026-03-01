using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware
{
    public class ReaderCommand : IReaderCommand
    {
        private readonly Dictionary<string, string> _commands;

        public ReaderCommand(ReaderConfig config)
        {
            _commands = config.Commands ?? new Dictionary<string, string>();
        }

        public string Read() => _commands.TryGetValue("read", out var cmd) ? cmd : "Read command not found.";
        public string Reset() => _commands.TryGetValue("reset", out var cmd) ? cmd : "Reset command not found.";

        public void Execute()
        {
            Console.WriteLine("Executing command...");
            // You can expand this to run actual SDK logic
        }
    }
}
