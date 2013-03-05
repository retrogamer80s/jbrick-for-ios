using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NXTManager.Connectivity;

namespace NXTManager.NXTCommands
{
    class NXTRunProgramCommand : NXTCommand
    {
        private String filename;

        public NXTRunProgramCommand(NXTConnection nxtConn, String filename)
            : base(nxtConn)
        {
            this.filename = filename;
        }

        public override void Execute()
        {
            byte[] Command = new byte[22];
            //Set command type
            Command[0] = DIRECT_CMD_NO_REPLY; //System command without a response
            //Set command for nxt to execute
            Command[1] = 0x00; //Linear file create
            //Bytes 2-21 represent the file name in ascii encoding ending with a null terminator (any un-used bytes should be filled with null terminators)

            //Insert the filename, converting to ascii first
            int charCount = MAX_STR_LENGTH < filename.Length ? MAX_STR_LENGTH : filename.Length;
            ASCIIEncoding.ASCII.GetBytes(filename, 0, charCount, Command, 2);
            for (int i = 2 + filename.Length; i < Command.Length; i++)
                Command[i] = 0x00; //Insert null terminators

            SendNXTCommand(Command);
        }
    }
}
