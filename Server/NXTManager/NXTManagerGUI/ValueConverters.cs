using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using System.Windows.Media.Imaging;
using System.IO;

namespace NXTManagerGUI
{
    public class EnabledImageConverter : IValueConverter
    {

        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            String src = @"Resources\nxtbluetoothsymbol_disabled.png";
            if (value is bool && ((bool)value))
                src = @"Resources\nxtbluetoothsymbol.png";
            
            BitmapImage image = new BitmapImage();
            image.BeginInit();
            image.UriSource = new Uri(Path.GetFullPath(src));
            image.EndInit();

            return image;

        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
