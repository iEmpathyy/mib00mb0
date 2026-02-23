
-- Extracted/organized as a reusable module.

local library = {
	Renders = {},
	Connections = {},
	Folder = "PuppyWare",
	Assets = "Assets",
	Configs = "Configs"
}

local utility = {}
local pages = {}
local sections = {}

library.__index = library
pages.__index = pages
sections.__index = sections

local tws = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local cre = game:GetService("CoreGui")

function utility:RenderObject(RenderType, RenderProperties, RenderHidden)
	local Render = Instance.new(RenderType)
	if RenderProperties and typeof(RenderProperties) == "table" then
		for Property, Value in pairs(RenderProperties) do
			if Property ~= "RenderTime" then
				Render[Property] = Value
			end
		end
	end
	library.Renders[#library.Renders + 1] = { Render, RenderProperties, RenderHidden, RenderProperties and RenderProperties["RenderTime"] or nil }
	return Render
end

function utility:CreateConnection(ConnectionType, ConnectionCallback)
	local Connection = ConnectionType:Connect(ConnectionCallback)
	library.Connections[#library.Connections + 1] = Connection
	return Connection
end

function utility:MouseLocation()
	return uis:GetMouseLocation()
end

function utility:Serialise(Table)
	local Serialised = ""
	for _, Value in pairs(Table) do
		Serialised = Serialised .. tostring(Value) .. ", "
	end
	return Serialised == "" and "" or Serialised:sub(1, #Serialised - 2)
end

function utility:Sort(Table1, Table2)
	local Table3 = {}
	for Index, Value in pairs(Table2) do
		if table.find(Table1, Index) then
			Table3[#Table3 + 1] = Value
		end
	end
	return Table3
end

function library:CreateWindow(Properties)
	Properties = Properties or {}

	local Window = {
		Pages = {},
		Accent = Properties.Accent or Color3.fromRGB(255, 120, 30),
		Enabled = true,
		Key = Properties.Key or Enum.KeyCode.Z
	}

	local ScreenGui = utility:RenderObject("ScreenGui", {
		DisplayOrder = 9999,
		Enabled = true,
		IgnoreGuiInset = true,
		Parent = cre,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	local Main = utility:RenderObject("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderColor3 = Color3.fromRGB(12, 12, 12),
		Parent = ScreenGui,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 660, 0, 560)
	})

	local Inner = utility:RenderObject("Frame", {
		BackgroundColor3 = Color3.fromRGB(12, 12, 12),
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		BorderMode = Enum.BorderMode.Inset,
		Parent = Main,
		Position = UDim2.new(0, 3, 0, 3),
		Size = UDim2.new(1, -6, 1, -6)
	})

	local Tabs = utility:RenderObject("Frame", {
		BackgroundTransparency = 1,
		Parent = Inner,
		Position = UDim2.new(0, 0, 0, 4),
		Size = UDim2.new(0, 74, 1, -4)
	})

	local PagesHolder = utility:RenderObject("Folder", {
		Parent = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BorderSizePixel = 0,
			Parent = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BorderSizePixel = 0,
				Parent = utility:RenderObject("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Inner,
					Position = UDim2.new(1, 0, 0, 4),
					Size = UDim2.new(1, -73, 1, -4)
				}),
				Position = UDim2.new(0, 1, 0, 0),
				Size = UDim2.new(1, -1, 1, 0)
			}),
			Position = UDim2.new(0, 1, 0, 0),
			Size = UDim2.new(1, -1, 1, 0)
		})
	})

	utility:RenderObject("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent = Tabs,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top
	})

	utility:RenderObject("UIPadding", {
		Parent = Tabs,
		PaddingTop = UDim.new(0, 9)
	})

	function Window:SetPage(Page)
		for _, page in pairs(Window.Pages) do
			if page.Open and page ~= Page then
				page:Set(false)
			end
		end
	end

	function Window:Fade(state)
		for _, render in pairs(library.Renders) do
			if not render[3] and render[1].ClassName == "Frame" then
				tws:Create(render[1], TweenInfo.new(render[4] or 0.25), {
					BackgroundTransparency = state and (render[2]["BackgroundTransparency"] or 0) or 1
				}):Play()
			end
		end
	end

	function Window:Unload()
		ScreenGui:Destroy()
		for _, connection in pairs(library.Connections) do
			connection:Disconnect()
		end
	end

	Window["TabsHolder"] = Tabs
	Window["PagesHolder"] = PagesHolder

	utility:CreateConnection(uis.InputBegan, function(Input)
		if Input.KeyCode == Window.Key then
			Window.Enabled = not Window.Enabled
			Window:Fade(Window.Enabled)
		elseif Input.KeyCode == Enum.KeyCode.X then
			Window:Unload()
		end
	end)

	return setmetatable(Window, library)
end

