using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NXTManager
{
    public static class ArrayExtensions
    {
        public static T[] SubArray<T>(this T[] data, int index, int maxLength)
        {
            int length = index + maxLength <= data.Length ? maxLength : data.Length - index;
            T[] result = new T[length];
            Array.Copy(data, index, result, 0, length);
            return result;
        }
    }
}
