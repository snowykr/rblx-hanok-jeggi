local SetRoles_client = {}

function SetRoles_client.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")

	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui

	local teacherPart = workspace.Interactables:WaitForChild("TeacherPart")
	local teacherProx = teacherPart:WaitForChild("ProximityPrompt")

	local enteredPassword = nil
	local radius = UDim.new(0, 20)

	-- RoleGui
	local roleGui = Instance.new("ScreenGui")
	roleGui.Parent = PlayerGui
	roleGui.Name = "RoleGui"

	-- MainFrame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.Position = UDim2.new(0, 0, 0, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Visible = true
	mainFrame.Parent = roleGui

	-- RegisterFrame
	local registerFrame = Instance.new("Frame")
	registerFrame.Name = "RegisterFrame"
	registerFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
	registerFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
	registerFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	registerFrame.BorderSizePixel = 0
	registerFrame.Visible = false
	registerFrame.Parent = mainFrame

	local registerCorner = Instance.new("UICorner")
	registerCorner.CornerRadius = radius
	registerCorner.Parent = registerFrame

	-- PasswordTextBox
	local passwordTextBox = Instance.new("TextBox")
	passwordTextBox.Name = "PasswordTextBox"
	passwordTextBox.Size = UDim2.new(0.695, 0, 0.423, 0)
	passwordTextBox.Position = UDim2.new(0.163, 0, 0.145, 0)
	passwordTextBox.BackgroundColor3 = Color3.new(0, 0, 0)
	passwordTextBox.BackgroundTransparency = 0.3
	passwordTextBox.Text = ""
	passwordTextBox.TextScaled = true
	passwordTextBox.TextColor3 = Color3.new(1, 1, 1)
	passwordTextBox.ShowNativeInput = true
	passwordTextBox.TextEditable = true
	passwordTextBox.Font = Enum.Font.DenkOne
	passwordTextBox.Parent = registerFrame

	local passwordCorner = Instance.new("UICorner")
	passwordCorner.CornerRadius = radius
	passwordCorner.Parent = passwordTextBox

	local passwordConstraint = Instance.new("UITextSizeConstraint")
	passwordConstraint.MaxTextSize = 70
	passwordConstraint.MinTextSize = 10
	passwordConstraint.Parent = passwordTextBox

	-- ExitButton
	local exitButton = Instance.new("TextButton")
	exitButton.Name = "ExitButton"
	exitButton.Size = UDim2.new(0.049, 0, 0.095, 0)
	exitButton.Position = UDim2.new(0.951, 0, 0, 0)
	exitButton.BackgroundColor3 = Color3.new(1, 1, 1)
	exitButton.Text = "X"
	exitButton.TextColor3 = Color3.new(0, 0, 0)
	exitButton.TextScaled = true
	exitButton.Parent = registerFrame

	local exitCorner = Instance.new("UICorner")
	exitCorner.CornerRadius = radius
	exitCorner.Parent = exitButton

	local exitConstraint = Instance.new("UITextSizeConstraint")
	exitConstraint.MaxTextSize = 35
	exitConstraint.MinTextSize = 1
	exitConstraint.Parent = exitButton

	-- ProceedButton
	local proceedButton = Instance.new("TextButton")
	proceedButton.Name = "ProceedButton"
	proceedButton.Size = UDim2.new(0.694, 0, 0.208, 0)
	proceedButton.Position = UDim2.new(0.163, 0, 0.676, 0)
	proceedButton.BackgroundColor3 = Color3.new(0, 0, 0)
	proceedButton.Text = "Proceed"
	proceedButton.TextScaled = true
	proceedButton.TextColor3 = Color3.new(1, 1, 1)
	proceedButton.Font = Enum.Font.DenkOne
	proceedButton.Parent = registerFrame

	local proceedCorner = Instance.new("UICorner")
	proceedCorner.CornerRadius = radius
	proceedCorner.Parent = proceedButton

	local proceedConstraint = Instance.new("UITextSizeConstraint")
	proceedConstraint.MaxTextSize = 70
	proceedConstraint.MinTextSize = 10
	proceedConstraint.Parent = proceedButton

	-- ExitButton
	exitButton.MouseButton1Click:Connect(function()
		registerFrame.Visible = false
	end)

	-- ProceedButton, Enter key
	proceedButton.MouseButton1Click:Connect(function()
		if enteredPassword then
			Remotes.Role:WaitForChild("RequestAuth"):FireServer(enteredPassword)
		end
	end)
	passwordTextBox.FocusLost:Connect(function(enterPressed)
		enteredPassword = passwordTextBox.Text
		if enterPressed and enteredPassword then
			Remotes.Role:WaitForChild("RequestAuth"):FireServer(enteredPassword)
		end
	end)

	-- TeacherProximityPrompt
	teacherProx.Triggered:Connect(function()
		registerFrame.Visible = true
	end)

	-- Handle AuthResult
	Remotes.Role:WaitForChild("AuthResult").OnClientEvent:Connect(function(result)
		if result then
			roleGui:Destroy()
			teacherPart:Destroy()
		end
	end)
end

return SetRoles_client
