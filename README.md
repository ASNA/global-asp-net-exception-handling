# An example pattern for DB connections and error handling


### Example pattern.

The intent of this pattern (and its example code) is to provide a reusable way to provide DataGate database connection objects and to provide effective global exception handling.

The code below shows the pattern in action. Note that:

* The code-behind doesn't need to provide any error handling for the DataGate database object. Those details are handled by the code. 
* The runtime database name is soft-coded in `web.config.`
* An error page is provided to show unhandled or explicitly-thrown runtime exceptions. This also logs the exception details to a text file.

    ...
    Using System.Configuration
    ...

    BegClass example_code_behind...
        DclDB DB 
        DclFld DGDBManager Type(DataGateDB) New()

        BegSr Page_Load Access(*Private) Event(*This.Load)
            DclSrParm sender Type(*Object)
            DclSrParm e Type(System.EventArgs)

            DclFld ActiveDBName Type(*String) 
            DclFld RuntimeDBName Type(*String) 

            // Fetch active DB name.
            ActiveDBName = ConfigurationManager.AppSettings['ActiveDBName']
            // Fetch runtime DB Name. 
            RuntimeDBName = ConfigurationManager.AppSettings[ActiveDBName]
            // Get DB Reference. DGDB now references active DataGate DB
            // connection for life of this page. Pass this reference
            // around as needed during the lifetime of this page.
            DGDB = DGDBManager.GetNewConnection(RuntimeDBName)

            If (NOT Page.IsPostBack)
                // Do work...
            Else            
                // Do work...
            EndIf
        EndSr 

        BegSr Page_Unload Access(*Private) Event(*This.Unload)
            DclSrParm sender Type(*Object)
            DclSrParm e Type(System.EventArgs)

            // Disconnect before page goes out of scope.
            Disconnect DGDB
        EndSr

    EndClass

If an unhandled or explicitly-thrown exception occurs the following error page is displayed. This page is shown with ASP.NET's `Server.Transfer` method so that url continues to reflect the page that caused the error. 

