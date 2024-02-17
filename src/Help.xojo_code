#tag Class
Protected Class Help
	#tag Method, Flags = &h0, Description = 5072696E7473206F75742061206D657373616765206578706C61696E696E6720746865206261736963207573616765206F662074686520746F6F6C2E
		Shared Sub BasicUsage()
		  /// Prints out a message explaining the basic usage of the tool.
		  
		  Using Rainbow
		  
		  Print("Strike3 is a flexible static site generator built with love by Garry Pettet and written in Xojo.")
		  Print("")
		  Print("The main command is " + Colourise("strike", Colour.Magenta) + ", used to build your Strike site.")
		  Print("Complete documentation can be found at " + _
		  Colourise("https://github.com/gkjpettet/strike", Colour.Magenta) + ".")
		  Print("")
		  Print("Usage:")
		  Print("  strike [command]")
		  Print("")
		  Print("Available commands:")
		  Print("  create       Create a new site")
		  Print("  build        Build an existing site")
		  Print("  version      Print the version number of Strike")
		  Print("")
		  Print("Use " + Colourise("strike help [command]", Colour.Magenta) + _
		  " for detailed help on a specific command.")
		  
		  Quit(0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Build()
		  /// Prints out a message explaining how the build command works.
		  
		  Using Rainbow
		  
		  Print("The " + Colourise("build", Colour.Magenta) + " command is simple but powerful. " +_
		  "It's where all the magic happens.")
		  
		  Print("Running " + Colourise("strike build", Colour.Magenta) + " from a site root will render " + _
		  "all of your content")
		  
		  Print("(using the current theme) into the " + Colourise("/public", Colour.Magenta) + " folder. " + _
		  "If an error occurs,")
		  
		  Print("Strike will advise how to fix it. All that's left to do after that")
		  
		  Print("is to publish the contents of " + Colourise("/public", Colour.Magenta) + _
		  " to your web server.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CommandRequiresSiteRoot()
		  Using Rainbow
		  
		  Var message() As String
		  
		  message.Add("Unable to locate config file. Perhaps you need to create a new site?")
		  message.Add("Run " + Colourise("strike help create", Colour.Magenta) + " for details.")
		  
		  App.PrintError(message)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E7473206F7574207468652068656C70206D65737361676520666F722074686520606372656174656020636F6D6D616E642E
		Shared Sub Create()
		  /// Prints out the help message for the `create` command.
		  
		  Print("The create command can do one of two things:")
		  
		  Print("1). Create a new site")
		  
		  Print("2). Create a new theme template")
		  
		  Print("Usage:")
		  
		  Print("strike create site [site-name]")
		  
		  Print("strike create theme [theme-name]")
		  
		  Quit(0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5072696E7473206F7574207468652068656C70206D65737361676520666F7220746865202776657273696F6E2720636F6D6D616E642E
		Shared Sub Version()
		  /// Prints out the help message for the 'version' command.
		  
		  Print("All software has a version number. For Strike it's " + Strike.Version.ToString)
		  
		  Quit(0)
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
