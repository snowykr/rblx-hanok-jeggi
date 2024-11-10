local Notify = {}

function Notify.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player.PlayerGui

	local TweenService = game:GetService("TweenService")

	local notifyGui, notifyFrame, contentLabel

	local function createNotifyUI()
		local radius = UDim.new(0, 20)

		-- NotifyGui
		notifyGui = Instance.new("ScreenGui")
		notifyGui.DisplayOrder = 999
		notifyGui.Parent = playerGui
		notifyGui.Name = "NotifyGui"

		-- NotifyFrame
		notifyFrame = Instance.new("Frame")
		notifyFrame.ZIndex = 2
		notifyFrame.Name = "NotifyFrame"
		notifyFrame.Size = UDim2.new(0.6, 0, 0.109, 0)
		notifyFrame.Position = UDim2.new(0.2, 0, 0.115, 0)
		notifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		notifyFrame.BackgroundTransparency = 1
		notifyFrame.Visible = true
		notifyFrame.Parent = notifyGui

		-- UICorner for NotifyFrame
		local notifyFrameCorner = Instance.new("UICorner")
		notifyFrameCorner.CornerRadius = radius
		notifyFrameCorner.Parent = notifyFrame

		-- ContentLabel
		contentLabel = Instance.new("TextLabel")
		contentLabel.ZIndex = 3
		contentLabel.Name = "ContentLabel"
		contentLabel.Size = UDim2.new(0.989, 0, 0.844, 0)
		contentLabel.Position = UDim2.new(0.005, 0, 0.08, 0)
		contentLabel.BackgroundTransparency = 1
		contentLabel.Text = ""
		contentLabel.TextScaled = true
		contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		contentLabel.Font = Enum.Font.TitilliumWeb
		contentLabel.Parent = notifyFrame
	end

	createNotifyUI()

	local function tweenVisibility(frame, isVisible)
		local goal = { BackgroundTransparency = isVisible and 0.4 or 1 }
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(frame, tweenInfo, goal)
		tween:Play()

		local label = frame:FindFirstChild("ContentLabel")
		if label then
			local labelGoal = { TextTransparency = isVisible and 0 or 1 }
			local labelTween = TweenService:Create(label, tweenInfo, labelGoal)
			labelTween:Play()
		end
	end

	-- Notify Event Handler
	local notificationActive = false

	local currentMessage = {
		text = "",
		startTime = 0,
	}

	local DISPLAY_DURATION = 2.5

	local function updateNotification()
		local currentTime = time()

		if currentMessage.startTime > 0 then
			if currentTime - currentMessage.startTime >= DISPLAY_DURATION then
				-- Hide notification if display duration has passed
				tweenVisibility(notifyFrame, false)
				currentMessage.startTime = 0
				delay(0.5, function()
					notifyFrame.Visible = false
					notificationActive = false
				end)
			end
		end
	end

	-- Start the update loop
	game:GetService("RunService").Heartbeat:Connect(updateNotification)

	Remotes.Notify.NotifyEvent.OnClientEvent:Connect(function(message)
		contentLabel.Text = message
		currentMessage.text = message
		currentMessage.startTime = time()

		tweenVisibility(notifyFrame, true)
		notifyFrame.Visible = true
		notificationActive = true
	end)
end

return Notify
