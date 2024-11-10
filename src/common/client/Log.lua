local Log = {}

function Log.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player.PlayerGui

	local TweenService = game:GetService("TweenService")

	local mainFrame, logGui
	local radius = UDim.new(0, 20)
	local maxLogs = 3
	local logFrames = {}

	local function createLogFrame(index)
		-- LogFrame
		local frame = Instance.new("Frame")
		frame.ZIndex = 2
		frame.Name = "LogFrame" .. index
		frame.Size = UDim2.new(0.3 * (index > 1 and 0.8 or 1), 0, 0.05 * (index > 1 and 0.8 or 1), 0)
		frame.Position = UDim2.new(0.7, 0, 0.215 + (index - 1) * 0.06 * (index > 2 and 0.92 or 1), 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 1
		frame.Visible = false
		frame.Parent = mainFrame

		-- UICorner for logFrame
		local logFrameCorner = Instance.new("UICorner")
		logFrameCorner.CornerRadius = radius
		logFrameCorner.Parent = frame

		-- ContentLabel
		local label = Instance.new("TextLabel")
		label.ZIndex = 3
		label.Name = "ContentLabel"
		label.Size = UDim2.new(0.98, 0, 0.9, 0)
		label.Position = UDim2.new(0.01, 0, 0.005, 0)
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.Text = ""
		label.TextScaled = true
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.TitilliumWeb
		label.Parent = frame

		table.insert(logFrames, frame)
		return frame, label
	end

	local function createlogUI()
		-- logGui
		logGui = Instance.new("ScreenGui")
		logGui.DisplayOrder = 999
		logGui.Parent = playerGui
		logGui.Name = "LogGui"

		-- MainFrame
		mainFrame = Instance.new("Frame")
		mainFrame.ZIndex = 1
		mainFrame.Name = "MainFrame"
		mainFrame.Size = UDim2.new(1, 0, 1, 0)
		mainFrame.Position = UDim2.new(0, 0, 0, 0)
		mainFrame.BackgroundTransparency = 1
		mainFrame.Visible = true
		mainFrame.Parent = logGui

		for i = 1, maxLogs do
			createLogFrame(i)
		end
	end

	createlogUI()

	-- log Event Handler
	local messages = {}

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

	local function updateLogs()
		local currentTime = tick()
		for i, logFrame in ipairs(logFrames) do
			if messages[i] then
				logFrame.ContentLabel.Text = messages[i].message
				if not logFrame.Visible then
					tweenVisibility(logFrame, true)
					logFrame.Visible = true
				end
				if currentTime - messages[i].time >= 3 then
					table.remove(messages, i)
					tweenVisibility(logFrame, false)
					delay(0.5, function()
						logFrame.Visible = false
					end)
				end
			else
				if logFrame.Visible then
					tweenVisibility(logFrame, false)
					delay(0.5, function()
						logFrame.Visible = false
					end)
				end
			end
		end
	end

	Remotes.Log.LogEvent.OnClientEvent:Connect(function(message)
		table.insert(messages, 1, { message = message, time = tick() })
		if #messages > maxLogs then
			table.remove(messages, maxLogs + 1)
		end
		updateLogs()
	end)

	game:GetService("RunService").RenderStepped:Connect(updateLogs)
end

return Log
