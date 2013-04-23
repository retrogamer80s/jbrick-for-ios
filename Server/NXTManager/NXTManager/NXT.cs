using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.ComponentModel;
using NXTManager.NXTCommands;
using System.IO;
using NXTManager.Connectivity;
using InTheHand.Net.Sockets;
using InTheHand.Net.Bluetooth;
using System.Net.Sockets;
using System.Collections.ObjectModel;
using InTheHand.Net;
using System.Collections;

namespace NXTManager
{
    public class NXT : INotifyPropertyChanged
    {
        private static Dictionary<String, NXT> availableRobots = new Dictionary<string, NXT>();
        public static Dictionary<String, NXT> AvailableRobots { get { return availableRobots; } }

        private String name;
        public String Name {
            get { return name; }
            private set
            {
                name = value;
                RaisePropertyChanged("Name");
            }
        }

        public String ID { get { return uniqueID; } }
        public String ConnectionName { get { return nxtConn.Name; } }

        public delegate void AvailableRobotsChangedEventHandler(object sender, AvailableDevicesChangedEventArgs args);
        public static event AvailableRobotsChangedEventHandler RobotAdded;
        public event AvailableRobotsChangedEventHandler Disconnected;
        public event AvailableRobotsChangedEventHandler Reconnected;

        private static readonly int DEFAULT_TIMEOUT = 500;
        private static readonly int DEVICE_DISCOVERY_POLL_RATE = 0;

        private String uniqueID;
        private NXTConnection nxtConn;
        private bool connected;
        private BlockingCollection<NXTCommand> commandQueue;
        private BackgroundWorker commandExecuter;
        private static BackgroundWorker deviceDiscovery;
        private static bool continueDeviceDiscovery;

        private NXT(String uniqueID, NXTConnection nxtConn)
        {
            this.name = "Connecting...";
            this.nxtConn = nxtConn;
            this.uniqueID = uniqueID;
            connected = false;

            commandQueue = new BlockingCollection<NXTCommand>();
            commandExecuter = new BackgroundWorker();
            commandExecuter.DoWork += new DoWorkEventHandler(ExecuteNextCommand);
            commandExecuter.RunWorkerAsync();

            // Submit the request to get the device name
            NXTGetNameCommand getName = new NXTGetNameCommand(nxtConn);
            getName.ReceivedData += new NXTCommand.NXTReceivedDataHandler(getName_ReceivedData);
            commandQueue.Add(getName);
            
        }

        public static void FindNXTDevices()
        {
            continueDeviceDiscovery = true;
            if (deviceDiscovery == null)
            {
                deviceDiscovery = new BackgroundWorker();
                deviceDiscovery.DoWork += new DoWorkEventHandler(FindNXTDevices);
            }
            // Start up device discovery if it was not already
            if (!deviceDiscovery.IsBusy)
                deviceDiscovery.RunWorkerAsync();
        }

        public static void FindNXTDevices(object sender, DoWorkEventArgs eventArgs)
        {
            
            while (continueDeviceDiscovery)
            {
                if (!availableRobots.ContainsKey("USB")) // If a usb was not connected before test it now
                {
                    NXT usbNXT = new NXT("USB", new NXTUsbConnection());
                    if (usbNXT.nxtConn.IsConnected)
                    {
                        availableRobots.Add("USB", usbNXT);
                        OnDeviceAdded(usbNXT);
                    }
                }

                var btClient = new BluetoothClient();
                List<BluetoothClient> btRobots = new List<BluetoothClient>();
                btClient.InquiryLength = new TimeSpan(0, 0, 4);
                BluetoothDeviceInfo[] btDevices = btClient.DiscoverDevicesInRange();
                foreach (BluetoothDeviceInfo btDevice in btDevices)
                {
                    try
                    {
                        // The property InstalledServices only lists services for devices that have been paired with
                        // the computer already (rather than requesting it from the device). This is fine in our 
                        // scenario since you cant get a service list off the devices unless it is already paired.
                        if (btDevice.InstalledServices.Contains(NXT32FeetBT.NXT_BT_SERVICE))
                        {
                            String nxtIdentifier = btDevice.DeviceAddress.ToString();
                            if (!availableRobots.ContainsKey(nxtIdentifier))
                            {
                                NXT foundNXT = new NXT(nxtIdentifier, new NXT32FeetBT(btDevice.DeviceAddress));
                                availableRobots.Add(nxtIdentifier, foundNXT);
                                OnDeviceAdded(foundNXT);
                            }
                            else
                            {
                                if (!availableRobots[nxtIdentifier].connected)
                                {
                                    availableRobots[nxtIdentifier].Reconnect();
                                }
                            }
                        }
                    }
                    catch (SocketException e) { } // Socket exception occurs if the device is not an nxt
                }

                // Check if any previously found devices were lost
                var btAddresses = from btDevice in btDevices
                                  select btDevice.DeviceAddress.ToString();
                foreach (NXT nxt in AvailableRobots.Values)
                {
                    if (!btAddresses.Contains(nxt.uniqueID))
                    {
                        nxt.connected = false;
                        nxt.OnDeviceDisconnected();
                    }
                }

                // Sleep for the designated poll interval
                Thread.Sleep(DEVICE_DISCOVERY_POLL_RATE);
            }
        }

