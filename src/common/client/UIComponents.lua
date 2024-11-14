local UIComponents = {}

-- 속성을 안전하게 설정하는 함수
local function safeSetProperty(instance, prop, value)
	local success, error = pcall(function()
		instance[prop] = value
	end)
	if not success then
		warn(string.format("Failed to set property '%s' on %s: %s", prop, instance.Name, error))
	end
end

-- UICorner 추가 함수
function UIComponents.addUICorner(instance, radius, callback) -- callback 없이 작동하는지 확인 필요, stroke에도 확인
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius or 10)
	uiCorner.Parent = instance

	-- if callback then
	-- 	callback(uiCorner)
	-- end
	return uiCorner
end

-- UIStroke 추가 함수
function UIComponents.addUIStroke(instance, color, callback)
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = typeof(color) == "Color3" and color or Color3.fromRGB(0, 0, 0)
	uiStroke.Thickness = 4
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = instance

	if callback then
		callback(uiStroke)
	end
	return uiStroke
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
	-- 기본 속성 설정
	local default_props = {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
	}

	-- 인스턴스 생성
	local instance = Instance.new(className)

	-- 기본 속성 적용
	for prop, value in pairs(default_props) do
		safeSetProperty(instance, prop, value) -- 작동 확인 필요
	end

	-- 사용자 정의 속성 적용
	for prop, value in pairs(props) do
		if
			prop ~= "Events"
			and prop ~= "MaxTextSize"
			and prop ~= "MinTextSize"
			and prop ~= "CornerRadius"
			and prop ~= "Stroke"
			and prop ~= "FontWeight"
			and instance[prop] ~= nil
		then
			safeSetProperty(instance, prop, value)
		end
	end

	-- FontWeight 설정
	if props.FontWeight then
		local success, error = pcall(function()
			local currentFont = instance.FontFace
			local newFont = Font.new(currentFont.Family, props.FontWeight, currentFont.Style)
			instance.FontFace = newFont
		end)
		if not success then
			warn(string.format("Failed to set FontWeight on %s: %s", instance.Name, error))
		end
	end

	-- 이벤트 연결
	if props.Events then
		for event, event_callback in pairs(props.Events) do
			local success, error = pcall(function()
				if instance[event] then
					instance[event]:Connect(event_callback)
				end
			end)
			if not success then
				warn(string.format("Failed to connect event '%s' on %s: %s", event, instance.Name, error))
			end
		end
	end

	-- UICorner 추가
	if props.CornerRadius then
		UIComponents.addUICorner(instance, props.CornerRadius)
	end

	-- UIStroke 추가
	if props.Stroke then
		UIComponents.addUIStroke(instance, props.Stroke)
	end

	-- UITextSizeConstraint 추가
	if props.MaxTextSize and props.MinTextSize then
		UIComponents.addUITextSizeConstraint(instance, props.MaxTextSize, props.MinTextSize)
	end

	-- 콜백 실행
	if callback then
		local success, error = pcall(callback, instance)
		if not success then
			warn(string.format("Failed to execute callback for %s: %s", instance.Name, error))
		end
	end

	return instance
end

-- 인스턴스 템플릿:
-- scale이 1인 createXX부터, XX 이후의 숫자가 커질수록 scale이 작아짐
-- callback 고려
-- font 정해야 함

-- Function to merge new_props into props for templates
local function mergeProps(original_props, new_props)
	local props = table.clone(original_props)
	if new_props then
		for key, value in pairs(new_props) do
			props[key] = value
		end
	end
	return props
end

