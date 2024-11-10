local TeacherClient = {}

function TeacherClient.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui

	-- UI Components 모듈 사용
	local UIComponents = require(ReplicatedStorage.Shared.Modules.UIComponents)
	local SetHighlights = require(ReplicatedStorage.Shared.Modules.SetHighlights)

	local radius = UDim.new(0, 20)

	-- TeacherGui
	local teacherGui = Instance.new("ScreenGui")
	teacherGui.Parent = PlayerGui
	teacherGui.Name = "TeacherGui"
end

return TeacherClient
