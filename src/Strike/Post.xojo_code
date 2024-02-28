#tag Class
Protected Class Post
	#tag Method, Flags = &h0, Description = 45786973747320736F2074686520536974654275696C64657220636C6173732063616E20696E7374616E746961746520616E20656D70747920706F73742E204E6F7420666F722067656E6572616C207573652E
		Sub Constructor()
		  /// Exists so the SiteBuilder class can instantiate an empty post. 
		  /// Not for general use.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(file As FolderItem)
		  Self.File = file
		  Self.Data = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 457874726163747320616E642072656D6F76657320544F4D4C2066726F6E746D6174746572202869662070726573656E74292066726F6D207468697320706F7374277320726177206D61726B646F776E20616E642072657475726E73206974206173206120737472696E672E
		Sub ExtractFrontMatter()
		  /// Extracts and removes TOML frontmatter (if present) from this post's `Markdown` property
		  /// and assigns it to this post's `FrontMatter` property.
		  ///
		  /// If present, frontmatter must occur at the beginning the post's markdown.
		  /// Frontmatter is in the format:
		  /// +++
		  /// VALID TOML
		  /// +++
		  
		  FrontMatter = ""
		  
		  If Markdown.Length < 6 Or Markdown.Trim.Left(3) <> "+++" Then
		    Return
		  End If
		  
		  Var rg As New RegEx
		  rg.SearchPattern = "^(\+{3}(?:\n|\r)([\w\W]+?)\+{3})"
		  rg.ReplacementPattern = ""
		  
		  Var match As RegExMatch = rg.Search(Markdown)
		  If match <> Nil Then
		    Frontmatter = match.SubExpressionString(0).Replace("+++", "")
		    Frontmatter = Frontmatter.Left(Frontmatter.Length - 3).Trim
		    Markdown = rg.Replace(Markdown).Trim
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573207468697320706F737427732066726F6E746D61747465722028696620616E792920696E746F207468697320706F737427732060446174616020616E642067756172616E746565642070726F706572746965732E2057696C6C20726169736520612060537472696B652E4572726F7260206966207468652066726F6E746D617474657220697320696E76616C69642E
		Sub ParseFrontmatter()
		  /// Parses this post's frontmatter (if any) into this post's `Data` and guaranteed properties.
		  /// Will raise a `Strike.Error` if the frontmatter is invalid.
		  
		  If Frontmatter = "" Then
		    Date = File.ModificationDateTime
		    Slug = Strike.Slugify(File.Name.Replace(".md", ""))
		    Title = Self.Slug
		    Return
		  End If
		  
		  // Have the required post properties been overridden by the frontmatter?
		  Try
		    Data = ParseTOML(Frontmatter)
		  Catch e As RuntimeException
		    Raise New Strike.Error("Invalid TOML frontmatter in `" + Self.File.NativePath + "`: " + e.Message)
		  End Try
		  
		  // Post date.
		  If Data.HasKey("date") Then
		    Try
		      Date = Date.FromString(Data.Value("date"))
		    Catch e As RuntimeException
		      Raise New Strike.Error("Invalid frontmatter `date` value (" + File.NativePath + ")")
		    End Try
		    Data.Remove("date")
		  Else
		    Date = File.ModificationDateTime
		  End If
		  
		  // Draft status.
		  If Data.HasKey("isDraft") Then
		    Try
		      IsDraft = Data.Value("isDraft")
		    Catch e As RuntimeException
		      Raise New Strike.Error("Invalid frontmatter `isDraft` value (" + File.NativePath + ")")
		    End Try
		    Data.Remove("isDraft")
		  End If
		  
		  // Post slug.
		  If Data.HasKey("slug") Then
		    // We need to slugify the specified slug in case it contains invalid HTML characters.
		    Slug = Slugify(Data.Value("slug").StringValue)
		    Data.Remove("slug")
		  Else
		    Slug = Slugify(File.Name.Replace(".md", ""))
		  End If
		  
		  // Post title.
		  If Data.HasKey("title") Then
		    Title = Data.Value("title")
		    Data.Remove("title")
		  Else
		    Title = Slugify(File.Name.Replace(".md", ""))
		  End If
		  
		  // Post tags.
		  If Data.HasKey("tags") Then
		    Try
		      Var vTags() As Variant = Data.Value("tags")
		      Data.Remove("tags")
		      For Each tag As String In vTags
		        Tags.Add(tag)
		      Next tag
		    Catch e As RuntimeException
		      Raise New Strike.Error("Invalid frontmatter `tags` value (" + File.NativePath + ")")
		    End Try
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520737065636966696564206E756D626572206F662063686172616374657273206F66207468652072656E646572656420636F6E74656E74207769746820616E792048544D4C2073747269707065642E
		Function Summary(charCount As Integer = 55) As String
		  /// Returns the specified number of characters of the rendered content with any HTML stripped.
		  
		  Var s As String = StripHTMLTags(RenderedMarkdown)
		  
		  If s.Length > charCount Then s = s.Left(charCount)
		  
		  Return s + "..."
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 4172626974726172792064617461206173736F6369617465642077697468207468697320706F73742E
		Data As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520646174652074686520706F737420776173207075626C6973686564202864656661756C747320746F207468652066696C652773206D6F64696669636174696F6E2064617465292E
		Date As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320706F7374277320736F757263652066696C652E
		File As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652066696C65207061746820666F72207468697320706F7374277320736F757263652066696C652E
		FilePath As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520666972737420706172616772617068206F66207468697320706F737420696E636C7564696E6720616E792048544D4C20746167732074686174206D696768742062652070726573656E742E
		FirstParagraph As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520666972737420706172616772617068206F66207468697320706F7374207769746820616E792048544D4C20746167732073747269707065642E
		FirstParagraphStripped As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320706F7374277320544F4D4C2066726F6E746D61747465722E204D617920626520656D7074792E
		FrontMatter As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 412068617368206F66207468697320706F737427732066696C652E
		Hash As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 57686574686572206F72206E6F74207468697320706F737420697320612064726166742E
		IsDraft As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320706F73742069732074686520686F6D65706167652E
		IsHomepage As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206973206120706167652E2046616C73652069662069742773206120706F73742E
		IsPage As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074696D65207468697320706F737420776173206C6173742070726F6365737365642E
		LastUpdated As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320706F73742773206D61726B646F776E2E
		Markdown As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320706F737427732072656E6465726564204D61726B646F776E2028692E652E2048544D4C20627574206265666F72652074656D706C6174696E67292E
		RenderedMarkdown As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652073656374696F6E207468697320706F73742069732077697468696E2E2053756273656374696F6E732061726520736570617261746564206279206120222E22
		#tag Note
			The section this post is within. Subsections are separated by a "."
			www.example.com/blog/first-post.html           section = blog
			www.example.com/blog/personal/test.html        section = blog.personal
			www.example.com/about/index.html               section = about
		#tag EndNote
		Section As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706F7374277320736C75672E
		Slug As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E792074616773206173736F6369617465642077697468207468697320706F73742E
		Tags() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320706F73742773207469746C652E
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207075626C69632055524C20666F72207468697320706F73742E
		URL As String
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
		#tag ViewProperty
			Name="IsHomepage"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FilePath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FrontMatter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hash"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDraft"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPage"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Markdown"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RenderedMarkdown"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Section"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Slug"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URL"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstParagraph"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstParagraphStripped"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
