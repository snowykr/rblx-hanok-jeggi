local Loading = {}

function Loading:Init()
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local ContentProvider = game:GetService("ContentProvider")

	-- ScreenGui 생성
	local loadingScreen = Instance.new("ScreenGui")
	loadingScreen.Name = "LoadingScreen"
	loadingScreen.IgnoreGuiInset = true
	loadingScreen.ResetOnSpawn = false
	loadingScreen.DisplayOrder = 100

	-- MainFrame 생성
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BackgroundTransparency = 0
	mainFrame.Parent = loadingScreen

	-- 배경 프레임
	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	background.Parent = mainFrame

	-- 타이틀 텍스트
	local titleText = Instance.new("TextLabel")
	titleText.Text = "4Fun Speaking"
	titleText.Font = Enum.Font.GothamBold
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.TextScaled = true
	titleText.Size = UDim2.new(0.8, 0, 0.1, 0)
	titleText.Position = UDim2.new(0.1, 0, 0.4, 0)
	titleText.BackgroundTransparency = 1
	titleText.Parent = background

	-- 로딩바 외부 베이스
	local loadingBarOuterBase = Instance.new("Frame")
	loadingBarOuterBase.Size = UDim2.new(0.6, 0, 0.05, 0)
	loadingBarOuterBase.Position = UDim2.new(0.2, 0, 0.55, 0)
	loadingBarOuterBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	loadingBarOuterBase.Parent = background

	-- 로딩바 내부 베이스
	local loadingBarInnerBase = Instance.new("Frame")
	loadingBarInnerBase.Size = UDim2.new(0.99, 0, 0.8, 0)
	loadingBarInnerBase.Position = UDim2.new(0.005, 0, 0.1, 0)
	loadingBarInnerBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loadingBarInnerBase.Parent = loadingBarOuterBase

	-- 로딩바
	local loadingBar = Instance.new("Frame")
	loadingBar.Size = UDim2.new(0, 0, 1, 0)
	loadingBar.Position = UDim2.new(0, 0, 0, 0)
	loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	loadingBar.Parent = loadingBarInnerBase

	-- 퍼센티지 텍스트
	local percentText = Instance.new("TextLabel")
	percentText.Text = "0%"
	percentText.Font = Enum.Font.GothamMedium
	percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentText.TextScaled = true
	percentText.Size = UDim2.new(0.2, 0, 0.05, 0)
	percentText.Position = UDim2.new(0.4, 0, 0.62, 0)
	percentText.BackgroundTransparency = 1
	percentText.Parent = background

	-- 둥근 모서리 적용
	local function applyRoundedCorners(frame, radius)
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(radius, 0)
		uiCorner.Parent = frame
	end

	applyRoundedCorners(loadingBarOuterBase, 1)
	applyRoundedCorners(loadingBarInnerBase, 1)
	applyRoundedCorners(loadingBar, 1)

	-- 로딩 로직
	local function updateLoadingBar(progress)
		loadingBar.Size = UDim2.new(progress, 0, 1, 0)
		percentText.Text = string.format("%d%%", math.floor(progress * 100))
	end

	-- 로딩 화면 제거
	local function removeLoadingScreen()
		for i = 0, 1, 0.1 do
			mainFrame.BackgroundTransparency = i
			for _, child in pairs(mainFrame:GetDescendants()) do
				if child:IsA("GuiObject") then
					child.BackgroundTransparency = 1
					if child:IsA("TextLabel") or child:IsA("TextButton") then
						child.TextTransparency = i
					end
				end
			end
			task.wait(0.05)
		end
		loadingScreen:Destroy()
	end

	---------------------------- 로딩 스크립트 ----------------------------

	local function setupLoadingScreen()
		-- Roblox 기본 로딩 화면 제거
		game.ReplicatedFirst:RemoveDefaultLoadingScreen()

		-- 로딩 화면 활성화
		loadingScreen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

		-- 초기 로딩 20%
		Player.CameraMaxZoomDistance = 15
		updateLoadingBar(0.1)
		wait(0.01)

		-- 리모트 생성 대기
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Remotes = ReplicatedStorage:WaitForChild("Remotes")
		updateLoadingBar(0.2)

		-- 플레이어 아바타 로드 대기
		local Player = Players.LocalPlayer
		local character = Player.Character or Player.CharacterAdded:Wait()
		updateLoadingBar(0.3)

		-- 에셋 프리로드
		local loadedAssets = 0
		local totalAssets = #self.assetsToPreload

		ContentProvider:PreloadAsync(self.assetsToPreload, function(assetId, status)
			loadedAssets = loadedAssets + 1
			-- 프리로드 진행 상황 표시 (30%에서 60%)
			updateLoadingBar(0.3 + (loadedAssets / totalAssets * 0.3))
		end)

		-- 워크스페이스 로딩 추적
		local function trackWorkspaceLoading()
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
		end

		trackWorkspaceLoading()

		local function initClientModules()
			local totalModules = #self.modulesToLoad
			for i, module in ipairs(self.modulesToLoad) do
				require(module).init()
				updateLoadingBar(0.8 + (i / totalModules * 0.2))
			end
		end

		initClientModules()

		-- 최종 로딩 완료
		updateLoadingBar(1)

		-- 로딩 화면 제거
		task.wait(1)
		removeLoadingScreen()
	end

	-- 실행
	setupLoadingScreen()

	return loadingScreen
end

return Loading