-- MainFrame 템플릿
-- M0: Fullscreen MainFrame
function UIComponents.createM0(parent, new_props)
	local default_props = {
		Name = "MainFrame",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = true,
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("Frame", props, function(instance)
		instance.Parent = parent
	end)
end

-- Frame 템플릿
-- F0: Fullscreen Frame
function UIComponents.createF0(parent, new_props)
	local default_props = {
		Name = "F0",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Visible = true,
		CornerRadius = UDim.new(0.03, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("Frame", props, function(instance)
		instance.Parent = parent
	end)
end
-- F1: Frame with 80% width and 70% height
function UIComponents.createF1(parent, new_props)
	local default_props = {
		Name = "F1",
		Size = UDim2.new(0.8, 0, 0.7, 0),
		Position = UDim2.new(0.1, 0, 0.15, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Visible = true,
		CornerRadius = UDim.new(0.05, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("Frame", props, function(instance)
		instance.Parent = parent
	end)
end
-- F2: Frame with 50% width and 50% height
function UIComponents.createF2(parent, new_props)
	local default_props = {
		Name = "F2",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Visible = true,
		CornerRadius = UDim.new(0.07, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("Frame", props, function(instance)
		instance.Parent = parent
	end)
end
-- F3: Frame with 40% width and 50% height
function UIComponents.createF3(parent, new_props)
	local default_props = {
		Name = "F3",
		Size = UDim2.new(0.4, 0, 0.5, 0),
		Position = UDim2.new(0.3, 0, 0.25, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Visible = true,
		CornerRadius = UDim.new(0.07, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("Frame", props, function(instance)
		instance.Parent = parent
	end)
end

-- TextButton 템플릿
-- TB0: TextButton with 100% width and 100% height
function UIComponents.createTB0(parent, new_props)
	local default_props = {
		Name = "TB0",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Text Button",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		Font = Enum.Font.DenkOne,
		MaxTextSize = 70,
		MinTextSize = 10,
		CornerRadius = UDim.new(0.06, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextButton", props, function(instance)
		instance.Parent = parent
	end)
end
-- TB1: TextButton with 50% width and 50% height
function UIComponents.createTB1(parent, new_props)
	local default_props = {
		Name = "TB1",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Text Button",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		Font = Enum.Font.DenkOne,
		MaxTextSize = 70,
		MinTextSize = 10,
		CornerRadius = UDim.new(0.1, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextButton", props, function(instance)
		instance.Parent = parent
	end)
end
-- TB2: TextButton with 20% width and 10% height
function UIComponents.createTB2(parent, new_props)
	local default_props = {
		Name = "TB2",
		Size = UDim2.new(0.2, 0, 0.1, 0),
		Position = UDim2.new(0.4, 0, 0.45, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Text Button",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		Font = Enum.Font.DenkOne,
		MaxTextSize = 70,
		MinTextSize = 10,
		CornerRadius = UDim.new(0.3, 0),
		Stroke = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextButton", props, function(instance)
		instance.Parent = parent
	end)
end

-- EB: ExitButton
function UIComponents.createEB(parent, new_props, mainframe)
	local default_props = {
		Name = "ExitButton",
		Size = UDim2.new(0.049, 0, 0.095, 0),
		Position = UDim2.new(0.94, 0, 0, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Text = "X",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(0, 0, 0),
	}
	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextButton", props, function(instance)
		instance.Parent = parent
		instance.MouseButton1Click:Connect(function()
			mainframe.Visible = false
		end)
	end)
end

-- TextLabel 템플릿
-- TL0: TextLabel with 100% width and 100% height
function UIComponents.createTL0(parent, new_props)
	local default_props = {
		Name = "TL0",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Text = "Text Label",
		Font = Enum.Font.TitilliumWeb,
		TextTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	}

	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextLabel", props, function(instance)
		instance.Parent = parent
	end)
end
-- TL1: TextLabel with 50% width and 50% height
function UIComponents.createTL1(parent, new_props)
	local default_props = {
		Name = "TL1",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.25, 0, 0.25, 0),
		Text = "Text Label",
		Font = Enum.Font.TitilliumWeb,
		TextTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	}

	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextLabel", props, function(instance)
		instance.Parent = parent
	end)
end
-- TL2: TextLabel with 20% width and 10% height
function UIComponents.createTL2(parent, new_props)
	local default_props = {
		Name = "TL2",
		Size = UDim2.new(0.2, 0, 0.1, 0),
		Position = UDim2.new(0.4, 0, 0.45, 0),
		Text = "Text Label",
		Font = "Bangers",
		TextTransparency = 0,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	}

	local props = mergeProps(default_props, new_props)

	return UIComponents.create("TextLabel", props, function(instance)
		instance.Parent = parent
	end)
end

return UIComponents
