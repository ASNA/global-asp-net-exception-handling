<%@ Application Language="AVR" %>

<script runat="server">

    BegSr Application_Start
        DclSrParm sender Type(*Object)
        DclSrParm e Type(EventArgs)

        // Code that runs on application startup

    EndSr

    BegSr Application_End
        DclSrParm sender Type(*Object)
        DclSrParm e Type(EventArgs)

        //  Code that runs on application shutdown

    EndSr
        
    BegSr Application_Error
        DclSrParm sender Type(*Object)
        DclSrParm e Type(EventArgs)

        DclFld Error Type(System.Exception)
        DclFld guid Type(System.Guid) 
        DclFld ErrorKey Type(*String) 
        
        Error = Server.GetLastError()
        Server.ClearError()

        guid = System.Guid.NewGuid()
        ErrorKey = guid.ToString()

        If Error *Is System.Web.HttpUnhandledException
            Application[ErrorKey] = Error
            Server.TransferRequest('/Error.aspx?error=' + ErrorKey, *True)
        EndIf 

    EndSr

    BegSr Session_Start
        DclSrParm sender Type(*Object)
        DclSrParm e Type(EventArgs)

        // Code that runs when a new session is started
        DclFld ActiveDBName  Type(*String)
        DclFld DBName        Type(*String) 
        ActiveDBName = System.Configuration.ConfigurationManager.AppSettings["ActiveDBName"]
        DBName = System.Configuration.ConfigurationManager.AppSettings[ActiveDBName]
        Session['dbname'] = DBName
    EndSr

    BegSr Session_End
        DclSrParm sender Type(*Object)
        DclSrParm e Type(EventArgs)

        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    EndSr

       
</script>
