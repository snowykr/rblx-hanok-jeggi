local LeaderBoardScript = {}

function LeaderBoardScript:Init()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local Players = game:GetService("Players")

	-- 플레이어 점수 관리
	local playerScores = {}

	-- 플레이어가 접속할 때 점수 초기화
	Players.PlayerAdded:Connect(function(player)
		playerScores[player.UserId] = 0
	end)

	-- 플레이어가 게임을 성공적으로 끝냈을 때 점수 업데이트
	local function updatePlayerScore(player, score)
		if playerScores[player.UserId] then
			playerScores[player.UserId] = score
			-- 클라이언트로 점수 전송
			Remotes.LeaderBoard.LeaderBoardUpdateEvent:FireAllClients(player.Name, score)
		end
	end

	-- 서버에서 점수 업데이트 요청 처리
	Remotes.Jeggi.ScoreUpdateEvent.OnServerEvent:Connect(function(player, newScore)
		print("Updating score for player: " .. player.Name .. " to " .. tostring(newScore))
		updatePlayerScore(player, newScore)
	end)

	-- 플레이어가 퇴장할 때 점수 제거
	Players.PlayerRemoving:Connect(function(player)
		playerScores[player.UserId] = nil
	end)
end

return LeaderBoardScript
