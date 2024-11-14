local LeaderBoardScript = require(script.LeaderBoardScript)
local JeggiMainScript = require(script.JeggiMainScript)
local GameControlScript = require(script.GameControlScript)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes") -- 대기

LeaderBoardScript:Init()
JeggiMainScript:Init()
GameControlScript:Init()
