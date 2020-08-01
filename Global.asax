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

		// Code that runs when an unhandled error occurs

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