![](https://asna.com/media/images/critical-error-1.png)

## Implementation code

### web.config

As many database names as needed are defined in web.config. The `ActiveDBName` key defines the active DB name. Changing this value to any of the other database name keys provided identifies the active database name the next
time the app runs. 

    <?xml version="1.0"?>
    <configuration>
    ...
    <appSettings>
        <add key="ActiveDBName" value="local"/>
        <add key="local" value="*Public/DG NET Local"/>
        <add key="ibmi" value="*Public/Cypress"/>
    </appSettings>
    ...
    </configuration>

### DataGate DB manager class

This class connects to a given DataGate database. If successful, it returns a reference to an active DataGate DB object. If unsuccessful, an `ArguementException` is thrown. 

    Using System

    BegClass DataGateDB Access(*Public)

        // Note that no DBName is provided here! This assumes you're 
        // doing all your code in secondary classes. 
        DclDB DGDB 

        BegFunc GetNewConnection Access(*Public) +
                Type(ASNA.VisualRPG.Runtime.Database) 
            DclSrParm DBName Type(*String) 

            DclFld MsgMask Type(*String) 

            MsgMask = 'Could not connect to {0} database name'

            If *This.DGDB.IsOpen
                Disconnect *This.DGDB
            EndIf 

            *This.DGDB.DBName = DBName
            Try 
                Connect *This.DGDB 
                // If you get here, you're good! 
                // Return the DB object. 
                LeaveSr DGDB 
            Catch Error Type(System.Exception) 
                // Sad trombone.
                Throw *New System.ArgumentException(String.Format(MsgMask, DBName)) 
            EndTry  
        EndFunc

    EndClass

### Global exception handling

The `global.asax's` Application_Error provides the jumping-off place to globally handle any otherwise unhandled application exceptions. 

When an unhandled exception occurs, the session state object is usually not accessible. To persist the unhandled exception (so its details can be shown) that exception is put in an application state variable. Application state is shared by all users so to ensure error key uniqueness, a guid is used as the application state key for the stored exception. 

ASP.NET's `Server.Transfer` transfers control to the `error.aspx` page, passing the guid as a query string value. This enables `error.aspx` to fetch that exception to show the exception's details.

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

### The error.aspx page

The `error.aspx` markup is shown below. It uses the free [FontAwesome 'skull-crossbones' icon](https://fontawesome.com/icons/skull-crossbones?style=solid). `error.aspx` is in the project's root.

This page assumes an `error` folder is your project's root. It writes the details shown on this page to a file in that folder named yyyy-mm-dd-hh-mm-ss where the time is in 24-hour format. 

This page doesn't include any links for the user to recover control of the application. You may want to consider adding such links. It's possible back button would let the user recover control, but an explicit link is probably better. 

    <%@ Page Language="AVR" AutoEventWireup="false" CodeFile="Error.aspx.vr" Inherits="Error" %>

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

    <html xmlns="http://www.w3.org/1999/xhtml" >
    <head runat="server">
        <title>Untitled Page</title>
        <link href="/dist/css/error.css" rel="stylesheet" />
    </head>
    <body>
        <form id="form1" runat="server">
        <div>
            <div class="error-icon-container">
                <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="skull-crossbones" class="svg-inline--fa fa-skull-crossbones fa-w-14" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M439.15 453.06L297.17 384l141.99-69.06c7.9-3.95 11.11-13.56 7.15-21.46L432 264.85c-3.95-7.9-13.56-11.11-21.47-7.16L224 348.41 37.47 257.69c-7.9-3.95-17.51-.75-21.47 7.16L1.69 293.48c-3.95 7.9-.75 17.51 7.15 21.46L150.83 384 8.85 453.06c-7.9 3.95-11.11 13.56-7.15 21.47l14.31 28.63c3.95 7.9 13.56 11.11 21.47 7.15L224 419.59l186.53 90.72c7.9 3.95 17.51.75 21.47-7.15l14.31-28.63c3.95-7.91.74-17.52-7.16-21.47zM150 237.28l-5.48 25.87c-2.67 12.62 5.42 24.85 16.45 24.85h126.08c11.03 0 19.12-12.23 16.45-24.85l-5.5-25.87c41.78-22.41 70-62.75 70-109.28C368 57.31 303.53 0 224 0S80 57.31 80 128c0 46.53 28.22 86.87 70 109.28zM280 112c17.65 0 32 14.35 32 32s-14.35 32-32 32-32-14.35-32-32 14.35-32 32-32zm-112 0c17.65 0 32 14.35 32 32s-14.35 32-32 32-32-14.35-32-32 14.35-32 32-32z"></path></svg>
            </div> 
            <h1>CRITICAL ERROR</h1>
            <h2>
                <asp:Label ID="labelErrorHeading" runat="server" Text="Label"></asp:Label>
            </h2>
            <h3>Error details (exceptions are shown inner-most first)</h3>
            <div class="error-detail-container">
                <pre><asp:Literal ID="literalErrorDetail" runat="server"></asp:Literal></pre>
            </div>
        </div>
        </form>
    </body>
    </html>

The `error.aspx.vr` code behind is shown below:

This code fetches the error exception object from the application object using the key provided in the query string. 

    Using System
    Using System.Collections.Specialized    

    BegClass Error Partial(*Yes) Access(*Public) Extends(System.Web.UI.Page)
        DclConst CRLF  Value(U'000D000A')  Access(*Public) 

        BegSr Page_Load Access(*Private) Event(*This.Load)
            DclSrParm sender Type(*Object)
            DclSrParm e Type(System.EventArgs)
        
            DclFld Error   Type(System.Exception) 
            DclFld ErrorKey Type(*String) 
            
            *This.Title = "An error occurred"

            If (NOT Page.IsPostBack)
                ErrorKey = Request.QueryString['error']

                Error = Application[ErrorKey] *As System.Exception 

                If Error <> *Nothing  
                    // Show error details.
                    literalErrorDetail.Text = GetErrorDetails(Error, CRLF)             
                EndIf             
            EndIf
        EndSr

        BegFunc GetErrorDetails Type(*String)  Access(*Public) 
            //
            // Get all error message and stack trace info for a given error.
            //
            DclSrParm Error    Type(System.Exception) 
            DclSrParm NewLine  Type(*String) 
            
            // NewLine provides the way new lines should be formed. When the
            // text is used inside a multi-line textbox, a CRLF should be used 
            // as a newline. When the text is sent as a formatted email (as 
            // an HTML document) the <br> tag should be used.

            DclFld ErrorDetails Type(System.Text.StringBuilder) New(512) 
            DclFld NestedDetails Type(StringCollection) New()
            DclFld Counter Type(*Integer4) 

            DclFld Level Type(*Integer4) 
            DclFld Now Type(DateTime) 
            DclFld MsgMask Type(*String) 
            DclFld Index Type(*Integer4) 

            MsgMask = 'This error occured on {0} at {1}M{2}' 
                    
            Now = DateTime.Now 
            labelErrorHeading.Text = + 
              String.Format(MsgMask, Now.ToString("dddd, MMMM dd, yyyy"), +
              Now.ToString("hh:mm:ss t"), NewLine + NewLine)

            CollectNestedErrorDetail(Error, NestedDetails, Level, NewLine)         

            // Collect all exception detail.
            Error = Error.InnerException
            DoWhile (Error <> *Nothing) 
                Level = Level + 1
                CollectNestedErrorDetail(Error, NestedDetails, Level, NewLine) 
                Error = Error.InnerException
            EndDo 
        
            // Reorder exception detail that the inner-most exception, the one
            // that caused the problem, is shown first. 
            For Index(Counter = NestedDetails.Count -1) DownTo(0) 
                ErrorDetails.Append(NestedDetails[Counter])
                If Counter <> 0 
                    ErrorDetails.Append(*New System.String('-' *As *OneChar, 150) + NewLine)
                EndIf 
            EndFor 

            LogError(ErrorDetails.ToString())
            LeaveSr ErrorDetails.ToString() 
        EndFunc 
        
        BegSr CollectNestedErrorDetail
            DclSrParm Error         Type(System.Exception) 
            DclSrParm NestedDetails Type(StringCollection) 
            DclSrParm Level         Type(*Integer4)
            DclSrParm NewLine       Type(*String) 
            
            DclFld ErrorDetails  Type(System.Text.StringBuilder) New()

            ErrorDetails.Append("Error level " + Level.ToString() + NewLine)              
            ErrorDetails.Append("Error message: ")
            ErrorDetails.Append(Error.Message + NewLine + NewLine) 
            ErrorDetails.Append("Stack trace:" + NewLine) 
            ErrorDetails.Append(Error.StackTrace + NewLine + NewLine + NewLine + NewLine) 

            NestedDetails.Add(ErrorDetails.ToString()) 
        EndSr

        BegSr LogError
            DclSrParm ErrorDetails Type(*String) 

            DclFld ErrorsFolderPath Type(*String) 
            DclFld Filename Type(*String) 
            DclFld FullFilename Type(*String) 

            ErrorsFolderPath  = Server.MapPath('/errors') 
            FileName = DateTime.Now.ToString('yyyy-MM-dd-hh-mm-ss')
            FullFilename = String.Format('{0}\{1}.log', ErrorsFolderPath, Filename)
            
            File.WriteAllText(FullFilename, ErrorDetails)   
        EndSr 
    EndClass

The 'error.css' is shown below for the `error.aspx` page. 

    body {
        background-color: #ebeceb;
        font-family: sans-serif;
    }

    .error-icon-container {
        width: 6rem;
    }

    .error-detail-container {
        font-size: 1.4em;
        height: 48rem;
        overflow: auto;
    }



