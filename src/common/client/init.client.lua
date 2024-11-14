game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local Loading = require(script.Loading)

Loading.modulesToLoad = {
	script.UIComponents,
	script.Notify,
	script.SetRoles_client,
	script.Log,
	script.RankingBoard,
}

Loading.assetsToPreload = {}

Loading:Init()
