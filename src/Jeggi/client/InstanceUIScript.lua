local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local InstanceUIScript = {}

-- UI 생성 함수
local function CreateGameUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = playerGui

	-- PlayButton 생성
	local playButton = Instance.new("TextButton")
	playButton.Name = "PlayButton"
	playButton.Text = "Play"
	playButton.Size = UDim2.new(0.2, 0, 0.1, 0)
	playButton.Position = UDim2.new(0.4, 0, 0.8, 0)
	playButton.Parent = screenGui

	-- 카운트다운 Label 생성
	local countdownLabel = Instance.new("TextLabel")
	countdownLabel.Name = "Countdown"
	countdownLabel.Text = ""
	countdownLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
	countdownLabel.Position = UDim2.new(0.4, 0, 0.7, 0)
	countdownLabel.Visible = false
	countdownLabel.Parent = screenGui

	-- Game Over 텍스트 생성
	local gameOverText = Instance.new("TextLabel")
	gameOverText.Name = "GameOverText"
	gameOverText.Text = "Game Over!"
	gameOverText.Size = UDim2.new(0.3, 0, 0.2, 0)
	gameOverText.Position = UDim2.new(0.35, 0, 0.4, 0)
	gameOverText.Visible = false
	gameOverText.Parent = screenGui

	print("Game UI created for player: " .. player.Name)

	-- PlayButton 클릭 시 이벤트 처리
	playButton.MouseButton1Click:Connect(function()
		print("PlayButton clicked by player: " .. player.Name)
		playButton.Visible = false
		countdownLabel.Visible = true

		-- 3초 카운트다운
		for i = 3, 1, -1 do
			countdownLabel.Text = tostring(i)
			wait(1)
		end
		countdownLabel.Visible = false

		-- 서버에 제기 생성 요청
		Remotes.Jeggi.JeggiCreationEvent:FireServer()
	end)
end

function InstanceUIScript.init()
	-- 서버로부터 게임 시작 신호를 받으면 UI 생성
	Remotes.Jeggi.StartGameEvent.OnClientEvent:Connect(function()
		print("Received StartGameEvent from server")
		CreateGameUI()
	end)

	-- 게임 오버 이벤트 수신
	Remotes.Jeggi.GameOverEvent.OnClientEvent:Connect(function()
		local gameOverText = player.PlayerGui:FindFirstChild("GameOverText")
		if gameOverText then
			gameOverText.Visible = true
			wait(2)
			gameOverText.Visible = false
		end
	end)
end

return InstanceUIScript