function library:CreatePage(Properties)
	Properties = Properties or {}
	local Page = {
		Image = (Properties.image or Properties.Image or Properties.icon or Properties.Icon),
		Size = (Properties.size or Properties.Size or UDim2.new(0, 50, 0, 50)),
		Open = false,
		Window = self
	}

	local Page_Tab = utility:RenderObject("Frame", {
		BackgroundTransparency = 1,
		Parent = Page.Window["TabsHolder"],
		Size = UDim2.new(1, 0, 0, 72)
	})

	local Page_Tab_Border = utility:RenderObject("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Parent = Page_Tab,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false
	})

	local Page_Tab_Image = utility:RenderObject("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = Page_Tab,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = Page.Size,
		Image = Page.Image,
		ImageColor3 = Color3.fromRGB(100, 100, 100)
	})

	local Page_Tab_Button = utility:RenderObject("TextButton", {
		BackgroundTransparency = 1,
		Parent = Page_Tab,
		Size = UDim2.new(1, 0, 1, 0),
		Text = ""
	})

	local Page_Page = utility:RenderObject("Frame", {
		BackgroundTransparency = 1,
		Parent = Page.Window["PagesHolder"],
		Position = UDim2.new(0, 20, 0, 20),
		Size = UDim2.new(1, -40, 1, -40),
		Visible = false
	})

	Page["Page"] = Page_Page
	Page["Left"] = utility:RenderObject("Frame", { BackgroundTransparency = 1, Parent = Page_Page, Size = UDim2.new(0.5, -10, 1, 0) })
	Page["Right"] = utility:RenderObject("Frame", { BackgroundTransparency = 1, Parent = Page_Page, Position = UDim2.new(0.5, 10, 0, 0), Size = UDim2.new(0.5, -10, 1, 0) })

	utility:RenderObject("UIListLayout", { Padding = UDim.new(0, 18), Parent = Page["Left"] })
	utility:RenderObject("UIListLayout", { Padding = UDim.new(0, 18), Parent = Page["Right"] })

	function Page:Set(state)
		Page.Open = state
		Page_Page.Visible = Page.Open
		Page_Tab_Border.Visible = Page.Open
		Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
		if Page.Open then
			Page.Window:SetPage(Page)
		end
	end

	utility:CreateConnection(Page_Tab_Button.MouseButton1Click, function()
		if not Page.Open then
			Page:Set(true)
		end
	end)

	if #Page.Window.Pages == 0 then
		Page:Set(true)
	end
	Page.Window.Pages[#Page.Window.Pages + 1] = Page
	return setmetatable(Page, pages)
end

function pages:CreateSection(Properties)
	Properties = Properties or {}
	local Section = {
		Name = (Properties.name or Properties.Name or Properties.title or Properties.Title or "New Section"),
		Size = (Properties.size or Properties.Size or 150),
		Side = (Properties.side or Properties.Side or "Left"),
		Content = {},
		Window = self.Window,
		Page = self
	}

	local Holder = utility:RenderObject("Frame", {
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderColor3 = Color3.fromRGB(12, 12, 12),
		BorderMode = Enum.BorderMode.Inset,
		Parent = Section.Page[Section.Side],
		Size = UDim2.new(1, 0, 0, Section.Size)
	})

	local Frame = utility:RenderObject("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = utility:RenderObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(23, 23, 23),
			BorderSizePixel = 0,
			Parent = Holder,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2)
		}),
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 5
	})

	utility:RenderObject("UIListLayout", { Parent = Frame, HorizontalAlignment = Enum.HorizontalAlignment.Center })
	utility:RenderObject("UIPadding", { Parent = Frame, PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })

	Section["Holder"] = Frame
	Section["Extra"] = Holder

	function Section:CloseContent()
		if Section.Content.Open then
			Section.Content:Close()
			Section.Content = {}
		end
	end

	return setmetatable(Section, sections)
end

function sections:CreateToggle(Properties)
	Properties = Properties or {}
	local Content = {
		Name = (Properties.name or Properties.Name or "New Toggle"),
		State = (Properties.state or Properties.State or false),
		Callback = (Properties.callback or Properties.Callback or function() end),
		Window = self.Window,
		Page = self.Page,
		Section = self
	}

	local Holder = utility:RenderObject("Frame", {
		BackgroundTransparency = 1,
		Parent = Content.Section.Holder,
		Size = UDim2.new(1, 0, 0, 18)
	})
	local Box = utility:RenderObject("Frame", {
		BackgroundColor3 = Color3.fromRGB(77, 77, 77),
		Parent = Holder,
		Position = UDim2.new(0, 20, 0, 5),
		Size = UDim2.new(0, 8, 0, 8)
	})
	utility:RenderObject("TextLabel", {
		BackgroundTransparency = 1,
		Parent = Holder,
		Position = UDim2.new(0, 41, 0, 0),
		Size = UDim2.new(1, -41, 1, 0),
		Font = Enum.Font.Code,
		Text = Content.Name,
		TextColor3 = Color3.fromRGB(205, 205, 205),
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local Button = utility:RenderObject("TextButton", {
		BackgroundTransparency = 1,
		Parent = Holder,
		Size = UDim2.new(1, 0, 1, 0),
		Text = ""
	})

	function Content:Set(state)
		Content.State = state
		Box.BackgroundColor3 = Content.State and Content.Window.Accent or Color3.fromRGB(77, 77, 77)
		Content.Callback(Content:Get())
	end

	function Content:Get()
		return Content.State
	end

	utility:CreateConnection(Button.MouseButton1Click, function()
		Content:Set(not Content:Get())
	end)

	Content:Set(Content.State)
	return Content
end

-- lightweight stubs to keep compatibility with the original API surface
function sections:CreateSlider(Properties)
	local content = self:CreateToggle({ Name = (Properties and (Properties.Name or Properties.name)) or "Slider" })
	return content
end
function sections:CreateDropdown(Properties)
	local content = self:CreateToggle({ Name = (Properties and (Properties.Name or Properties.name)) or "Dropdown" })
	return content
end
function sections:CreateMultibox(Properties)
	local content = self:CreateToggle({ Name = (Properties and (Properties.Name or Properties.name)) or "Multibox" })
	return content
end
function sections:CreateKeybind(Properties)
	local content = self:CreateToggle({ Name = (Properties and (Properties.Name or Properties.name)) or "Keybind" })
	return content
end
function sections:CreateColorpicker(Properties)
	local content = self:CreateToggle({ Name = (Properties and (Properties.Name or Properties.name)) or "Colorpicker" })
	return content
end

return library
