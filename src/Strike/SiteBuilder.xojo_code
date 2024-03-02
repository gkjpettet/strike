#tag Class
Protected Class SiteBuilder
	#tag Method, Flags = &h21, Description = 5265637572736976656C79206164647320286173204E617669676174696F6E4974656D73292074686520666F6C6465727320636F6E7461696E65642077697468696E2060666F6C64657260206173206368696C6472656E206F6620746865207061737365642060706172656E7460204E617669676174696F6E4974656D20616E642072657475726E7320746865206D6F64696669656420706172656E742E
		Private Function AddNavigationChildren(parent As Strike.NavigationItem, folder As FolderItem) As Strike.NavigationItem
		  /// Recursively adds (as NavigationItems) the folders contained within `folder` as children of 
		  /// the passed `parent` NavigationItem and returns the modified parent.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Get the children of the folder in alphabetical name order
		  Var orderedChildren() As FolderItem
		  For Each child As FolderItem In folder.Children
		    orderedChildren.Add(child)
		  Next child
		  orderedChildren.Sort(AddressOf FolderItemArraySort)
		  
		  ' For Each f As FolderItem In folder.Children
		  For Each f As FolderItem In orderedChildren
		    If f.IsFolder Then
		      Var ni As New Strike.NavigationItem(f.Name.Titlecase, NavigationPermalink(f), Strike.Slugify(f.Name), parent)
		      parent.Children.Add(AddNavigationChildren(ni, f))
		    End If
		  Next f
		  
		  Return parent
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 41646473207468652070617373656420706F737420746F20746865207369746527732064617461626173652E
		Private Sub AddPostToDatabase(post As Strike.Post)
		  /// Adds the passed post to the site's database.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var rs As RowSet
		  Var tagName As String
		  
		  Var dRow As New DatabaseRow
		  dRow.Column("date") = CType(post.Date.SecondsFrom1970, Integer) // Must be an integer, not a Double!
		  dRow.Column("dateYear") = post.Date.Year
		  dRow.Column("dateMonth") = post.Date.Month
		  dRow.Column("dateDay") = post.Date.Day
		  dRow.Column("filePath") = post.FilePath
		  dRow.Column("firstParagraph") = post.FirstParagraph
		  dRow.Column("firstParagraphStripped") = post.FirstParagraphStripped
		  dRow.Column("hash") = post.Hash
		  dRow.Column("isDraft") = post.IsDraft
		  dRow.Column("isHomepage") = post.IsHomepage
		  dRow.Column("isPage") = post.IsPage
		  dRow.Column("lastUpdated") = SecondsFrom1970
		  dRow.Column("markdown") = post.Markdown
		  dRow.Column("renderedMarkdown") = post.RenderedMarkdown
		  dRow.Column("section") = post.Section
		  dRow.Column("slug") = post.Slug
		  dRow.Column("title") = post.Title
		  dRow.Column("toml") = GenerateTOML(post.Data)
		  dRow.Column("url") = post.URL
		  dRow.Column("verified") = True
		  
		  Try
		    Database.AddRow("posts", dRow)
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to insert post into the database (" + _
		    post.File.NativePath + "): " + e.Message)
		  End Try
		  
		  // Get the database ID of this post.
		  Var postID As Integer = Database.LastRowID
		  
		  // Add tags.
		  Var tagID As Integer
		  For Each tagName In post.Tags
		    // Check if this tag has already been defined. If so, grab it's database ID.
		    rs = Database.SelectSQL("SELECT id FROM tags WHERE name='" + tagName + "';")
		    If rs.RowCount <> 0 Then
		      tagID = rs.Column("id").IntegerValue
		    Else
		      // This tag has not yet been defined in the database - let's remedy that.
		      dRow = New DatabaseRow
		      dRow.Column("name") = tagName
		      Try
		        Database.AddRow("tags", dRow)
		      Catch e As DatabaseException
		        Raise New Strike.Error("Unable to insert tag (" + tagName + ") into the database (" + _
		        post.File.NativePath + "): " + e.Message)
		      End Try
		      tagID = Database.LastRowID
		    End If
		    
		    // Now we have the ID of this post and the ID of this tag. Create an entry in the pivot table.
		    dRow = New DatabaseRow
		    dRow.Column("posts_id") = postID
		    dRow.Column("tags_id") = tagID
		    Try
		      Database.AddRow("post_tag", dRow)
		    Catch e As DatabaseException
		      Raise New Strike.Error("Unable to insert tag (" + tagName + ") for post (" + _
		      post.File.NativePath + ") into the database pivot table:  " + e.Message)
		    End Try
		  Next tagName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5573656420746F207265637572736976656C7920636F70792074686520666F6C64657220737472756374757265206F6620602F636F6E74656E746020696E746F206F7572207075626C6963206275696C6420666F6C6465722E
		Private Sub AddSectionFolder(source As FolderItem, destination As FolderItem)
		  /// Used to recursively copy the folder structure of `/content` into our public build folder.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var newDestination As FolderItem
		  
		  If source.IsFolder Then
		    If source.NativePath = Root.Child("content").NativePath Then
		      // Don't create a `content` folder in the destination!
		      newDestination = destination
		    Else
		      newDestination = destination.Child(source.Name)
		      newDestination.CreateFolder
		    End If
		    
		    For Each f As FolderItem In source.Children
		      If f.IsFolder Then AddSectionFolder(f, newDestination)
		    Next f
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4275696C64732074686520736974652E20546865206275696C7420736974652077696C6C20626520706C616365642077697468696E20607075626C69636020696E207468652073697465277320726F6F742E20417373756D657320746861742061207369746520686173206265656E20636F72726563746C79206C6F61646564207072696F7220746F2063616C6C696E672074686973206D6574686F642E204D617920726169736520616E20657863657074696F6E2E
		Sub Build()
		  /// Builds the site. The built site will be placed within `public` in the site's root.
		  /// Assumes that a site has been correctly loaded prior to calling this method.
		  /// May raise an exception.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Ensure we have an empty public folder to build into.
		  PublicFolder = Root.Child("public")
		  If PublicFolder.Exists Then
		    Try
		      PublicFolder.RemoveFolderAndContents
		    Catch e As RuntimeException
		      Raise New Strike.Error("Unable to delete the existing `public` folder: " + e.Message)
		    End Try
		  End If
		  Try
		    publicFolder.CreateFolder
		  Catch e As IOException
		    e.Message = "Unable to create the `public` folder. " + e.Message
		  End Try
		  
		  ValidateTheme(Self.Theme)
		  
		  // Clear out the RSS items before we render the posts.
		  RSSItems.ResizeTo(-1)
		  
		  // Publish the 404 page.
		  Theme.Child("layouts").Child("404.html").CopyTo(publicFolder)
		  
		  // Set the verified status of every post in the database to false.
		  Database.ExecuteSQL("UPDATE posts SET verified=0;")
		  
		  // Parse the contents to the database.
		  Process(Root.Child("content"))
		  
		  // Remove any posts in the database which were not verified.
		  // These will be posts that have been removed since the last build was ran.
		  Database.ExecuteSQL("DELETE FROM posts WHERE verified=0;")
		  
		  BuildSiteFolders
		  
		  CopyThemeAssets
		  
		  CopyStorage
		  
		  BuildNavigation
		  
		  BuildTags
		  
		  BuildArchives
		  
		  RenderPosts
		  
		  BuildLists(Root.Child("content"))
		  
		  // RSS.
		  If Config.Lookup("rss", False) Then BuildRSSFeed
		  
		  // Run post build scripts.
		  RunScripts
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BuildArchives()
		  /// Builds the archive folders and files.
		  ///
		  /// baseURL/archive/<year>/index.html
		  /// baseURL/archive/<year>/<month>/index.html
		  /// baseURL/archive/<year>/<month>/<day>/index.html
		  /// baseURL/archive/<year>/page/<pageNumber>/index.html
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Const QUOTE = """"
		  
		  // Does the user want us to build archives? They are computationally expensive to build.
		  If config.Lookup("archives", False) = False Then Return
		  
		  Var days() As Integer
		  
		  Var monthFolder, dayFolder As FolderItem
		  
		  Var buildDrafts As Boolean = Config.Lookup("buildDrafts", False)
		  
		  // Get an array of years that have posts.
		  Var rs As RowSet
		  Try
		    rs = Database.SelectSQL(SQL.YearsWithPosts(buildDrafts))
		    If rs = Nil Or rs.RowCount = 0 Then Return
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to select all years containing posts from the database: " + e.Message)
		  End Try
		  
		  Var years(), months() As Integer
		  For Each row As DatabaseRow In rs
		    years.Add(rs.Column("year").IntegerValue)
		  Next row
		  
		  // Create the parent archive folder.
		  Var archiveFolder As FolderItem = PublicFolder.Child("archive")
		  archiveFolder.CreateFolder
		  
		  // Clear out any previously created archive tree.
		  ArchiveTree.ResizeTo(-1)
		  
		  // Build each archive year.
		  For Each year As Integer In years
		    Var arcYear As New ArchiveYear(year)
		    
		    Var yearFolder As FolderItem = archiveFolder.Child(year.ToString)
		    yearFolder.CreateFolder
		    BuildArchivesList(yearFolder, year)
		    
		    // Get an array of the months of this year that have posts.
		    months.ResizeTo(-1)
		    
		    Try
		      rs = Database.SelectSQL(SQL.MonthsWithPostsInYear(year, buildDrafts))
		      If rs = Nil Or rs.RowCount = 0 Then
		        // No posts for this month.
		        Continue
		      End If
		      
		    Catch e As DatabaseException
		      Raise New Strike.Error("Unable to select months of the specified year containing posts from the database: " + e.Message)
		    End Try
		    
		    For Each row As DatabaseRow In rs
		      months.Add(rs.Column("month").IntegerValue)
		    Next row
		    
		    // Build each archive month for this year.
		    For Each month As Integer In months
		      Var arcMonth As New ArchiveMonth(month)
		      
		      // How many posts in this month for this year?
		      Var countRS As RowSet = Database.SelectSQL(SQL.PostCountForMonth(arcYear.Value, arcMonth.Value, buildDrafts))
		      arcMonth.PostCount = countRS.Column("total").IntegerValue
		      
		      monthFolder = yearFolder.Child(month.ToString)
		      monthFolder.CreateFolder
		      BuildArchivesList(monthFolder, year, month)
		      
		      // Get an array of the days of this month and year that have posts.
		      days.ResizeTo(-1)
		      Try
		        rs = Database.SelectSQL(SQL.DaysWithPostsInMonthAndYear(year, month, buildDrafts))
		        If rs = Nil Or rs.RowCount = 0 Then
		          // No posts for this day.
		          Continue
		        End If
		      Catch e As DatabaseException
		        Raise New Strike.Error("Unable to select days of the specified month/year containing posts from the databse: " + e.Message)
		      End Try
		      
		      For Each row As DatabaseRow In rs
		        days.Add(rs.Column("day").IntegerValue)
		      Next row
		      
		      // Build each archive day for this month and year.
		      For Each day As Integer In days
		        arcMonth.Days.Add(day)
		        
		        dayFolder = monthFolder.Child(day.ToString)
		        dayFolder.CreateFolder
		        BuildArchivesList(dayFolder, year, month, day)
		      Next day
		      
		      arcYear.Months.Add(arcMonth)
		    Next month
		    
		    ArchiveTree.Add(arcYear)
		  Next year
		  
		  // Build an unordered HTML list of the archives by short and long month.
		  // These are avaliable as {{archives.months}} and {{archives.longMonths}} tags.
		  ArchiveMonthsHTML = "<ul class=" + QUOTE + "archive-months" + QUOTE + ">"
		  ArchiveLongMonthsHTML = "<ul class=" + QUOTE + "archive-long-months" + QUOTE + ">"
		  
		  For Each arcYear As ArchiveYear In ArchiveTree
		    For Each arcMonth As ArchiveMonth In arcYear.Months
		      Var url As String = Permalink(PublicFolder.Child("archive").Child(arcYear.Value.ToString).Child(arcMonth.Value.ToString))
		      
		      ArchiveMonthsHTML = ArchiveMonthsHTML + "<li>" + _
		      "<a href=" + QUOTE + url + QUOTE + ">" + arcMonth.ShortName + " " + _
		      arcYear.Value.ToString + "</a><span class=""post-count"">" + arcMonth.PostCount.ToString + "</span></li>"
		      
		      ArchiveLongMonthsHTML = ArchiveLongMonthsHTML + "<li>" + _
		      "<a href=" + QUOTE + url + QUOTE + ">" + arcMonth.LongName + " " + _
		      arcYear.Value.ToString + "</a><span class=""post-count"">" + arcMonth.PostCount.ToString + "</span></li>"
		    Next arcMonth
		  Next arcYear
		  
		  ArchiveMonthsHTML = ArchiveMonthsHTML + "</ul>"
		  ArchiveLongMonthsHTML = ArchiveLongMonthsHTML + "</ul>"
		  
		  // Render baseURL/archive/index.html.
		  RenderArchivePage
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C647320746865206172636869766520666F6C6465727320616E642066696C657320666F72207468697320796561722E20576520617373756D652074686174207468657265206973206174206C65617374206F6E6520706F7374206D61646520696E207468697320796561722E
		Private Sub BuildArchivesList(enclosingFolder As FolderItem, year As Integer, month As Integer = -1, day As Integer = -1)
		  /// Builds the archive folders and files for this year.
		  /// We assume that there is at least one post made in this year.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var prevNum, nextNum As Integer
		  
		  Var buildDrafts As Boolean = Config.Lookup("buildDrafts", False)
		  
		  // What type of archives list is this?
		  Var type As String
		  If month = -1 Then
		    type = "year"
		  ElseIf day = -1 Then
		    type = "month"
		  Else
		    type = "day"
		  End If
		  
		  // How many posts for this type?
		  Var rs As RowSet
		  Try
		    Select Case type
		    Case "year"
		      rs = Database.SelectSQL(SQL.PostCountForYear(year, buildDrafts))
		    Case "month"
		      rs = Database.SelectSQL(SQL.PostCountForMonth(year, month, buildDrafts))
		    Case "day"
		      rs = Database.SelectSQL(SQL.PostCountForDay(year, month, day, buildDrafts))
		    Else
		      Raise New Strike.Error("Invalid type `" + type + "`.")
		    End Select
		  Catch e As DatabaseException
		    Raise New Strike.Error("Error selecting posts from the database when building the archives list: " + e.Message)
		  End Try
		  
		  If rs = Nil Then
		    Raise New Strike.Error("Error selecting posts from the database when building the archives list. The RowSet is Nil.")
		  End If
		  
		  Var postCount As Integer = rs.Column("total").IntegerValue
		  
		  // Get the "archives.html" template file text to use to render this archive list page(s).
		  Var templateFile As FolderItem = Theme.Child("layouts").Child("archives.html")
		  If Not templateFile.Exists Then
		    Raise New Strike.Error("The `archives.html` template file is missing.")
		  End If
		  Var template As String = FileContents(templateFile)
		  
		  // As we know how many posts to list per page and we know how many posts there are, we can
		  // calculate how many list pages we need.
		  Var postsPerPage As Integer = Config.Lookup("postsPerPage", -1)
		  Var numListPages As Integer = If(postsPerPage = -1, 1, Ceiling(postCount / postsPerPage))
		  
		  // Construct any required pagination folders.
		  If numListPages > 1 Then
		    Var pageFolder As FolderItem = enclosingFolder.Child("page")
		    pageFolder.CreateFolder
		    For i As Integer = 2 To numListPages
		      pageFolder.Child(i.ToString).CreateFolder
		    Next i
		  End If
		  
		  // Get all required posts, ordered by published date, paginated and render them.
		  For currentPage As Integer = 1 To numListPages
		    // Create the context for this list page.
		    Var context As New Strike.ListContext
		    
		    Try
		      Select Case type
		      Case "year"
		        rs = Database.SelectSQL(SQL.PostsForYear(year, postsPerPage, currentPage, buildDrafts))
		        context.ArchiveYear = year
		        context.ArchiveMonth = month
		        context.ArchiveDay = day
		        context.ArchiveDateRange = year.ToString
		      Case "month"
		        rs = Database.SelectSQL(SQL.PostsForMonth(year, month, postsPerPage, currentPage, buildDrafts))
		        context.ArchiveYear = year
		        context.ArchiveMonth = month
		        context.ArchiveDay = day
		        context.ArchiveDateRange = MonthToString(month) + " " + year.ToString
		      Case "day"
		        rs = Database.SelectSQL(SQL.PostsForDay(year, month, day, postsPerPage, currentPage, buildDrafts))
		        context.ArchiveYear = year
		        context.ArchiveMonth = month
		        context.ArchiveDay = day
		        context.ArchiveDateRange = MonthToString(month) + " " + day.ToString + " " + year.ToString
		      Else
		        Raise New Strike.Error("Invalid type `" + type + "`.")
		      End Select
		    Catch e As DatabaseException
		      Raise New Strike.Error("An error occurred when getting the required posts whilst building the archives list: " + e.Message)
		    End Try
		    
		    If rs = Nil Then
		      Raise New Strike.Error("Unexpected Nil RowSet.")
		    End If
		    
		    If numListPages = 1 Then
		      // Only one page.
		      context.PreviousPage = "#"
		      context.NextPage = "#"
		      
		    Else
		      // Multiple pages.
		      If currentPage = numListPages Then
		        // Last page of multiple pages.
		        prevNum = currentPage - 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(enclosingFolder.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(enclosingFolder.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = "#"
		        
		      ElseIf currentPage = 1 Then
		        //  First page of multiple pages.
		        context.PreviousPage = "#"
		        nextNum = currentPage + 1
		        context.NextPage = Permalink(enclosingFolder.Child("page").Child(nextNum.ToString).Child("index.html"))
		        
		      Else
		        // Not the first or last of multiple pages.
		        prevNum = currentPage - 1
		        nextNum = currentPage + 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(enclosingFolder.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(enclosingFolder.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = Permalink(enclosingFolder.Child("page").Child(Str(nextNum)).Child("index.html"))
		      End If
		    End If
		    
		    RenderListPage(rs, context, currentPage, template, enclosingFolder)
		  Next currentPage
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C647320746865206C697374207061676528732920666F7220616C6C2073656374696F6E7320696E2074686520636F6E74656E7420666F6C6465722C20706C6163696E67207468656D20696E746F20746865202F7075626C696320666F6C6465722E
		Private Sub BuildLists(folder As FolderItem)
		  /// Builds the list page(s) for all sections in the content folder, placing them
		  /// into the /public folder.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  If folder.IsFolder Then
		    If IsSection(folder) Then RenderList(folder)
		    For Each f As FolderItem In folder.Children
		      If f.IsFolder Then BuildLists(f)
		    Next f
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4372656174657320746865206D61696E2073697465206E617669676174696F6E20747265652E
		Private Sub BuildNavigation()
		  /// Creates the main site navigation tree.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Create the root.
		  SiteNavTree = New Strike.NavigationItem("root", "baseURL", "")
		  
		  // Add the home link if specified.
		  If Config.Lookup("includeHomeLinkInNavigation", False) Then
		    SiteNavTree.Children.Add(New Strike.NavigationItem("Home", BaseURL, "home", SiteNavTree))
		  End If
		  
		  // Add the sections in the `/content` folder.
		  SiteNavTree = AddNavigationChildren(SiteNavTree, Root.Child("content"))
		  
		  // Add the archive last (if required).
		  If config.Lookup("archives", False) Then
		    SiteNavTree.Children.Add(New Strike.NavigationItem("Archives", BaseURL + "archive.html", "archives", SiteNavTree))
		  End If
		  
		  // Convert the SiteNavTree into HTML and cache it.
		  SiteNavigationHTML = SiteNavTree.ToHTML
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C64732074686520525353206665656420616E6420736176657320697420746F20602F7273732E786D6C602E
		Private Sub BuildRSSFeed()
		  /// Builds the RSS feed and saves it to `/rss.xml`.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var xml As New XmlDocument
		  
		  Var xmlRoot As XMLNode = xml.AppendChild(xml.CreateElement("rss"))
		  xmlRoot.SetAttribute("version", "2.0")
		  
		  Var channel As XMLNode = xmlRoot.AppendChild(xml.CreateElement("channel"))
		  Call XmlNodeWithText(xml, channel, "title", Config.Lookup("siteName", "Default Title"))
		  Call XmlNodeWithText(xml, channel, "description", Config.Lookup("description", ""))
		  Call XmlNodeWithText(xml, channel, "link", BaseURL)
		  
		  If RSSItems.Count > 0 Then
		    // Sort the RSS items by date (newest first).
		    RSSItems.Sort(AddressOf CompareRSSItemDates)
		    
		    // Add each item to the XML document.
		    For Each ri As RSSItem In RSSItems
		      Var item As XMLNode = channel.AppendChild(xml.CreateElement("item"))
		      Call XmlNodeWithText(xml, item, "title", ri.Title)
		      Call XmlNodeWithText(xml, item, "link", ri.URL)
		      Call XmlNodeWithText(xml, item, "pubDate", ri.PubDate.ToString)
		      Call XmlNodeWithText(xml, item, "description", ri.Description)
		    Next ri
		  End If
		  
		  // Write the XML to `public/rss.xml`.
		  Try
		    Var rssFile As FolderItem = PublicFolder.Child("rss.xml")
		    WriteToFile(rssFile, xml.ToString)
		  Catch e As RuntimeException
		    Raise New Strike.Error("Unable To create the rss.xml file: " + e.Message)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E737472756374732074686520726571756972656420666F6C6465727320696E2074686520602F7075626C69636020666F6C64657220746F20686F757365207468652072656E64657265642048544D4C2066696C65732E
		Private Sub BuildSiteFolders()
		  /// Constructs the required folders in the `/public` folder to house the rendered HTML files.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // User defined content sections.
		  AddSectionFolder(Root.Child("content"), PublicFolder)
		  
		  // Storage folder
		  PublicFolder.Child("storage").CreateFolder
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4275696C6473207468652074616720666F6C6465727320616E642066696C65732E
		Private Sub BuildTags()
		  /// Builds the tag folders and files.
		  ///
		  /// E.g:
		  /// baseURL/tag/<tag-name>/index.html
		  /// baseURL/tag/<tag-name>/page/2/index.html, etc
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var rs As RowSet
		  Try
		    rs = Database.SelectSQL(SQL.AllTags)
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to retrieve all post tags from the database: " + e.Message)
		  End Try
		  
		  If rs = Nil Or rs.RowCount = 0 Then Return
		  
		  // Create the root folder for all tags.
		  Var tagRoot As FolderItem = PublicFolder.Child("tag")
		  tagRoot.CreateFolder
		  
		  // Render each tag.
		  For Each row As DatabaseRow In rs
		    Var tagName As String = row.Column("name").StringValue
		    Var tagFolder As FolderItem = tagRoot.Child(tagName)
		    tagFolder.CreateFolder
		    RenderTag(tagName, tagFolder)
		  Next row
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5573656420746F20736F727420525353206974656D73206279207468656972207075626C69636174696F6E20646174652E
		Private Function CompareRSSItemDates(r1 As Strike.RSSItem, r2 As Strike.RSSItem) As Integer
		  /// Used to sort RSS items by their publication date.
		  
		  If r1.pubDate.SecondsFrom1970 < r2.pubDate.SecondsFrom1970 Then Return 1
		  
		  If r1.pubDate.SecondsFrom1970 > r2.pubDate.SecondsFrom1970 Then Return -1
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206865782D656E636F646564204D443520646967657374206F6620746865207061737365642066696C652E20417373756D6573206066696C6560206973206E6F74204E696C20616E6420697320612066696C652C206E6F74206120666F6C6465722E
		Private Function ComputeHash(file As FolderItem) As String
		  /// Returns the hex-encoded MD5 digest of the passed file.
		  /// Assumes `file` is not Nil and is a file, not a folder.
		  ///
		  /// Thanks to Kem Tekinay: https://forum.xojo.com/t/md5-check-a-file/23390/5?u=garrypettet
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var mdfive As New MD5Digest
		  
		  Var bs As BinaryStream = BinaryStream.Open(file)
		  
		  While Not bs.EndOfFile
		    Var chunk As String = bs.Read(1000000)
		    mdfive.Process(chunk)
		  Wend
		  
		  Return EncodeHex(mdfive.Value)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ConnectToDatabase()
		  /// Connects to the database file.
		  /// Assumes `Root` points to a validated site root.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Database = New SQLiteDatabase
		  DatabaseFile = Root.Child("site.data")
		  Database.DatabaseFile = DatabaseFile
		  
		  Try
		    Database.Connect 
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to connect to the site's database: " + e.Message)
		  End Try
		  
		  // Enable foreign key support in SQLite
		  Try
		    Database.ExecuteSQL("PRAGMA FOREIGN_KEYS = ON;")
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to enable foreign key support.")
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  /// Private to prevent external instantiation. SiteBuilders should be constructed from 
		  /// one of the shared methods.
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F7069657320616E792066696C657320696E2060526F6F742F73746F726167656020746F20607075626C69632F73746F72616765602E
		Private Sub CopyStorage()
		  /// Copies any files in `Root/storage` to `public/storage`.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var publicStorage As FolderItem = PublicFolder.Child("storage")
		  
		  Var storage As FolderItem = Root.Child("storage")
		  
		  For Each item As FolderItem In storage.Children
		    item.CopyTo(publicStorage)
		  Next item
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F7069657320616E79206173736574732070726F7669646564206279207468652063757272656E74207468656D6520746F20607075626C69632F7468656D652F617373657473602E
		Private Sub CopyThemeAssets()
		  /// Copies any assets provided by the current theme to `public/theme/assets`.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var publicAssets As FolderItem = PublicFolder.Child("assets")
		  Var themeAssets As FolderItem = Theme.Child("assets")
		  
		  If themeAssets.Count > 0 Then
		    Var f As FolderItem = publicAssets
		    f.CreateFolder
		    
		    For Each item As FolderItem In themeAssets.Children
		      item.CopyTo(publicAssets)
		    Next item
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 437265617465732061206E657720656D7074792073697465206E616D65642060736974654E616D65602077697468696E2061206368696C6420666F6C646572206F662060706172656E7460207573696E6720746865207370656369666965642064656661756C74207468656D652E
		Shared Function Create(siteName As String, parent As FolderItem, defaultTheme As FolderItem, sampleContent As Boolean) As Strike.SiteBuilder
		  /// Creates a new empty site named `siteName` within a child folder of `parent` using the 
		  /// specified default theme.
		  ///
		  /// Assigns this site builder to the newly constructed site.
		  /// Raises an exception if an issue occurs.
		  
		  Var builder As New SiteBuilder
		  
		  // Sanity checks.
		  If parent = Nil Or Not parent.Exists Then
		    Raise New InvalidArgumentException("Cannot create a new site as the parent folder does not exist.")
		  End If
		  
		  If Not parent.IsFolder Then
		    Raise New InvalidArgumentException("Cannot create a new site as the parent FolderItem must be a folder, not a file.")
		  End If
		  
		  If siteName = "" Then
		    Raise New InvalidArgumentException("Cannot create a new site as you haven't provided a site name.")
		  End If
		  
		  If Not parent.IsReadable Or Not parent.IsWriteable Then
		    Raise New InvalidArgumentException("Cannot create a new site as the parent folder is not read/writeable.")
		  End If
		  
		  // Create and assign the root folder.
		  builder.Root = parent.Child(siteName)
		  If builder.Root.Exists Then
		    Var message As String = If(builder.Root.IsFolder, "folder", "file")
		    Raise New InvalidArgumentException("Cannot create a new site as there is already a " + _
		    message + " with that name within the specified parent.")
		  End If
		  Try
		    builder.Root.CreateFolder
		  Catch e As IOException
		    Raise New IOException("Unable to create the site's root folder.")
		  End Try
		  
		  // Create the required folders.
		  // Content.
		  Try
		    builder.Root.Child("content").CreateFolder
		  Catch e As RuntimeException
		    Raise New IOException("Unable to create the `content` folder within the site root.")
		  End Try
		  
		  // Storage.
		  Try
		    builder.Root.Child("storage").CreateFolder
		  Catch e As RuntimeException
		    Raise New IOException("Unable to create the `storage` folder within the site root.")
		  End Try
		  
		  // Themes.
		  Try
		    builder.Root.Child("themes").CreateFolder
		  Catch e As RuntimeException
		    Raise New IOException("Unable to create the `themes` folder within the site root.")
		  End Try
		  
		  ValidateTheme(defaultTheme)
		  
		  // Copy the default theme to the `themes` folder.
		  defaultTheme.CopyTo(builder.Root.Child("themes"))
		  
		  // Initialise the site's configuration.
		  Try
		    Var tout As TextOutputStream = TextOutputStream.Create(builder.Root.Child("config.toml"))
		    builder.Config = NewConfig
		    tout.Write(GenerateTOML(builder.Config))
		    tout.Close
		  Catch e As RuntimeException
		    Raise New IOException("Unable to create the config file within the site root.")
		  End Try
		  
		  // Create the site's database.
		  builder.CreateDatabase
		  
		  If sampleContent Then
		    CreateSampleContent(builder.Root)
		  End If
		  
		  Return builder
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437265617465732061206E657720646174616261736520666F72207468652063757272656E7420736974652E20417373756D65732074686174206043726561746528296020686173206A757374206265656E2063616C6C65642E
		Private Sub CreateDatabase()
		  /// Creates a new database for the current site.
		  /// Assumes that `Create()` has just been called.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Create the actual file on disk that will contain the SQLite database.
		  DatabaseFile = Root.Child("site.data")
		  Database = New SQLiteDatabase
		  Database.DatabaseFile = DatabaseFile
		  Try
		    Database.CreateDatabase
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to create the database file.")
		  End Try
		  
		  // Run the schema to construct an empty database.
		  Try
		    Database.ExecuteSQL(SCHEMA)
		  Catch e As DatabaseException
		    Raise New Strike.Error("An error occurring whilst creating the database from the scheme: " + e.Message)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4372656174657320736F6D6520626F696C6572706C6174652F7374617274657220636F6E74656E7420666F722074686520736974652077697468696E20746865207061737365642060736974656020666F6C6465722E
		Private Shared Sub CreateSampleContent(site As FolderItem)
		  /// Creates some boilerplate/starter content for the site within the passed `site` folder.
		  
		  Const QUOTE = """"
		  
		  // Create a 'Hello World' post.
		  Try
		    Var f As FolderItem = site.Child("content").Child("Hello World.md")
		    Var tout As TextOutputStream = TextOutputStream.Create(f)
		    tout.WriteLine("+++")
		    tout.WriteLine("title = " + QUOTE + "Hello World!" + QUOTE)
		    tout.WriteLine("+++")
		    tout.WriteLine("")
		    tout.WriteLine("This is your first post. Feel free to edit or delete it.")
		    tout.Close
		  Catch
		    Raise New Strike.Error("Unable to create sample content (`Hello World post`).")
		  End Try
		  
		  // Create an 'about' page.
		  Try
		    site.Child("content").Child("about").CreateFolder
		    Var f As FolderItem = site.Child("content").Child("about").Child("index.md")
		    Var tout As TextOutputStream = TextOutputStream.Create(f)
		    tout.WriteLine("+++")
		    tout.WriteLine("title = " + QUOTE + "About Page" + QUOTE)
		    tout.WriteLine("+++")
		    tout.WriteLine("")
		    tout.Write("This is an example of a page. You can find its content in **/content/about/index.md**. ")
		    tout.Write("Feel free to edit or delete it.")
		    tout.Close
		  Catch
		    Raise New Strike.Error("Unable to create sample content (`About Page`).")
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966207468657265206973206120706F737420696E2074686520646174616261736520776974682061206D61746368696E67206861736820616E642066696C6520706174682E
		Private Function FileExistsInDatabase(hash As String, filePath As String) As Boolean
		  /// Returns True if there is a post in the database with a matching hash and file path. 
		  ///
		  /// If there is then the contents of the post's file hasn't changed and so we don't need 
		  /// to re-render the markdown. 
		  /// If the hash is not in the database but the file path is then the file has changed but the
		  /// user kept it in the same location in `/content`. 
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Is there a post in the database with this hash and file path?
		  Var sql As String = "SELECT id FROM posts WHERE (hash='" + hash + "') AND (filePath = '" + _
		  filePath + "');"
		  Var rs As RowSet = Database.SelectSQL(sql)
		  If rs.RowCount = 0 Then
		    // Nope.
		    Return False
		  Else
		    // File path and hash matches. We can safely skip this file but first flag that we've 
		    // verified it.
		    sql = "UPDATE posts SET verified=1 WHERE id=" + rs.Column("id").IntegerValue.ToString + ";"
		    Database.ExecuteSQL(sql)
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B657320612066696C6520666F756E642077697468696E20602F636F6E74656E746020616E64206164647320697420746F2074686520736974652773206461746162617365206966206E65656465642E204D617920726169736520616E20657863657074696F6E2E
		Private Sub FileToDatabase(file as FolderItem)
		  /// Takes a file found within `/content` and adds it to the site's database if needed.
		  /// May raise an exception.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var post As New Strike.Post(file)
		  
		  // Assert this is a Markdown file.
		  If file.Name.Length < 4 Or file.Name.Right(3) <> ".md" Then
		    Raise New Strike.Error("An unexpected non-Markdown file was found: `" + _
		    file.NativePath + "`.")
		  End If
		  
		  // Set the file path for this post's source file.
		  post.FilePath = file.NativePath
		  
		  // Compute this file's hash.
		  post.Hash = ComputeHash(file)
		  
		  // Skip this file if it's already in the database and hasn't changed since.
		  If FileExistsInDatabase(post.Hash, post.FilePath) Then Return
		  
		  // Get the contents of this file.
		  Try
		    Var tin As TextInputStream = TextInputStream.Open(file)
		    post.Markdown = tin.ReadAll
		    tin.Close
		  Catch
		    Raise New Strike.Error("Unable to read the contents of `" + file.NativePath + "`.")
		  End Try
		  
		  // Extract and parse the frontmatter from the markdown (if any).
		  post.ExtractFrontMatter
		  post.ParseFrontmatter
		  
		  // Determine the public URL for this post.
		  post.URL = URLForFile(file, post.Slug)
		  
		  // Determine this post's section.
		  post.Section = SectionForPost(post)
		  
		  // Set this post's updated date.
		  post.LastUpdated = DateTime.Now
		  
		  // Homepage, page or post?
		  If file.NativePath = Root.Child("content").Child("index.md").NativePath Then
		    post.IsHomepage = True
		  ElseIf file.Name = "index.md" Then
		    post.IsPage = True
		  Else
		    post.IsPage = False
		  End If
		  
		  // Render the Markdown.
		  post.RenderedMarkdown = MarkdownKit.ToHTML(post.Markdown)
		  
		  /// Computes the first paragraph for this post (HTML stripped and not).
		  Var rx As New RegEx
		  rx.SearchPattern = "<p>(.+)<\/p>"
		  Var match As RegExMatch
		  match = rx.Search(post.RenderedMarkdown)
		  If match <> Nil Then
		    post.FirstParagraphStripped = StripHTMLTags(match.SubExpressionString(0))
		    post.FirstParagraph = match.SubExpressionString(0)
		  Else
		    post.FirstParagraphStripped = StripHTMLTags(post.RenderedMarkdown)
		    post.FirstParagraph = post.RenderedMarkdown
		  End If
		  
		  // Add this post to the database.
		  AddPostToDatabase(post)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652073656374696F6E20666F72207468697320666F6C6465722E205468652073656374696F6E206973206120646F742D64656C696D6974656420737472696E6720726570726573656E74696E6720776865726520696E2074686520602F636F6E74656E746020686965726172636879207468697320666F6C6465722069732E
		Private Function FolderAsSection(folder As FolderItem) As String
		  /// Returns the section for this folder.
		  /// The section is a dot-delimited string representing where in the `/content` hierarchy this
		  /// folder is.
		  ///
		  /// E.g:
		  ///  www.example.com/blog/             section = blog
		  ///  www.example.com/blog/personal/    section = blog.personal
		  ///  www.example.com/about/            section = about
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  If Not folder.IsFolder Then
		    Raise New Strike.Error("`" + folder.NativePath + "` is not a folder.")
		  End If
		  
		  Var url As String = folder.URLPath // example: "file://path/to/file".
		  
		  url = url.Right(url.Length - url.IndexOf("content/") - 8)
		  
		  If url = "" Then
		    // Content folder (the root section).
		    Return ""
		  End If
		  
		  If url.Right(1) = "/" Then url = url.Left(url.Length - 1)
		  
		  Return url.ReplaceAll("/", ".")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 412064656C656761746520666F7220736F7274696E6720616E206172726179206F6620466F6C6465724974656D7320616C7068616265746963616C6C79206279206E616D652E
		Private Function FolderItemArraySort(f1 As FolderItem, f2 As FolderItem) As Integer
		  /// A delegate for sorting an array of FolderItems alphabetically by name.
		  
		  If f1.Name > f2.Name Then Return 1
		  If f1.Name < f2.Name Then Return -1
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652074656D706C6174652066696C6520746F2075736520746F2072656E646572207468697320706F73742E
		Private Function GetTemplateFile(p As Strike.Post, postType As Strike.PostTypes) As FolderItem
		  /// Returns the template file to use to render this post.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // We default to `theme/page.html` or `theme/post.html` if we can't 
		  // find `theme/sectionPath/page.html` or `theme/sectionPath/page.html` (depending on `type`)
		  // as these files are required to be present in every theme.
		  Var templateFile As FolderItem = Theme.Child("layouts")
		  Var sections() As String = p.Section.Split(".")
		  For Each section As String In sections
		    templateFile = templateFile.Child(section)
		    If Not templateFile.Exists Then
		      templateFile = Theme.Parent
		      Exit
		    End If
		  Next section
		  templateFile = templateFile.Child(postType.ToString + ".html")
		  
		  // Check that the "page.html" or "post.html" template file for this section exists.
		  If Not templateFile.Exists And _
		    templateFile.NativePath <> theme.Child("layouts").Child(postType.ToString + ".html").NativePath Then
		    // It doesn't exist. Fallback to the default "page.html" or "post.html" template file.
		    templateFile = theme.Child("layouts").Child(postType.ToString + ".html")
		  End If
		  
		  If Not templateFile.Exists Then
		    Raise New Strike.Error("Cannot find the default `" + postType.ToString + ".html` template file.")
		  End If
		  
		  Return templateFile
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652074656D706C6174652066696C6520746F2075736520746F2072656E64657220746869732073656374696F6E206C6973742E206073656374696F6E602069732074686520646F742D64656C696D697465642073656374696F6E20706174682E
		Private Function GetTemplateListFile(section As String) As FolderItem
		  /// Returns the template file to use to render this section list.
		  /// `section` is the dot-delimited section path.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  /// Get the template file to use to render this post.
		  /// We default to `theme/list.html` if we can't find `theme/sectionPath/list.html`.
		  Var template As FolderItem = Theme.Child("layouts")
		  Var sections() As String = section.Split(".")
		  For Each s As String In sections
		    template = template.Child(s)
		    If Not template.Exists Then
		      template = Theme.Parent
		      Exit
		    End If
		  Next s
		  template = template.Child("list.html")
		  
		  // Check that the "list.html" template file for this section exists.
		  If Not template.Exists And template.NativePath <> Theme.Child("layouts").Child("list.html").NativePath Then
		    // It doesn't exist. Fallback to the default "list.html" template file.
		    template = Theme.Child("layouts").Child("list.html")
		  End If
		  
		  If Not template.Exists Then
		    Raise New Strike.Error("Cannot find the default `list.html` template file.")
		  End If
		  
		  Return template
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 537472696B652070726F76696465732061206E756D626572206F66206D697363656C6C616E656F7573207461677320746861742063616E2062652063616C6C65642066726F6D20616E792074656D706C6174652066696C652E2052657475726E732074686520737472696E672076616C7565206F662074686520726571756573746564207461672E20526169736573206120537472696B652E4572726F7220696620746865207265717565737465642068656C7065722074616720697320756E6B6E6F776E2E
		Private Function HelperTag(name As String) As String
		  /// Strike provides a number of miscellaneous tags that can be called from any template file.
		  /// Returns the string value of the requested tag.
		  /// Raises a Strike.Error if the requested helper tag is unknown.
		  ///
		  /// {{helper.day}}        The current day of the month (two digits).
		  /// {{helper.longMonth}}  The current month (e.g. January).
		  /// {{helper.shortMonth}} The current month (e.g. Jan).
		  /// {{helper.month}}      The current month (two digits).
		  /// {{helper.year}}       The current year (four digits).
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var d As DateTime = DateTime.Now
		  
		  Select Case name
		  Case "day"
		    If d.Day < 10 Then
		      Return "0" + d.Day.ToString
		    Else
		      Return d.Day.ToString
		    End If
		    
		  Case "longMonth"
		    Return d.LongMonth
		    
		  Case "shortMonth"
		    Return d.ShortMonth
		    
		  Case "month"
		    If d.Month < 10 Then
		      Return "0" + d.Month.ToString
		    Else
		      Return d.Month.ToString
		    End If
		    
		  Case "year"
		    Return d.Year.ToString
		    
		  Case Else
		    Raise New Strike.Error ("Unknown helper name `" + name + "`.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E6A656374732074686520737472696E672076616C75652073706563696669656420696E20436F6E6669672E696E6A65637448656164206A757374206265666F726520746865206669727374206F6363757272656E6365206F6620603C2F686561643E6020696E206068746D6C602E2052657475726E7320746865206D6F646966696564206068746D6C602E
		Private Function InjectBody(html As String) As String
		  /// Injects the string value specified in Config.injectBody just before the last 
		  /// occurrence of `</body>` in `html`.
		  /// Returns the modified `html`.
		  
		  Var value As String = Config.Lookup("injectBody", "")
		  
		  If value = "" Then Return html
		  
		  // Find the last occurrence of </body>.
		  Var rx As New RegEx
		  rx.SearchPattern = "(?<!<\/body>).+<\/body>"
		  Var match As RegExMatch = rx.Search(html)
		  
		  // No match so leave the HTML unaltered.
		  If match = Nil Then Return html
		  
		  // Get the start location in html of the found </body>.
		  Var bodyStart As Integer = html.LeftBytes(match.SubExpressionStartB(0)).Length
		  
		  // Get the actual string matched (which may be preceded by whitespace).
		  Var matchedBody As String = match.SubExpressionString(0)
		  
		  // Do the insertion.
		  Return html.Replace(bodyStart, matchedBody.Length, value + EndOfLine + matchedBody, Config.Lookup("extendedUnicodeSupport", False))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E6A656374732074686520737472696E672076616C75652073706563696669656420696E20436F6E6669672E696E6A65637448656164206A757374206265666F726520746865206669727374206F6363757272656E6365206F6620603C2F686561643E6020696E206068746D6C602E2052657475726E7320746865206D6F646966696564206068746D6C602E
		Private Function InjectHead(html As String) As String
		  /// Injects the string value specified in Config.injectHead just before the first 
		  /// occurrence of `</head>` in `html`.
		  /// Returns the modified `html`.
		  
		  Var value As String = Config.Lookup("injectHead", "")
		  
		  If value = "" Then Return html
		  
		  Return html.Replace("</head>", value + EndOfLine + "</head>")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B6573206120666F6C6465722077697468696E20602F636F6E74656E746020616E642072657475726E732054727565206966206974277320612073656374696F6E20726174686572207468616E206120706167652E204966206120666F6C64657220696E20602F636F6E74656E746020636F6E7461696E73206A75737420612073696E676C6520696E6465782E6D642066696C65207468656E2069742773206120706167652C206F7468657277697365206974277320612073656374696F6E2E
		Private Function IsSection(folder As FolderItem) As Boolean
		  /// Takes a folder within `/content` and returns True if it's a section rather than a page.
		  /// If a folder in `/content` contains just a single index.md file then it's a page, 
		  /// otherwise it's a section.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  If Not folder.Child("index.md").Exists Then
		    // Section. 
		    Return True
		  End If
		  
		  If FileCount(folder) = 1 Then
		    // Page (has an index.md file and there is only one file in the folder).
		    Return False
		  End If
		  
		  Return True // Section.
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732061206E657720536974654275696C64657220696E7374616E636520636F6E73747275637465642066726F6D207468652070617373656420537472696B65207369746520726F6F7420666F6C6465722E
		Shared Function Load(siteFolder As FolderItem) As Strike.SiteBuilder
		  /// Returns a new SiteBuilder instance constructed from the passed Strike site root folder.
		  
		  Strike.ValidateSite(siteFolder)
		  
		  // Create the builder instance and set the root and config file destinations.
		  Var builder As New Strike.SiteBuilder
		  builder.Root = siteFolder
		  
		  LoadConfig(builder)
		  
		  // Connect to the site's database.
		  builder.DatabaseFile = builder.Root.Child("site.data")
		  builder.ConnectToDatabase
		  
		  Return builder
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4C6F6164732074686520636F6E6669672066696C6520666F722074686520706173736564206275696C64657220696E7374616E63652E
		Private Shared Sub LoadConfig(builder As Strike.SiteBuilder)
		  /// Loads the config file for the passed builder instance.
		  
		  builder.Config = ParseTOML(FileContents(builder.Root.Child("config.toml")))
		  
		  // When a TOML array is parsed we get a Variant array. We need a String array...
		  Var vExcluded() As Variant = builder.Config.Value("rssExcludedSections")
		  builder.Config.Remove("rssExcludedSections")
		  For Each section As String In vExcluded
		    builder.mRSSExcludedSections.Add(section)
		  Next section
		  
		  // Get the list of any sections that should be listed alphabetically by title rather than
		  // publication date.
		  // When a TOML array is parsed we get a Variant array. We need a String array...
		  Var vListAlphabetically() As Variant = builder.Config.Value("alphabeticalSections")
		  builder.Config.Remove("alphabeticalSections")
		  For Each section As String In vListAlphabetically
		    builder.AlphabeticalSections.Add(section)
		  Next section
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207075626C6963207065726D616C696E6B20666F72207468652073706563696669656420666F6C64657220696E2074686520602F636F6E74656E746020666F6C6465722E
		Private Function NavigationPermalink(folder As FolderItem) As String
		  /// Returns the public permalink for the specified folder in the `/content` folder.
		  ///
		  /// Used when generating the main site navigation.
		  /// We keep error checking light here as it should have been done beforehand.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var f As FolderItem = folder
		  
		  Var url As String
		  Do
		    If url <> "" Then
		      url = Slugify(f.Name) + "/" + url
		    Else
		      url = Slugify(f.Name)
		    End If
		    f = f.Parent
		  Loop Until f.NativePath = Root.Child("content").NativePath
		  
		  Return BaseURL + url + "/index.html"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320612064696374696F6E61727920636F6E7461696E696E67207468652064656661756C7420636F6E6669672073657474696E677320666F72206120736974652E
		Shared Function NewConfig() As Dictionary
		  /// Returns a dictionary containing the default config settings for a site.
		  
		  Var alphabeticalSections() As String
		  Var rssExcludedSections() As String
		  
		  Var config As New Dictionary( _
		  "alphabeticalSections"        : alphabeticalSections, _
		  "archives"                    : False, _
		  "baseURL"                     : "/", _
		  "buildDrafts"                 : False, _
		  "description"                 : "My awesome site", _
		  "extendedUnicodeSupport"      : False, _
		  "includeHomeLinkInNavigation" : False, _
		  "injectHead"                  : "", _
		  "injectBody"                  : "", _
		  "postsPerPage"                : 10, _
		  "rss"                         : False, _
		  "rssExcludedSections"         : rssExcludedSections, _
		  "siteName"                    : "My Site", _
		  "theme"                       : DefaultTheme _
		  )
		  
		  Return config
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207065726D616C696E6B20746F20746865206E657874207075626C697368656420706F737420696E207468652073616D652073656374696F6E206F72202223222069662074686572652069736E2774206F6E652E
		Private Function NextPost(post As Strike.Post) As String
		  /// Returns the permalink to the next published post in the same section or "#"
		  /// if there isn't one.
		  
		  Var rs As RowSet
		  
		  Var query As String
		  If AlphabeticalSections.IndexOf(post.Section) <> -1 Then
		    // This post's section is ordered alphabetically by title.
		    query = SQL.PostsAfterTitle(post.title, post.Section, Config.Value("buildDrafts"), 1)
		  Else
		    // This post's section is ordered by publication date.
		    query = SQL.PostsAfterDate(post.Date, post.Section, Config.Value("buildDrafts"), 1)
		  End If
		  
		  Try
		    rs = Database.SelectSQL(query)
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to select posts after date `" + post.Date.ToString + _
		    "`: " + e.Message)
		  End Try
		  
		  If rs = Nil Or rs.RowCount = 0 Then Return "#"
		  
		  For Each row As DatabaseRow In rs
		    // We want the first row since the RowSet order is important.
		    Var nextP As Strike.Post = PostFromDatabaseRow(row)
		    Return nextP.URL
		  Next row
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520466F6C6465724974656D20666F72207768657265207468697320706F73742073686F756C642062652072656E646572656420746F20696E20746865206F757470757420666F6C6465722E
		Private Function OutputPathForPost(p As Strike.Post) As FolderItem
		  /// Returns the FolderItem for where this post should be rendered to in the output folder.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // If there's no section then it's top level.
		  If p.Section = "" Then
		    Return PublicFolder.Child(p.Slug + ".html")
		  End If
		  
		  Var destination As FolderItem = PublicFolder
		  
		  Var sections() As String = p.Section.Split(".")
		  For Each section As String In sections
		    destination = destination.Child(section)
		    If Not destination.Exists Then
		      Raise New Strike.Error("The output destination `" + destination.NativePath + _
		      "` does not exist.")
		    End If
		  Next section
		  
		  Return destination.Child(p.Slug + ".html")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320776861742077696C6C20626520746865207075626C69632055524C206F6620746865207061737365642066696C652E
		Private Function Permalink(f As FolderItem) As String
		  /// Returns what will be the public URL of the passed file.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var baseURL As String = Config.Lookup("baseURL", "/")
		  Return If(baseURL.Right(1) = "/", baseURL.Left(baseURL.Length - 1), baseURL) + _
		  f.NativePath.Replace(PublicFolder.NativePath, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E756D626572206F6620706F73747320696E20746865207370656369666965642073656374696F6E2E206073656374696F6E602073686F756C6420626520646F742D64656C696D697465642028652E673A2022626C6F672E706572736F6E616C2220666F7220706F73747320696E2060636F6E74656E742F626C6F672F706572736F6E616C60292E
		Private Function PostCountForSection(section As String) As Integer
		  /// Returns the number of posts in the specified section.
		  /// `section` should be dot-delimited (e.g: "blog.personal" for posts in `content/blog/personal`).
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var rs As RowSet
		  Try
		    If Config.Lookup("buildDrafts", False) Then
		      rs = Database.SelectSQL("SELECT COUNT(*) FROM posts WHERE section='" + section + "';")
		    Else
		      rs = Database.SelectSQL("SELECT COUNT(*) FROM posts WHERE section='" + section + "' " + _
		      "AND isDraft=0;")
		    End If
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to select all posts from section `" + section + "`: " + e.Message)
		  End Try
		  
		  If rs = Nil Or rs.RowCount = 0 Then
		    Return 0
		  Else
		    Return rs.Column("COUNT(*)").IntegerValue
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E7374616E7469617465732061206E657720706F73742066726F6D206120726F7720696E20746865207369746527732064617461626173652028706F737473207461626C65292E204D617920726169736520612060537472696B652E4572726F72602E
		Private Function PostFromDatabaseRow(row As DatabaseRow) As Strike.Post
		  /// Instantiates a new post from a row in the site's database (posts table).
		  /// May raise a `Strike.Error`.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  #Pragma BreakOnExceptions False
		  
		  Var p As New Strike.Post
		  
		  Var postID As Integer = row.Column("id").IntegerValue
		  
		  p.Date = New DateTime(row.Column("date").IntegerValue)
		  
		  Try
		    p.FilePath = row.Column("filePath").StringValue
		    p.File = New FolderItem(p.FilePath, FolderItem.PathModes.Native)
		  Catch e As RuntimeException
		    Raise New Strike.Error("Invalid post file path. ID = " + postID.ToString + ", filePath: " + p.FilePath)
		  End Try
		  
		  p.FirstParagraph = row.Column("firstParagraph").StringValue
		  
		  p.FirstParagraphStripped = row.Column("firstParagraphStripped").StringValue
		  
		  p.Hash = row.Column("hash").StringValue
		  
		  p.IsDraft = row.Column("isDraft").BooleanValue
		  
		  p.IsHomepage = row.Column("isHomepage").BooleanValue
		  
		  p.IsPage = row.Column("isPage").BooleanValue
		  
		  p.LastUpdated = New DateTime(row.Column("lastUpdated").IntegerValue)
		  
		  p.Markdown = row.Column("markdown").StringValue
		  
		  p.RenderedMarkdown = row.Column("renderedMarkdown").StringValue
		  
		  p.Section = row.Column("section").StringValue
		  
		  p.Slug = row.Column("slug").StringValue
		  
		  p.Title = row.Column("title").StringValue
		  
		  Try
		    p.Data = ParseTOML(row.Column("toml").StringValue)
		  Catch
		    p.Data = Nil
		  End Try
		  
		  p.URL = row.Column("url").StringValue
		  
		  // Tags.
		  Var tagsRS As RowSet
		  Try
		    tagsRS = Database.SelectSQL(Strike.SQL.TagsForPost(row.Column("id").IntegerValue))
		  Catch e As DatabaseException
		    Raise New Strike.Error("An error occurred selecting tags for post with id `" + postID.ToString + "`: " + e.Message)
		  End Try
		  
		  For Each tagRow As DatabaseRow In tagsRS
		    p.Tags.Add(tagRow.Column("name").StringValue)
		  Next tagRow
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207065726D616C696E6B20746F207468652070726576696F75736C79207075626C697368656420706F737420696E207468652073616D652073656374696F6E206F72202223222069662074686572652069736E2774206F6E652E
		Private Function PreviousPost(post As Strike.Post) As String
		  /// Returns the permalink to the previously published post in the same section or "#" 
		  /// if there isn't one.
		  
		  Var rs As RowSet
		  
		  Var query As String
		  If AlphabeticalSections.IndexOf(post.Section) <> -1 Then
		    // This post's section is ordered alphabetically by title.
		    query = SQL.PostsBeforeTitle(post.Title, post.Section, Config.Value("buildDrafts"), 1)
		  Else
		    // This post's section is ordered by publication date.
		    query = SQL.PostsBeforeDate(post.Date, post.Section, Config.Value("buildDrafts"), 1)
		  End If
		  
		  Try
		    rs = Database.SelectSQL(query)
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to select posts before date `" + post.Date.ToString + _
		    "`: " + e.Message)
		  End Try
		  
		  If rs = Nil Or rs.RowCount = 0 Then Return "#"
		  
		  For Each row As DatabaseRow In rs
		    // We want the first row since the RowSet order is important.
		    Var nextP As Strike.Post = PostFromDatabaseRow(row)
		    Return nextP.URL
		  Next row
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 547261766572736573207468697320666F6C64657220616E642070617273657320697420696E746F20746865207369746527732064617461626173652E
		Private Sub Process(folder As FolderItem)
		  /// Traverses this folder and parses it into the site's database.
		  ///
		  /// We call it recursively for each folder encountered within `/content`.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  For Each item As FolderItem In folder.Children
		    If item.IsFolder Then
		      Process(item)
		    Else
		      If item.Name <> ".DS_STORE" Then
		        FileToDatabase(item)
		      End If
		    End If
		  Next item
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E6465727320746865206261736555524C2F617263686976652F696E6465782E68746D6C20706167652E
		Private Sub RenderArchivePage()
		  /// Renders the baseURL/archive/index.html page.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Get the "archives-home.html" template file text to use to render this post.
		  Var templateFile As FolderItem = Theme.Child("layouts").Child("archives-home.html")
		  If Not templateFile.Exists Then
		    Raise New Strike.Error("The `archives-home.html` template file is missing")
		  End If
		  Var result As String = FileContents(templateFile)
		  
		  Var destination As FolderItem = PublicFolder.Child("archive.html")
		  
		  // Check there actually content in this template file.
		  // Otherwise we just create an empty file.
		  If result = "" Then
		    WriteToFile(destination, "")
		    Return
		  End If
		  
		  result = ResolveTags(result)
		  
		  // Is there anything to inject in the <head>?
		  If Config.Lookup("injectHead", "") <> "" Then
		    result = InjectHead(result)
		  End If
		  
		  // Is there anything to inject at the end of <body>?
		  If Config.Lookup("injectBody", "") <> "" Then
		    result = InjectBody(result)
		  End If
		  
		  result = result.Trim
		  
		  // Write the contents to disk.
		  WriteToFile(destination, result.Trim)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E73747275637473206120686F6D6520706167652074686174206C6973747320616C6C207369746520706F7374732E
		Private Sub RenderHomePageList()
		  /// Constructs a home page that lists all site posts.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var buildDrafts As Boolean = Config.Lookup("buildDrafts", False)
		  
		  /// How many posts are in this section?
		  Var postCount As Integer = SitePostCount
		  
		  If postCount = 0 Then
		    Return
		  End If
		  
		  // Get a reference to the parent folder that will contain this section's list pages.
		  Var destination As FolderItem = PublicFolder
		  
		  // Get the "list.html" template file text to use to render this list page.
		  Var templateFile As FolderItem = GetTemplateListFile("")
		  Var template As String = FileContents(templateFile)
		  
		  // As we know how many posts to list per page and we know how many posts there are, we can
		  // calculate how many list pages we need.
		  Var postsPerPage As Integer = Config.Lookup("postsPerPage", -1)
		  Var numListPages As Integer = If(postsPerPage = -1, 1, Ceiling(postCount / postsPerPage))
		  
		  // Construct any required pagination folders.
		  If numListPages > 1 Then
		    Var pageFolder As FolderItem = destination.Child("page")
		    pageFolder.CreateFolder
		    For a As Integer = 2 To numListPages
		      pageFolder.Child(a.ToString).CreateFolder
		    Next a
		  End If
		  
		  // Get all posts ordered by published date, paginated and render them.
		  Var prevNum, nextNum As Integer
		  For currentPage As Integer = 1 To numListPages
		    Var rs As RowSet 
		    Try
		      rs = Database.SelectSQL(SQL.AllPosts(postsPerPage, currentPage, buildDrafts))
		    Catch e As DatabaseException
		      Raise New Strike.Error("Unable to get all posts: " + e.Message)
		    End Try
		    If rs = Nil Then
		      Raise New Strike.Error("Unexpected Nil RowSet.")
		    End If
		    
		    // Create the context for this list page.
		    Var context As New Strike.ListContext
		    
		    If numListPages = 1 Then
		      // Only one page.
		      context.PreviousPage = "#"
		      context.NextPage = "#"
		      
		    Else
		      // Multiple pages.
		      If currentPage = numListPages Then
		        // Last page of multiple pages.
		        prevNum = currentPage - 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(destination.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(destination.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = "#"
		        
		      ElseIf currentPage = 1 Then 
		        // First page of multiple pages.
		        context.PreviousPage = "#"
		        nextNum = currentPage + 1
		        context.NextPage = Permalink(destination.Child("page").Child(nextNum.ToString).Child("index.html"))
		        
		      Else
		        // Not the first or last of multiple pages.
		        prevNum = currentPage - 1
		        nextNum = currentPage + 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(destination.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(destination.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = Permalink(destination.Child("page").Child(nextNum.ToString).Child("index.html"))
		      End If
		    End If
		    
		    RenderListPage(rs, context, currentPage, template, destination)
		  Next currentPage
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E6465727320746865206C697374207061676528732920666F7220746865207370656369666965642073656374696F6E2061732048544D4C20746F20746865202F7075626C696320666F6C6465722E
		Private Sub RenderList(sectionFolder As FolderItem)
		  /// Renders the list page(s) for the specified section as HTML to the /public folder.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var buildDrafts As Boolean = Config.Lookup("buildDrafts", False)
		  
		  // Convert the passed section folder into a dot-delimited path (as stored in the database).
		  Var section As String = FolderAsSection(sectionFolder)
		  
		  // How many posts are in this section?
		  Var postCount As Integer = PostCountForSection(section)
		  If postCount = 0 Then
		    If sectionFolder.NativePath = Root.Child("content").NativePath Then
		      // No static home page defined and no posts within the content folder. 
		      // Need to list all posts.
		      RenderHomePageList
		    Else
		      Raise New Strike.Error("There is no content in `" + sectionFolder.NativePath + "`.")
		    End If
		  End If
		  
		  // Get a reference to the parent folder that will contain this section's list pages.
		  Var destination As FolderItem = PublicFolder
		  Var sections() As String = section.Split(".")
		  If sections.Count = 0 Then sections.Add("")
		  If sections(0) <> "" Then
		    For Each s As String In sections
		      destination = destination.Child(s)
		    Next s
		  End If
		  
		  If Not destination.Exists Then
		    Raise New Strike.Error("The destination for section `" + section + "` does not exist.")
		  End If
		  
		  // Get the "list.html" template file text to use to render this list page.
		  Var templateFile As FolderItem = GetTemplateListFile(section)
		  Var template As String = FileContents(templateFile)
		  
		  // As we know how many posts to list per page and we know how many posts there are, we can
		  // calculate how many list pages we need.
		  Var postsPerPage As Integer = Config.Lookup("postsPerPage", -1)
		  Var numListPages As Integer = If(postsPerPage = -1, 1, Ceiling(postCount / postsPerPage))
		  
		  // Construct any required pagination folders.
		  If numListPages > 1 Then
		    Var pageFolder As FolderItem = destination.Child("page")
		    pageFolder.CreateFolder
		    For a As Integer = 2 To numListPages
		      pageFolder.Child(a.ToString).CreateFolder
		    Next a
		  End If
		  
		  // Get all posts belonging to this section, ordered either by published date or alphabetically by title
		  // paginated and render them.
		  Var prevNum, nextNum As Integer
		  For currentPage As Integer = 1 To numListPages
		    Var rs As RowSet
		    Try
		      If AlphabeticalSections.IndexOf(section) <> - 1Then
		        rs = Database.SelectSQL(SQL.PostsForSectionOrderedAlphabetically(section, postsPerPage, currentPage, buildDrafts))
		      Else
		        rs = Database.SelectSQL(SQL.PostsForSection(section, postsPerPage, currentPage, buildDrafts))
		      End If
		      If rs = Nil Then Raise New Strike.Error("Unexpected RowSet = Nil.")
		    Catch e As DatabaseException
		      Raise New Strike.Error("Unable to get posts for section `" + section + "` from the database: " + e.Message)
		    End Try
		    
		    // Create the context for this list page.
		    Var context As New Strike.ListContext
		    If numListPages = 1 Then
		      // Only one page.
		      context.PreviousPage = "#"
		      context.NextPage = "#"
		      
		    Else
		      // Multiple pages.
		      If currentPage = numListPages Then
		        // Last page of multiple pages.
		        prevNum = currentPage - 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(destination.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(destination.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = "#"
		        
		      ElseIf currentPage = 1 Then
		        // First page of multiple pages.
		        context.PreviousPage = "#"
		        nextNum = currentPage + 1
		        context.NextPage = Permalink(destination.Child("page").Child(nextNum.ToString).Child("index.html"))
		        
		      Else
		        // Not the first or last of multiple pages.
		        prevNum = currentPage - 1
		        nextNum = currentPage + 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(destination.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(destination.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = Permalink(destination.Child("page").Child(nextNum.ToString).Child("index.html"))
		      End If
		    End If
		    
		    RenderListPage(rs, context, currentPage, template, destination)
		  Next currentPage
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B6573206120526F77536574206F6620706F7374732066726F6D206F757220646174616261736520746861742073686F756C642062652072656E64657265642061732061206C69737420706167652E2060706167654E756D62657260206973207468652070616765206E756D62657220666F72207468697320636F6C6C656374696F6E206F6620706F73747320616E642060746F74616C4E756D5061676573602069732074686520746F74616C206E756D626572206F662070616765732074686174206D616B6520757020746869732073656374696F6E2773206C6973742E20452E673A206966207765206861766520313020706F73747320696E20612073656374696F6E20616E642077652061726520646973706C6179696E67203320706F737473207065722070616765207468656E2060746F74616C4E756D50616765736020776F756C64206265203420286173207765206E65656420342070616765733A20312F322F332C20342F352F362C20372F382F3920616E642031302920417373756D65732074686174205265636F7264536574206973206E6F74204E696C2E206074656D706C6174656020697320746865207465787420636F6E74656E7473206F662074686520226C6973742E68746D6C222066696C6520746F2075736520746F2072656E646572207468697320706167652028616C736F20617373756D6564206E6F74204E696C292E
		Private Sub RenderListPage(rs As RowSet, context As Strike.ListContext, pageNumber As Integer, template As String, enclosingFolder As FolderItem)
		  /// Takes a RowSet of posts from our database that should be rendered as a list page.
		  ///
		  /// `pageNumber` is the page number for this collection of posts and `totalNumPages` is the total
		  /// number of pages that make up this section's list.
		  /// E.g: if we have 10 posts in a section and we are displaying 3 posts per page then `totalNumPages`
		  /// would be 4 (as we need 4 pages: 1/2/3, 4/5/6, 7/8/9 and 10)
		  /// Assumes that RecordSet is not Nil.
		  /// `template` is the text contents of the "list.html" file to use to render this page (also assumed not Nil).
		  ///
		  /// `enclosingFolder` is the folder in the built site that contains the list index and page subfolders
		  /// E.g: If there are 3 list pages for blog/personal then `enclosingFolder` will be set to /public/blog/personal
		  /// and we have the following structure:
		  /// /public/blog/personal
		  ///   index.html      <-- page 1 list contents
		  ///   page/2/index.html
		  ///   page/3/index.html
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  /// Get a reference to the file on disk where we'll store the finished page.
		  Var pageFile As FolderItem
		  If pageNumber = 1 Then
		    pageFile = enclosingFolder.Child("index.html")
		  Else
		    pageFile = enclosingFolder.Child("page").Child(pageNumber.ToString).Child("index.html")
		  End If
		  
		  // Convert this RowSet to an array of posts.
		  Var post, posts() As Strike.Post
		  Try
		    For Each row As DatabaseRow In rs
		      post = PostFromDatabaseRow(row)
		      posts.Add(post)
		    Next row
		  Catch e As RuntimeException
		    Raise New Strike.Error("An error occured whilst trying to convert a DatabaseRow to " + _
		    "a Post instance.")
		  End Try
		  
		  Var result As String = template
		  
		  // Check there is is actually content in this template file.
		  // Otherwise write an empty file.
		  If result = "" Then
		    WriteToFile(pageFile, "")
		    Return
		  End If
		  
		  // Resolve any for each loops.
		  // These are blocks of templating code that need to be run for each post in posts().
		  // Syntax:
		  //  {{foreach}}
		  //    Any valid templating code
		  //  {{endeach}}
		  Var rg As New RegEx
		  rg.SearchPattern = "{{foreach}}[\s\S]*?{{endeach}}"
		  
		  Var match As RegExMatch
		  Var rawLoop, resolvedLoop As String
		  Do
		    match = rg.Search(result)
		    If match <> Nil Then
		      // Found a loop. 
		      rawLoop = match.SubExpressionString(0)
		      
		      // Store the character position of the start of this loop.
		      Var startIndex As Integer = result.LeftBytes(match.SubExpressionStartB(0)).Length
		      
		      // Remove the {{foreach}} and {{endeach}} to get the loop contents.
		      Var loopContents As String = rawLoop.Replace("{{foreach}}", "").Trim
		      loopContents = loopContents.Left(loopContents.Length - 11).Trim // 11 = {{endeach}}
		      
		      // For each post, we need to resolve the tags in loopContents.
		      For Each post In posts
		        
		        Var pageLoop As String = loopContents
		        
		        pageLoop = ResolveTags(pageLoop, post, context)
		        
		        resolvedLoop = resolvedLoop + pageLoop
		        
		      Next post
		      
		      // Insert the resolved loop at the start index of the rawLoop.
		      result = result.Insert(resolvedLoop, startIndex)
		    End If
		    
		    // Remove this raw loop.
		    Try
		      result = result.Replace(rawLoop, "")
		    Catch
		      // Ignore.
		    End Try
		    
		  Loop Until match = Nil
		  
		  result = ResolveTags(result, post, context)
		  
		  // Is there anything to inject in the <head>?
		  If Config.Lookup("injectHead", "") <> "" Then
		    result = InjectHead(result)
		  End If
		  
		  // Is there anything to inject at the end of <body>?
		  If Config.Lookup("injectBody", "") <> "" Then
		    result = InjectBody(result)
		  End If
		  
		  result = result.Trim
		  
		  // Write the result to disk.
		  WriteToFile(pageFile, result.Trim)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E6465727320616E20696E646976696475616C20706F73742061732048544D4C20746F2074686520602F7075626C69636020666F6C6465722E
		Private Sub RenderPost(p As Strike.Post, postType As Strike.PostTypes)
		  /// Renders an individual post as HTML to the `/public` folder.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Get the correct template to use to render this post.
		  Var templateFile As FolderItem
		  
		  Select Case postType
		  Case PostTypes.Page
		    // Get the "page.html" template file text to use to render this post.
		    templateFile = GetTemplateFile(p, Strike.PostTypes.Page)
		    
		  Case PostTypes.Post
		    // Get the "post.html" template file text to use to render this post.
		    templateFile = GetTemplateFile(p, Strike.PostTypes.Post)
		    
		  Case PostTypes.Homepage
		    // Get the "home.html" template file text to use to render the homepage.
		    templateFile = theme.Child("layouts").Child("home.html")
		    
		  Else
		    Raise New Strike.Error("Unknown post type.")
		  End Select
		  
		  Var result As String = FileContents(templateFile)
		  
		  // If there is no content in the template file then we just write an empty file.
		  If result = "" Then
		    WriteToFile(OutputPathForPost(p), "")
		    Return
		  End If
		  
		  result = ResolveTags(result, p)
		  
		  // Is there anything to inject in the <head>?
		  If Config.Lookup("injectHead", "") <> "" Then
		    result = InjectHead(result)
		  End If
		  
		  // Is there anything to inject at the end of <body>?
		  If Config.Lookup("injectBody", "") <> "" Then
		    result = InjectBody(result)
		  End If
		  
		  result = result.Trim
		  
		  // Write the contents to disk.
		  WriteToFile(OutputPathForPost(p), result.Trim)
		  
		  // Add this post to our RSS items array (if desired).
		  If postType = PostTypes.Post And Config.Lookup("rss", False) And _ 
		    mRSSExcludedSections.IndexOf(p.Section) = -1 Then
		    RSSItems.Add(New Strike.RSSItem(p.Title, p.URL, p.Date, p.FirstParagraphStripped))
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E646572732074686520706F73747320696E207468652073697465277320646174616261736520746F2048544D4C207573696E67207468652063757272656E74207468656D652E
		Private Sub RenderPosts()
		  /// Renders the posts in the site's database to HTML using the current theme.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var rs As RowSet
		  
		  // Get the posts as a RowSet.
		  If Config.Lookup("buildDrafts", False) Then
		    Try
		      rs = Database.SelectSQL("SELECT * FROM posts WHERE verified=1 AND date <= " + SecondsFrom1970.ToString("####################") + ";")
		    Catch e As DatabaseException
		      Raise New Strike.Error("Database error selecting all verified posts.")
		    End Try
		  Else
		    Try
		      Var sql As String = "SELECT * FROM posts WHERE verified=1 AND isDraft=0 AND date <= " + SecondsFrom1970.ToString("####################") + ";"
		      rs = Database.SelectSQL(sql)
		    Catch e As DatabaseException
		      Raise New Strike.Error("Database error selecting all non-draft verified posts.")
		    End Try
		  End If
		  
		  If rs.RowCount = 0 Then Return // No posts to render.
		  
		  For Each row As DatabaseRow In rs
		    Var p As Strike.Post = PostFromDatabaseRow(row)
		    If p.IsHomepage Then
		      RenderPost(p, PostTypes.Homepage)
		    ElseIf p.IsPage Then
		      RenderPost(p, PostTypes.Page)
		    Else
		      RenderPost(p, PostTypes.Post)
		    End If
		  Next row
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656E646572732074686520746167206C6973742066696C65732F666F6C6465727320666F722074686520706173736564207461672E
		Private Sub RenderTag(tagName As String, tagFolder As FolderItem)
		  /// Renders the tag list files/folders for the passed tag.
		  ///
		  /// `tagFolder` is the parent folder for this tag
		  /// E.g: the 'happy' tag parent folder is: `baseURL/tag/happy/`
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // How many posts have this tag?
		  Var rs As RowSet
		  Try
		    rs = Database.SelectSQL(SQL.PostCountForTag(tagName))
		  Catch e As DatabaseException
		    Raise New Strike.Error("Unable to get the post count for tag `" + tagName + "` from the database.")
		  End Try
		  
		  If rs = Nil Then
		    Raise New Strike.Error("Unexpected Nil RowSet.")
		  End If
		  Var postCount As Integer = rs.Column("total").IntegerValue
		  
		  // Get the "tags.html" template file text to use to render the tag list page(s).
		  Var templateFile As FolderItem = theme.Child("layouts").Child("tags.html")
		  If Not templateFile.Exists Then
		    Raise New Strike.Error("The `tags.html` template file is missing.")
		  End If
		  Var template As String = FileContents(templateFile)
		  
		  // As we know how many posts to list per page and we know how many posts there are, we can
		  // calculate how many list pages we need.
		  Var postsPerPage As Integer = Config.Lookup("postsPerPage", -1)
		  Var numListPages As Integer = If(postsPerPage = -1, 1, Ceiling(postCount / postsPerPage))
		  
		  // Construct any required pagination folders.
		  If numListPages > 1 Then
		    Var pageFolder As FolderItem = tagFolder.Child("page")
		    pageFolder.CreateFolder
		    For a As Integer = 2 To numListPages
		      pageFolder.Child(a.ToString).CreateFolder
		    Next a
		  End If
		  
		  // Get all posts with this tag, ordered by published date, paginated and render them.
		  Var prevNum, nextNum As Integer
		  For currentPage As Integer = 1 To numListPages
		    Try
		      rs = Database.SelectSQL(SQL.PostsForTag(tagName, postsPerPage, currentPage))
		    Catch e As DatabaseException
		      Raise New Strike.Error("Unable to retrieve the posts tagged with `" + tagName + "` from the database: " + e.Message)
		    End Try
		    
		    // Create the context for this list page.
		    Var context As New Strike.ListContext
		    If numListPages = 1 Then
		      // Only one page.
		      context.PreviousPage = "#"
		      context.NextPage = "#"
		    Else
		      // Multiple pages.
		      If currentPage = numListPages Then
		        // Last page of multiple pages.
		        prevNum = currentPage - 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(tagFolder.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(tagFolder.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = "#"
		      ElseIf currentPage = 1 Then
		        // First page of multiple pages.
		        context.PreviousPage = "#"
		        nextNum = currentPage + 1
		        context.NextPage = Permalink(tagFolder.Child("page").Child(nextNum.ToString).Child("index.html"))
		      Else
		        // Not the first or last of multiple pages.
		        prevNum = currentPage - 1
		        nextNum = currentPage + 1
		        If prevNum = 1 Then
		          context.PreviousPage = Permalink(tagFolder.Child("index.html"))
		        Else
		          context.PreviousPage = Permalink(tagFolder.Child("page").Child(prevNum.ToString).Child("index.html"))
		        End If
		        context.NextPage = Permalink(tagFolder.Child("page").Child(nextNum.ToString).Child("index.html"))
		      End If
		    End If
		    context.tag = tagName
		    
		    RenderListPage(rs, context, currentPage, template, tagFolder)
		  Next currentPage
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54616B657320612060746167602066726F6D20612074656D706C6174652066696C6520696E2074686520666F726D20607B7B736F6D657468696E677D7D6020616E64207265736F6C76657320697420746F206120737472696E672076616C75652E20417373756D657320607461676020697320666C616E6B6564207769746820607B7B7D7D602E204D617920726169736520612060537472696B652E4572726F72602E
		Private Function ResolveTag(tag As String, post As Strike.Post = Nil, listContext As Strike.ListContext = Nil) As String
		  /// Takes a `tag` from a template file in the form `{{something}}` and resolves it to
		  /// a string value. Returns an empty string if the tag is unknown.
		  /// Assumes `tag` is flanked with `{{}}`.
		  /// May raise a `Strike.Error`.
		  ///
		  /// If this is a list page then a ListContext will be passed in.
		  /// A Post instance will be passed in for all posts and pages except the homepage.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Remove the starting `{{` and trailing `}}`.
		  tag = tag.Right(tag.Length - 2)
		  tag = tag.Left(tag.Length - 2)
		  
		  // ------------------------------------------------------
		  // {{partial FILE-NAME}}
		  // ------------------------------------------------------
		  Var partialName As String
		  If tag.Length >= 7 And tag.Left(7) = "partial" Then
		    // Get the name of the partial file to include.
		    partialName = tag.Replace("partial", "").Trim
		    
		    // Does this file exist in the current theme?
		    // If so, return the contents of the partial template otherwise raise an error.
		    Try
		      Var partialFile As FolderItem = theme.Child("layouts").Child("partials").Child(partialName + ".html")
		      // We need to recursively resolve any tags that might be in this partial template file too.
		      Return ResolveTags(FileContents(partialFile))
		    Catch
		      Raise New Strike.Error ("Cannot locate the partial template file `" + partialName + "`.")
		    End Try
		  End If
		  
		  // ------------------------------------------------------
		  // {{assets}}
		  // ------------------------------------------------------
		  If tag = "assets" Then
		    Return SpecialURL("assets")
		  End If
		  
		  // ------------------------------------------------------
		  // {{storage}}
		  // ------------------------------------------------------
		  If tag = "storage" Then
		    Return SpecialURL("storage")
		  End If
		  
		  // ------------------------------------------------------
		  // {{navigation}}
		  // ------------------------------------------------------
		  If tag = "navigation" Then
		    Return SiteNavigationHTML
		  End If
		  
		  // ------------------------------------------------------
		  // RSS feed tag?
		  // {{feedURL}}
		  // ------------------------------------------------------
		  If tag = "feedURL" Then
		    Return Config.Lookup("baseURL", "/") + "rss.xml"
		  End If
		  
		  // ------------------------------------------------------
		  // Site data?
		  // {{site.VALUE}}
		  // ------------------------------------------------------
		  If tag.Length >= 5 And tag.Left(5) = "site." Then
		    Return SiteTag(tag.Replace("site.", ""))
		  End If
		  
		  // ------------------------------------------------------
		  // Helper tag?
		  // {{helper.VALUE}}
		  // ------------------------------------------------------
		  If tag.Length >= 7 And tag.Left(7) = "helper." Then
		    Return HelperTag(tag.Replace("helper.", ""))
		  End If
		  
		  // ------------------------------------------------------
		  // Strike tag?
		  //  {{strike.VALUE}}
		  // ------------------------------------------------------
		  If tag.Length >= 7 And tag.Left(7) = "strike." Then
		    Return StrikeTag(tag.Replace("strike.", ""))
		  End If
		  
		  // ------------------------------------------------------
		  // Archives tag?
		  // {{archives.VALUE}}
		  // ------------------------------------------------------
		  If tag = "archives.months" Then Return ArchiveMonthsHTML
		  If tag = "archives.longMonths" Then Return ArchiveLongMonthsHTML
		  If tag = "archives.url" Then Return Permalink(PublicFolder.Child("archive.html"))
		  
		  // ------------------------------------------------------
		  // List-specific tags
		  // ------------------------------------------------------
		  If listContext <> Nil Then
		    // {{list.VALUE}}
		    If tag.Length >= 5 And tag.Left(5) = "list." Then
		      tag = tag.Replace("list.", "")
		      
		      Select Case tag
		      Case "tag"
		        Return listContext.Tag
		        
		      Case "archiveDateRange"
		        Return listContext.ArchiveDateRange
		        
		      Case "archiveYear"
		        If listContext.ArchiveYear > -1 Then
		          Return listContext.ArchiveYear.ToString
		        Else
		          Return ""
		        End If
		        
		      Case "archiveMonth"
		        If listContext.ArchiveMonth > -1 Then
		          Return MonthToString(listContext.ArchiveMonth)
		        Else
		          Return ""
		        End If
		        
		      Case "archiveDay"
		        If listContext.ArchiveDay > -1 Then
		          Return listContext.ArchiveDay.ToString
		        Else
		          Return ""
		        End If
		        
		      Case "nextPage"
		        Return listContext.NextPage
		        
		      Case "previousPage"
		        Return listContext.PreviousPage
		        
		      Else
		        Raise New Strike.Error ("Unknown list tag `{{list." + tag + "}}`.")
		      End Select
		    End If
		  End If
		  
		  // ------------------------------------------------------
		  // Post-specific tags posts
		  // ------------------------------------------------------
		  If post <> Nil Then
		    
		    If tag = "nextPost" Then Return NextPost(post)
		    If tag = "previousPost" Then Return PreviousPost(post)
		    
		    If tag = "content" Then Return post.RenderedMarkdown
		    
		    If tag = "date" Then Return post.Date.ToString
		    
		    If tag = "date.second" Then
		      Return If(post.Date.Second < 10, "0" + post.Date.Second.ToString, post.Date.Second.ToString)
		    End If
		    
		    If tag = "date.minute" Then
		      Return If(post.Date.Minute < 10, "0" + post.Date.Minute.ToString, post.Date.Minute.ToString)
		    End If
		    
		    If tag = "date.hour" Then
		      Return If(post.Date.Hour < 10, "0" + post.Date.Hour.ToString, post.Date.Hour.ToString)
		    End If
		    
		    If tag = "date.day" Then Return post.Date.Day.ToString
		    
		    If tag = "date.month" Then Return post.Date.Month.ToString
		    
		    If tag = "date.longMonth" Then Return post.Date.LongMonth
		    
		    If tag = "date.shortMonth" Then Return post.Date.ShortMonth
		    
		    If tag = "date.year" Then Return post.Date.Year.ToString
		    
		    If tag = "date.shortYear" Then Return ShortYear(post.Date.Year.ToString)
		    
		    If tag = "firstParagraph" Then Return post.FirstParagraph
		    
		    If tag = "permalink" Then Return post.URL
		    
		    If tag = "readingTime" Then Return Strike.MinutesToRead(post.RenderedMarkdown)
		    
		    If tag = "summary" Then Return post.Summary
		    
		    If tag = "tags" Then Return TagsAsHTML(post)
		    
		    If tag = "title" Then Return post.Title
		    
		    If tag = "wordCount" Then Return Strike.WordCount(post.RenderedMarkdown).ToString
		    
		    // ------------------------------------------------------
		    // Post data?
		    // ------------------------------------------------------
		    If post.Data <> Nil And post.Data.HasKey("tag") Then
		      Return post.Data.Value("tag")
		    End If
		    
		  End If
		  
		  // Unknown tag, just return an empty string.
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ResolveTags(s As String, p As Strike.Post = Nil, context As Strike.ListContext = Nil) As String
		  // Find the template tags within `s`.
		  Var rg As New RegEx
		  rg.SearchPattern = "{{\s*[^}]+\s*}}"
		  
		  // Analyse each one and replace.
		  Var match As RegExMatch
		  Var searchStart As Integer = 0
		  Do
		    match = rg.Search(s, searchStart)
		    If match <> Nil Then
		      // Get the {{tag}}.
		      Var tag As String = match.SubExpressionString(0)
		      
		      // Store the character position of the start of this tag.
		      Var tagStart As Integer = s.LeftBytes(match.SubExpressionStartB(0)).Length
		      
		      // Resolve the tag.
		      Var resolvedTag As String = ResolveTag(tag, p, context)
		      
		      // Replace the original {{tag}} with resolvedTag. It'll be the first occurrence in the string.
		      s = s.Replace(tagStart, tag.Length, resolvedTag, Config.Lookup("extendedUnicodeSupport", False))
		      
		      // Since the string we're searching has changed (we've added in the contents of the
		      // resolved tag) we need to adjust where we start searching from.
		      searchStart = tagStart + resolvedTag.Length
		    End If
		  Loop Until match = Nil
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 537472696B6520616C6C6F7773207468652072756E6E696E67206F6620637573746F6D20586F6A6F5363726970747320616674657220746865206275696C6420686173206265656E20636F6D706C657465642E2054686573652073637269707473206D75737420626520696E207468652073697465277320602F736372697074736020666F6C64657220616E6420686176652074686520657874656E73696F6E2060786F6A6F5F736372697074602E
		Private Sub RunScripts()
		  /// Strike allows the running of custom XojoScripts after the build has been completed.
		  /// These scripts must be in the site's `/scripts` folder and have the extension `xojo_script`.
		  
		  // Scripts are optional so check there is a folder containing some.
		  Var scriptsFolder As FolderItem = Root.Child("scripts")
		  If Not scriptsFolder.Exists Then Return
		  
		  // Collate all the .xojo_script files in this folder.
		  Var scripts() As FolderItem
		  For Each f As FolderItem In scriptsFolder.Children
		    If f.IsFolder = False And f.Name.EndsWith(".xojo_script") Then
		      scripts.Add(f)
		    End If
		  Next f
		  
		  If scripts.Count = 0 Then Return
		  
		  // Run each script.
		  Var context As New ScriptContext(Root, Theme)
		  Var script As StrikeXojoScript
		  For Each scriptFile As FolderItem In scripts
		    script = New StrikeXojoScript(scriptFile, context)
		    
		    Try
		      script.Run
		    Catch e As RuntimeException
		      Raise New Strike.Error("An error occurred whilst running the `" + _
		      scriptFile.NativePath + "` script. " + e.Message)
		    End Try
		  Next scriptFile
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652073656374696F6E20666F72206120676976656E20706F73742E204D617920726169736520612060537472696B652E4572726F72602E
		Private Function SectionForPost(post As Strike.Post) As String
		  /// Returns the section for a given post.
		  /// May raise a `Strike.Error`.
		  ///
		  /// The section is a dot-delimited string value representing where in the /content hierarchy this post is.
		  /// E.g:
		  /// www.example.com/blog/first-post.html           section = blog
		  /// www.example.com/blog/personal/test.html        section = blog.personal
		  /// www.example.com/about                          section = about
		  /// www.example.com/about/index.html               section = about
		  ///
		  /// The passed post **must** already have its URL correctly set.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var section As String
		  
		  // post.URL is in the format: `BaseURL/section1/section[N]/fileName.html`.
		  Try
		    section = post.URL.Replace(Config.Lookup("baseURL", "/"), "")
		    section = section.Replace(post.Slug + ".html", "")
		    section = section.ReplaceAll("/", ".").Trim
		    If section = "" Then Return ""
		    If section.Left(1) = "." Then section = section.Right(section.Length - 1)
		    If section.Right(1) = "." Then section = section.Left(section.Length - 1)
		  Catch
		    Raise New Strike.Error("Unable to determine post section for `" + _
		    post.File.NativePath + "`.")
		  End Try
		  
		  Return section
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206C6173742074776F20646967697473206F6620746865207061737365642034206469676974207965617220737472696E672E
		Private Function ShortYear(year As String) As String
		  /// Returns the last two digits of the passed 4 digit year string.
		  
		  Return year.Right(2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E756D626572206F6620706F73747320696E2074686520736974652E
		Private Function SitePostCount() As Integer
		  /// Returns the number of posts in the site.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var rs As RowSet
		  
		  Try
		    If Config.Lookup("buildDrafts", False) Then
		      rs = Database.SelectSQL("SELECT COUNT(*) FROM posts WHERE isPage=0;")
		    Else
		      rs = Database.SelectSQL("SELECT COUNT(*) FROM posts WHERE isPage=0 AND isDraft=0;")
		    End If
		  Catch e As DatabaseException
		    Raise New Strike.Error("Error selecting posts from the database: " + e.Message)
		  End Try
		  
		  If rs = Nil Or rs.RowCount = 0 Then
		    Return 0
		  Else
		    Return rs.Column("COUNT(*)").IntegerValue
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652072657175657374656420736974652064617461206173206120737472696E672E
		Private Function SiteTag(name as String) As String
		  /// Returns the requested site data as a string.
		  ///
		  /// The value of any variable in the site’s `config.toml` file can be retrieved from any 
		  /// template file with the tag `{{site.VARIABLE_NAME}}`, this includes user-defined variables. 
		  /// This is the prefered method to set global data values.
		  ///
		  /// For example, to get the base URL of the entire site from within a template file, simply use 
		  /// the tag `{{site.baseURL}}`.
		  /// 
		  /// Returns an empty string if the value is missing.
		  
		  Return config.Lookup(name, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520726571756573746564207370656369616C2055524C2E20537472696B65206861732061206E756D626572206F66207370656369616C2055524C732073756368206173207468656D65206173736574732C2052535320666565642C2061726368697665732C206574632E204D617920726169736520616E20657863657074696F6E20696620746865207370656369616C2055524C20697320756E6B6E6F776E2E
		Private Function SpecialURL(name As String) As String
		  /// Returns the requested special URL.
		  /// Strike has a number of special URLs such as theme assets, RSS feed, archives, etc.
		  /// May raise an exception if the special URL is unknown.
		  
		  Select Case name
		  Case "assets"
		    Return Config.Lookup("baseURL", "/") + "assets"
		    
		  Case "storage"
		    Return Config.Lookup("baseURL", "/") + "storage"
		    
		  Else
		    Raise New Strike.Error("Unknown special URL `" + name + "`.")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 537472696B652070726F76696465732061206E756D626572206F662067656E657261746F722D737065636966696320746167732E2052657475726E73207468652076616C756520666F722074686520706173736564206E616D6564207461672E20526169736573206120537472696B652E4572726F72206966207468657265206973206E6F20537472696B652074616720776974682074686520726571756573746564206E616D652E
		Private Function StrikeTag(name As String) As String
		  /// Strike provides a number of generator-specific tags. Returns the value for the
		  /// passed named tag.
		  /// Raises a Strike.Error if there is no Strike tag with the requested name.
		  ///
		  /// {{strike.generator}}:
		  ///        Meta tag For the version of Strike that built the site.
		  ///        Example output: <meta name="generator" content="Strike 1.0.0" />
		  ///
		  /// {{strike.version}}: Strike’s version number
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Const QUOTE = """"
		  
		  Select Case name
		  Case "generator"
		    Return "<meta name=" + QUOTE + "generator" + QUOTE + " content=" + QUOTE + "Strike " + _
		    Version.ToString + QUOTE + "/>"
		    
		  Case "version"
		    Return Version.ToString
		    
		  Else
		    Raise New Strike.Error("Unknown strike tag '{{strike." + name + "}}'")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652070617373656420706F73742773207461677320617320616E20756E6F7264657265642048544D4C206C6973742E20496620746865726520617265206E6F2074616773207468656E20616E20656D707479206C6973742069732072657475726E65642E
		Function TagsAsHTML(p As Strike.Post) As String
		  /// Returns the passed post's tags as an unordered HTML list.
		  /// If there are no tags then an empty list is returned.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Const QUOTE = """"
		  
		  If p.Tags.Count = 0 Then Return ""
		  
		  Var html As String = "<ul class=" + QUOTE + "tags" + QUOTE + ">"
		  
		  For Each tag As String In p.Tags
		    html = html + "<li><a href=" + QUOTE + Permalink(PublicFolder.Child("tag").Child(tag)) + _
		    QUOTE + ">" + tag + "</a></li>"
		  Next tag
		  
		  Return html + "</ul>"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 44657465726D696E657320746865207075626C69632055524C20666F7220746865207061737365642066696C652E
		Private Function URLForFile(file As FolderItem, slug As String) As String
		  /// Determines the public URL for the passed file.
		  ///
		  /// E.g. if the file's path = content/about/index.md then url = baseURL/about/index.html
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Var content As FolderItem = Root.Child("content")
		  Var item As FolderItem = file.Parent
		  
		  Var url As String
		  Do Until item.NativePath = content.NativePath
		    
		    If url = "" Then
		      url = Slugify(item.Name) + url
		    Else
		      url = item.Name + "/" + url
		    End If
		    
		    item = item.Parent
		    
		  Loop
		  
		  Return Config.Lookup("baseURL", "/") + url + If(url = "", "", "/") + slug + ".html"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 577269746573207468652070617373656420737472696E6720746F20746865207370656369666965642066696C652E204D617920726169736520616E20494F457863657074696F6E2E
		Private Sub WriteToFile(file As FolderItem, contents As String)
		  /// Writes the passed string to the specified file.
		  /// May raise an IOException.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  Try
		    Var tout As TextOutputStream = TextOutputStream.Create(file)
		    tout.Write(contents)
		    tout.Close
		  Catch
		    Raise New Strike.Error ("Unable to write to `" + file.NativePath + "`.")
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E76656E69656E6365206D6574686F6420666F7220616464696E6720612074657874206E6F646520746F207468652073706563696669656420706172656E74206E6F64652E
		Private Function XmlNodeWithText(ByRef xml As XmlDocument, ByRef parentNode As XmlNode, nodeTitle As String, textToAdd As String) As XmlNode
		  /// Convenience method for adding a text node to the specified parent node.
		  
		  #Pragma DisableBackgroundTasks
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  If xml = Nil Or parentNode = Nil Then Return Nil
		  
		  Var node As XMLNode = parentNode.AppendChild(xml.CreateElement(nodeTitle))
		  Var textNode As XMLTextNode = xml.CreateTextNode(nodeTitle)
		  textNode.Value = textToAdd
		  node.AppendChild(textNode)
		  
		  Return node
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This class manages the building of a single site.
		
	#tag EndNote


	#tag Property, Flags = &h21, Description = 53656374696F6E7320746861742073686F756C64206265206C697374656420616C7068616265746963616C6C7920726174686572207468616E206279207075626C69636174696F6E20646174652E204D617920626520656D7074792E
		Private AlphabeticalSections() As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4120756E6F7264657265642048544D4C206C697374206F6620746865206172636869766573206279206C6F6E67206D6F6E7468202D2067656E65726174656420627920604275696C6441726368697665732829602E
		Private ArchiveLongMonthsHTML As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4120756E6F7264657265642048544D4C206C697374206F66207468652061726368697665732062792073686F7274206D6F6E7468202D2067656E65726174656420627920604275696C6441726368697665732829602E
		Private ArchiveMonthsHTML As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Computed within `BuildArchives()` and used to generate the archives <ul> HTML.
		#tag EndNote
		Private ArchiveTree() As Strike.ArchiveYear
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21, Description = 54686520626173652055524C20666F722074686520736974652E205265747269657665642066726F6D207468652073697465277320636F6E6669672064696374696F6E6172792E
		#tag Getter
			Get
			  Return Config.Lookup("baseURL", "/")
			  
			End Get
		#tag EndGetter
		Private BaseURL As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 546869732073697465277320636F6E66696775726174696F6E2E
		Private Config As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652053514C69746520646174616261736520666F72207468697320736974652E
		Private Database As SQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652053514C6974652064617461626173652066696C652E
		Private DatabaseFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F6620746865207468656D6520746F20757365207768656E206372656174696E672061206E657720736974652E
		Shared DefaultTheme As String = "skeleton"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRSSExcludedSections() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520736974652773207075626C696320666F6C6465722E2054686973206973207468652064657374696E6174696F6E20746861742074686520736974652077696C6C206265207772697474656E20746F2E
		PublicFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652073697465277320726F6F7420666F6C6465722E
		Root As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RSSItems() As Strike.RSSItem
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41206361636865642048544D4C2076657273696F6E206F662074686520736974652773206D61696E206E617669676174696F6E2E
		Private SiteNavigationHTML As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652073697465206E617669676174696F6E207472656520726F6F742E
		Private SiteNavTree As Strike.NavigationItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652063757272656E74207468656D6520746F207573652E
		#tag Getter
			Get
			  Return Root.Child("themes").Child(Config.Lookup("theme", DefaultTheme))
			  
			End Get
		#tag EndGetter
		Theme As FolderItem
	#tag EndComputedProperty


	#tag Constant, Name = SCHEMA, Type = String, Dynamic = False, Default = \"\n\nCREATE TABLE \"post_tag\" (\n\"id\" INTEGER UNIQUE PRIMARY KEY\x2C\n\"posts_id\" INTEGER NOT NULL\x2C\n\"tags_id\" INTEGER NOT NULL\n);\n\n\nCREATE TABLE \"posts\" (\n\"id\" INTEGER PRIMARY KEY UNIQUE\x2C\n\"date\" INTEGER NOT NULL\x2C\n\"dateDay\" INTEGER NOT NULL\x2C\n\"dateMonth\" INTEGER NOT NULL\x2C\n\"dateYear\" INTEGER NOT NULL\x2C\n\"filePath\" TEXT NOT NULL\x2C\n\"hash\" TEXT NOT NULL\x2C\n\"isDraft\" INTEGER NOT NULL DEFAULT 0\x2C\n\"isHomepage\" INTEGER DEFAULT 0 NOT NULL\x2C\n\"isPage\" INTEGER NOT NULL DEFAULT 0\x2C\n\"lastUpdated\" TEXT NOT NULL\x2C\n\"markdown\" TEXT\x2C\n\"renderedMarkdown\" TEXT\x2C\n\"section\" TEXT NOT NULL\x2C\n\"slug\" TEXT NOT NULL\x2C\n\"title\" TEXT NOT NULL\x2C\n\"toml\" TEXT\x2C\n\"url\" TEXT NOT NULL\x2C\n\"verified\" INTEGER DEFAULT 0 NOT NULL\x2C\n\"firstParagraph\" TEXT\x2C\n\"firstParagraphStripped\" TEXT\n);\n\n\nCREATE TABLE \"tags\" (\n\"id\" INTEGER PRIMARY KEY UNIQUE\x2C\n\"name\" TEXT NOT NULL UNIQUE\n);\n", Scope = Private, Description = 5468652053514C20726571756972656420746F2063726561746520746865207369746527732064617461626173652E
	#tag EndConstant


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
