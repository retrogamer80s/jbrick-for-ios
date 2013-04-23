using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.IO;
using System.Diagnostics;
using NXTManager;
using NXCCompilerWebService.DataClasses;

namespace NXCCompilerWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class NXCCompiler : INXCCompiler
    {
        public String Compile(String src, String filename, String nxtID)
        {
            filename += ".rxe";
            Guid guidFilename = Guid.NewGuid();
            String srcFilename = String.Format(Directory.GetCurrentDirectory() + @"\{0}.nxc", guidFilename);
            String compiledFilename = String.Format(Directory.GetCurrentDirectory() + @"\{0}.rxe", guidFilename);

            File.WriteAllText(srcFilename, src);
            RunResults runResults = Program.RunExecutable(Directory.GetCurrentDirectory() + @"\nbc.exe", 
                        "-O="+ compiledFilename + " " + srcFilename, ".");
            if (runResults.RunException != null)
                System.Diagnostics.Trace.WriteLine(runResults.RunException);
            else
            {
                System.Diagnostics.Trace.WriteLine("Output");
                System.Diagnostics.Trace.WriteLine("======");
                System.Diagnostics.Trace.WriteLine(runResults.Output);
                System.Diagnostics.Trace.WriteLine("Error");
                System.Diagnostics.Trace.WriteLine("=====");
                System.Diagnostics.Trace.WriteLine(runResults.Error);

                if (runResults.Error.Length < 3)
                { // An empty error list is "{}" 
                    SendProgramToNXT(compiledFilename, filename, nxtID);

                }

                File.Delete(srcFilename);
                return runResults.Error.ToString();
            }

            return null;
        }

        private void SendProgramToNXT(string compiledFilename, string filename, string nxtID)
        {
            if(NXT.AvailableRobots.ContainsKey(nxtID))
            {
                byte[] buffer;
                FileStream compiledFile = new FileStream(compiledFilename, FileMode.Open, FileAccess.Read);
                try
                {
                    int length = (int)compiledFile.Length;
                    buffer = new byte[length];
                    int count;
                    int sum = 0;

                    while ((count = compiledFile.Read(buffer, sum, length - sum)) > 0)
                        sum += count;

                }
                finally
                {
                    compiledFile.Close();
                }

                NXT.AvailableRobots[nxtID].CreateFile(filename, buffer);
            }
        }

        private void SendProgramToAllNXTS(string compiledFilename, string filename)
        {
            byte[] buffer;
            FileStream compiledFile = new FileStream(compiledFilename, FileMode.Open, FileAccess.Read);
            try
            {
                int length = (int)compiledFile.Length;
                buffer = new byte[length];
                int count;
                int sum = 0;

                while ((count = compiledFile.Read(buffer, sum, length - sum)) > 0)
                    sum += count;

            }
            finally
            {
                compiledFile.Close();
            }

            foreach (NXT robot in NXT.AvailableRobots.Values)
                robot.CreateFile(filename, buffer);
        }

        public NXTRobot[] GetAvailableDevices()
        {
            List<NXTRobot> robots = new List<NXTRobot>();
            foreach (NXT robot in NXT.AvailableRobots.Values)
                robots.Add(new NXTRobot(robot));

            return robots.ToArray();
        }

        public void PlayTone(String nxtID, int tone, int duration)
        {
            if(NXT.AvailableRobots.ContainsKey(nxtID))
                NXT.AvailableRobots[nxtID].PlayTone(duration, tone);
        }

        public void RunProgram(String nxtID, String filename)
        {
            filename += ".rxe";
            if (NXT.AvailableRobots.ContainsKey(nxtID))
                NXT.AvailableRobots[nxtID].RunProgram(filename);

        }

        public void StopProgram(String nxtID)
        {
            if (NXT.AvailableRobots.ContainsKey(nxtID))
                NXT.AvailableRobots[nxtID].StopProgram();
        }
    }

    class RunResults
    {
        public int ExitCode;
        public Exception RunException;
        public StringBuilder Output;
        public StringBuilder Error;
    }

    class Program
    {
        public static RunResults RunExecutable(string executablePath, string arguments, string workingDirectory)
        {
            RunResults runResults = new RunResults
            {
                Output = new StringBuilder(),
                Error = new StringBuilder(),
                RunException = null
            };
            try
            {
                if (File.Exists(executablePath))
                {
                    using (Process proc = new Process())
                    {
                        proc.StartInfo.FileName = executablePath;
                        proc.StartInfo.Arguments = arguments;
                        proc.StartInfo.WorkingDirectory = workingDirectory;
                        proc.StartInfo.UseShellExecute = false;
                        proc.StartInfo.RedirectStandardOutput = true;
                        proc.StartInfo.RedirectStandardError = true;
                        proc.OutputDataReceived +=
                            (o, e) => runResults.Output.Append(e.Data).Append(Environment.NewLine);
                        proc.ErrorDataReceived +=
                            (o, e) => runResults.Error.Append(e.Data).Append(Environment.NewLine);
                        proc.Start();
                        proc.BeginOutputReadLine();
                        proc.BeginErrorReadLine();
                        proc.WaitForExit();
                        runResults.ExitCode = proc.ExitCode;
                    }
                }
                else
                {
                    throw new ArgumentException("Invalid executable path.", "exePath");
                }
            }
            catch (Exception e)
            {
                runResults.RunException = e;
            }
            return runResults;
        }
    }
}