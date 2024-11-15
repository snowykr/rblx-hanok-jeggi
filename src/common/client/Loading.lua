local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UIComponents = require(script.Parent.UIComponents)

local Player = Players.LocalPlayer
local playerGui = Player.PlayerGui

local Loading = {}

function Loading:Init()
	-- ScreenGui 생성
	local loadingGui = UIComponents.createSG(nil, {
		Name = "LoadingGui",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 100,
	})

	-- MainFrame 생성
	local mainFrame = UIComponents.createM0(loadingGui, {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
	})

	-- 타이틀 텍스트
	UIComponents.createTL2(mainFrame, {
		Name = "TitleText",
		Size = UDim2.new(0.8, 0, 0.1, 0),
		Position = UDim2.new(0.1, 0, 0.4, 0),
		BackgroundTransparency = 1,
		Text = "4Fun Speaking",
		FontWeight = Enum.FontWeight.Bold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		MaxTextSize = 90,
	})

	-- 로딩바 외부 베이스
	local loadingBarBase = UIComponents.createF0(mainFrame, {
		Name = "LoadingBarBase",
		Size = UDim2.new(0.6, 0, 0.05, 0),
		Position = UDim2.new(0.2, 0, 0.55, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		CornerRadius = UDim.new(1, 0),
		Stroke = Color3.fromRGB(255, 255, 255),
	})

	-- 로딩바
	local loadingBar = UIComponents.createF0(loadingBarBase, {
		Name = "LoadingBar",
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		CornerRadius = UDim.new(1, 0),
	})

	-- 퍼센티지 텍스트
	UIComponents.createTL2(mainFrame, {
		Name = "PercentText",
		Size = UDim2.new(0.2, 0, 0.05, 0),
		Position = UDim2.new(0.4, 0, 0.62, 0),
		BackgroundTransparency = 1,
		Text = "0%",
		TextColor3 = Color3.fromRGB(255, 255, 255),
	})

	-- 로딩 화면 제거
	local function removeLoadingScreen()
		local test = 0
		for transparency = 0, 1, 0.1 do
			test = transparency
			UIComponents.setTransparencyRecursive(loadingGui, transparency)
			task.wait(0.03)
		end

		if test == 1 then
			print("test end")
			loadingGui:Destroy()
		end
	end

	---------------------------- 로딩 스크립트 ----------------------------

	-- 로딩바 업데이트 함수
	local function updateLoadingBar(progress)
		-- print("updateLoadingBar", progress)
		loadingBar.Size = UDim2.new(progress, 0, 1, 0)
		mainFrame.PercentText.Text = string.format("%d%%", math.floor(progress * 100))
	end

	-- 로딩 화면 설정
	local function setupLoadingScreen()
		-- Roblox 기본 로딩 화면 제거
		game.ReplicatedFirst:RemoveDefaultLoadingScreen()

		-- 로딩 화면 활성화
		loadingGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

		-- 초기 로딩 20%
		Player.CameraMaxZoomDistance = 15
		updateLoadingBar(0.1)
		wait(0.01)

		-- 리모트 생성 대기
		ReplicatedStorage:WaitForChild("Remotes")
		updateLoadingBar(0.2)

		-- 플레이어 아바타 로드 대기
		local character = Player.Character or Player.CharacterAdded:Wait()
		updateLoadingBar(0.3)

		-- 에셋 프리로드
		local loadedAssets = 0
		local totalAssets = #self.assetsToPreload

		local function onAssetLoaded(assetId, status)
			if status == Enum.AssetFetchStatus.Success then
				loadedAssets = loadedAssets + 1
				-- 프리로드 진행 상황 표시 (30%에서 60%)
				updateLoadingBar(0.3 + (loadedAssets / totalAssets * 0.3))
			else
				warn("Failed to load asset:", assetId)
			end
		end

		ContentProvider:PreloadAsync(self.assetsToPreload, onAssetLoaded)

		-- 워크스페이스 로딩 추적
		local totalParts = #workspace:GetDescendants()
		local loadedParts = 0

		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") then
				part:GetPropertyChangedSignal("Parent"):Connect(function()
					loadedParts = loadedParts + 1
					updateLoadingBar(0.6 + (loadedParts / totalParts * 0.2))
				end)
			end
		end

		-- 클라이언트 모듈 초기화
		local totalModules = #self.modulesToInit
		for i, module in ipairs(self.modulesToInit) do
			require(module).init()
			updateLoadingBar(0.8 + (i / totalModules * 0.2))
		end

		-- 최종 로딩 완료
		updateLoadingBar(1)

		-- 로딩 화면 제거
		task.wait(1)
		removeLoadingScreen()
	end

	-- 실행
	setupLoadingScreen()

	return loadingGui
end

return Loading
