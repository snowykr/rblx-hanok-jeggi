local UIComponents = {}

-- 기본 속성 설정
local defaultProps = {
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
}

-- UICorner 추가 함수
function UIComponents.addUICorner(instance, radius, callback)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius or 10)
	uiCorner.Parent = instance

	if callback then
		callback(uiCorner)
	end
	return uiCorner
end

-- UITextSizeConstraint 추가 함수
function UIComponents.addUITextSizeConstraint(instance, maxSize, minSize, callback)
	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
	uiTextSizeConstraint.MaxTextSize = maxSize
	uiTextSizeConstraint.MinTextSize = minSize
	uiTextSizeConstraint.Parent = instance

	if callback then
		callback(uiTextSizeConstraint)
	end
	return uiTextSizeConstraint
end

-- AspectRatioConstraint 추가 함수
function UIComponents.setAspectRatio(instance, ratio)
	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.AspectRatio = ratio
	aspectRatio.Parent = instance
end

-- 기본 인스턴스 생성 함수
function UIComponents.create(className, props, callback)
	local instance = Instance.new(className)

	-- 기본 속성 적용
	for prop, value in pairs(defaultProps) do
		if instance[prop] ~= nil then
			instance[prop] = props[prop] or value
		end
	end

	-- 사용자 정의 속성 적용
	for prop, value in pairs(props) do
		if
			prop ~= "Events"
			and prop ~= "MaxTextSize"
			and prop ~= "MinTextSize"
			and prop ~= "CornerRadius"
			and prop ~= "FontWeight"
			and instance[prop] ~= nil
		then
			instance[prop] = value
		end
	end

	-- FontWeight 설정
	if props.FontWeight then
		local currentFont = instance.FontFace
		local newFont = Font.new(currentFont.Family, props.FontWeight, currentFont.Style)
		instance.FontFace = newFont
	end

	-- 이벤트 연결
	if props.Events then
		for event, callback in pairs(props.Events) do
			if instance[event] then
				instance[event]:Connect(callback)
			end
		end
	end

	-- UICorner 추가
	if props.CornerRadius then
		UIComponents.addUICorner(instance, props.CornerRadius)
	end

	-- UITextSizeConstraint 추가
	if props.MaxTextSize and props.MinTextSize then
		UIComponents.addUITextSizeConstraint(instance, props.MaxTextSize, props.MinTextSize)
	end

	-- 콜백 실행
	if callback then
		callback(instance)
	end

	return instance
end

local radius = UDim.new(0, 20)
-- 메인 UI 생성 함수
function UIComponents.CreateMainUI(player)
	local playerGui = player.PlayerGui
end

return UIComponents
