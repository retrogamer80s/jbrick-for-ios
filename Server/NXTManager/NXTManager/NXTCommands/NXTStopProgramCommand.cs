using NXTManager.Connectivity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager.NXTCommands
{
    class NXTStopProgramCommand : NXTCommand
    {
        public NXTStopProgramCommand(NXTConnection nxtConn) : base(nxtConn) { }

        public override void Execute()
        {
            byte[] Command = new byte[2];
            //Set command type
            Command[0] = DIRECT_CMD_NO_REPLY; //System command without a response
            //Set command for nxt to execute
            Command[1] = 0x01; //Stop Program
            //Bytes 2-21 represent the file name in ascii encoding ending with a null terminator (any un-used bytes should be filled with null terminators)

            SendNXTCommand(Command);
        }
    }
}
