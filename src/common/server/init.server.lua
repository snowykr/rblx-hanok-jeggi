local SetRoles_server = require(script.SetRoles_server)
local SetRemotes = require(script.SetRemotes)

SetRemotes.init()
SetRoles_server.init()

wait(7)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
Remotes.Notify.NotifyEvent:FireAllClients("game initialized")
