using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NXTManager.Connectivity;

namespace NXTManager.NXTCommands
{
    class NXTSetNameCommand : NXTCommand
    {
        private String newName;
        public NXTSetNameCommand(NXTConnection nxtConn, String newName)
            : base(nxtConn)
        {
            this.newName = newName;
        }

        public override void Execute()
        {
            byte[] Command = new byte[18];
            //Set command type
            Command[0] = SYSTEM_CMD_WITH_REPLY; //System command without a response
            //Set command for nxt to execute
            Command[1] = 0x98; //Linear file create
            //Bytes 2-21 represent the file name in ascii encoding ending with a null terminator (any un-used bytes should be filled with null terminators)

            //Insert the filename, converting to ascii first
            int charCount = MAX_STR_LENGTH < newName.Length ? MAX_STR_LENGTH : newName.Length;
            ASCIIEncoding.ASCII.GetBytes(newName, 0, charCount, Command, 2);
            for (int i = 2 + newName.Length; i < Command.Length; i++)
                Command[i] = 0x00; //Insert null terminators

            SendNXTCommand(Command);
        }
    }
}
