#tag Class
Protected Class ListContext
	#tag Property, Flags = &h0, Description = 546865206172636869766520646174652072616E6765207468617420706F73747320696E207468697320636F6E746578742061726520647261776E2066726F6D2E20452E673A20223230323322206F72202246656272756172792032332032303234222E
		ArchiveDateRange As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F6E6C792076616C6964206F6E2061726368697665206C6973742070616765733A20602D3160206F7468657277697365207468697320697320746865206461792028312D333129206F662074686520706F737473206265696E67206C69737465642E
		ArchiveDay As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F6E6C792076616C6964206F6E2061726368697665206C6973742070616765733A20602D3160206F7468657277697365207468697320697320746865206D6F6E74682028312D313229206F662074686520706F737473206265696E67206C69737465642E
		ArchiveMonth As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F6E6C792076616C6964206F6E2061726368697665206C6973742070616765733A20602D3160206F74686572776973652074686973206973207468652079656172206F662074686520706F737473206265696E67206C69737465642E
		ArchiveYear As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		NextPage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PreviousPage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Tag As String
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
			Name="NextPage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PreviousPage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="Tag"
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
			Name="ArchiveDateRange"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArchiveDay"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArchiveMonth"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArchiveYear"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
