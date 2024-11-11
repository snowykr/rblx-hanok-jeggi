local EffectControlScript = {}

function EffectControlScript:Init()
	local function CreateEffect(position)
		local effect = Instance.new("Part")
		effect.Size = Vector3.new(5, 0.1, 5)
		effect.Anchored = true
		effect.Position = position
		effect.Transparency = 0.5
		effect.BrickColor = BrickColor.new("Bright yellow")
		effect.Parent = game.Workspace

		-- 일정 시간이 지나면 이펙트 제거
		game:GetService("Debris"):AddItem(effect, 2)
	end

	return CreateEffect
end

return EffectControlScript
