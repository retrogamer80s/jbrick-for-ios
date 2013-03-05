using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using NXTManager.Connectivity;

namespace NXTManager.NXTCommands
{
    public abstract class NXTCommand
    {
        public static readonly byte SYSTEM_CMD_NO_REPLY = 0x81;
        public static readonly byte SYSTEM_CMD_WITH_REPLY = 0x01;
        public static readonly byte DIRECT_CMD_NO_REPLY = 0x80;
        public static readonly byte DIRECT_CMD_WITH_REPLY = 0x00;
        public static readonly int MAX_STR_LENGTH = 15;

        protected NXTConnection nxtConn;

        public delegate void NXTReceivedDataHandler(Object sender, NXTReceivedDataEventArgs args);
        public event NXTReceivedDataHandler ReceivedData;

        public NXTCommand(NXTConnection nxtConn)
        {
            this.nxtConn = nxtConn;
        }

        public abstract void Execute();

        protected byte[] SendNXTCommand(byte[] command)
        {
            //Send Command
            return nxtConn.Send(command);
        }

        protected void OnReceivedData(String data)
        {
            if (ReceivedData != null)
                ReceivedData(this, new NXTReceivedDataEventArgs(data));
        }
    }
}
