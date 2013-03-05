using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Ports;
using NXTManager.Connectivity;

namespace NXTManager.NXTCommands
{
    class NXTGetNameCommand : NXTCommand
    {

        public NXTGetNameCommand(NXTConnection nxtConn) : base(nxtConn) { }

        public override void Execute()
        {
            byte[] command = new byte[2];
            //Set command type
            command[0] = 0x01; //System command with a response
            //Set command for nxt to execute
            command[1] = 0x9B; //Get Device Info

            try
            {
                Byte[] reply = SendNXTCommand(command);
                if (reply != null && reply.Length == 33)
                {
                    //Convert the bytes to ASCII characters and trim trailing null terminators
                    OnReceivedData(ASCIIEncoding.ASCII.GetString(reply.SubArray(3, 16)).Trim(new char[] { '\0' }));
                }
            }
            catch (TimeoutException){ OnReceivedData(null); } //A timeout means that the device isn't an nxt
            catch (IOException) { OnReceivedData(null); } //Com port was not accessable, also not an NXT
        }

        public String GetName()
        {
            byte[] command = new byte[2];
            //Set command type
            command[0] = 0x01; //System command with a response
            //Set command for nxt to execute
            command[1] = 0x9B; //Get Device Info

            try
            {
                Byte[] reply = SendNXTCommand(command);
                if (reply != null && reply.Length == 33)
                {
                    //Convert the bytes to ASCII characters and trim trailing null terminators
                    return ASCIIEncoding.ASCII.GetString(reply.SubArray(3, 16)).Trim(new char[] { '\0' });
                }
            }
            catch (TimeoutException) { return null; } //A timeout means that the device isn't an nxt
            catch (IOException) { return null; } //Com port was not accessable, also not an NXT
            return null;
        }
    }
}
