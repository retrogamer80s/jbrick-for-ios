using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using NXTManager.Connectivity;

namespace NXTManager.NXTCommands
{
    class PlaySoundCommand : NXTCommand
    {
        private byte[] duration;
        private byte[] tone;

        public PlaySoundCommand(NXTConnection nxtConn, int duration, int tone) : base(nxtConn)
        {
            this.duration = BitConverter.GetBytes(duration);
            this.tone = BitConverter.GetBytes(tone);
        }

        public override void Execute()
        {
            byte[] Command = new byte[6];
            //Set command type
            Command[0] = DIRECT_CMD_NO_REPLY; //Direct command without a response
            //Set command for nxt to execute
            Command[1] = 0x03; //Play Tone
            //Set Tone
            Command[2] = tone[0];
            Command[3] = tone[1];
            //Set Duration
            Command[4] = duration[0];
            Command[5] = duration[1];

            SendNXTCommand(Command);
        }
    }
}
