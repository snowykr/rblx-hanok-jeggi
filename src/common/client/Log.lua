local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UIComponents = require(script.Parent.UIComponents)

local Log = {}

-- 로컬 변수
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local messages = {}
local logFrames = {}

local MAX_LOGS = 3
local DISPLAY_DURATION = 3

-- UI 생성 함수
local function createLogUI()
	-- ScreenGui, MainFrame 생성
	local logGui = UIComponents.createSG(PlayerGui, {
		Name = "LogGui",
		DisplayOrder = 49,
	})
	local mainFrame = UIComponents.createM0(logGui)

	-- LogFrame 생성
	for i = 1, MAX_LOGS do
		local frame = UIComponents.createF0(mainFrame, {
			Name = "LogFrame" .. i,
			Size = UDim2.new(0.3 * (i > 1 and 0.8 or 1), 0, 0.05 * (i > 1 and 0.8 or 1), 0),
			Position = UDim2.new(0.7, 0, 0.215 + (i - 1) * 0.06 * (i > 2 and 0.92 or 1), 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
		})

		UIComponents.createTL2(frame, {
			Name = "ContentLabel",
			Size = UDim2.new(0.98, 0, 0.9, 0),
			Position = UDim2.new(0.01, 0, 0.005, 0),
			Text = "",
			TextTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
		})

		table.insert(logFrames, frame)
	end
end

-- 로그 업데이트 함수
local function updateLogs()
	local currentTime = tick()

	for i, logFrame in ipairs(logFrames) do
		if messages[i] then
			logFrame.ContentLabel.Text = messages[i].message
			if not logFrame.Visible then
				UIComponents.setTransparencyRecursive(logFrame, 0)
				logFrame.Visible = true
			end
			if currentTime - messages[i].time >= DISPLAY_DURATION then
				table.remove(messages, i)
				UIComponents.setTransparencyRecursive(logFrame, 1)
				delay(0.5, function()
					logFrame.Visible = false
				end)
			end
		else
			if logFrame.Visible then
				UIComponents.setTransparencyRecursive(logFrame, 1)
				delay(0.5, function()
					logFrame.Visible = false
				end)
			end
		end
	end
end

-- 로그 업데이트
game:GetService("RunService").Heartbeat:Connect(updateLogs)

Remotes.Log.LogEvent.OnClientEvent:Connect(function(new_message)
	table.insert(messages, 1, { message = new_message, time = tick() })
	if #messages > MAX_LOGS then
		table.remove(messages, MAX_LOGS + 1)
	end
end)

-- 초기화 함수
function Log.init()
	createLogUI()

	print("Log initialized")
end

return Log
