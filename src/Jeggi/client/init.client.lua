local InstanceUIScript = require(script:WaitForChild("InstanceUIScript"))
local ClientSideUIScript = require(script:WaitForChild("ClientSideUIScript"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes") -- 대기

InstanceUIScript.init()
ClientSideUIScript.init()
