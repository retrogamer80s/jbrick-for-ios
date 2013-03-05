using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager
{
    public class AvailableDevicesChangedEventArgs : EventArgs
    {
        public readonly NXT AffectedDevice;

        public AvailableDevicesChangedEventArgs(NXT nxt)
        {
            AffectedDevice = nxt;
        }
    }
}
