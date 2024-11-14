local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Modules = ReplicatedStorage.Shared:WaitForChild("Modules")

local UIComponents = require(Modules:WaitForChild("UIComponents"))

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local RankingBoard = {}

function RankingBoard.init()
	RankingBoard.CreateBoardUI()
end

function RankingBoard.CreateBoardUI()
	-- RankingBoard
	local rankingBoard = Instance.new("ScreenGui")
	rankingBoard.DisplayOrder = 50
	rankingBoard.Parent = PlayerGui
	rankingBoard.Name = "RankingBoard"

	local mainFrame = UIComponents.createM0(rankingBoard)

	-- local playButton = UIComponents.create("TextButton", {
	-- 	Name = "PlayButton",
	-- 	CornerRadius = UDim.new(0.3, 0),
	-- 	Stroke = Color3.fromRGB(0, 0, 0),
	-- 	Size = UDim2.new(0.164, 0, 0.092, 0),
	-- 	Position = UDim2.new(0.417, 0, 0.733, 0),
	-- 	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	-- 	Text = "Play!",
	-- 	TextScaled = true,
	-- 	MaxTextSize = 60,
	-- 	MinTextSize = 10,
	-- 	Font = "Bangers",
	-- 	TextColor3 = Color3.fromRGB(0, 0, 0),
	-- }, function(instance)
	-- 	instance.Parent = mainFrame
	-- end)

	UIComponents.createTB2(mainFrame, {
		Name = "PlayButton",
		Size = UDim2.new(0.164, 0, 0.092, 0),
		Position = UDim2.new(0.417, 0, 0.733, 0),
		Text = "Play!",
		MaxTextSize = 60,
	})

	-- BoardFrame 생성
	-- local boardFrame = UIComponents.create("Frame", {
	-- 	Size = UDim2.new(0.418, 0, 0.503, 0),
	-- 	Position = UDim2.new(0.291, 0, 0.174, 0),
	-- 	BackgroundTransparency = 0,
	-- 	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	-- 	Visible = true,
	-- 	Name = "BoardFrame",
	-- 	CornerRadius = UDim.new(0.07, 0),
	-- 	Stroke = Color3.fromRGB(0, 0, 0),
	-- }, function(instance)
	-- 	instance.Parent = mainFrame
	-- end)

	local boardFrame = UIComponents.createF3(mainFrame, { Name = "BoardFrame", Position = UDim2.new(0.3, 0, 0.17, 0) })

	-- 게임 이름
	-- local titleText = UIComponents.create("TextLabel", {
	-- 	Size = UDim2.new(0.444, 0, 0.15, 0),
	-- 	Position = UDim2.new(0.278, 0, 0.02, 0),
	-- 	Text = "Game Title",
	-- 	Font = "Bangers",
	-- 	TextColor3 = Color3.fromRGB(0, 0, 0),
	-- 	TextScaled = true,
	-- 	BackgroundTransparency = 1,
	-- }, function(instance)
	-- 	instance.Parent = boardFrame
	-- end)

	UIComponents.createTL2(boardFrame, {
		Size = UDim2.new(0.444, 0, 0.15, 0),
		Position = UDim2.new(0.278, 0, 0.02, 0),
		Text = "Game Title",
		Font = "Bangers",
		BackgroundTransparency = 1,
	})

	-- ExitButton
	-- local exitButton = UIComponents.create("TextButton", {
	-- 	Name = "ExitButton",
	-- 	Size = UDim2.new(0.049, 0, 0.095, 0),
	-- 	Position = UDim2.new(0.94, 0, 0, 0),
	-- 	BackgroundTransparency = 1,
	-- 	Text = "X",
	-- 	TextColor3 = Color3.new(0, 0, 0),
	-- 	TextScaled = true,
	-- }, function(instance)
	-- 	instance.Parent = boardFrame
	-- 	UIComponents.addUITextSizeConstraint(instance, 30, 1)
	-- 	instance.MouseButton1Click:Connect(function()
	-- 		mainFrame.Visible = false
	-- 	end)
	-- end)

	UIComponents.createEB(boardFrame, nil, mainFrame)

	-- RankingFrame
	-- local rankingFrame1 = UIComponents.create("Frame", {
	-- 	Name = "RankingFrame",
	-- 	Size = UDim2.new(0.942, 0, 0.796, 0),
	-- 	Position = UDim2.new(0.03, 0, 0.2, 0),
	-- 	BackgroundTransparency = 1,
	-- }, function(instance)
	-- 	instance.Parent = boardFrame
	-- end)

	UIComponents.createF3(boardFrame, {
		Name = "RankingFrame",
		Size = UDim2.new(0.942, 0, 0.796, 0),
		Position = UDim2.new(0.03, 0, 0.2, 0),
		BackgroundTransparency = 1,
	})

	-- test
	-- RankingBoard.UpdateRank()
