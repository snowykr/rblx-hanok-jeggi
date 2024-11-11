local JeggiMainScript = {}

function JeggiMainScript:Init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

	local Workspace = game:GetService("Workspace")
	local TweenService = game:GetService("TweenService")

	local jeggiModel = ReplicatedStorage.Models:WaitForChild("Jeggi")
	-- local gongSound = ReplicatedStorage.Sounds:WaitForChild("Gong") -- 사운드 private라서 접근 불가
	local effectTemplate = ReplicatedStorage.Models:WaitForChild("JeggiEffect") -- 이펙트 추가

	-- 플레이어 점수 테이블
	local playerScores = {}

	-- 게임 상태 변수
	local isRaisingJeggi = false -- 제기 상승 중인지 여부

	-- 게임 오버 처리 함수
	function GameOver(player)
		print("Game Over for player: " .. player.Name)

		-- 제기 제거
		for _, jeggi in ipairs(Workspace:GetChildren()) do
			if jeggi.Name == "Jeggi" then
				jeggi:Destroy()
				print("Destroying Jeggi for player: " .. player.Name)
			end
		end
	end

	-- 제기 처리 함수 (낙하와 상승을 통합)
	local function HandleJeggi(player, jeggi, phase)
		-- 제기 낙하 처리 (phase == "drop")
		if phase == "drop" then
			print("Dropping Jeggi for player: " .. player.Name)
			print("Jeggi position at drop: " .. tostring(jeggi.PrimaryPart.Position))

			-- 이펙트 생성
			local effectClone = effectTemplate:Clone()
			effectClone.Position = jeggi.PrimaryPart.Position - Vector3.new(0, 2, 0) -- 낙하 지점에 생성
			effectClone.Parent = Workspace
			game:GetService("Debris"):AddItem(effectClone, 2) -- 2초 후 이펙트 제거

			-- 중력 적용
			local bodyVelocity = jeggi.PrimaryPart:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(0, -10, 0)
			bodyVelocity.Parent = jeggi.PrimaryPart

			-- 3초 후 게임 오버 체크
			wait(2.5)
			local playerPos = player.Character:WaitForChild("HumanoidRootPart").Position
			local jeggiPos = jeggi.PrimaryPart.Position
			jeggiPos = Vector3.new(jeggiPos.X, 0, jeggiPos.Z) -- Y 좌표 고정

			local distance = (playerPos - jeggiPos).Magnitude
			print("Distance: " .. distance)

			if distance > 5 then
				print("Game Over! Player did not reach the jeggi.")
				GameOver(player)
			else
				print("Player reached the jeggi in time!")

				-- Gong 사운드 재생
				-- local gongClone = gongSound:Clone()
				-- gongClone.Parent = Workspace
				-- gongClone:Play()
				-- game:GetService("Debris"):AddItem(gongClone, 2) -- 2초 후 사운드 제거

				-- 점수 1점 추가
				playerScores[player.UserId] = (playerScores[player.UserId] or 0) + 1
				Remotes.Jeggi.ScoreUpdateEvent:FireAllClients(player, playerScores[player.UserId])
				HandleJeggi(player, jeggi, "raise") -- 제기 상승 처리
			end

			-- 제기 상승 처리 (phase == "raise")
		elseif phase == "raise" then
			if isRaisingJeggi then
				return
			end -- 중복 상승 방지
			isRaisingJeggi = true -- 상승 상태로 설정

			print("Raising Jeggi for player: " .. player.Name)

			-- 랜덤한 X, Z 좌표로 상승
			local randomX = math.random(-5, 5)
			local randomZ = math.random(-5, 5)

			-- TweenService로 제기를 상승시킴
			local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
			local targetCFrame = jeggi.PrimaryPart.CFrame + Vector3.new(randomX, 10, randomZ)
			local tween = TweenService:Create(jeggi.PrimaryPart, tweenInfo, { CFrame = targetCFrame })
			tween:Play()

			tween.Completed:Connect(function()
				print("Jeggi raised to a new random position. Dropping Jeggi again...")
				isRaisingJeggi = false -- 상승 종료
				HandleJeggi(player, jeggi, "drop") -- 제기 낙하 처리 다시 호출
			end)
		end
	end

	-- 제기 생성 함수
	local function CreateJeggi(player)
		print("Creating Jeggi for player: " .. player.Name)

		local jeggiClone = jeggiModel:Clone()
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		-- 플레이어 앞에 제기 생성
		jeggiClone:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, 5, -3))
		jeggiClone.Parent = Workspace

		print("PrimaryPart set for Jeggi: " .. jeggiClone.PrimaryPart.Name)
		HandleJeggi(player, jeggiClone, "drop") -- 제기 낙하 시작

		return jeggiClone
	end

	-- 게임 시작 시 점수 초기화
	local function InitializePlayerScore(player)
		playerScores[player.UserId] = 0
	end

	-- 서버가 Jeggi 생성 요청을 받을 때
	Remotes.Jeggi.JeggiCreationEvent.OnServerEvent:Connect(function(player)
		InitializePlayerScore(player)
		CreateJeggi(player)
	end)
end

return JeggiMainScript
