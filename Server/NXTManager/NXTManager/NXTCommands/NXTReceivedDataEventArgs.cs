using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager.NXTCommands
{
    public class NXTReceivedDataEventArgs : EventArgs
    {
        public String Result { get; private set; }

        public NXTReceivedDataEventArgs(String result)
        {
            Result = result;
        }
    }
}
