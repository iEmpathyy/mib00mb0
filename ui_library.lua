-- [[ // Error Handling // ]]
local Passed, Statement = pcall(function()
	-- [[ // Libraries // ]]
	local library = {
		Renders = {},
		Connections = {},
		Folder = "PuppyWare",
		Assets = "Assets",
		Configs = "Configs"
	}
	local utility = {}
	-- [[ // Tables // ]]
	local pages = {}
	local sections = {}
	-- [[ // Indexes // ]]
	do
		library.__index = library
		pages.__index = pages
		sections.__index = sections
	end
	-- [[ // Variables // ]] 
	local uis = game:GetService("UserInputService")
	local hs = game:GetService("HttpService")
	local cre = game:GetService("CoreGui")
	local plr = game:GetService("Players").LocalPlayer
	
	-- [[ // Functions // ]]
	function utility:RenderObject(RenderType, RenderProperties)
		local Render = Instance.new(RenderType)
		--
		if RenderProperties and typeof(RenderProperties) == "table" then
			for Property, Value in pairs(RenderProperties) do
				pcall(function()
					Render[Property] = Value
				end)
			end
		end
		--
		Render.Name = hs:GenerateGUID(false)
		library.Renders[#library.Renders + 1] = Render
		--
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
		for Index, Value in pairs(Table) do
			Serialised = Serialised .. Value .. ", "
		end
		return Serialised:sub(0, #Serialised - 2)
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
	
	-- [[ // UI Functions // ]]
	function library:CreateWindow(Properties)
		Properties = Properties or {}
		
		local Window = {
			Pages = {},
			Accent = Properties.accent or Color3.fromRGB(255, 120, 30),
			Enabled = true,
			Dragging = false,
			DragOffset = Vector2.new(0, 0),
			MinSize = Properties.minSize or Vector2.new(400, 300),
			MaxSize = Properties.maxSize or Vector2.new(1920, 1080)
		}
		
		do
			local ScreenGui = utility:RenderObject("ScreenGui", {
				DisplayOrder = 9999,
				Enabled = true,
				IgnoreGuiInset = true,
				Parent = cre,
				ResetOnSpawn = false,
				ZIndexBehavior = "Global"
			})
			
			-- Main Frame
			local ScreenGui_MainFrame = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(25, 25, 25),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(12, 12, 12),
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				Parent = ScreenGui,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 660, 0, 560)
			})
			
			-- Drag Handle (seluruh frame bisa di-drag)
			local DragHandle = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = ScreenGui_MainFrame,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 999
			})
			
			-- Inner Border
			local ScreenGui_MainFrame_InnerBorder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = ScreenGui_MainFrame,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2)
			})
			
			-- Inner Frame
			local MainFrame_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(60, 60, 60),
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				Parent = ScreenGui_MainFrame,
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(1, -6, 1, -6)
			})
			
			-- Tabs Section
			local InnerBorder_InnerFrame_Tabs = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 4),
				Size = UDim2.new(0, 74, 1, -4)
			})
			
			-- Pages Section
			local InnerBorder_InnerFrame_Pages = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(1, 0, 0, 4),
				Size = UDim2.new(1, -73, 1, -4)
			})
			
			-- Top Gradient
			local InnerBorder_InnerFrame_TopGradient = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = MainFrame_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 4)
			})
			
			-- Tabs List Layout
			local InnerFrame_Tabs_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 4),
				Parent = InnerBorder_InnerFrame_Tabs,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
			
			-- Tabs Padding
			local InnerFrame_Tabs_Padding = utility:RenderObject("UIPadding", {
				Parent = InnerBorder_InnerFrame_Tabs,
				PaddingTop = UDim.new(0, 9)
			})
			
			-- Pages Inner Border
			local InnerFrame_Pages_InnerBorder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerBorder_InnerFrame_Pages,
				Position = UDim2.new(0, 1, 0, 0),
				Size = UDim2.new(1, -1, 1, 0)
			})
			
			-- Top Gradient Image
			local InnerFrame_TopGradient_Gradient = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerBorder_InnerFrame_TopGradient,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				Image = "rbxassetid://8508019876",
				ImageColor3 = Color3.fromRGB(255, 255, 255)
			})
			
			-- Pages Inner Frame
			local Pages_InnerBorder_InnerFrame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = InnerFrame_Pages_InnerBorder,
				Position = UDim2.new(0, 1, 0, 0),
				Size = UDim2.new(1, -1, 1, 0)
			})
			
			-- Pages Folder
			local InnerBorder_InnerFrame_Folder = utility:RenderObject("Folder", {
				Parent = Pages_InnerBorder_InnerFrame
			})
			
			-- Background Pattern
			local InnerBorder_InnerFrame_Pattern = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Pages_InnerBorder_InnerFrame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Image = "rbxassetid://8547666218",
				ImageColor3 = Color3.fromRGB(12, 12, 12),
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 8, 0, 8)
			})
			
			-- [[ // Drag Function (Smooth) // ]]
			local function startDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Window.Dragging = true
					local mousePos = uis:GetMouseLocation()
					local objPos = ScreenGui_MainFrame.AbsolutePosition
					Window.DragOffset = mousePos - objPos
				end
			end
			
			local function updateDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and Window.Dragging and Window.DragOffset then
					local mousePos = uis:GetMouseLocation()
					local newPos = mousePos - Window.DragOffset
					ScreenGui_MainFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
				end
			end
			
			local function stopDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Window.Dragging = false
					Window.DragOffset = nil
				end
			end
			
			-- [[ // Connections for Drag // ]]
			utility:CreateConnection(DragHandle.InputBegan, startDrag)
			utility:CreateConnection(uis.InputChanged, updateDrag)
			utility:CreateConnection(uis.InputEnded, stopDrag)
			
			-- [[ // Window Functions // ]]
			function Window:SetPage(Page)
				for index, page in pairs(Window.Pages) do
					if page.Open and page ~= Page then
						page:Set(false)
					end
				end
			end
			
			function Window:Unload()
				ScreenGui:Remove()
				for index, connection in pairs(library.Connections) do
					pcall(function()
						connection:Disconnect()
					end)
				end
				library.Renders = {}
				library.Connections = {}
			end
			
			-- [[ // Index Setting // ]]
			Window["TabsHolder"] = InnerBorder_InnerFrame_Tabs
			Window["PagesHolder"] = InnerBorder_InnerFrame_Folder
			Window["MainFrame"] = ScreenGui_MainFrame
			Window["ScreenGui"] = ScreenGui
		end
		
		return setmetatable(Window, library)
	end
	
	-- [[ // Page Functions // ]]
	function library:CreatePage(Properties)
		Properties = Properties or {}
		
		local Page = {
			Name = Properties.name or "Page",
			Image = Properties.image or Properties.icon or "rbxassetid://8547236654",
			Size = Properties.size or UDim2.new(0, 50, 0, 50),
			Open = false,
			Window = self
		}
		
		do
			local Page_Tab = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page.Window["TabsHolder"],
				Size = UDim2.new(1, 0, 0, 72)
			})
			
			local Page_Tab_Border = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = false,
				ZIndex = 2
			})
			
			local Page_Tab_Image = utility:RenderObject("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = Page.Size,
				ZIndex = 2,
				Image = Page.Image,
				ImageColor3 = Color3.fromRGB(100, 100, 100)
			})
			
			local Page_Tab_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Tab_Border_Inner = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Tab_Border,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 1, 1, -2),
				ZIndex = 2
			})
			
			local Border_Inner_Inner = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Tab_Border_Inner,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 0, 1, -2),
				ZIndex = 2
			})
			
			local Inner_Inner_Pattern = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Border_Inner_Inner,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Image = "rbxassetid://8509210785",
				ImageColor3 = Color3.fromRGB(12, 12, 12),
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 8, 0, 8),
				ZIndex = 2
			})
			
			local Page_Page = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page.Window["PagesHolder"],
				Position = UDim2.new(0, 20, 0, 20),
				Size = UDim2.new(1, -40, 1, -40),
				Visible = false
			})
			
			local Page_Page_Left = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Page,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			
			local Page_Page_Right = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Page_Page,
				Position = UDim2.new(0.5, 10, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			
			local Page_Left_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = Page_Page_Left,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
			
			local Page_Right_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = Page_Page_Right,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
			
			Page["Page"] = Page_Page
			Page["Left"] = Page_Page_Left
			Page["Right"] = Page_Page_Right
			
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
			
			utility:CreateConnection(Page_Tab_Button.MouseEnter, function()
				Page_Tab_Image.ImageColor3 = Color3.fromRGB(172, 172, 172)
			end)
			
			utility:CreateConnection(Page_Tab_Button.MouseLeave, function()
				Page_Tab_Image.ImageColor3 = Page.Open and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
			end)
		end
		
		if #Page.Window.Pages == 0 then Page:Set(true) end
		Page.Window.Pages[#Page.Window.Pages + 1] = Page
		return setmetatable(Page, pages)
	end
	
	-- [[ // Section Functions // ]]
	function pages:CreateSection(Properties)
		Properties = Properties or {}
		
		local Section = {
			Name = Properties.name or "New Section",
			Size = Properties.size or 150,
			Side = Properties.side or "Left",
			Content = {},
			Window = self.Window,
			Page = self
		}
		
		do
			local Section_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(12, 12, 12),
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				Parent = Section.Page[Section.Side],
				Size = UDim2.new(1, 0, 0, Section.Size),
				ZIndex = 2
			})
			
			local Section_Holder_Extra = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 2
			})
			
			local Section_Holder_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 2
			})
			
			local Section_Holder_TitleInline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 9, 0, -1),
				Size = UDim2.new(0, 0, 0, 2),
				ZIndex = 5
			})
			
			local Section_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -26, 0, 15),
				ZIndex = 5,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "<b>" .. Section.Name .. "</b>",
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 11,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Holder_Extra_Gradient1 = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 1, 0, 1),
				Rotation = 180,
				Size = UDim2.new(1, -2, 0, 20),
				Visible = false,
				ZIndex = 4,
				Image = "rbxassetid://7783533907",
				ImageColor3 = Color3.fromRGB(23, 23, 23)
			})
			
			local Holder_Extra_Gradient2 = utility:RenderObject("ImageLabel", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, -2, 0, 20),
				Visible = false,
				ZIndex = 4,
				Image = "rbxassetid://7783533907",
				ImageColor3 = Color3.fromRGB(23, 23, 23)
			})
			
			local Holder_Extra_ArrowUp = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, -21, 0, 0),
				Size = UDim2.new(0, 7 + 8, 0, 6 + 8),
				Text = "",
				Visible = false,
				ZIndex = 4
			})
			
			local Holder_Extra_ArrowDown = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, -21, 1, -(6 + 8)),
				Size = UDim2.new(0, 7 + 8, 0, 6 + 8),
				Text = "",
				Visible = false,
				ZIndex = 4
			})
			
			local Extra_ArrowUp_Image = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Extra_ArrowUp,
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 7, 0, 6),
				Visible = true,
				ZIndex = 4,
				Image = "rbxassetid://8548757311",
				ImageColor3 = Color3.fromRGB(205, 205, 205)
			})
			
			local Extra_ArrowDown_Image = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Extra_ArrowDown,
				Position = UDim2.new(0, 4, 0, 4),
				Size = UDim2.new(0, 7, 0, 6),
				Visible = true,
				ZIndex = 4,
				Image = "rbxassetid://8548723563",
				ImageColor3 = Color3.fromRGB(205, 205, 205)
			})
			
			local Holder_Extra_Bar = utility:RenderObject("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 6, 1, 0),
				Visible = false,
				ZIndex = 4
			})
			
			local Holder_Extra_Line = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Extra,
				Position = UDim2.new(0, 0, 0, -1),
				Size = UDim2.new(1, 0, 0, 1),
				ZIndex = 4
			})
			
			local Holder_Frame_ContentHolder = utility:RenderObject("ScrollingFrame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Section_Holder_Frame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 4,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BottomImage = "rbxassetid://7783554086",
				CanvasSize = UDim2.new(0, 0, 0, 0),
				MidImage = "rbxassetid://7783554086",
				ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
				ScrollBarImageTransparency = 0,
				ScrollBarThickness = 5,
				TopImage = "rbxassetid://7783554086",
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			})
			
			local Frame_ContentHolder_List = utility:RenderObject("UIListLayout", {
				Padding = UDim.new(0, 0),
				Parent = Holder_Frame_ContentHolder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
			
			local Frame_ContentHolder_Padding = utility:RenderObject("UIPadding", {
				Parent = Holder_Frame_ContentHolder,
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15)
			})
			
			Section_Holder_TitleInline.Size = UDim2.new(0, Section_Holder_Title.TextBounds.X + 6, 0, 2)
			
			Section["Holder"] = Holder_Frame_ContentHolder
			Section["Extra"] = Section_Holder_Extra
			
			function Section:CloseContent()
				if Section.Content and Section.Content.Close then
					Section.Content:Close()
					Section.Content = {}
				end
			end
			
			utility:CreateConnection(Holder_Frame_ContentHolder:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
				Holder_Extra_Gradient1.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
				Holder_Extra_Gradient2.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
				Holder_Extra_Bar.Visible = Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y
				
				if (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y > Holder_Frame_ContentHolder.AbsoluteWindowSize.Y) then
					Holder_Extra_ArrowUp.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y > 5)
					Holder_Extra_ArrowDown.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y + 5 < (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
				end
			end)
			
			utility:CreateConnection(Holder_Frame_ContentHolder:GetPropertyChangedSignal("CanvasPosition"), function()
				if Section.Content and Section.Content.Close then
					Section.Content:Close()
					Section.Content = {}
				end
				Holder_Extra_ArrowUp.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y > 1)
				Holder_Extra_ArrowDown.Visible = (Holder_Frame_ContentHolder.CanvasPosition.Y + 1 < (Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
			end)
			
			utility:CreateConnection(Holder_Extra_ArrowUp.MouseButton1Click, function()
				Holder_Frame_ContentHolder.CanvasPosition = Vector2.new(0, math.clamp(Holder_Frame_ContentHolder.CanvasPosition.Y - 10, 0, Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
			end)
			
			utility:CreateConnection(Holder_Extra_ArrowDown.MouseButton1Click, function()
				Holder_Frame_ContentHolder.CanvasPosition = Vector2.new(0, math.clamp(Holder_Frame_ContentHolder.CanvasPosition.Y + 10, 0, Holder_Frame_ContentHolder.AbsoluteCanvasSize.Y - Holder_Frame_ContentHolder.AbsoluteSize.Y))
			end)
		end
		
		return setmetatable(Section, sections)
	end
	
	-- [[ // Content Functions // ]]
	function sections:CreateToggle(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or "New Toggle",
			State = Properties.state or Properties.default or false,
			Callback = Properties.callback or function() end,
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, 8 + 10),
				ZIndex = 3
			})
			
			local Content_Holder_Outline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 20, 0, 5),
				Size = UDim2.new(0, 8, 0, 8),
				ZIndex = 3
			})
			
			local Content_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Holder_Outline_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(77, 77, 77),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder_Outline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 3
			})
			
			local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140)),
				Enabled = true,
				Rotation = 90,
				Parent = Holder_Outline_Frame
			})
			
			function Content:Set(state)
				Content.State = state
				Holder_Outline_Frame.BackgroundColor3 = Content.State and Content.Window.Accent or Color3.fromRGB(77, 77, 77)
				Content.Callback(Content:Get())
			end
			
			function Content:Get()
				return Content.State
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function()
				Content:Set(not Content:Get())
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180))
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140))
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	function sections:CreateSlider(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or nil,
			State = Properties.state or Properties.default or 0,
			Min = Properties.min or 0,
			Max = Properties.max or 100,
			Suffix = Properties.suffix or "",
			Decimals = 1 / (Properties.decimals or 1),
			Callback = Properties.callback or function() end,
			Holding = false,
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, (Content.Name and 24 or 13) + 5),
				ZIndex = 3
			})
			
			local Content_Holder_Outline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 40, 0, Content.Name and 18 or 5),
				Size = UDim2.new(1, -99, 0, 7),
				ZIndex = 3
			})
			
			if Content.Name then
				local Content_Holder_Title = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = Enum.Font.Code,
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Holder,
					Position = UDim2.new(0, 41, 0, 4),
					Size = UDim2.new(1, -41, 0, 10),
					ZIndex = 3,
					Font = Enum.Font.Code,
					RichText = true,
					Text = Content.Name,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextSize = 9,
					TextStrokeTransparency = 1,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			end
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Holder_Outline_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(71, 71, 71),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder_Outline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 3
			})
			
			local Outline_Frame_Slider = utility:RenderObject("Frame", {
				BackgroundColor3 = Content.Window.Accent,
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 0, 1, 0),
				ZIndex = 3
			})
			
			local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175)),
				Enabled = true,
				Rotation = 270,
				Parent = Holder_Outline_Frame
			})
			
			local Frame_Slider_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175)),
				Enabled = true,
				Rotation = 90,
				Parent = Outline_Frame_Slider
			})
			
			local Frame_Slider_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Outline_Frame_Slider,
				Position = UDim2.new(1, 0, 0.5, 1),
				Size = UDim2.new(0, 2, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 11,
				TextStrokeTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Center
			})
			
			local Frame_Slider_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Outline_Frame_Slider,
				Position = UDim2.new(1, 0, 0.5, 1),
				Size = UDim2.new(0, 2, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 11,
				TextStrokeTransparency = 0.5,
				TextTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Center
			})
			
			function Content:Set(state)
				Content.State = math.clamp(math.round(state * Content.Decimals) / Content.Decimals, Content.Min, Content.Max)
				Frame_Slider_Title.Text = "<b>" .. Content.State .. Content.Suffix .. "</b>"
				Outline_Frame_Slider.Size = UDim2.new((1 - ((Content.Max - Content.State) / (Content.Max - Content.Min))), 0, 1, 0)
				Content.Callback(Content:Get())
			end
			
			function Content:Refresh()
				local Mouse = utility:MouseLocation()
				local relativeX = math.clamp(Mouse.X - Holder_Outline_Frame.AbsolutePosition.X, 0, Holder_Outline_Frame.AbsoluteSize.X)
				local percent = relativeX / Holder_Outline_Frame.AbsoluteSize.X
				local value = Content.Min + (Content.Max - Content.Min) * percent
				Content:Set(value)
			end
			
			function Content:Get()
				return Content.State
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function()
				Content:Refresh()
				Content.Holding = true
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
				Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
				Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 215, 215))
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Content.Holding and Color3.fromRGB(215, 215, 215) or Color3.fromRGB(175, 175, 175))
				Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Content.Holding and Color3.fromRGB(215, 215, 215) or Color3.fromRGB(175, 175, 175))
			end)
			
			utility:CreateConnection(uis.InputChanged, function(Input)
				if Content.Holding then
					Content:Refresh()
				end
			end)
			
			utility:CreateConnection(uis.InputEnded, function(Input)
				if Content.Holding and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Content.Holding = false
					Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175))
					Frame_Slider_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(175, 175, 175))
				end
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	function sections:CreateDropdown(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or "New Dropdown",
			State = Properties.state or Properties.default or 1,
			Options = Properties.options or {"Option 1", "Option 2", "Option 3"},
			Callback = Properties.callback or function() end,
			Content = {Open = false},
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, 34 + 5),
				ZIndex = 3
			})
			
			local Content_Holder_Outline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 40, 0, 15),
				Size = UDim2.new(1, -98, 0, 20),
				ZIndex = 3
			})
			
			local Content_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 4),
				Size = UDim2.new(1, -41, 0, 10),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 4),
				Size = UDim2.new(1, -41, 0, 10),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Holder_Outline_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(36, 36, 36),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder_Outline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 3
			})
			
			local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
				Enabled = true,
				Rotation = 270,
				Parent = Holder_Outline_Frame
			})
			
			local Outline_Frame_Title = utility:RenderObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(155, 155, 155),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Outline_Frame_Title2 = utility:RenderObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(155, 155, 155),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Outline_Frame_Arrow = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(1, -11, 0.5, -4),
				Size = UDim2.new(0, 7, 0, 6),
				Image = "rbxassetid://8532000591",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3
			})
			
			function Content:Set(state)
				Content.State = state
				Outline_Frame_Title.Text = Content.Options[Content:Get()]
				Outline_Frame_Title2.Text = Content.Options[Content:Get()]
				Content.Callback(Content:Get())
				if Content.Content and Content.Content.Refresh then
					Content.Content:Refresh()
				end
			end
			
			function Content:Get()
				return Content.State
			end
			
			function Content:Open()
				Content.Section:CloseContent()
				
				local Open = {}
				local Connections = {}
				local InputCheck
				
				local Content_Open_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Extra,
					Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 21),
					Size = UDim2.new(1, -98, 0, (18 * #Content.Options) + 2),
					ZIndex = 6
				})
				
				local Open_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Open_Holder,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 6
				})
				
				local Open_Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 6
				})
				
				for Index, Option in ipairs(Content.Options) do
					local Outline_Frame_Option = utility:RenderObject("Frame", {
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BackgroundTransparency = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Open_Holder_Outline_Frame,
						Position = UDim2.new(0, 0, 0, 18 * (Index - 1)),
						Size = UDim2.new(1, 0, 1 / #Content.Options, 0),
						ZIndex = 6
					})
					
					local Frame_Option_Title = utility:RenderObject("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 6,
						Font = Enum.Font.Code,
						RichText = true,
						Text = tostring(Option),
						TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local Frame_Option_Title2 = utility:RenderObject("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 6,
						Font = Enum.Font.Code,
						RichText = true,
						Text = tostring(Option),
						TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local Frame_Option_Button = utility:RenderObject("TextButton", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 6
					})
					
					local Clicked = utility:CreateConnection(Frame_Option_Button.MouseButton1Click, function()
						Content:Set(Index)
					end)
					
					local Entered = utility:CreateConnection(Frame_Option_Button.MouseEnter, function()
						Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end)
					
					local Left = utility:CreateConnection(Frame_Option_Button.MouseLeave, function()
						Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					end)
					
					table.insert(Connections, Clicked)
					table.insert(Connections, Entered)
					table.insert(Connections, Left)
					
					Open[Index] = {Index, Frame_Option_Title, Frame_Option_Title2, Outline_Frame_Option, Frame_Option_Button}
				end
				
				function Content.Content:Close()
					Content.Content.Open = false
					Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
					
					for _, Connection in ipairs(Connections) do
						Connection:Disconnect()
					end
					
					if InputCheck then InputCheck:Disconnect() end
					
					for _, Objects in pairs(Open) do
						Objects[2]:Destroy()
						Objects[3]:Destroy()
						Objects[4]:Destroy()
						Objects[5]:Destroy()
					end
					
					Content_Open_Holder:Destroy()
					Open_Holder_Outline:Destroy()
					Open_Holder_Outline_Frame:Destroy()
					
					Content.Content.Refresh = nil
					Connections = nil
					Open = nil
				end
				
				function Content.Content:Refresh()
					for Index, Objects in pairs(Open) do
						Objects[2].TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
						Objects[3].TextColor3 = Index == Content.State and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
					end
				end
				
				Content.Content.Open = true
				Content.Section.Content = Content.Content
				Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
				
				task.wait()
				
				InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
					if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
						local Mouse = utility:MouseLocation()
						local withinBounds = Mouse.X > Content_Open_Holder.AbsolutePosition.X and 
										  Mouse.Y > Content_Open_Holder.AbsolutePosition.Y and 
										  Mouse.X < Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X and 
										  Mouse.Y < Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y
						
						if not withinBounds then
							Content.Section:CloseContent()
						end
					end
				end)
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function()
				if Content.Content.Open then
					Content.Section:CloseContent()
				else
					Content:Open()
				end
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Holder_Outline_Frame.BackgroundColor3 = Content.Content.Open and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(36, 36, 36)
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	function sections:CreateMultibox(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or "New Multibox",
			State = Properties.state or Properties.default or {},
			Options = Properties.options or {"Option 1", "Option 2", "Option 3"},
			Minimum = Properties.min or 0,
			Maximum = Properties.max or #(Properties.options or {}),
			Callback = Properties.callback or function() end,
			Content = {Open = false},
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, 34 + 5),
				ZIndex = 3
			})
			
			local Content_Holder_Outline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 40, 0, 15),
				Size = UDim2.new(1, -98, 0, 20),
				ZIndex = 3
			})
			
			local Content_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 4),
				Size = UDim2.new(1, -41, 0, 10),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 4),
				Size = UDim2.new(1, -41, 0, 10),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Holder_Outline_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(36, 36, 36),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder_Outline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 3
			})
			
			local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
				Enabled = true,
				Rotation = 270,
				Parent = Holder_Outline_Frame
			})
			
			local Outline_Frame_Title = utility:RenderObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(155, 155, 155),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Outline_Frame_Title2 = utility:RenderObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(155, 155, 155),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Outline_Frame_Arrow = utility:RenderObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Holder_Outline_Frame,
				Position = UDim2.new(1, -11, 0.5, -4),
				Size = UDim2.new(0, 7, 0, 6),
				Image = "rbxassetid://8532000591",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3
			})
			
			function Content:Set(state)
				table.sort(state)
				Content.State = state
				
				local selected = {}
				for _, index in ipairs(Content.State) do
					table.insert(selected, Content.Options[index])
				end
				
				local text = #selected > 0 and utility:Serialise(selected) or "-"
				Outline_Frame_Title.Text = text
				Outline_Frame_Title2.Text = text
				
				Content.Callback(Content:Get())
				if Content.Content and Content.Content.Refresh then
					Content.Content:Refresh()
				end
			end
			
			function Content:Get()
				return Content.State
			end
			
			function Content:Open()
				Content.Section:CloseContent()
				
				local Open = {}
				local Connections = {}
				local InputCheck
				
				local Content_Open_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Extra,
					Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 21),
					Size = UDim2.new(1, -98, 0, (18 * #Content.Options) + 2),
					ZIndex = 6
				})
				
				local Open_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content_Open_Holder,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 6
				})
				
				local Open_Holder_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(21, 21, 21),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 6
				})
				
				for Index, Option in ipairs(Content.Options) do
					local Outline_Frame_Option = utility:RenderObject("Frame", {
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BackgroundTransparency = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Open_Holder_Outline_Frame,
						Position = UDim2.new(0, 0, 0, 18 * (Index - 1)),
						Size = UDim2.new(1, 0, 1 / #Content.Options, 0),
						ZIndex = 6
					})
					
					local Frame_Option_Title = utility:RenderObject("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 6,
						Font = Enum.Font.Code,
						RichText = true,
						Text = tostring(Option),
						TextColor3 = table.find(Content.State, Index) and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local Frame_Option_Title2 = utility:RenderObject("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 6,
						Font = Enum.Font.Code,
						RichText = true,
						Text = tostring(Option),
						TextColor3 = table.find(Content.State, Index) and Content.Window.Accent or Color3.fromRGB(205, 205, 205),
						TextSize = 9,
						TextStrokeTransparency = 1,
						TextTransparency = 0.5,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					
					local Frame_Option_Button = utility:RenderObject("TextButton", {
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Parent = Outline_Frame_Option,
						Size = UDim2.new(1, 0, 1, 0),
						Text = "",
						ZIndex = 6
					})
					
					local Clicked = utility:CreateConnection(Frame_Option_Button.MouseButton1Click, function()
						local NewTable = {}
						for _, v in ipairs(Content.State) do
							table.insert(NewTable, v)
						end
						
						local pos = table.find(NewTable, Index)
						if pos then
							if #NewTable - 1 >= Content.Minimum then
								table.remove(NewTable, pos)
							end
						else
							if #NewTable + 1 <= Content.Maximum then
								table.insert(NewTable, Index)
							end
						end
						
						Content:Set(NewTable)
					end)
					
					local Entered = utility:CreateConnection(Frame_Option_Button.MouseEnter, function()
						Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end)
					
					local Left = utility:CreateConnection(Frame_Option_Button.MouseLeave, function()
						Outline_Frame_Option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					end)
					
					table.insert(Connections, Clicked)
					table.insert(Connections, Entered)
					table.insert(Connections, Left)
					
					Open[Index] = {Index, Frame_Option_Title, Frame_Option_Title2, Outline_Frame_Option, Frame_Option_Button}
				end
				
				function Content.Content:Close()
					Content.Content.Open = false
					Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
					
					for _, Connection in ipairs(Connections) do
						Connection:Disconnect()
					end
					
					if InputCheck then InputCheck:Disconnect() end
					
					for _, Objects in pairs(Open) do
						Objects[2]:Destroy()
						Objects[3]:Destroy()
						Objects[4]:Destroy()
						Objects[5]:Destroy()
					end
					
					Content_Open_Holder:Destroy()
					Open_Holder_Outline:Destroy()
					Open_Holder_Outline_Frame:Destroy()
					
					Content.Content.Refresh = nil
					Connections = nil
					Open = nil
				end
				
				function Content.Content:Refresh()
					for Index, Objects in pairs(Open) do
						local selected = table.find(Content.State, Index)
						Objects[2].TextColor3 = selected and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
						Objects[3].TextColor3 = selected and Content.Window.Accent or Color3.fromRGB(205, 205, 205)
					end
				end
				
				Content.Content.Open = true
				Content.Section.Content = Content.Content
				Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
				
				task.wait()
				
				InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
					if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
						local Mouse = utility:MouseLocation()
						local withinBounds = Mouse.X > Content_Open_Holder.AbsolutePosition.X and 
										  Mouse.Y > Content_Open_Holder.AbsolutePosition.Y and 
										  Mouse.X < Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X and 
										  Mouse.Y < Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y
						
						if not withinBounds then
							Content.Section:CloseContent()
						end
					end
				end)
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Down, function()
				if Content.Content.Open then
					Content.Section:CloseContent()
				else
					Content:Open()
				end
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Holder_Outline_Frame.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Holder_Outline_Frame.BackgroundColor3 = Content.Content.Open and Color3.fromRGB(46, 46, 46) or Color3.fromRGB(36, 36, 36)
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	function sections:CreateKeybind(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or "New Keybind",
			State = Properties.state or Properties.default or nil,
			Mode = Properties.mode or "Hold",
			Callback = Properties.callback or function() end,
			Active = false,
			Holding = false,
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		local Keys = {
			KeyCodes = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero", "Insert", "Tab", "Home", "End", "LeftAlt", "LeftControl", "LeftShift", "RightAlt", "RightControl", "RightShift", "CapsLock"},
			Inputs = {"MouseButton1", "MouseButton2", "MouseButton3"},
			Shortened = {
				["MouseButton1"] = "M1", 
				["MouseButton2"] = "M2", 
				["MouseButton3"] = "M3", 
				["Insert"] = "INS", 
				["LeftAlt"] = "LA", 
				["LeftControl"] = "LC", 
				["LeftShift"] = "LS", 
				["RightAlt"] = "RA", 
				["RightControl"] = "RC", 
				["RightShift"] = "RS", 
				["CapsLock"] = "CL", 
				["One"] = "1", 
				["Two"] = "2", 
				["Three"] = "3", 
				["Four"] = "4", 
				["Five"] = "5", 
				["Six"] = "6", 
				["Seven"] = "7", 
				["Eight"] = "8", 
				["Nine"] = "9", 
				["Zero"] = "0"
			}
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, 8 + 10),
				ZIndex = 3
			})
			
			local Content_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Content_Holder_Value = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -61, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = "",
				TextColor3 = Color3.fromRGB(114, 114, 114),
				TextStrokeColor3 = Color3.fromRGB(15, 15, 15),
				TextSize = 9,
				TextStrokeTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Right
			})
			
			function Content:Shorten(Str)
				for Index, Value in pairs(Keys.Shortened) do
					Str = string.gsub(Str, Index, Value)
				end
				return Str
			end
			
			function Content:Set(state)
				Content.State = state or {}
				Content.Active = false
				local text = #Content:Get() > 0 and Content:Shorten(Content:Get()[2]) or "-"
				Content_Holder_Value.Text = "[" .. text .. "]"
				Content.Callback(Content:Get())
			end
			
			function Content:Get()
				return Content.State
			end
			
			function Content:Change(Key)
				if Key.EnumType then
					if Key.EnumType == Enum.KeyCode or Key.EnumType == Enum.UserInputType then
						if table.find(Keys.KeyCodes, Key.Name) or table.find(Keys.Inputs, Key.Name) then
							Content:Set({Key.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType", Key.Name})
							return true
						end
					end
				end
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function()
				Content.Holding = true
				Content_Holder_Value.TextColor3 = Color3.fromRGB(255, 0, 0)
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseButton2Click, function()
				Content:Set()
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Content_Holder_Value.TextColor3 = Color3.fromRGB(164, 164, 164)
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Content_Holder_Value.TextColor3 = Content.Holding and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(114, 114, 114)
			end)
			
			utility:CreateConnection(uis.InputBegan, function(Input)
				if Content.Holding then
					local key = Input.KeyCode.Name ~= "Unknown" and Input.KeyCode or Input.UserInputType
					local Success = Content:Change(key)
					if Success then
						Content.Holding = false
						Content_Holder_Value.TextColor3 = Color3.fromRGB(114, 114, 114)
					end
				end
				
				if Content:Get()[1] and Content:Get()[2] then
					local keyMatch = false
					if Content:Get()[1] == "KeyCode" then
						keyMatch = Input.KeyCode == Enum.KeyCode[Content:Get()[2]]
					else
						keyMatch = Input.UserInputType == Enum.UserInputType[Content:Get()[2]]
					end
					
					if keyMatch then
						if Content.Mode == "Hold" then
							Content.Active = true
						elseif Content.Mode == "Toggle" then
							Content.Active = not Content.Active
						end
					end
				end
			end)
			
			utility:CreateConnection(uis.InputEnded, function(Input)
				if Content:Get()[1] and Content:Get()[2] then
					local keyMatch = false
					if Content:Get()[1] == "KeyCode" then
						keyMatch = Input.KeyCode == Enum.KeyCode[Content:Get()[2]]
					else
						keyMatch = Input.UserInputType == Enum.UserInputType[Content:Get()[2]]
					end
					
					if keyMatch and Content.Mode == "Hold" then
						Content.Active = false
					end
				end
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	function sections:CreateColorpicker(Properties)
		Properties = Properties or {}
		
		local Content = {
			Name = Properties.name or "New Colorpicker",
			State = Properties.state or Properties.default or Color3.fromRGB(255, 255, 255),
			Callback = Properties.callback or function() end,
			Content = {Open = false},
			Window = self.Window,
			Page = self.Page,
			Section = self
		}
		
		do
			local Content_Holder = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content.Section.Holder,
				Size = UDim2.new(1, 0, 0, 8 + 10),
				ZIndex = 3
			})
			
			local Content_Holder_Outline = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(1, -38, 0, 4),
				Size = UDim2.new(0, 17, 0, 9),
				ZIndex = 3
			})
			
			local Content_Holder_Title = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Title2 = utility:RenderObject("TextLabel", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Position = UDim2.new(0, 41, 0, 0),
				Size = UDim2.new(1, -41, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Code,
				RichText = true,
				Text = Content.Name,
				TextColor3 = Color3.fromRGB(205, 205, 205),
				TextSize = 9,
				TextStrokeTransparency = 1,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Content_Holder_Button = utility:RenderObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})
			
			local Holder_Outline_Frame = utility:RenderObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Parent = Content_Holder_Outline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				ZIndex = 3
			})
			
			local Outline_Frame_Gradient = utility:RenderObject("UIGradient", {
				Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140)),
				Enabled = true,
				Rotation = 90,
				Parent = Holder_Outline_Frame
			})
			
			function Content:Set(state)
				Content.State = state
				Holder_Outline_Frame.BackgroundColor3 = Content.State
				Content.Callback(Content:Get())
			end
			
			function Content:Get()
				return Content.State
			end
			
			function Content:Open()
				Content.Section:CloseContent()
				
				local Connections = {}
				local InputCheck
				
				local Content_Open_Holder = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Content.Section.Extra,
					Position = UDim2.new(0, Content_Holder_Outline.AbsolutePosition.X - Content.Section.Extra.AbsolutePosition.X, 0, Content_Holder_Outline.AbsolutePosition.Y - Content.Section.Extra.AbsolutePosition.Y + 10),
					Size = UDim2.new(0, 180, 0, 175),
					ZIndex = 6
				})
				
				local Open_Holder_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(12, 12, 12),
					BorderMode = Enum.BorderMode.Inset,
					BorderSizePixel = 1,
					Parent = Content_Open_Holder,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 6
				})
				
				local Open_Outline_Frame = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Holder_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 6
				})
				
				local ValSat_Picker_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Outline_Frame,
					Position = UDim2.new(0, 2, 0, 2),
					Size = UDim2.new(0, 152, 0, 152),
					ZIndex = 6
				})
				
				local Hue_Picker_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Outline_Frame,
					Position = UDim2.new(1, -19, 0, 2),
					Size = UDim2.new(0, 17, 0, 152),
					ZIndex = 6
				})
				
				local Transparency_Picker_Outline = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(12, 12, 12),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = Open_Outline_Frame,
					Position = UDim2.new(0, 2, 1, -14),
					Size = UDim2.new(0, 152, 0, 12),
					ZIndex = 6
				})
				
				local ValSat_Picker_Color = utility:RenderObject("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Parent = ValSat_Picker_Outline,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 6
				})
				
				-- Ini hanya placeholder, untuk colorpicker lengkap perlu implementasi lebih lanjut
				function Content.Content:Close()
					Content.Content.Open = false
					for _, Connection in ipairs(Connections) do
						Connection:Disconnect()
					end
					if InputCheck then InputCheck:Disconnect() end
					Content_Open_Holder:Destroy()
					Connections = {}
				end
				
				Content.Content.Open = true
				Content.Section.Content = Content.Content
				
				InputCheck = utility:CreateConnection(uis.InputBegan, function(Input)
					if Content.Content.Open and Input.UserInputType == Enum.UserInputType.MouseButton1 then
						local Mouse = utility:MouseLocation()
						local withinBounds = Mouse.X > Content_Open_Holder.AbsolutePosition.X and 
										  Mouse.Y > Content_Open_Holder.AbsolutePosition.Y and 
										  Mouse.X < Content_Open_Holder.AbsolutePosition.X + Content_Open_Holder.AbsoluteSize.X and 
										  Mouse.Y < Content_Open_Holder.AbsolutePosition.Y + Content_Open_Holder.AbsoluteSize.Y
						
						if not withinBounds and not (Mouse.X > Content_Holder.AbsolutePosition.X and 
						   Mouse.Y > Content_Holder.AbsolutePosition.Y and 
						   Mouse.X < Content_Holder.AbsolutePosition.X + Content_Holder.AbsoluteSize.X and 
						   Mouse.Y < Content_Holder.AbsolutePosition.Y + Content_Holder.AbsoluteSize.Y) then
							Content.Section:CloseContent()
						end
					end
				end)
			end
			
			utility:CreateConnection(Content_Holder_Button.MouseButton1Click, function()
				if Content.Content.Open then
					Content.Section:CloseContent()
				else
					Content:Open()
				end
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseEnter, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180))
			end)
			
			utility:CreateConnection(Content_Holder_Button.MouseLeave, function()
				Outline_Frame_Gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 140, 140))
			end)
			
			Content:Set(Content.State)
		end
		
		return Content
	end
	
	-- Return library
	return library
end)

if Passed then
	return Statement
else
	warn("Library failed to load:", Statement)
end
