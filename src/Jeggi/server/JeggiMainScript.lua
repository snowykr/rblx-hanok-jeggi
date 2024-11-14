local JeggiMainScript = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TweenService = game:GetService("TweenService")
local GameConfig = require(script.Parent.GameConfig)

local jeggiModel = ReplicatedStorage.Models:WaitForChild("Jeggi")
local effectTemplate = ReplicatedStorage.Models:WaitForChild("JeggiEffect")

type PlayerScore = {
	[number]: number,
}

local State = {
	playerScores = {} :: PlayerScore,
	isRaisingJeggi = false,
}

local function createEffect(position: Vector3)
	local effect = effectTemplate:Clone()
	effect.Position = position - Vector3.new(0, GameConfig.EFFECT.Y_OFFSET, 0)
	effect.Parent = workspace
	game:GetService("Debris"):AddItem(effect, GameConfig.EFFECT.DURATION)
end

local function handleGameOver(player: Player)
	for _, jeggi in ipairs(workspace:GetChildren()) do
		if jeggi.Name == "Jeggi" then
			jeggi:Destroy()
		end
	end
	Remotes.Jeggi.GameOverEvent:FireClient(player)
end

local function updateScore(player: Player)
	State.playerScores[player.UserId] = (State.playerScores[player.UserId] or 0) + GameConfig.SCORE.INCREMENT
	Remotes.Jeggi.ScoreUpdateEvent:FireAllClients(player, State.playerScores[player.UserId])
end

local handleJeggiDrop

local function handleJeggiRise(player: Player, jeggi: Model)
	if State.isRaisingJeggi then
		return
	end

	State.isRaisingJeggi = true

	local randomX = math.random(GameConfig.JEGGI.RANDOM_OFFSET.MIN, GameConfig.JEGGI.RANDOM_OFFSET.MAX)
	local randomZ = math.random(GameConfig.JEGGI.RANDOM_OFFSET.MIN, GameConfig.JEGGI.RANDOM_OFFSET.MAX)

	local tweenInfo = TweenInfo.new(GameConfig.JEGGI.RISE_DURATION, Enum.EasingStyle.Linear)
	local targetCFrame = jeggi.PrimaryPart.CFrame + Vector3.new(randomX, GameConfig.JEGGI.RISE_HEIGHT, randomZ)

	local tween = TweenService:Create(jeggi.PrimaryPart, tweenInfo, { CFrame = targetCFrame })
	tween:Play()

	tween.Completed:Connect(function()
		State.isRaisingJeggi = false
		handleJeggiDrop(player, jeggi)
	end)
end

handleJeggiDrop = function(player: Player, jeggi: Model)
	createEffect(jeggi.PrimaryPart.Position)

	local bodyVelocity = jeggi.PrimaryPart:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, GameConfig.JEGGI.DROP_VELOCITY, 0)
	bodyVelocity.Parent = jeggi.PrimaryPart

	task.delay(GameConfig.JEGGI.DROP_DURATION, function()
		local playerPos = player.Character
			and player.Character:FindFirstChild("HumanoidRootPart")
			and player.Character.HumanoidRootPart.Position
		local jeggiPos = jeggi.PrimaryPart.Position

		if not playerPos then
			return handleGameOver(player)
		end

		jeggiPos = Vector3.new(jeggiPos.X, 0, jeggiPos.Z)
		local distance = (playerPos - jeggiPos).Magnitude

		if distance > GameConfig.JEGGI.REACH_DISTANCE then
			handleGameOver(player)
		else
			updateScore(player)
			handleJeggiRise(player, jeggi)
		end
	end)
end

local function createJeggi(player: Player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local jeggiClone = jeggiModel:Clone()
	jeggiClone:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, 5, -3))
	jeggiClone.Parent = workspace

	handleJeggiDrop(player, jeggiClone)
	return jeggiClone
end

function JeggiMainScript:Init()
	Remotes.Jeggi.JeggiCreationEvent.OnServerEvent:Connect(function(player)
		State.playerScores[player.UserId] = 0
		createJeggi(player)
	end)
end

return JeggiMainScript
