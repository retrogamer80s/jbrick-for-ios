using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NXTManager;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows.Threading;
using System.Threading;

namespace NXTManagerGUI
{
    class MainViewModel : INotifyPropertyChanged
    {
        Dispatcher uiDispatcher;
        public MainViewModel()
        {
            uiDispatcher = Dispatcher.CurrentDispatcher;
            Robots = new ObservableCollection<NXTViewModel>();
            NXT.RobotAdded += new NXT.AvailableRobotsChangedEventHandler(NXT_RobotAdded);
            NXT.FindNXTDevices();
        }

        void NXT_RobotAdded(object sender, AvailableDevicesChangedEventArgs args)
        {
            // Modification to the observable collection must take place on the ui thread
            uiDispatcher.BeginInvoke( new ThreadStart( () => 
            { 
                Robots.Add(new NXTViewModel(args.AffectedDevice)); 
            }));
        }
        
        public ObservableCollection<NXTViewModel> Robots { get; private set; }

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
