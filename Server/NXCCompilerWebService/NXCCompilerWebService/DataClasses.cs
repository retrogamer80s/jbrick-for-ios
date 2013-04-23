using NXTManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace NXCCompilerWebService.DataClasses
{
    [DataContract]
    public class NXTRobot
    {
        [DataMember]
        public String Name { get; set; }
        [DataMember]
        public String ID { get; set; }

        public NXTRobot(NXT robot)
        {
            Name = robot.Name;
            ID = robot.ID;
        }
    }
}