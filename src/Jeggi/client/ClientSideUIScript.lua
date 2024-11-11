local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ClientSideUIScript = {}

function ClientSideUIScript.init()
	-- 리더보드 UI 초기화
	local leaderboardGui = Instance.new("ScreenGui")
	leaderboardGui.Parent = playerGui
	local leaderboardFrame = Instance.new("Frame")
	leaderboardFrame.Parent = leaderboardGui
	leaderboardFrame.Size = UDim2.new(0.3, 0, 0.3, 0)
	leaderboardFrame.Position = UDim2.new(0.7, 0, 0.05, 0)

	leaderboardFrame.Visible = false
	-- 임시처리

	Remotes.LeaderBoard.LeaderBoardUpdateClientEvent.OnClientEvent:Connect(function(leaderBoardData)
		-- 기존 리더보드 초기화
		for _, child in pairs(leaderboardFrame:GetChildren()) do
			child:Destroy()
		end

		-- 새로운 리더보드 정보 추가
		local yOffset = 0
		for userId, data in pairs(leaderBoardData) do
			local playerLabel = Instance.new("TextLabel")
			playerLabel.Parent = leaderboardFrame
			playerLabel.Size = UDim2.new(1, 0, 0, 30)
			playerLabel.Position = UDim2.new(0, 0, 0, yOffset)
			playerLabel.Text = data.name .. ": " .. data.score
			yOffset = yOffset + 30
		end
	end)
end

return ClientSideUIScript
