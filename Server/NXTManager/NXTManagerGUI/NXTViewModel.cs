using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using NXTManager;
using System.Windows.Input;

namespace NXTManagerGUI
{
    class NXTViewModel : INotifyPropertyChanged
    {
        private NXT robot;

        public NXTViewModel(NXT robot)
        {
            this.robot = robot;
            robot.PropertyChanged += new PropertyChangedEventHandler(robot_PropertyChanged);
            robot.Disconnected += new NXT.AvailableRobotsChangedEventHandler(robot_Disconnected);
            robot.Reconnected += new NXT.AvailableRobotsChangedEventHandler(robot_Reconnected);
            connected = false;
        }

        void robot_Disconnected(object sender, AvailableDevicesChangedEventArgs args)
        {
            Connected = false;
        }

        void robot_Reconnected(object sender, AvailableDevicesChangedEventArgs args)
        {
            Connected = true;
        }

        void robot_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            RaisePropertyChanged(e.PropertyName);
        }

        #region View Properties
        public String Name
        {
            get { return robot.Name; }
            set
            {
                robot.Rename(value);
                RaisePropertyChanged("Name");
            }
        }

        private ICommand playToneCommand;
        public ICommand PlayToneCommand
        {
            get
            {
                if (playToneCommand == null)
                    playToneCommand = new RelayCommand(param => this.PlayTone());
                return playToneCommand;
            }
        }

        private bool connected;
        public bool Connected
        {
            get { return connected; }
            set
            {
                if (connected != value)
                {
                    connected = value;
                    RaisePropertyChanged("Connected");
                }
            }
        }
        #endregion // View Properties

        #region Private Methods
        private void PlayTone()
        {
            robot.PlayTone(500, 500);
        }
        #endregion // Private Methods


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
