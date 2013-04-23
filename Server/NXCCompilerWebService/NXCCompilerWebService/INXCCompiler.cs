using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.IO;
using NXCCompilerWebService.DataClasses;

namespace NXCCompilerWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface INXCCompiler
    {

        [OperationContract]
        [WebInvoke(
            Method = "POST",
            ResponseFormat = WebMessageFormat.Xml,
            RequestFormat = WebMessageFormat.Json,
            BodyStyle = WebMessageBodyStyle.WrappedRequest,
            UriTemplate = "Devices/{nxtID}/Compile")]
        String Compile(string src, string filename, string nxtID);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json,
             BodyStyle = WebMessageBodyStyle.Bare,
             UriTemplate = "Devices")]
        NXTRobot[] GetAvailableDevices();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json,
             BodyStyle = WebMessageBodyStyle.Bare,
             UriTemplate = "Devices/{nxtID}/PlayTone?tone={tone}&duration={duration}")]
        void PlayTone(string nxtID, int tone, int duration);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json,
             BodyStyle = WebMessageBodyStyle.Bare,
             UriTemplate = "Devices/{nxtID}/RunProgram?program={filename}")]
        void RunProgram(string nxtID, string filename);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json,
             BodyStyle = WebMessageBodyStyle.Bare,
             UriTemplate = "Devices/{nxtID}/StopProgram")]
        void StopProgram(string nxtID);
    }
}
