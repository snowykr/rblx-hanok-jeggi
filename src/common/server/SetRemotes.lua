local SetRemotes = {}

function SetRemotes.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

	if not Remotes then
		Remotes = Instance.new("Folder")
		Remotes.Name = "Remotes"
		Remotes.Parent = ReplicatedStorage
	end

	-- 리모트 생성 함수
	local function newRemotes(remoteType, name, parentName)
		local parentFolder = Remotes:FindFirstChild(parentName)
		if not parentFolder then
			parentFolder = Instance.new("Folder")
			parentFolder.Name = parentName
			parentFolder.Parent = Remotes
		end

		local newRemote
		if remoteType == "RemoteEvent" then
			newRemote = Instance.new("RemoteEvent")
		elseif remoteType == "RemoteFunction" then
			newRemote = Instance.new("RemoteFunction")
		else
			error("잘못된 remoteType: " .. remoteType)
		end

		newRemote.Name = name
		newRemote.Parent = parentFolder
	end

	function SetRemotes.createRemotes()
		-- Common
		newRemotes("RemoteEvent", "NotifyEvent", "Notify")
		newRemotes("RemoteEvent", "LogEvent", "Log")
		newRemotes("RemoteEvent", "RequestAuth", "Role")
		newRemotes("RemoteEvent", "AuthResult", "Role")

		-- Teacher
		newRemotes("RemoteEvent", "StartSuspectGame", "Teacher")
		newRemotes("RemoteEvent", "ShowNote", "Teacher")
		newRemotes("RemoteEvent", "TeacherDataUpdate", "Teacher")

		-- Student
		newRemotes("RemoteEvent", "ShowUI", "Student")
		newRemotes("RemoteEvent", "UpdateGameData", "Student")
		newRemotes("RemoteEvent", "DecideButton", "Student")
		newRemotes("RemoteEvent", "RetryEvent", "Student")
		newRemotes("RemoteEvent", "HatButton", "Student")
		newRemotes("RemoteEvent", "PocketButton", "Student")
		newRemotes("RemoteEvent", "ShoesButton", "Student")
		newRemotes("RemoteEvent", "PartSelectionEvent", "Student")

		-- Game Common
		newRemotes("RemoteEvent", "UpdateNoteData", "Common")
		newRemotes("RemoteEvent", "ResetCharacters", "Common")
	end

	SetRemotes.createRemotes()
end

return SetRemotes