end

function RankingBoard.UpdateRank(data)
	-- dummy data, the fourth data should be returned as "You", 데이터 가공해주는 함수 제작 필요
	data = {
		{ name = "Player1", score = 100 },
		{ name = "Player2", score = 90 },
		{ name = "Player3", score = 80 },
		{ rank = 56, name = "You", score = 80 },
	}

	-- RankingList(1~n)
	local ROWS = 4
	local SPACING = 0.05
	local HEIGHT = (1 - SPACING * (ROWS + 2)) / ROWS

	for i, entry in ipairs(data) do
		-- local innerRankingFrame = UIComponents.create("Frame", {
		-- 	Name = "RankingList_" .. i,
		-- 	Stroke = Color3.fromRGB(0, 0, 0),
		-- 	Size = UDim2.new(1, 0, HEIGHT, 0),
		-- 	Position = UDim2.new(0, 0, SPACING + (HEIGHT + SPACING) * (i - 1), 0),
		-- 	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		-- }, function(instance)
		-- 	instance.Parent = PlayerGui.RankingBoard.MainFrame.BoardFrame:FindFirstChild("RankingFrame")
		-- end)

		local innerRankingFrame =
			UIComponents.createF0(PlayerGui.RankingBoard.MainFrame.BoardFrame:FindFirstChild("RankingFrame"), {
				Name = "RankingList_" .. i,
				Size = UDim2.new(1, 0, HEIGHT, 0),
				Position = UDim2.new(0, 0, SPACING + (HEIGHT + SPACING) * (i - 1), 0),
				CornerRadius = UDim.new(0, 0),
			})

		-- UIComponents.create("TextLabel", {
		-- 	Name = "Rank",
		-- 	Stroke = Color3.fromRGB(0, 0, 0),
		-- 	Size = UDim2.new(0.15, 0, 1, 0),
		-- 	Position = UDim2.new(0, 0, 0, 0),
		-- 	Text = tostring(i),
		-- 	TextScaled = true,
		-- 	MaxTextSize = 70,
		-- 	MinTextSize = 10,
		-- 	Font = "Bangers",
		-- 	TextColor3 = Color3.fromRGB(0, 0, 0),
		-- 	BackgroundTransparency = 1,
		-- }, function(inner_instance)
		-- 	inner_instance.Parent = innerRankingFrame
		-- end)

		UIComponents.createTL2(innerRankingFrame, {
			Name = "Rank",
			Size = UDim2.new(0.15, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = tostring(i),
			BackgroundTransparency = 1,
			Stroke = Color3.fromRGB(0, 0, 0),
		})

		-- UIComponents.create("TextLabel", {
		-- 	Name = "UserName",
		-- 	Size = UDim2.new(0.7, 0, 1, 0),
		-- 	Position = UDim2.new(0.15, 0, 0, 0),
		-- 	Text = entry.name,
		-- 	TextScaled = true,
		-- 	MaxTextSize = 70,
		-- 	MinTextSize = 10,
		-- 	Font = "Bangers",
		-- 	TextColor3 = Color3.fromRGB(0, 0, 0),
		-- 	BackgroundTransparency = 1,
		-- }, function(inner_instance)
		-- 	inner_instance.Parent = innerRankingFrame
		-- end)

		UIComponents.createTL2(innerRankingFrame, {
			Name = "UserName",
			Size = UDim2.new(0.7, 0, 1, 0),
			Position = UDim2.new(0.15, 0, 0, 0),
			Text = entry.name,
			BackgroundTransparency = 1,
			Stroke = Color3.fromRGB(0, 0, 0),
		})

		-- UIComponents.create("TextLabel", {
		-- 	Name = "Score",
		-- 	Stroke = Color3.fromRGB(0, 0, 0),
		-- 	Size = UDim2.new(0.15, 0, 1, 0),
		-- 	Position = UDim2.new(0.85, 0, 0, 0),
		-- 	Text = entry.score,
		-- 	TextScaled = true,
		-- 	MaxTextSize = 70,
		-- 	MinTextSize = 10,
		-- 	Font = "Bangers",
		-- 	TextColor3 = Color3.fromRGB(0, 0, 0),
		-- 	BackgroundTransparency = 1,
		-- }, function(inner_instance)
		-- 	inner_instance.Parent = innerRankingFrame
		-- end)

		UIComponents.TL2(innerRankingFrame, {
			Name = "Score",
			Size = UDim2.new(0.15, 0, 1, 0),
			Position = UDim2.new(0.85, 0, 0, 0),
			Text = entry.score,
			BackgroundTransparency = 1,
			Stroke = Color3.fromRGB(0, 0, 0),
		})
	end
end

return RankingBoard
