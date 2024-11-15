local Players = game:GetService("Players")

local UIComponents = require(script.Parent.UIComponents)

local RankingBoard = {}

-- 로컬 변수
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- UI 생성 함수
local function createBoardUI()
	-- ScreenGui, MainFrame 생성
	local rankingGui = UIComponents.createSG(playerGui, { Name = "RankingGui", DisplayOrder = 50 })
	local mainFrame = UIComponents.createM0(rankingGui)

	-- Play 버튼 생성
	UIComponents.createTB2(mainFrame, {
		Name = "PlayButton",
		Size = UDim2.new(0.164, 0, 0.092, 0),
		Position = UDim2.new(0.417, 0, 0.733, 0),
		Text = "Play!",
		FontWeight = Enum.FontWeight.Bold,
	})

	-- BoardFrame 생성
	local boardFrame = UIComponents.createF3(
		mainFrame,
		{ Name = "BoardFrame", Position = UDim2.new(0.3, 0, 0.17, 0), Stroke = Color3.fromRGB(0, 0, 0) }
	)

	-- Game Title Label 생성
	UIComponents.createTL2(boardFrame, {
		Size = UDim2.new(0.444, 0, 0.15, 0),
		Position = UDim2.new(0.278, 0, 0.02, 0),
		Text = "Game Title",
		FontWeight = Enum.FontWeight.Bold,
		BackgroundTransparency = 1,
	})

	-- Exit Button 생성
	UIComponents.createEB(boardFrame, nil, mainFrame)

	-- RankingFrame 생성
	UIComponents.createF3(boardFrame, {
		Name = "RankingFrame",
		Size = UDim2.new(0.942, 0, 0.796, 0),
		Position = UDim2.new(0.03, 0, 0.2, 0),
		BackgroundTransparency = 1,
	})

	-- 테스트 콜
	RankingBoard.updateRank()
end

-- 랭킹 클리어 함수
local function clearRankUI()
	local rankingFrame = playerGui.RankingGui.MainFrame.BoardFrame:FindFirstChild("RankingFrame")
	if rankingFrame then
		for _, child in ipairs(rankingFrame:GetChildren()) do
			child:Destroy()
		end
	end
end

-- 랭킹 업데이트 함수
function RankingBoard.updateRank(data)
	-- 더미 데이터 (서버에서 받아와야 함)
	data = data
		or {
			{ rank = 1, name = "Player1", score = 100 },
			{ rank = 2, name = "Player2", score = 90 },
			{ rank = 3, name = "Player3", score = 80 },
			{ rank = 56, name = "Player4", score = 80 },
		}

	local ROWS = 4
	local SPACING = 0.05
	local HEIGHT = (1 - SPACING * (ROWS + 2)) / ROWS

	local rankingFrame = playerGui.RankingGui.MainFrame.BoardFrame:FindFirstChild("RankingFrame")

	-- 랭킹 클리어
	clearRankUI()

	for i, entry in ipairs(data) do
		local userData = { rank = entry.rank, name = entry.name, score = entry.score }
		local strokeColor = Color3.fromRGB(0, 0, 0)

		if i == 4 then
			userData.name = "You"
			strokeColor = Color3.fromRGB(0, 136, 255)
		end

		local innerRankingFrame = UIComponents.createF0(rankingFrame, {
			Name = "RankingList_" .. i,
			Size = UDim2.new(1, 0, HEIGHT, 0),
			Position = UDim2.new(0, 0, SPACING + (HEIGHT + SPACING) * (i - 1), 0),
			CornerRadius = UDim.new(0.07, 0),
			Stroke = strokeColor,
		})

		UIComponents.createTL2(innerRankingFrame, {
			Name = "Rank",
			Size = UDim2.new(0.15, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = userData.rank,
			BackgroundTransparency = 1,
		})

		UIComponents.createTL2(innerRankingFrame, {
			Name = "UserName",
			Size = UDim2.new(0.7, 0, 1, 0),
			Position = UDim2.new(0.15, 0, 0, 0),
			Text = userData.name,
			BackgroundTransparency = 1,
		})

		UIComponents.createTL2(innerRankingFrame, {
			Name = "Score",
			Size = UDim2.new(0.15, 0, 1, 0),
			Position = UDim2.new(0.85, 0, 0, 0),
			Text = userData.score,
			BackgroundTransparency = 1,
		})
	end
end

-- 초기화 함수
function RankingBoard.init()
	createBoardUI()
end

return RankingBoard
