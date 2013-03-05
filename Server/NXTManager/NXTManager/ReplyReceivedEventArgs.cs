using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager
{
    class ReplyReceivedEventArgs : EventArgs
    {
        public byte[] Reply { get; private set; }

        public ReplyReceivedEventArgs(byte[] reply)
        {
            Reply = reply;
        }
    }
}
