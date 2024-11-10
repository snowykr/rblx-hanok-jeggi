game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local Loading = require(script.Loading)

Loading.modulesToLoad = {
	script.Notify,
	script.SetRoles_client,
	script.Log,
}

Loading.assetsToPreload = {}

Loading:Init()
