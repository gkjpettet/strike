#tag Class
Protected Class ArchiveMonth
	#tag Method, Flags = &h0
		Sub Constructor(month As Integer)
		  Self.Value = month
		  
		  Select Case month
		  Case 1
		    Self.ShortName = "Jan"
		    Self.LongName = "January"
		    
		  Case 2
		    Self.ShortName = "Feb"
		    Self.LongName = "February"
		    
		  Case 3
		    Self.ShortName = "Mar"
		    Self.LongName = "March"
		    
		  Case 4
		    Self.ShortName = "Apr"
		    Self.LongName = "April"
		    
		  Case 5
		    Self.ShortName = "May"
		    Self.LongName = "May"
		    
		  Case 6
		    Self.ShortName = "Jun"
		    Self.LongName = "June"
		    
		  Case 7
		    Self.ShortName = "Jul"
		    Self.LongName = "July"
		    
		  Case 8
		    Self.ShortName = "Aug"
		    Self.LongName = "August"
		    
		  Case 9
		    Self.ShortName = "Sep"
		    Self.LongName = "September"
		    
		  Case 10
		    Self.ShortName = "Oct"
		    Self.LongName = "October"
		    
		  Case 11
		    Self.ShortName = "Nov"
		    Self.LongName = "November"
		    
		  Case 12
		    Self.ShortName = "Dec"
		    Self.LongName = "December"
		    
		  Else
		    Raise New Strike.Error("Invalid month value: " + month.ToString + ".")
		  End Select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Days() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LongName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ShortName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Integer
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
			Name="LongName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="ShortName"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
