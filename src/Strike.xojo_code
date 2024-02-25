#tag Module
Protected Module Strike
	#tag Method, Flags = &h1, Description = 476574732074686520737472696E6720636F6E74656E7473206F6620746865207061737365642066696C652E205374616E6461726469736573206C696E6520656E64696E677320746F20554E49582E204D617920726169736520612060537472696B652E4572726F72602E
		Protected Function FileContents(file As FolderItem) As String
		  /// Gets the string contents of the passed file.
		  /// Standardises line endings to UNIX.
		  /// May raise a `Strike.Error`.
		  
		  Try
		    
		    Var tin As TextInputStream = TextInputStream.Open(file)
		    Var contents As String = tin.ReadAll
		    Return contents.ReplaceLineEndings(EndOfLine.UNIX)
		    
		  Catch e As RuntimeException
		    
		    Raise New Strike.Error("Unable to get the contents of the passed file: " + e.Message)
		    
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E756D626572206F662066696C657320286E6F7420666F6C646572732920696E207468652070617373656420466F6C6465724974656D2E
		Private Function FileCount(folder As FolderItem) As Integer
		  /// Returns the number of files (not folders) in the passed FolderItem.
		  //
		  /// We exclude macOS .DS_STORE files.
		  
		  If folder.IsFolder = False Then Return 0
		  
		  Var count As Integer = 0
		  For Each f As FolderItem In folder.Children
		    If f.Name = ".DS_STORE" Then Continue
		    If Not f.IsFolder Then count = count + 1
		  Next f
		  
		  Return count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E7365727473207468652070617373656420737472696E672060737472696E67546F496E736572746020696E746F20737472696E67206073602061742060706F736974696F6E6020287A65726F206261736564292E
		Private Function Insert(Extends s As String, stringToInsert As String, position As Integer) As String
		  /// Inserts the passed string `stringToInsert` into string `s` at `position` (zero based).
		  
		  If s = "" Then Return stringToInsert
		  
		  If stringToInsert = "" Then Return s
		  
		  If (position + 1) > s.Length Then Return s
		  
		  If position = 0 Then Return stringToInsert + s
		  
		  If position = s.Length - 1 Then Return s + stringToInsert
		  
		  Var left As String = s.Left(position)
		  
		  Var right As String = s.Right(s.Length - position)
		  
		  Return left + stringToInsert + right
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206D6F6E7468206F662074686520706173736564206461746520696E206C6F6E6720666F726D2028652E672E20224A616E75617279222C20224665627275617279222C20657463292E
		Private Function LongMonth(Extends d As DateTime) As String
		  /// Returns the month of the passed date in long form (e.g. "January", "February", etc).
		  
		  If d = Nil Then Return ""
		  
		  Select Case d.Month
		  Case 1
		    Return "January"
		  Case 2
		    Return "February"
		  Case 3
		    Return "March"
		  Case 4
		    Return "April"
		  Case 5
		    Return "May"
		  Case 6
		    Return "June"
		  Case 7
		    Return "July"
		  Case 8
		    Return "August"
		  Case 9
		    Return "September"
		  Case 10
		    Return "October"
		  Case 11
		    Return "November"
		  Case 12
		    Return "December"
		  Else
		    Return ""
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732074686520657374696D617465642074696D6520696E206D696E7574657320746F20726561642060736020696E2074686520666F726D3A202278206D696E2072656164222E
		Protected Function MinutesToRead(s As String) As String
		  /// Returns the estimated time in minutes to read `s` in the form: "x min read".
		  ///
		  /// The maths is based on this post:
		  /// https://marketingland.com/estimated-reading-times-increase-engagement-79830
		  
		  Const WORDS_PER_MIN = 225
		  
		  Var time As Double = Wordcount(s) / WORDS_PER_MIN
		  Var minutes As Integer = time
		  Var seconds As Integer = Ceiling((time - minutes) * 0.6)
		  
		  If seconds > 30 Then minutes = minutes + 1
		  If minutes <= 0 Then minutes = 1
		  
		  Return minutes.ToString + " min read"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120737472696E672076657273696F6E206F6620746865206E756D65726963206D6F6E7468207061737365642028652E672E20224A616E75617279222066726F6D20312C20224665627275617279222066726F6D20322C20657463292E
		Private Function MonthToString(m As Integer) As String
		  /// Returns a string version of the numeric month passed 
		  /// (e.g. "January" from 1, "February" from 2, etc).
		  
		  Select Case m
		  Case 1
		    Return "January"
		  Case 2
		    Return "February"
		  Case 3
		    Return "March"
		  Case 4
		    Return "April"
		  Case 5
		    Return "May"
		  Case 6
		    Return "June"
		  Case 7
		    Return "July"
		  Case 8
		    Return "August"
		  Case 9
		    Return "September"
		  Case 10
		    Return "October"
		  Case 11
		    Return "November"
		  Case 12
		    Return "December"
		  Else
		    Return ""
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207365636F6E6473206E6F772069732066726F6D20313937302028556E69782065706F63682074696D65292E
		Private Function SecondsFrom1970() As Integer
		  /// Returns the seconds now is from 1970 (Unix epoch time).
		  
		  Return DateTime.Now.SecondsFrom1970
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206D6F6E7468206F662074686520706173736564206461746520696E2073686F727420666F726D2028652E672E20224A616E222C2022466562222C20657463292E
		Private Function ShortMonth(Extends d As DateTime) As String
		  /// Returns the month of the passed date in short form (e.g. "Jan", "Feb", etc).
		  
		  If d = Nil Then
		    Return ""
		  Else
		    Select Case d.Month
		    Case 1
		      Return "Jan"
		    Case 2
		      Return "Feb"
		    Case 3
		      Return "Mar"
		    Case 4
		      Return "Apr"
		    Case 5
		      Return "May"
		    Case 6
		      Return "Jun"
		    Case 7
		      Return "Jul"
		    Case 8
		      Return "Aug"
		    Case 9
		      Return "Sep"
		    Case 10
		      Return "Oct"
		    Case 11
		      Return "Nov"
		    Case 12
		      Return "Dec"
		    Else
		      Return ""
		    End Select
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652070617373656420737472696E6720617320612055524C2D667269656E646C79206C6F7765726361736520736C75672E204120736C7567206973207468652070617274206F6620616E2055524C207768696368206964656E74696669657320612070616765207573696E672068756D616E2D7265616461626C65206B6579776F7264732E
		Protected Function Slugify(s As String) As String
		  /// Returns the passed string as a URL-friendly lowercase slug.
		  /// A slug is the part of an URL which identifies a page using human-readable keywords.
		  ///
		  /// URL reserved characters: ! * ' ( ) ; : @ & = + $ , / ? # [ ]
		  
		  Var rg As New RegEx
		  
		  rg.Options.ReplaceAllMatches = True
		  
		  // First remove all of the reserved characters.
		  rg.SearchPattern = "([!*'();:@&=+$,/?#[\]])"
		  rg.ReplacementPattern = ""
		  s = rg.Replace(s)
		  
		  // Replace % with "percent".
		  rg.SearchPattern = "([%])"
		  rg.ReplacementPattern = "percent"
		  s = rg.Replace(s)
		  
		  // Replace all whitespace with "-".
		  rg.SearchPattern = "([\s])"
		  rg.ReplacementPattern = "-"
		  s = rg.Replace(s)
		  
		  // Replace "--" with "-".
		  rg.SearchPattern = "(-){2,}"
		  rg.ReplacementPattern = "-"
		  s = rg.Replace(s)
		  
		  // Lowercase it and return.
		  Return s.Lowercase
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 53747269707320616C6C2048544D4C20746167732066726F6D2060736020616E642072657475726E732069742E
		Protected Function StripHTMLTags(s As String) As String
		  /// Strips all HTML tags from `s` and returns it.
		  
		  Var rg As New RegEx
		  rg.SearchPattern = REGEX_STRIP_HTML
		  rg.ReplacementPattern = ""
		  
		  Var match As RegExMatch
		  Do
		    match = rg.Search(s)
		    If match <> Nil Then
		      s = s.Replace(match.SubExpressionString(0), "")
		    End If
		  Loop Until match = Nil
		  
		  Return rg.Replace(s)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206120706F737420747970652E
		Function ToString(Extends postType As Strike.PostTypes) As String
		  /// Returns a string representation of a post type.
		  
		  Select Case postType
		  Case PostTypes.Page
		    Return "page"
		    
		  Case PostTypes.Post
		    Return "post"
		    
		  Else
		    Raise New Strike.Error("Unknown post type.")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 41737365727473207468617420746865207265717569726564206B657973206172652070726573656E7420696E207468652074686520706173736564207369746520636F6E66696775726174696F6E2064696374696F6E6172792E20526169736573206120537472696B652E4572726F72206966206E6F742E
		Protected Sub ValidateConfigHasRequiredKeys(config As Dictionary)
		  /// Asserts that the required keys are present in the the passed site configuration dictionary.
		  /// Raises a Strike.Error if not.
		  
		  If config = Nil Then
		    Raise New Strike.Error("The configuration dictionary is Nil.")
		  End If
		  
		  If Not config.HasKey("archives") Then
		    Raise New Strike.Error("The configuration file is missing the `archives` key.")
		  End If
		  
		  If Not config.HasKey("baseURL") Then
		    Raise New Strike.Error("The configuration file is missing the `baseURL` key.")
		  End If
		  
		  If Not config.HasKey("buildDrafts") Then
		    Raise New Strike.Error("The configuration file is missing the `buildDrafts` key.")
		  End If
		  
		  If Not config.HasKey("description") Then
		    Raise New Strike.Error("The configuration file is missing the `description` key.")
		  End If
		  
		  If Not config.HasKey("includeHomeLinkInNavigation") Then
		    Raise New Strike.Error("The configuration file is missing the `includeHomeLinkInNavigation` key.")
		  End If
		  
		  If Not config.HasKey("postsPerPage") Then
		    Raise New Strike.Error("The configuration file is missing the `postsPerPage` key.")
		  End If
		  
		  If Not config.HasKey("rss") Then
		    Raise New Strike.Error("The configuration file is missing the `rss` key.")
		  End If
		  
		  If Not config.HasKey("rssExcludedSections") Then
		    Raise New Strike.Error("The configuration file is missing the `rssExcludedSections` key.")
		  End If
		  
		  If Not config.HasKey("theme") Then
		    Raise New Strike.Error("The configuration file is missing the `theme` key.")
		  End If
		  
		  If Not config.HasKey("siteName") Then
		    Raise New Strike.Error("The configuration file is missing the `siteName` key.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 56616C6964617465732074686174207468652070617373656420666F6C64657220697320612076616C696420537472696B6520736974652E2052616973657320616E20657863657074696F6E206966206E6F742E
		Protected Sub ValidateSite(siteFolder As FolderItem)
		  /// Validates that the passed folder is a valid Strike site.
		  /// Raises an exception if not.
		  
		  If siteFolder = Nil Or Not siteFolder.Exists Then
		    Raise New InvalidArgumentException("The site folder does not exist.")
		  End If
		  
		  If Not siteFolder.IsFolder Then
		    Raise New InvalidArgumentException("Invalid FolderItem. The site folder must be a folder, not a file.")
		  End If
		  
		  If Not siteFolder.IsReadable Or Not siteFolder.IsWriteable Then
		    Raise New IOException("Cannot load site. Unable to read/write the site folder.")
		  End If
		  
		  // Config file.
		  Var config As FolderItem = siteFolder.Child("config.toml")
		  If Not config.Exists Then
		    Raise New InvalidArgumentException("The site is missing the `config.toml` file.")
		  End If
		  Var configTOML As String
		  Try
		    Var tin As TextInputStream = TextInputStream.Open(config)
		    configTOML = tin.ReadAll
		    tin.Close
		  Catch e As IOException
		    e.Message = "Unable to read the site's config.toml file. " + e.Message
		    Raise e
		  End Try
		  Var configDict As Dictionary
		  Try
		    configDict = ParseTOML(configTOML)
		    ValidateConfigHasRequiredKeys(configDict)
		  Catch e As TOMLKit.TKException
		    e.Message = "The `config.toml` file contains invalid TOML. " + e.Message
		    Raise e
		  End Try
		  
		  // Database.
		  If Not siteFolder.Child("site.data").Exists Then
		    Raise New InvalidArgumentException("There is no site database.")
		  End If
		  
		  // Content.
		  If Not siteFolder.Child("content").Exists Then
		    Raise New InvalidArgumentException("The site is missing the `contents` folder.")
		  End If
		  
		  // Storage.
		  If Not siteFolder.Child("storage").Exists Then
		    Raise New InvalidArgumentException("The site is missing the `storage` folder.")
		  End If
		  
		  // Themes.
		  If Not siteFolder.Child("themes").Exists Then
		    Raise New InvalidArgumentException("The site is missing the `themes` folder.")
		  End If
		  For Each theme As FolderItem In siteFolder.Child("themes").Children
		    If theme.Name = ".DS_Store" Then Continue
		    ValidateTheme(theme)
		  Next theme
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 56616C6964617465732074686520706173736564207468656D652E2052616973657320616E20657863657074696F6E20696620746865726520697320616E2069737375652E
		Protected Sub ValidateTheme(theme As FolderItem)
		  /// Validates the passed theme.
		  /// Raises an exception if there is an issue.
		  
		  If theme = Nil Or Not theme.Exists Then
		    Raise New Strike.Error("The specified theme folder does not exist.")
		  End If
		  
		  If Not theme.IsFolder Then
		    Raise New Strike.Error("A valid theme must be a folder, not a file.")
		  End If
		  
		  // theme.json
		  If Not theme.Child("theme.json").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing its `theme.json` file.")
		  End If
		  ValidateThemeFile(theme.Child("theme.json"))
		  
		  // /assets
		  If Not theme.Child("assets").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing its `assets` folder.")
		  End If
		  
		  // ========================
		  // /layouts
		  // ========================
		  Var layouts As FolderItem = theme.Child("layouts")
		  If Not layouts.Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing its `layouts` folder.")
		  End If
		  
		  If Not layouts.Child("404.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `404.html` file.")
		  End If
		  
		  If Not layouts.Child("archives.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing an `archives.html` file.")
		  End If
		  
		  If Not layouts.Child("archives-home.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing an `archives-home.html` file.")
		  End If
		  
		  If Not layouts.Child("home.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `home.html` file.")
		  End If
		  
		  If Not layouts.Child("post.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `post.html` file.")
		  End If
		  
		  If Not layouts.Child("page.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `page.html` file.")
		  End If
		  
		  If Not layouts.Child("list.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `list.html` file.")
		  End If
		  
		  If Not layouts.Child("tags.html").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing a `tags.html` file.")
		  End If
		  
		  If Not layouts.Child("partials").Exists Then
		    Raise New Strike.Error("The theme `" + theme.Name + "` is missing the `layouts/partials` folder.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 4173736572747320746865207061737365642066696C6520697320612076616C696420607468656D652E6A736F6E602066696C652E
		Protected Sub ValidateThemeFile(themeFile As FolderItem)
		  /// Asserts the passed file is a valid `theme.json` file.
		  
		  If themeFile = Nil Or Not themeFile.Exists Then
		    Raise New Strike.Error("`theme.json` does not exist.")
		  End If
		  
		  If themeFile.IsFolder Then
		    Raise New Strike.Error("`theme.json` must be a file, not a folder.")
		  End If
		  
		  Var themeJSON As String
		  Try
		    Var tin As TextInputStream = TextInputStream.Open(themeFile)
		    themeJSON = tin.ReadAll
		    tin.Close
		  Catch e As IOException
		    Raise New Strike.Error("Unable to read the contents of `" + themeFile.NativePath + "`.")
		  End Try
		  
		  Var themeDict As Dictionary
		  Try
		    themeDict = ParseJSON(themeJSON)
		  Catch e As JSONException
		    Raise New Strike.Error("Invalid JSON in `" + themeFile.NativePath + "`: " + e.Message)
		  End Try
		  
		  If Not themeDict.HasKey("name") Then
		    Raise New Strike.Error("The theme file (`" + themeFile.NativePath + "`) is missing the `name` key.")
		  End If
		  
		  If Not themeDict.HasKey("description") Then
		    Raise New Strike.Error("The theme file (`" + themeFile.NativePath + "`) is missing the `description` key.")
		  End If
		  
		  If Not themeDict.HasKey("minVersion") Then
		    Raise New Strike.Error("The theme file (`" + themeFile.NativePath + "`) is missing the `minVersion` key.")
		  End If
		  Var themeVersion As New SemanticVersion(themeDict.Value("minVersion").StringValue)
		  If themeVersion > Strike.Version Then
		    Raise New Strike.Error("The `" + themeDict.Value("name") + _
		    "` theme requires Strike version " + themeVersion.ToString + " but you are running version " _
		    + Strike.Version.ToString + ".")
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320746865206E756D626572206F6620776F72647320696E207468652070617373656420737472696E672E
		Protected Function WordCount(s As String) As Integer
		  /// Returns the number of words in the passed string.
		  
		  Return s.Split.LastIndex + 1
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Dependencies
		FileKit
		-------
		This is required for copying and recursively deleting FolderItems.
		
		
	#tag EndNote

	#tag Note, Name = Requirements
		You must copy the default theme to the app's resources folder within the app bundle.
		This is named Strike.DEFAULT_THEME.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h1, Description = 5468652063757272656E742076657273696F6E206F662074686520537472696B6520656E67696E652E
		#tag Getter
			Get
			  Static v As New SemanticVersion(VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH)
			  
			  Return v
			  
			End Get
		#tag EndGetter
		Protected Version As SemanticVersion
	#tag EndComputedProperty


	#tag Constant, Name = REGEX_STRIP_HTML, Type = String, Dynamic = False, Default = \"<(\?:[^>\x3D]|\x3D\'[^\']*\'|\x3D\"[^\"]*\"|\x3D[^\'\"][^\\s>]*)*>", Scope = Private, Description = 526567756C61722065787072657373696F6E20666F72206D61746368696E672048544D4C20746167732E
	#tag EndConstant

	#tag Constant, Name = VERSION_MAJOR, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VERSION_MINOR, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VERSION_PATCH, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant


	#tag Enum, Name = PostTypes, Type = Integer, Flags = &h1
		Homepage
		  Page
		Post
	#tag EndEnum


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
End Module
#tag EndModule
