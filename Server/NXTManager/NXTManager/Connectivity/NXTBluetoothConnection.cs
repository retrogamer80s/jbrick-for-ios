using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;

namespace NXTManager.Connectivity
{
    class NXTBluetoothConnection : NXTConnection
    {
        public SerialPort ComPort { get; set; }
        public bool IsConnected { get { return ComPort == null ? false : ComPort.IsOpen; } }
        public String Name { get { return ComPort.PortName; } }

        public NXTBluetoothConnection(SerialPort port)
        {
            ComPort = port;
        }

        public bool Open()
        {
            ComPort.Open();
            return true;
        }

        public void Close()
        {
            ComPort.Close();
        }

        public bool Reconnect()
        {
            // Not needed for this connection implimentation
            return true;
        }

        public byte[] Send(byte[] data)
        {
            // Create a Bluetooth header info
            List<byte> commandWithHeader = new List<byte>();
            //Construct the bluetooth header
            commandWithHeader.Add((byte)data.Length);
            commandWithHeader.Add(0x00);
            //Add the command
            commandWithHeader.AddRange(data);

            ComPort.Write(commandWithHeader.ToArray(), 0, commandWithHeader.Count);
            // 0x81 or 0x01 indicates that we should expect a reply.
            if (data[0] == NXTCommands.NXTCommand.SYSTEM_CMD_WITH_REPLY || data[0] == NXTCommands.NXTCommand.DIRECT_CMD_WITH_REPLY)
            {
                //Prepare reply buffer
                int length = ComPort.ReadByte() + 256 * ComPort.ReadByte();
                Byte[] reply = new Byte[length];
                //Get reply
                ComPort.Read(reply, 0, length);
                //Close the port
                return reply;
            }
            else
                return null;
        }
    }
}
