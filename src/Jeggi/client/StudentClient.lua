local StudentClient = {}

function StudentClient.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local CharacterModels = workspace:WaitForChild("CharacterModels")
	local TweenService = game:GetService("TweenService")

	-- Player
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
end

return StudentClient