        public void PlayTone(int duration, int tone)
        {
            commandQueue.Add(new PlaySoundCommand(nxtConn, duration, tone));
        }

        public void CreateFile(String filename, byte[] fileData)
        {
            commandQueue.Add(new NXTWriteFileCommand(nxtConn, filename, fileData));
        }

        public void Rename(String newName)
        {
            commandQueue.Add(new NXTSetNameCommand(nxtConn, newName));
            Name = newName;
        }

        public void RunProgram(String filename)
        {
            commandQueue.Add(new NXTRunProgramCommand(nxtConn, filename));
        }

        public void StopProgram()
        {
            commandQueue.Add(new NXTStopProgramCommand(nxtConn));
        }

        private void Reconnect()
        {
            connected = nxtConn.Reconnect();
            if (connected)
                OnDeviceReconnected();
            if (!commandExecuter.IsBusy)
                commandExecuter.RunWorkerAsync();
        }

        private static void OnDeviceAdded(NXT nxt)
        {
            if (RobotAdded != null)
                RobotAdded(nxt, new AvailableDevicesChangedEventArgs(nxt));
        }

        private void OnDeviceDisconnected()
        {
            if (Disconnected != null)
                Disconnected(this, new AvailableDevicesChangedEventArgs(this));
        }

        private void OnDeviceReconnected()
        {
            if (Reconnected != null)
                Reconnected(this, new AvailableDevicesChangedEventArgs(this));
        }

        private void getName_ReceivedData(object sender, NXTReceivedDataEventArgs args)
        {
            Name = args.Result;
        }

        private void ExecuteNextCommand(object sender, DoWorkEventArgs e)
        {
            ExecuteNextCommand(sender, e, 1);
        }

        private void ExecuteNextCommand(object sender, DoWorkEventArgs e, int connectionAttempts)
        {
            //Open the connection
            try
            {
                connected = nxtConn.Open();
                if (connected)
                    OnDeviceReconnected();
            }
            catch (IOException ioException)
            {
                if (connectionAttempts > 3)
                    throw ioException;
                else
                {
                    // Wait for the port to open up and try connecting again
                    Thread.Sleep(500);
                    connectionAttempts++;
                    ExecuteNextCommand(sender, e, connectionAttempts);
                }
            }

            while (connected)
            {
                // Take the the next command out of the queue (BlockingCollection defaults to FIFO order)
                // This method is expected to spend most of its time blocking on the queue
                NXTCommand command = commandQueue.Take();
                if (connected) // Make sure it is still connected
                    command.Execute();
                else
                    commandQueue.Add(command); // Since we couldn't execute re-add command
            }
        }

        override public bool Equals(object obj)
        {
 	         if( obj is NXT ){
                 return uniqueID.Equals( ((NXT)obj).uniqueID );
             }
             return false;
        }

        #region INotifyPropertyChanged Members

        public event PropertyChangedEventHandler PropertyChanged;

        private void RaisePropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
                this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }

        #endregion	
    }
}
