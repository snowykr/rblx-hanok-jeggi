local GameControlScript = {}

function GameControlScript:Init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local startPart = game.Workspace:WaitForChild("StartPart")
	local clickDetector = startPart:WaitForChild("ClickDetector")

	local function StartGame(player)
		-- 클라이언트에게 UI를 생성하라는 신호를 보냄
		print("Starting game for player: " .. player.Name)
		Remotes.Jeggi.StartGameEvent:FireClient(player)
	end

	-- StartPart 클릭 시 게임 시작
	clickDetector.MouseClick:Connect(function(player)
		print("Player clicked StartPart: " .. player.Name)
		StartGame(player)
	end)
end

return GameControlScript
