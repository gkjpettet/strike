#tag Module
Protected Module SQL
	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F73747320696E207468652073697465206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E
		Protected Function AllPosts(postsPerPage As Integer, currentPage As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to select all posts in the site limited to `postsPerPage`
		  /// with an offset calculated from the passed `currentPage`.
		  
		  If postsPerPage = -1 Then
		    // Return all posts. No pagination.
		    If buildDrafts Then
		      Return "SELECT * FROM posts WHERE isPage=0 AND date <= " + _
		      SecondsFrom1970.ToString("####################") + " ORDER BY date DESC;"
		    Else
		      Return "SELECT * FROM posts WHERE isPage=0 AND isDraft=0 AND date <= " + _
		      SecondsFrom1970.ToString("####################") + " ORDER BY date DESC;"
		    End If
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  If buildDrafts Then
		    Return "SELECT * FROM posts WHERE isPage=0 AND date <= " + _
		    SecondsFrom1970.ToString("####################") + " ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  Else
		    Return "SELECT * FROM posts WHERE isPage=0 AND isDraft=0 AND date <= " + _
		    SecondsFrom1970.ToString("####################") + " ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C20717565727920746F2072657475726E206120526F7753657420636F6E7461696E696E6720616C6C207461677320696E207468652064617461626173652E
		Protected Function AllTags() As String
		  /// Returns the SQL query to return a RowSet containing all tags in the database.
		  
		  Return "SELECT * FROM tags;"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E2061207265636F72642073657420636F6E7461696E696E672074686520646179732066726F6D2074686520737065636966696564206D6F6E746820616E6420796561722074686174206861766520706F7374732E204578636C7564652070616765732E
		Protected Function DaysWithPostsInMonthAndYear(year As Integer, month As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return a record set containing the days from the specified
		  /// month and year that have posts.
		  /// Exclude pages.
		  
		  If buildDrafts Then
		    Return "SELECT DISTINCT(dateDay) AS day FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' ORDER BY dateDay DESC;"
		  Else
		    Return "SELECT DISTINCT(dateDay) AS day FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' AND isDraft='0' ORDER BY dateDay DESC;"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E2061207265636F72642073657420636F6E7461696E696E6720746865206D6F6E7468732066726F6D207468652073706563696669656420796561722074686174206861766520706F7374732E204578636C756465732070616765732E
		Protected Function MonthsWithPostsInYear(year As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return a record set containing the months from the specified
		  /// year that have posts.
		  /// Excludes pages.
		  
		  If buildDrafts Then
		    Return "SELECT DISTINCT(dateMonth) AS month FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' ORDER BY dateMonth DESC;"
		  Else
		    Return "SELECT DISTINCT(dateMonth) AS month FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' AND isDraft='0' ORDER BY dateMonth DESC;"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E20746865206E756D626572206F6620706F7374732066726F6D2074686520737065636966696564206461792C206D6F6E746820616E6420796561722E204578636C756465732070616765732E
		Protected Function PostCountForDay(year As Integer, month As Integer, day As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return the number of posts from the specified day, month
		  /// and year.
		  /// Excludes pages.
		  
		  If buildDrafts Then
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND dateDay='" + day.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0';"
		  Else
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND dateDay='" + day.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0' AND isDraft=0;"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E20746865206E756D626572206F6620706F7374732066726F6D2074686520737065636966696564206D6F6E746820616E6420796561722E2045786C756465732070616765732E
		Protected Function PostCountForMonth(year As Integer, month As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return the number of posts from the specified month and year.
		  /// Exludes pages.
		  
		  If buildDrafts Then
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0';"
		  Else
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0' AND isDraft=0;"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E20746865206E756D626572206F6620706F73747320776974682074686520737065636966696564207461672E
		Protected Function PostCountForTag(tagName As String) As String
		  /// Returns the SQL statement to return the number of posts with the specified tag.
		  
		  Return "SELECT COUNT(DISTINCT posts.id) As 'total' FROM posts INNER Join post_tag ON " + _
		  "post_tag.posts_id = posts.id INNER Join tags ON " + _
		  "tags.id = post_tag.tags_id WHERE tags.name IN ('" + tagName + "');"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E20746865206E756D626572206F6620706F7374732066726F6D207468652073706563696669656420796561722E
		Protected Function PostCountForYear(year As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return the number of posts from the specified year.
		  
		  If buildDrafts Then
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0';"
		  Else
		    Return "SELECT COUNT(*) AS 'total' FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage=0 AND isHomepage='0' AND isDraft=0;"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C20717565727920746F2073656C65637420616C6C20706F73747320696E20746865207370656369666965642073656374696F6E2061667465722074686520676976656E20646174652C206F7074696F6E616C6C79206C696D6974656420746F2061206E756D6265722E20536F72746564206279206461746520617363656E64696E672E
		Protected Function PostsAfterDate(d As DateTime, section As String, includeDrafts As Boolean, limit As Integer = -1) As String
		  /// Returns the SQL query to select all posts in the specified section after the given date, 
		  /// optionally limited to a number. Sorted by date ascending.
		  
		  If limit < 0 Then
		    
		    If includeDrafts Then
		      Return "SELECT * FROM posts WHERE date > '" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date ASC;"
		    Else
		      Return "SELECT * FROM posts WHERE date > '" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' AND isDraft='0' " + _
		      "ORDER BY date ASC;"
		    End If
		    
		  Else
		    
		    If includeDrafts Then
		      Return "SELECT * FROM posts WHERE date >'" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date ASC LIMIT " + limit.ToString + ";"
		    Else
		      Return "SELECT * FROM posts WHERE date >'" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' AND isDraft='0' " + _
		      "ORDER BY date ASC LIMIT " + limit.ToString + ";"
		    End If
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C20717565727920746F2073656C65637420616C6C20706F73747320696E2074686520676976656E2073656374696F6E206265666F72652074686520676976656E20646174652C206F7074696F6E616C6C79206C696D6974656420746F2061206E756D6265722E20536F72746564206279206461746520617363656E64696E672E
		Protected Function PostsBeforeDate(d As DateTime, section As String, includeDrafts As Boolean, limit As Integer = -1) As String
		  /// Returns the SQL query to select all posts in the given section before the given date, 
		  /// optionally limited to a number. Sorted by date ascending.
		  
		  If limit < 0 Then
		    
		    If includeDrafts Then
		      Return "SELECT * FROM posts WHERE date < '" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date DESC"
		    Else
		      Return "SELECT * FROM posts WHERE date < '" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' AND isDraft='0' " + _
		      "ORDER BY date DESC"
		    End If
		    
		  Else
		    
		    If includeDrafts Then
		      Return "SELECT * FROM posts WHERE date <'" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date DESC LIMIT " + limit.ToString + ";"
		    Else
		      Return "SELECT * FROM posts WHERE date <'" + d.SecondsFrom1970.ToString("####################") + "' " + _
		      "AND section='" + section + "' AND isPage='0' AND isHomepage='0' AND isDraft='0' " + _
		      "ORDER BY date DESC LIMIT " + limit.ToString + ";"
		    End If
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F7374732066726F6D2074686520737065636966696564206461792C206D6F6E746820616E642079656172206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E204578636C756465732070616765732E
		Protected Function PostsForDay(year As Integer, month As Integer, day As Integer, postsPerPage As Integer, currentPage As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to select all posts from the specified day, month and year limited
		  /// to `postsPerPage` with an offset calculated from the passed `currentPage`.
		  /// Excludes pages.
		  
		  If postsPerPage = -1 Then
		    // All posts for this date - no pagination.
		    If buildDrafts Then
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND dateMonth='" + month.ToString + "' " + _
		      "AND dateDay='" + day.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date DESC;"
		    Else
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND dateMonth='" + month.ToString + "' " + _
		      "AND dateDay='" + day.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		      "ORDER BY date DESC;"
		    End If
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  If buildDrafts Then
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND dateDay='" + day.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  Else
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND dateDay='" + day.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F7374732066726F6D2074686520737065636966696564206D6F6E746820616E642079656172206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E204578636C756465732070616765732E
		Protected Function PostsForMonth(year As Integer, month As Integer, postsPerPage As Integer, currentPage As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to select all posts from the specified month and year limited
		  /// to `postsPerPage` with an offset calculated from the passed `currentPage`.
		  /// Excludes pages.
		  
		  If postsPerPage = -1 Then
		    // All posts for this date - no pagination.
		    If buildDrafts Then
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND dateMonth='" + month.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date DESC;"
		    Else
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND dateMonth='" + month.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		      "ORDER BY date DESC;"
		    End If
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  If buildDrafts Then
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  Else
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND dateMonth='" + month.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F73747320696E20746865207370656369666965642073656374696F6E206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E206073656374696F6E602073686F756C6420626520646F742D64656C696D697465642028652E673A2022626C6F672E706572736F6E616C2220666F7220706F73747320696E2060636F6E74656E742F626C6F672F706572736F6E616C60292E
		Protected Function PostsForSection(section As String, postsPerPage As Integer, currentPage As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to select all posts in the specified section limited
		  /// to `postsPerPage` with an offset calculated from the passed `currentPage`.
		  /// `section` should be dot-delimited (e.g: "blog.personal" for posts in `content/blog/personal`).
		  
		  If postsPerPage = -1 Then
		    // All posts for this section - no pagination.
		    If buildDrafts Then
		      Return "SELECT * FROM posts WHERE section='" + section + "' " + _
		      "AND date <= " + SecondsFrom1970.ToString("####################") + " ORDER BY date DESC;"
		    Else
		      Return "SELECT * FROM posts WHERE section='" + section + "' AND isDraft=0 " + _
		      "AND date <= " + SecondsFrom1970.ToString("####################") + " ORDER BY date DESC;"
		    End If
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  If buildDrafts Then
		    Return "SELECT * FROM posts WHERE section='" + section + "' " + _
		    "AND date <= " + SecondsFrom1970.ToString("####################") + " ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  Else
		    Return "SELECT * FROM posts WHERE section='" + section + "' AND isDraft=0 " + _
		    "AND date <= " + SecondsFrom1970.ToString("####################") + " ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F7374732077697468207468652073706563696669656420746167206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E
		Protected Function PostsForTag(tagName As String, postsPerPage As Integer, currentPage As Integer) As String
		  /// Returns the SQL statement to select all posts with the specified tag limited to `postsPerPage`
		  /// with an offset calculated from the passed `currentPage`.
		  
		  If postsPerPage = -1 Then
		    // All posts - no pagination.
		    Return "SELECT DISTINCT posts.* FROM posts INNER Join post_tag ON post_tag.posts_id " + _
		    "= posts.id INNER Join tags ON tags.id = post_tag.tags_id WHERE tags.name IN ('" + tagName + "') " + _
		    "ORDER BY posts.date DESC;"
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  Return "SELECT DISTINCT posts.* FROM posts INNER Join post_tag ON post_tag.posts_id " + _
		  "= posts.id INNER Join tags ON tags.id = post_tag.tags_id WHERE tags.name IN ('" + tagName + "') " + _
		  "ORDER BY posts.date DESC LIMIT " + postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C20706F7374732066726F6D20746865207370656369666965642079656172206C696D6974656420746F2060706F7374735065725061676560207769746820616E206F66667365742063616C63756C617465642066726F6D2074686520706173736564206063757272656E7450616765602E204578636C756465732070616765732E
		Protected Function PostsForYear(year As Integer, postsPerPage As Integer, currentPage As Integer, buildDrafts As Boolean) As String
		  /// Returns the SQL statement to select all posts from the specified year limited
		  /// to `postsPerPage` with an offset calculated from the passed `currentPage`.
		  /// Excludes pages.
		  
		  If postsPerPage = -1 Then
		    // All posts for this year - no pagination.
		    If buildDrafts Then
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' " + _
		      "ORDER BY date DESC;"
		    Else
		      Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		      "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		      "ORDER BY date DESC;"
		    End If
		  End If
		  
		  Var offset As Integer = (currentPage * postsPerPage) - postsPerPage
		  
		  If buildDrafts Then
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  Else
		    Return "SELECT * FROM posts WHERE dateYear='" + year.ToString + "' " + _
		    "AND isPage='0' AND isHomepage='0' AND isDraft=0 " + _
		    "ORDER BY date DESC LIMIT " + _
		    postsPerPage.ToString + " OFFSET " + offset.ToString + ";"
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2073656C65637420616C6C207461677320666F72206120706172746963756C617220706F73742049442E
		Protected Function TagsForPost(postID As Integer) As String
		  /// Returns the SQL statement to select all tags for a particular post ID.
		  ///
		  /// Credit:
		  ///  http://lekkerlogic.com/2016/02/site-tags-using-mysql-many-to-many-tags-schema-database-design/
		  
		  Return "SELECT tags.* FROM tags INNER JOIN post_tag ON tags.id = post_tag.tags_id " + _
		  "INNER JOIN posts ON post_tag.posts_id = posts.id WHERE posts.id = " + postID.ToString + ";"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652053514C2073746174656D656E7420746F2072657475726E2061207265636F72642073657420636F6E7461696E696E67207468652079656172732074686174206861766520706F7374732E204578636C7564652070616765732E
		Protected Function YearsWithPosts(buildDrafts As Boolean) As String
		  /// Returns the SQL statement to return a record set containing the years that have posts.
		  /// Exclude pages.
		  
		  If buildDrafts Then
		    Return "SELECT DISTINCT(dateYear) AS year FROM posts WHERE isPage='0' " + _
		    "AND isHomepage='0' ORDER BY dateYear DESC;"
		  Else
		    Return "SELECT DISTINCT(dateYear) AS year FROM posts WHERE isPage='0' " + _
		    "AND isHomepage='0' AND isDraft=0 ORDER BY dateYear DESC;"
		  End If
		  
		End Function
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
End Module
#tag EndModule
