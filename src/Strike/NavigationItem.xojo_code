#tag Class
Protected Class NavigationItem
	#tag Method, Flags = &h0
		Sub Constructor(title As String, URL As String, cssClass As String, parent As Strike.NavigationItem = Nil)
		  Self.title = title
		  Self.URL = URL
		  Self.CSSClass = cssClass
		  Self.Parent = parent
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686973206974656D20617320616E20756E6F7264657265642048544D4C206C6973742E2049662074686973206974656D20686173206E6F206368696C6472656E207468656E20616E20656D70747920737472696E672069732072657475726E65642E
		Function ToHTML(theClass As String = "") As String
		  /// Returns this item as an unordered HTML list.
		  /// If this item has no children then an empty string is returned.
		  
		  Const QUOTE = """"
		  
		  If Children.Count = 0 Then Return ""
		  
		  Var html As String
		  If theClass = "" Then
		    html = "<ul>"
		  Else
		    html = "<ul class=" + QUOTE + theClass + QUOTE + ">"
		  End If
		  
		  For Each child As Strike.NavigationItem In Children
		    If child.Children.Count = 0 Then
		      html = html + "<li" + If(child.CSSClass <> "", " class=" + QUOTE + child.CSSClass + QUOTE, "") + _
		      "><a href=" + QUOTE + child.URL + QUOTE + ">" + child.Title + "</a></li>"
		    Else
		      html = html + "<li" + If(child.CSSClass <> "", " class=" + QUOTE + child.CSSClass + QUOTE, "") + _
		      "><a href=" + QUOTE + child.URL + QUOTE + ">" + child.Title + "</a>" + child.ToHTML + "</li>"
		    End If
		  Next child
		  
		  Return html + "</ul>"
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686973206974656D2773206368696C6472656E2E204D617920626520656D7074792E
		Children() As Strike.NavigationItem
	#tag EndProperty

	#tag Property, Flags = &h0
		CSSClass As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Parent As Strike.NavigationItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		URL As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="URL"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CSSClass"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
