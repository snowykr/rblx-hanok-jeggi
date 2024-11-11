local LeaderBoardScript = require(script.LeaderBoardScript)
local JeggiMainScript = require(script.JeggiMainScript)
local GameControlScript = require(script.GameControlScript)
local EffectControlScript = require(script.EffectControlScript)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes") -- 대기

LeaderBoardScript:Init()
JeggiMainScript:Init()
GameControlScript:Init()
EffectControlScript:Init()
