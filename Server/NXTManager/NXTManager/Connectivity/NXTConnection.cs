using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager.Connectivity
{
    public interface NXTConnection
    {
        bool IsConnected { get; }
        String Name { get; }
        bool Open();
        void Close();
        bool Reconnect();
        byte[] Send(byte[] data);

    }
}
