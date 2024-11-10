local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Set the appropriate script based on the player's role
local function onRoleChanged()
	local role = LocalPlayer:GetAttribute("Role")
	if role == "Student" then
		require(script.StudentClient).init()
	elseif role == "Teacher" then
		require(script.TeacherClient).init()
	end
end

LocalPlayer:GetAttributeChangedSignal("Role"):Connect(onRoleChanged)
