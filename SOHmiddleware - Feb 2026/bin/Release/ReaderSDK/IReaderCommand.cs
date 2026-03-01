using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOHmiddleware.ReaderSDKs
{
    public interface IReaderCommand
    {
        string Read();
        string Reset();
        // Add more commands as needed
    }
}
