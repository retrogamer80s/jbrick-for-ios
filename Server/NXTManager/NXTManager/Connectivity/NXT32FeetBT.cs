using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using InTheHand.Net.Sockets;
using InTheHand.Net;
using System.Net.Sockets;
using InTheHand.Net.Bluetooth;
using System.IO;

namespace NXTManager.Connectivity
{
    class NXT32FeetBT : NXTConnection
    {
        public static readonly Guid NXT_BT_SERVICE = new Guid("{00001101-0000-1000-8000-00805F9B34FB}");

        private BluetoothClient btClient;
        private BluetoothAddress btAddress;

        public NXT32FeetBT(BluetoothAddress address)
        {
            btClient = new BluetoothClient();
            btAddress = address;
        }

        public bool IsConnected
        {
            get 
            {
                return btClient.Connected;
            }
        }

        public string Name
        {
            get { return "BT32Feet"; }
        }

        public bool Open()
        {
            try
            {
                btClient.Close();
                btClient = new BluetoothClient();
                btClient.Connect(btAddress, NXT_BT_SERVICE);
                return true;
            }
            catch (SocketException)
            {
                return false;
            }
        }

        public void Close()
        {
            btClient.Close();
        }

        public bool Reconnect()
        {
            try
            {
                btClient.Close();
                btClient = new BluetoothClient();
                btClient.Connect(btAddress, NXT_BT_SERVICE);
                return true;
            }
            catch (SocketException)
            {
                return false;
            }
        }

        public byte[] Send(byte[] data)
        {
            NetworkStream btStream = btClient.GetStream();

            // Create a Bluetooth header info
            List<byte> commandWithHeader = new List<byte>();
            //Construct the bluetooth header
            commandWithHeader.Add((byte)data.Length);
            commandWithHeader.Add(0x00);
            //Add the command
            commandWithHeader.AddRange(data);

            try
            {
                btStream.Write(commandWithHeader.ToArray(), 0, commandWithHeader.Count);
            }
            catch (IOException)
            {
                btStream.Write(commandWithHeader.ToArray(), 0, commandWithHeader.Count);
                // Try again, throwing the error if it fails again
            }
            // 0x81 or 0x01 indicates that we should expect a reply.
            if (data[0] == NXTCommands.NXTCommand.SYSTEM_CMD_WITH_REPLY || data[0] == NXTCommands.NXTCommand.DIRECT_CMD_WITH_REPLY)
            {
                //Prepare reply buffer
                int length = btStream.ReadByte() + 256 * btStream.ReadByte();
                Byte[] reply = new Byte[length];
                //Get reply
                btStream.Read(reply, 0, length);
                //Close the port
                return reply;
            }
            else
                return null;

        }
    }
}
