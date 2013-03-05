using System;
using WinUsbWrapper;

namespace NXTManager.Connectivity
{
    /// <summary>
    /// <para>Class representing communication over an USB connection.</para>
    /// </summary>
    /// <remarks>
    /// <para>Introduced with v2.0 of the framework.</para>
    /// </remarks>
    /// <seealso cref="NxtBluetoothConnection"/>
    public class NXTUsbConnection : NXTConnection
    {
        // I have no idea about how constant the GUID is. For all I know it may change every time the firmware of the NXT is updated.
        // This value was found in the fantomv.inf file. Search for [WinUsb_Inst_HW_AddReg].
        private static readonly Guid NXT_WINUSB_GUID = new Guid("{761ED34A-CCFA-416b-94BB-33486DB1F5D5}");
        private static UsbCommunication usb = new UsbCommunication(NXT_WINUSB_GUID);

        /// <summary>
        /// <para>This method has no function for an USB connection.</para>
        /// </summary>
        public bool Open()
        {
            return true;
        }

        /// <summary>
        /// <para>This method has no function for an USB connection.</para>
        /// </summary>
        public void Close()
        {
        }

        public bool Reconnect()
        {
            return true;
        }

        /// <summary>
        /// <para>Indicates if connected to the NXT brick.</para>
        /// </summary>
        public bool IsConnected
        {
            get { return usb.FindMyDevice(); }
        }

        public String Name
        {
            get { return "USB"; }
        }

        /// <summary>
        /// <para>Object to control mutex locking on the USB.</para>
        /// </summary>
        object usbLock = new object();

        /// <summary>
        /// <para>Sends a request for the NXT brick, and if applicable, receive the reply.</para>
        /// </summary>
        /// <param name="request">The request</param>
        /// <returns>The reply as a byte-array, or null</returns>
        public byte[] Send(byte[] request)
        {
            lock (usbLock)
            {
                usb.SendDataViaBulkTransfers(request);

                // 0x80 indicates that we should expect a reply.
                if ((request[0] & 0x80) == 0)
                {
                    return usb.ReadDataViaBulkTransfer();
                }
                else
                    return null;
            }
        }
    }
}
