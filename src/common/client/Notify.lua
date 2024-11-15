local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UIComponents = require(script.Parent.UIComponents)

local Notify = {}

-- 로컬 변수
local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local currentMessage = {
	message = "",
	startTime = nil,
}
local notifyFrame

local NOTIFY_TRANSPARENCY = 0.4
local DISPLAY_DURATION = 2.5

local function createNotifyUI()
	-- ScreenGui, MainFrame 생성
	local notifyGui = UIComponents.createSG(PlayerGui, {
		Name = "NotifyGui",
		DisplayOrder = 50,
	})
	--local mainFrame = UIComponents.createM0(notifyGui)

	-- NotifyFrame 생성
	notifyFrame = UIComponents.createF0(notifyGui, {
		ZIndex = 2,
		Name = "NotifyFrame",
		Size = UDim2.new(0.6, 0, 0.109, 0),
		Position = UDim2.new(0.2, 0, 0.115, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	})

	-- ContentLabel 생성
	UIComponents.createTL2(notifyFrame, {
		ZIndex = 3,
		Name = "ContentLabel",
		Size = UDim2.new(0.989, 0, 0.844, 0),
		Position = UDim2.new(0.005, 0, 0.08, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Color3.fromRGB(255, 255, 255),
	})
end

-- 메시지 업데이트 함수
local function updateNotification()
	if currentMessage.startTime then
		local currentTime = tick()
		notifyFrame.ContentLabel.Text = currentMessage.message

		if not notifyFrame.Visible then
			notifyFrame.Visible = true
			UIComponents.setTransparency(notifyFrame.ContentLabel, 0)
			for transparency = 1, NOTIFY_TRANSPARENCY, -0.1 do
				UIComponents.setTransparency(notifyFrame, transparency)

				task.wait(0.03)
			end
		end
		if currentTime - currentMessage.startTime >= DISPLAY_DURATION then
			--currentMessage.message = "del"
			--currentMessage.startTime = nil

			--UIComponents.setTransparencyRecursive(notifyFrame, 1)
			--notifyFrame.Visible = false
		end
	end
end

-- 메시지 업데이트
game:GetService("RunService").Heartbeat:Connect(updateNotification)

Remotes.Notify.NotifyEvent.OnClientEvent:Connect(function(new_message)
	print("NotifyEvent, new_message: ", new_message)
	currentMessage.message = new_message
	currentMessage.startTime = tick()
end)

-- 초기화 함수
function Notify.init()
	createNotifyUI()
end

return Notify
