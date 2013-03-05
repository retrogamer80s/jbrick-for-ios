using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NXTManager.Connectivity;
using System.IO;

namespace NXTManager.NXTCommands
{
    public class NXTWriteFileCommand : NXTCommand
    {
        private byte[] file;
        private String filename;

        public NXTWriteFileCommand(NXTConnection nxtConn, String filename, byte[] file)
            : base(nxtConn)
        {
            this.filename = filename;
            this.file = file;
        }

        public override void Execute()
        {
            NXTCreateFile();
        }

        private void NXTCreateFile()
        {
            byte[] Command = new byte[26];
            //Set command type
            Command[0] = SYSTEM_CMD_WITH_REPLY; //System command with a response
            //Set command for nxt to execute
            Command[1] = 0x89; //Linear file create
            //Bytes 4-23 represent the file name in ascii encoding ending with a null terminator (any un-used bytes should be filled with null terminators)
            //Bytes 24-27 represent the number of bytes to write to the file (LSB First again)

            //Insert the filename, converting to ascii first
            int charCount = MAX_STR_LENGTH < filename.Length ? MAX_STR_LENGTH : filename.Length;
            ASCIIEncoding.ASCII.GetBytes(filename, 0, charCount, Command, 2);
            for (int i = 2 + filename.Length; i < 22; i++)
                Command[i] = 0x00; //Insert null terminators

            //Insert the filesize
            byte[] filesizeArray = BitConverter.GetBytes(file.Length);
            for (int i = 22; i < 26; i++)
                Command[i] = filesizeArray[i - 22];

            byte[] reply = SendNXTCommand(Command);

            if (reply != null && reply[2] == 0x8F) //The file already exists
            {
                NXTDeleteFile();
                reply = SendNXTCommand(Command); // Resend the create command
            }
            else if (reply != null && reply[2] != 0x00) // There was an error
                throw new InvalidDataException();


            NXTWriteToFile(reply[reply.Length - 1]);
            NXTCloseFile(reply[reply.Length - 1]);
            new PlaySoundCommand(nxtConn, 500, 500).Execute();
        }

        private void NXTWriteToFile(byte fileID)
        {
            //The maxium size of a message that can be sent over bluetooth to the nxt
            //is 64 bytes. 5 of those bytes are used to describe the message. This leaves
            //59 bytes of data that can be sent with each message

            //Convert the file byte array into an array of byte arrays that are a maxium of 59 bytes
            byte[][] dataChunks = new byte[(int)Math.Ceiling((double)file.Length / (double)59)][];
            int currentChunk = 0;
            for (int i = 0; i < file.Length; i += 59)
            {
                dataChunks[currentChunk] = file.SubArray(i, 59);
                currentChunk++;
            }

            //Execute a write command for each data chunk
            foreach (byte[] dataChunk in dataChunks)
            {
                List<byte> Command = new List<byte>();
                //Set command type
                Command.Add(SYSTEM_CMD_NO_REPLY); //System command without a response
                //Set command for nxt to execute
                Command.Add(0x83); //Write
                Command.Add(fileID);
                Command.AddRange(dataChunk);

                SendNXTCommand(Command.ToArray());
            }
        }

        private void NXTCloseFile(byte fileID)
        {
            byte[] Command = new byte[3];
            //Set command type
            Command[0] = SYSTEM_CMD_NO_REPLY; //System command without a response
            //Set command for nxt to execute
            Command[1] = 0x84; //Close file
            Command[2] = fileID;

            SendNXTCommand(Command);
        }

        private void NXTDeleteFile()
        {
            byte[] Command = new byte[22];
            //Set command type
            Command[0] = SYSTEM_CMD_NO_REPLY; //System command without a response
            //Set command for nxt to execute
            Command[1] = 0x85; //Linear file create
            //Bytes 2-21 represent the file name in ascii encoding ending with a null terminator (any un-used bytes should be filled with null terminators)

            //Insert the filename, converting to ascii first
            int charCount = MAX_STR_LENGTH < filename.Length ? MAX_STR_LENGTH : filename.Length;
            ASCIIEncoding.ASCII.GetBytes(filename, 0, charCount, Command, 2);
            for (int i = 2 + filename.Length; i < 22; i++)
                Command[i] = 0x00; //Insert null terminators

            SendNXTCommand(Command);
        }
    }
}
