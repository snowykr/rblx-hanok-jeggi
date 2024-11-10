local SetRoles_server = {}

local correctPassword = "abc1981"

function SetRoles_server.init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local Players = game:GetService("Players")
	-- 선생님 유저 저장
	local function SetTeacher(Player)
		Player:SetAttribute("Role", "Teacher")
	end
	-- 학생 유저 저장
	local function SetStudent(Player)
		Player:SetAttribute("Role", "Student")
	end
	-- 전송받은 비밀번호로 인증 후 결과 전송
	Remotes.Role.RequestAuth.OnServerEvent:Connect(function(Player, enteredPassword)
		if enteredPassword == correctPassword then
			Remotes.Role.AuthResult:FireAllClients(true) -- 인증 성공 메시지 전송
			Remotes.Notify.NotifyEvent:FireClient(Player, "Registered as a Teacher")
			SetTeacher(Player)
			-- 다른 모든 유저를 Student로 설정
			for _, otherPlayer in pairs(Players:GetPlayers()) do
				if otherPlayer ~= Player then
					SetStudent(otherPlayer)
				end
			end
			Remotes.Role:Destroy()
		else
			Remotes.Role.AuthResult:FireAllClients(false) -- 인증 실패 메시지 전송
			Remotes.Notify.NotifyEvent:FireClient(Player, "Incorrect password")
		end
	end)
end

return SetRoles_server
