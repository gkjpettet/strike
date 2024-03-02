#tag Class
Protected Class ScriptContext
	#tag Method, Flags = &h0
		Sub Constructor(siteRoot As FolderItem, currentTheme As FolderItem)
		  Self.SiteRoot = siteRoot
		  Self.CurrentTheme = currentTheme
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F70696573206120466F6C6465724974656D2066726F6D2077697468696E207468652073697465277320726F6F7420746F2074686520602F7075626C69636020666F6C6465722E2060736F75726365602069732074686520706174682072656C617469766520746F2074686520726F6F74206F662074686520466F6C6465724974656D20746F20636F70792E
		Sub CopyFromRoot(source As String)
		  /// Copies a FolderItem from within the site's root to the `/public` folder.
		  /// `source` is the path relative to the root of the FolderItem to copy.
		  ///
		  /// Say we have the following site structure:
		  ///
		  /// ```
		  /// config.toml
		  /// [content]
		  /// [misc]
		  ///   - file1.html
		  ///   - file2.html
		  /// [scripts]
		  /// site.data
		  /// [storage]
		  /// [themes]
		  /// ```
		  ///
		  /// We can use this method to copy `file1.html` to the public root with the following syntax:
		  ///
		  /// ```xojo
		  /// CopyFromRoot("misc/file1.html")
		  /// ```
		  ///
		  /// We can also use this method to copy the entire [misc] folder to the public root like this:
		  ///
		  /// ```xojo
		  /// CopyFromRoot("misc")
		  /// ```
		  
		  source = source.ReplaceAll("\", "/")
		  
		  // Remove any leading and trailing slashes.
		  If source.EndsWith("/") Then source = source.Chop(1)
		  If source.BeginsWith("/") Then source = source.Right(source.Length - 1)
		  
		  // Split `source` into its children.
		  Var sourceParts() As String = source.ToArray("/")
		  
		  Var sourceFI As FolderItem = SiteRoot
		  For Each part As String In sourceParts
		    Try
		      sourceFI = sourceFI.Child(part)
		    Catch e As RuntimeException
		      Raise New Strike.Error("Invalid source path specified `" + source + _
		      "` in XojoScript method `CopyFromRoot()`.")
		    End Try
		  Next part
		  
		  If sourceFI = Nil Or Not sourceFI.Exists Then
		    Raise New Strike.Error("Invalid source path specified `" + source + _
		    "` in XojoScript method `CopyFromRoot()`.")
		  End If
		  
		  // Attempt the copy.
		  Try
		    sourceFI.CopyTo(SiteRoot.Child("public"))
		  Catch
		    Raise New Strike.Error("Unable to copy source (" + sourceFI.NativePath + ") to the public folder.")
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F70696573206120466F6C6465724974656D2066726F6D207468652063757272656E74207468656D6520666F6C64657220746F20746865207075626C696320726F6F742E2060736F75726365602069732074686520706174682072656C617469766520746F207468652063757272656E74207468656D6520726F6F74206F662074686520466F6C6465724974656D20746F20636F70792E
		Sub CopyFromTheme(source As String)
		  /// Copies a FolderItem from the current theme folder to the public root.
		  /// `source` is the path relative to the current theme root of the FolderItem to copy.
		  ///
		  /// Given the following theme structure:
		  ///
		  /// ```
		  /// [CURRENT THEME]
		  ///  - [assets]
		  ///  - [layouts]
		  ///  - [favicons]
		  ///    - favicon.ico
		  ///  - [misc]
		  ///    - cool.md
		  /// ```
		  ///
		  /// We can use this method to copy `favicon.ico` to the public root with the following syntax:
		  ///
		  /// ```xojo
		  /// CopyFromTheme("favicons/favicon.ico")
		  /// ```
		  ///
		  /// We can also use this method to copy the entire [misc] folder to the public root like this:
		  ///
		  /// ```xojo
		  /// CopyFromTheme("misc")
		  /// ```
		  
		  source = source.ReplaceAll("\", "/")
		  
		  // Remove any leading and trailing slashes.
		  If source.EndsWith("/") Then source = source.Chop(1)
		  If source.BeginsWith("/") Then source = source.Right(source.Length - 1)
		  
		  // Split `source` into its children.
		  Var sourceParts() As String = source.ToArray("/")
		  
		  Var sourceFI As FolderItem = CurrentTheme
		  For Each part As String In sourceParts
		    Try
		      sourceFI = sourceFI.Child(part)
		    Catch e As RuntimeException
		      Raise New Strike.Error("Invalid source path specified `" + source + _
		      "` in XojoScript method `CopyFromTheme()`.")
		    End Try
		  Next part
		  
		  If sourceFI = Nil Or Not sourceFI.Exists Then
		    Raise New Strike.Error("Invalid source path specified `" + source + _
		    "` in XojoScript method `CopyFromTheme()`.")
		  End If
		  
		  // Attempt the copy.
		  Try
		    sourceFI.CopyTo(SiteRoot.Child("public"))
		  Catch
		    Raise New Strike.Error("Unable to copy source (" + sourceFI.NativePath + ") to the public folder.")
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520636F6E74656E7473206F66207468652066696C65206174207468652070617468207370656369666965642E20416E20656D70747920737472696E672069732072657475726E656420696620616E206572726F72206F63637572732E
		Function GetFileContents(filePath As String) As String
		  /// Returns the contents of the file at the path specified.
		  /// An empty string is returned if an error occurs.
		  
		  #Pragma BreakOnExceptions False
		  
		  filePath = filePath.ReplaceAll("\", "/")
		  
		  // Remove any leading and trailing slashes.
		  If filePath.EndsWith("/") Then filePath = filePath.Chop(1)
		  If filePath.BeginsWith("/") Then filePath = filePath.Right(filePath.Length - 1)
		  
		  // Split `filePath` into its children.
		  Var parts() As String = filePath.ToArray("/")
		  
		  Var f As FolderItem = SiteRoot
		  For Each part As String In parts
		    Try
		      f = f.Child(part)
		    Catch e As RuntimeException
		      Raise New Strike.Error ("Invalid file path specified `" + filePath + _
		      "` in XojoScript method `GetFileContents()`.")
		    End Try
		  Next part
		  
		  If f = Nil Or Not f.Exists Then
		    Raise New Strike.Error ("Invalid file path specified `" + filePath + _
		    "` in XojoScript method `GetFileContents()`.")
		  End If
		  
		  Try
		    Return Strike.FileContents(f)
		  Catch e As RuntimeException
		    Return ""
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5772697465732060776861746020746F20746865207370656369666965642066696C6520706174682E205468652066696C6520706174682069732072656C617469766520746F207468652073697465277320726F6F742E
		Sub WriteToFile(what As String, filePath As String)
		  /// Writes `what` to the specified file path.
		  /// The file path is relative to the site's root.
		  
		  filePath = filePath.ReplaceAll("\", "/")
		  
		  // Remove any leading and trailing slashes.
		  If filePath.EndsWith("/") Then filePath = filePath.Chop(1)
		  If filePath.BeginsWith("/") Then filePath = filePath.Right(filePath.Length - 1)
		  
		  // Split `filePath` into its children.
		  Var parts() As String = filePath.ToArray("/")
		  
		  Var f As FolderItem = SiteRoot
		  For Each part As String In parts
		    Try
		      f = f.Child(part)
		    Catch e As RuntimeException
		      Raise New Strike.Error ("Invalid file path specified `" + filePath + _
		      "` in XojoScript method `WriteToFile()`.")
		    End Try
		  Next part
		  
		  If f = Nil Or Not f.Exists Or f.IsFolder Then
		    Raise New Strike.Error ("Invalid file path specified `" + filePath + _
		    "` in XojoScript method `WriteToFile()`.")
		  End If
		  
		  // Write to the specified file.
		  Try
		    Var tout As TextOutputStream = TextOutputStream.Create(f)
		    tout.Write(what)
		    tout.Close
		  Catch e As IOException
		    Raise New Strike.Error ("Unable to write to `" + filePath + _
		    "` in XojoScript method `WriteToFile()`: " + e.Message)
		  End Try
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865207468656D6520666F6C6465722063757272656E746C7920696E207573652E
		CurrentTheme As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652073697465277320726F6F7420666F6C6465722E
		SiteRoot As FolderItem
	#tag EndProperty


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
