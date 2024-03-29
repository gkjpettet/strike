#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ' #If DebugBuild
		  ' Debug(SpecialFolder.UserHome.Child("Sites").Child("cpcnerd.local"))
		  ' #EndIf
		  
		  // Remove the executable path (always passed as the first argument).
		  args.RemoveAt(0)
		  
		  // If no arguments passed we'll just print the basic usage and exit.
		  If args.Count = 0 Then Help.BasicUsage
		  
		  // Work out which command to run
		  Select Case args(0)
		  Case "build"
		    Command = CommandTypes.Build
		    
		  Case "create"
		    Command = CommandTypes.Create
		    
		  Case "help"
		    Command = CommandTypes.Help
		    
		  Case "set"
		    Command = CommandTypes.Set
		    
		  Case "version"
		    Command = CommandTypes.Version
		    
		  Else
		    PrintError("[" + args(0) + "] is an unknown command.")
		  End Select
		  
		  // Remove the command from the arguments array.
		  args.RemoveAt(0)
		  
		  ParseCommandOptions(args)
		  
		  RunCommand
		  
		  Exception e As Strike.Error
		    PrintError(e.message)
		    
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21, Description = 52657475726E73207468652062756E646C6564207468656D652063616C6C656420606E616D65602E2042756E646C6564207468656D6573206172652073746F7265642077697468696E2074686520617070277320604C6962736020666F6C6465722E
		Private Function BundledTheme(name As String) As FolderItem
		  /// Returns the bundled theme called `name`.
		  /// Bundled themes are stored within the app's `Libs` folder.
		  
		  Var appName As String = ExecutableFile.Name.ReplaceAll(".exe", "")
		  Return ExecutableFile.Parent.Child(appName + " Libs").Child(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Debug(site As FolderItem)
		  Var watch As New StopWatch(True)
		  
		  Var builder As Strike.SiteBuilder = Strike.SiteBuilder.Load(site)
		  builder.Build
		  
		  watch.Stop
		  Print("Took " + watch.ElapsedMilliseconds.ToString + " ms")
		  
		  Quit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 486176696E672070617273656420776869636820636F6D6D616E6420746F2072756E20616E6420656E737572696E67207765206861766520612076616C696420636F6D6D616E642C2074686973206D6574686F6420646F657320667572746865722070617273696E67206F662074686520636F6D6D616E642773206F7074696F6E7320286966207265717569726564292E
		Sub ParseCommandOptions(options() As String)
		  /// Having parsed which command to run and ensuring we have a valid command,
		  /// this method does further parsing of the command's options (if required).
		  
		  Select Case command
		  Case CommandTypes.Build
		    // Nothing to do.
		    
		  Case CommandTypes.Create
		    // We need to parse more options for this command.
		    ParseCreate(options)
		    
		  Case CommandTypes.Help
		    RunHelp(options)
		    
		  Case CommandTypes.Version
		    PrintVersion
		    
		  Else
		    // This shouldn't happen...
		    PrintError("Unknown command to run.")
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5061727365732074686520726571756972656420737562636F6D6D616E6420616E64206F7074696F6E7320666F722074686520606372656174656020636F6D6D616E642E
		Sub ParseCreate(options() As String)
		  /// Parses the required subcommand and options for the `create` command.
		  ///
		  /// Valid syntax is:
		  ///  create site [site-name]
		  ///  create theme [theme-name]
		  
		  If options.Count < 1 Then PrintError("Insufficient number of arguments provided.")
		  
		  // Get the subcommand.
		  Select Case options(0)
		  Case "site", "theme"
		    Subcommand = options(0)
		    
		  Else
		    PrintError("[" + options(0) + "] is an invalid subcommand or type.")
		  End Select
		  
		  // Get the name of the item to create.
		  Name = options(1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E74732074686520666F6C6C6F77696E67206172726179206F6620737472696E677320746F2074686520636F6E736F6C6520616E64207468656E2071756974732E
		Sub PrintError(messages() as String)
		  /// Prints the following array of strings to the console and then quits.
		  
		  Using Rainbow
		  
		  If messages.Count = 0 Then Quit(-1)
		  
		  For Each message As String In messages
		    Print(Colourise("Error: ", Colour.Red) + " " + message)
		  Next message
		  
		  Quit(-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E74732074686520706173736564206572726F72206D65737361676520746F2074686520636F6E736F6C6520616E642071756974732E
		Sub PrintError(message as String)
		  /// Prints the passed error message to the console and quits.
		  
		  Using Rainbow
		  
		  Print(Colourise("Error: " + message, Colour.Red))
		  
		  Quit(-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E7473206F7574207468652063757272656E742076657273696F6E206F662074686520746F6F6C2E
		Sub PrintVersion()
		  /// Prints out the current version of the tool.
		  
		  Print("Strike, a static site generator. Version: " + Strike.Version.ToString)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4275696C64732074686520736974652E
		Sub RunBuild()
		  /// Builds the site.
		  
		  Using Rainbow
		  
		  // Set the site root to the current working directory
		  Var siteFolder As FolderItem
		  #If DebugBuild
		    siteFolder = SpecialFolder.Desktop.Child("testsite")
		  #Else
		    siteFolder = SpecialFolder.CurrentWorkingDirectory
		  #EndIf
		  
		  Try
		    Var watch As New StopWatch(True)
		    Builder = Strike.SiteBuilder.Load(siteFolder)
		    Builder.Build
		    watch.Stop
		    
		    #If TargetWindows
		      // The tick doesn't display in the Windows Command Prompt...
		      Print(Colourise("Success.︎", Colour.Green))
		    #Else
		      Print(Colourise("Success ✔︎", Colour.Green))
		    #EndIf
		    
		    Print("Site built in " + watch.ElapsedMilliseconds.ToString + " ms")
		    
		    Quit(0)
		  Catch e As Strike.Error
		    Print(Colourise("An error occurred whilst building: " + e.message, Colour.Red))
		    Quit(-1)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 486176696E67207061727365642074686520636F6D6D616E6420616E6420737562636F6D6D616E6420746F2072756E2061732077656C6C20617320686176696E672073657420616E7920666C6167732C20776520617265206E6F7720726561647920746F2061637475616C6C7920646F20736F6D657468696E672E
		Sub RunCommand()
		  /// Having parsed the command and subcommand to run as well as having set any flags, we are
		  /// now ready to actually do something.
		  ///
		  /// The `help` and `version` commands are handled elsewhere.
		  
		  Select Case command
		  Case CommandTypes.Build
		    RunBuild
		    
		  Case CommandTypes.Create
		    Select Case subcommand
		    Case "site"
		      RunCreate(Name)
		      
		    Case "theme"
		      RunCreateTheme(Name)
		      
		    End Select
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 437265617465732061206E6577207369746520696E207468652063757272656E7420776F726B696E67206469726563746F72792E
		Sub RunCreate(siteName as String)
		  /// Creates a new site in the current working directory.
		  
		  Using Rainbow
		  
		  Var cwd As FolderItem
		  #If DebugBuild
		    cwd = SpecialFolder.Desktop
		  #Else
		    cwd = SpecialFolder.CurrentWorkingDirectory
		  #EndIf
		  
		  Try
		    Builder = Strike.SiteBuilder.Create(siteName, cwd, BundledTheme("neo"), True)
		    
		    #If TargetWindows
		      // The tick doesn't display in the Windows Command Prompt...
		      Print(Colourise("Success.︎", Colour.Green))
		      
		    #Else
		      Print(Colourise("Success ✔︎", Colour.Green))
		    #EndIf
		    
		    Print("Your new site was created at " + Builder.Root.NativePath)
		    
		    Print("A single post and a simple page have been created in " + Colourise("/content", Colour.Magenta) + _
		    ". A beautiful default theme called ")
		    
		    Print("'" + builder.DefaultTheme + "' has been created for you in " + _
		    Colourise("/themes", Colour.Magenta) + ".")
		    
		    Print("Feel free to create your own with " + Colourise("strike create theme [name]", Colour.Magenta) + ".")
		    Quit(0)
		    
		  Catch e As Strike.Error
		    Print(Colourise("Something went wrong when creating your site. " + e.message, Colour.Red))
		    Quit(-1)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 437265617465732061206E657720736B656C65746F6E207468656D652063616C6C656420607468656D654E616D656020696E207468652063757272656E7420776F726B696E67206469726563746F72792E
		Sub RunCreateTheme(themeName as String)
		  /// Creates a new skeleton theme called `themeName` in the current working directory.
		  
		  Using Rainbow
		  
		  Try
		    // Get the skeleton theme bundled with the app.
		    // Assumes it has been copied into the frameworks folder in a build step.
		    Var newTheme As FolderItem = BundledTheme("skeleton")
		    
		    // Rename it.
		    newTheme.Name = themeName
		    
		    // Copy the skeleton theme to the current working directory.
		    newTheme.CopyTo(SpecialFolder.CurrentWorkingDirectory)
		    
		    // Open the theme file and parse its TOML.
		    Var themeFile As FolderItem = newTheme.Child("theme.toml")
		    Var tin As TextInputStream = TextInputStream.Open(themeFile)
		    Var themeTOML As String = tin.ReadAll
		    tin.Close
		    Var themeDict As Dictionary = ParseTOML(themeTOML)
		    
		    // Rename the theme and overwrite the theme file with the updated TOML.
		    themeDict.Value("name") = themeName
		    Var tout As TextOutputStream = TextOutputStream.Create(themeFile)
		    tout.Write(GenerateTOML(themeDict))
		    tout.Close
		    
		    #If TargetWindows
		      //  The tick doesn't display in the Windows Command Prompt...
		      Print(Colourise("Success.︎", Colour.Green))
		    #else
		      Print(Colourise("Success ✔︎", Colour.Green))
		    #EndIf
		    
		    Print("Your new theme " + Colourise(themeName, Colour.Magenta) + " was created at " + _
		    SpecialFolder.CurrentWorkingDirectory.Child(themeName).NativePath)
		    Quit(0)
		    
		  Catch e As Strike.Error
		    Print(Colourise("Something went wrong when creating your new theme. " + e.Message, Colour.Red))
		    Quit(-1)
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446973706C6179732068656C70206F6E207468652073706563696669656420636F6D6D616E642E
		Sub RunHelp(options() As String)
		  /// Displays help on the specified command.
		  
		  // Check if no options passed. In which case, print basic usage and exit
		  If options.Count = 0 Then Help.BasicUsage
		  
		  // Make sure no more than one option is passed
		  If(options.Count > 1) Then
		    PrintError("Too many options passed to help command")
		  End If
		  
		  // Edge case: `strike help help`.
		  If options(0) = "help" Then
		    PrintError("Too many options passed to help command")
		  End If
		  
		  // Which command does the user want help with?
		  Select Case options(0)
		  Case "build"
		    Help.Build
		    
		  Case "create"
		    Help.Create
		    
		  Case "version"
		    Help.Version
		    
		  Else
		    PrintError("[" + options(0) + "] is an unknown command.")
		  End Select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Builder As Strike.SiteBuilder
	#tag EndProperty

	#tag Property, Flags = &h0
		Command As CommandTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652076616C7565206F662074686520226E616D652220617267756D656E742070617373656420746F2074686520746F6F6C2E204569746865722061207468656D65206F7220612073697465206E616D652E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Subcommand As String
	#tag EndProperty


	#tag Enum, Name = CommandTypes, Flags = &h0
		Build
		  Create
		  Help
		  Version
		  Undefined
		Set
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Command"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="CommandTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Build"
				"1 - Create"
				"2 - Help"
				"3 - Version"
				"4 - Undefined"
				"5 - Set"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Subcommand"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
