game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local Loading = require(script.Loading)

Loading.modulesToInit = {
	script.Notify,
	script.SetRoles_client,
	script.Log,
	script.RankingBoard,
}

Loading.assetsToPreload = {}

Loading:Init()
