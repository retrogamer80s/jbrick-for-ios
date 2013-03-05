using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NXTManager;
using System.IO.Ports;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Description;

namespace NXTConsoleUtility
{
    class Program
    {
        private static ServiceHost host;

        static void Main(string[] args)
        {
            host = new ServiceHost(typeof(NXCCompilerWebService.NXCCompiler));
            host.Open();

            byte[] buffer;
            FileStream compiledFile = new FileStream(@"C:\Users\Colton\Desktop\test.rxe", FileMode.Open, FileAccess.Read);
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

            List<NXT> devices = new List<NXT>();
            Console.WriteLine("Found {0} devices", devices.Count);
            foreach (NXT robot in devices)
            {
                Console.WriteLine("--> '{0}' on port '{1}'", robot.Name, robot.ConnectionName);
            }
            while (true)
            {
                Console.WriteLine("Press any key to perform sound off");
                Console.ReadKey(true);
                int count = 0;
                foreach (NXT robot in devices)
                {
                    //robot.Rename("NXT" + count);
                    //count++;
                    robot.PlayTone(500, 500);
                }
            }
        }
    }
}
