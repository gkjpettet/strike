#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyFilesLinux
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 2
					Subdirectory = 
					FolderItem = Li4vLi4vcmVzb3VyY2VzL3RoZW1lcy9za2VsZXRvbi8=
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyFilesMac
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 2
					Subdirectory = 
					FolderItem = Li4vLi4vcmVzb3VyY2VzL3RoZW1lcy9za2VsZXRvbi8=
				End
				Begin SignProjectStep Sign
				  DeveloperID=HFY9BS9SXH
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyFilesWindows
					AppliesTo = 0
					Architecture = 0
					Target = 0
					Destination = 2
					Subdirectory = 
					FolderItem = Li4vLi4vcmVzb3VyY2VzL3RoZW1lcy9za2VsZXRvbi8=
				End
			End
#tag EndBuildAutomation
