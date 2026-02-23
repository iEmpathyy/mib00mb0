-- [[ // Error Handling // ]]
local Passed, Statement = pcall(function()
	-- [[ // Service & Cache Variables // ]]
	local uis = game:GetService("UserInputService")
	local hs = game:GetService("HttpService")
	local cg = game:GetService("CoreGui")
	local plr = game:GetService("Players").LocalPlayer
	local tws = game:GetService("TweenService")

	-- [[ // UI Utility // ]]
	local utility = {
		is_dragging_blocked = false,
		Renders = {},
		Connections = {}
	}

	do
		local newInstance = Instance.new

		-- Dragable function dari kode Anda
		utility.setDraggable = function(object)
			local dragging = false

			object.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				local inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 and not utility.is_dragging_blocked then
					local mouse_location = uis:GetMouseLocation()
					local startPosX = mouse_location.X
					local startPosY = mouse_location.Y
					local objPosX = object.Position.X.Offset
					local objPosY = object.Position.Y.Offset
					dragging = true
					task.spawn(function()
						while dragging and not utility.is_dragging_blocked do
							mouse_location = uis:GetMouseLocation()
							object.Position = UDim2.new(0, objPosX - (startPosX - mouse_location.X), 0, objPosY - (startPosY - mouse_location.Y))
							task.wait()
						end
					end)
				end
			end)

			object.InputEnded:Connect(function(input, gpe)
				if gpe then return end
				local inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
		end

		utility.newObject = function(class, properties)
			local object = newInstance(class)

			for property, value in pairs(properties) do
				pcall(function()
					object[property] = value
				end)
			end

			object.Name = hs:GenerateGUID(false)
			utility.Renders[#utility.Renders + 1] = object

			return object
		end

		utility.CreateConnection = function(connectionType, callback)
			local connection = connectionType:Connect(callback)
			utility.Connections[#utility.Connections + 1] = connection
			return connection
		end

		utility.MouseLocation = function()
			return uis:GetMouseLocation()
		end

		utility.Serialise = function(Table)
			local Serialised = ""
			for Index, Value in pairs(Table) do
				Serialised = Serialised .. Value .. ", "
			end
			return Serialised:sub(0, #Serialised - 2)
		end

		utility.Sort = function(Table1, Table2)
			local Table3 = {}
			for Index, Value in pairs(Table2) do
				if table.find(Table1, Index) then
					Table3[#Table3 + 1] = Value
				end
			end
			return Table3
		end
	end

	-- [[ // UI // ]]
	local menu = {}
	local window = {}
	window.__index = window
	local tab = {}
	tab.__index = tab
	local section = {}
	section.__index = section

	do
		local newObject = utility.newObject

		function menu:CreateWindow(tabs)
			tabs = tabs or {}
			
			local _screenGui = newObject("ScreenGui", {
				DisplayOrder = 9999,
				Enabled = true,
				IgnoreGuiInset = true,
				Parent = plr:FindFirstChild("PlayerGui") or cg,
				ResetOnSpawn = false,
				ZIndexBehavior = "Global"
			})

			-- Main Border (yang akan di-drag)
			local Border = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(60, 60, 60);
				BorderColor3 = Color3.fromRGB(12, 12, 12);
				Position = UDim2.new(0.5, -329, 0.5, -279);
				Size = UDim2.new(0, 658, 0, 558);
				Parent = _screenGui
			})
			
			-- Apply dragable ke border
			utility.setDraggable(Border)
			
			local Border2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(40, 40, 40);
				Position = UDim2.new(0, 2, 0, 2);
				Size = UDim2.new(1, -4, 1, -4);
				Parent = Border;
			})
			local Background = newObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderColor3 = Color3.fromRGB(60, 60, 60);
				Position = UDim2.new(0, 3, 0, 3);
				Size = UDim2.new(1, -6, 1, -6);
				Image = "rbxassetid://15453092054";
				ScaleType = Enum.ScaleType.Tile;
				TileSize = UDim2.new(0, 4, 0, 548);
				Parent = Border2
			})
			local TabHolder = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 14);
				Size = UDim2.new(0, 73, 1, -36);
				Parent = Background
			})
			local TabLayout = newObject("UIListLayout", {
				Padding = UDim.new(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Parent = TabHolder
			})
			local TabPadding = newObject("UIPadding", {
				PaddingTop = UDim.new(0, 9);
				Parent = TabHolder
			})
			local TopGap = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = UDim2.new(0, 73, 0, 14);
				Parent = Background
			})
			local TopSideFix = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 73, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = TopGap
			})
			local TopSideFix2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(1, 0, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = TopSideFix
			})
			local BottomGap = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 1, -22);
				Size = UDim2.new(0, 73, 0, 22);
				Parent = Background
			})
			local BottomSideFix = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 73, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = BottomGap
			})
			local BottomSideFix2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(1, 0, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = BottomSideFix
			})
			local TopBar_2 = newObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderColor3 = Color3.fromRGB(12, 12, 12);
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 0, 2);
				ZIndex = 2;
				Image = "rbxassetid://15453122383";
				Parent = Background
			})
			local BlackBar = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(6, 6, 6);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 1, 0);
				Size = UDim2.new(1, 0, 0, 1);
				ZIndex = 2;
				Parent = TopBar_2
			})
			
			local PagesHolder = newObject("Folder", {
				Parent = Background
			})

			local new_window = {
				screenGui = _screenGui,
				border = Border,
				tab_holder = TabHolder,
				pages_holder = PagesHolder,
				active_tab = nil,
				background = Background,
				tabs = {},
				pages = {},
				Accent = Color3.fromRGB(255, 120, 30),
				Enabled = true
			}

			setmetatable(new_window, window)

			return new_window
		end

		function window:CreatePage(info)
			info = info or {}
			
			local Page = {
				Name = info.name or "Page",
				Icon = info.icon or "rbxassetid://15453302474",
				Open = false,
				Window = self,
				Sections = {}
			}

			local Button = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = UDim2.new(0, 73, 0, 64);
				Parent = self.tab_holder
			})
			
			local BottomBar = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 1, 1);
				Size = UDim2.new(1, 0, 0, 1);
				Visible = false;
				ZIndex = 2;
				Parent = Button
			})
			
			local BottomBar2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, -1);
				Size = UDim2.new(1, 2, 1, 0);
				ZIndex = 2;
				Parent = BottomBar
			})
			
			local Icon = newObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 1, 0);
				Image = Page.Icon;
				ImageColor3 = Color3.fromRGB(109, 109, 109);
				Parent = Button
			})
			
			local TopBar = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, -2);
				Size = UDim2.new(1, 0, 0, 1);
				Visible = false;
				ZIndex = 2;
				Parent = Button
			})
			
			local TopBar2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 1);
				Size = UDim2.new(1, 2, 1, 0);
				ZIndex = 2;
				Parent = TopBar
			})
			
			local SideBar = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 73, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = Button
			})
			
			local SideBar2 = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(1, 0, 0, 0);
				Size = UDim2.new(0, 1, 1, 0);
				Parent = SideBar    
			})

			local PageFrame = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 96, 0, 23);
				Size = UDim2.new(0, 532, 0, 506);
				Visible = false;
				Parent = self.background
			})
			
			local PageLeft = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0,
				Parent = PageFrame,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			
			local PageRight = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0,
				Parent = PageFrame,
				Position = UDim2.new(0.5, 10, 0, 0),
				Size = UDim2.new(0.5, -10, 1, 0)
			})
			
			local LeftList = newObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = PageLeft,
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Top"
			})
			
			local RightList = newObject("UIListLayout", {
				Padding = UDim.new(0, 18),
				Parent = PageRight,
				FillDirection = "Vertical",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Top"
			})

			Button.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				local inputType = input.UserInputType
				if inputType == Enum.UserInputType.MouseButton1 then
					if self.active_tab == Page then return end
					self:SetPage(Page)
				end
			end)

			Button.MouseEnter:Connect(function()
				if self.active_tab == Page then return end
				Icon.ImageColor3 = Color3.fromRGB(204, 204, 204)
			end)

			Button.MouseLeave:Connect(function()
				if self.active_tab == Page then return end
				Icon.ImageColor3 = Color3.fromRGB(109, 109, 109)
			end)

			Page.button = Button
			Page.icon = Icon
			Page.bottom_bar = BottomBar
			Page.top_bar = TopBar
			Page.side_bar = SideBar
			Page.frame = PageFrame
			Page.left = PageLeft
			Page.right = PageRight

			self.pages[#self.pages + 1] = Page
			self.tabs[#self.tabs + 1] = Page

			if #self.pages == 1 then
				self:SetPage(Page)
			end

			return setmetatable(Page, tab)
		end

		function window:SetPage(Page)
			self.active_tab = Page

			for _, tab in ipairs(self.tabs) do
				local is_active_tab = tab == Page
				tab.icon.ImageColor3 = is_active_tab and Color3.fromRGB(255,255,255) or Color3.fromRGB(109,109,109)
				tab.bottom_bar.Visible = is_active_tab
				tab.top_bar.Visible = is_active_tab
				tab.side_bar.Visible = not is_active_tab
				tab.button.BackgroundTransparency = is_active_tab and 1 or 0
				tab.frame.Visible = is_active_tab
				tab.Open = is_active_tab
			end
		end

		function window:Unload()
			self.screenGui:Destroy()
			for _, connection in ipairs(utility.Connections) do
				pcall(function()
					connection:Disconnect()
				end)
			end
			utility.Renders = {}
			utility.Connections = {}
		end

		function window:GetPage(index)
			return self.pages[index]
		end

		-- [[ Section Functions ]]
		function tab:CreateSection(info)
			info = info or {}
			
			local Section = {
				Name = info.name or "New Section",
				Side = info.side or "left",
				Size = info.size or 150,
				Page = self,
				Elements = {}
			}

			local SectionFrame = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				BorderColor3 = Color3.fromRGB(12, 12, 12);
				BorderMode = "Inset";
				BorderSizePixel = 1;
				Size = UDim2.new(1, 0, 0, Section.Size);
				Parent = Section.Side == "left" and self.left or self.right
			})
			
			local SectionInner = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				Parent = SectionFrame
			})
			
			local SectionTitle = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 12, 0, -10);
				Size = UDim2.new(1, -24, 0, 15);
				Font = "SourceSansBold";
				Text = Section.Name;
				TextColor3 = Color3.fromRGB(198, 198, 198);
				TextSize = 14;
				TextXAlignment = "Left";
				Parent = SectionInner
			})
			
			local TitleInline = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(23, 23, 23);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 9, 0, -1);
				Size = UDim2.new(0, SectionTitle.TextBounds.X + 6, 0, 2);
				Parent = SectionFrame
			})
			
			local ContentHolder = newObject("ScrollingFrame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 15);
				Size = UDim2.new(1, 0, 1, -15);
				Parent = SectionInner,
				AutomaticCanvasSize = "Y",
				BottomImage = "rbxassetid://7783554086",
				CanvasSize = UDim2.new(0, 0, 0, 0),
				MidImage = "rbxassetid://7783554086",
				ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
				ScrollBarThickness = 5,
				TopImage = "rbxassetid://7783554086"
			})
			
			local ContentList = newObject("UIListLayout", {
				Padding = UDim.new(0, 0),
				Parent = ContentHolder,
				FillDirection = "Vertical",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Top"
			})
			
			local ContentPadding = newObject("UIPadding", {
				Parent = ContentHolder,
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15)
			})

			Section.Frame = SectionFrame
			Section.Inner = SectionInner
			Section.Title = SectionTitle
			Section.ContentHolder = ContentHolder
			Section.ContentList = ContentList

			self.Sections[info.name] = Section

			return setmetatable(Section, section)
		end

		-- [[ Content Functions ]]
		function section:CreateToggle(info)
			info = info or {}
			
			local Toggle = {
				Name = info.name or "Toggle",
				State = info.default or false,
				Callback = info.callback or function() end,
				Section = self
			}

			local Holder = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = self.ContentHolder;
				Size = UDim2.new(1, 0, 0, 18);
			})
			
			local Outline = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 20, 0, 5);
				Size = UDim2.new(0, 8, 0, 8);
			})
			
			local Inner = newObject("Frame", {
				BackgroundColor3 = Toggle.State and Color3.fromRGB(255, 120, 30) or Color3.fromRGB(77, 77, 77);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Outline;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
			})
			
			local Title = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 41, 0, 0);
				Size = UDim2.new(1, -41, 1, 0);
				Font = "SourceSans";
				Text = Toggle.Name;
				TextColor3 = Color3.fromRGB(205, 205, 205);
				TextSize = 14;
				TextXAlignment = "Left";
			})
			
			local Button = newObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Size = UDim2.new(1, 0, 1, 0);
				Text = "";
			})

			function Toggle:Set(state)
				Toggle.State = state
				Inner.BackgroundColor3 = Toggle.State and Color3.fromRGB(255, 120, 30) or Color3.fromRGB(77, 77, 77)
				Toggle.Callback(Toggle.State)
			end

			function Toggle:Get()
				return Toggle.State
			end

			Button.MouseButton1Click:Connect(function()
				Toggle:Set(not Toggle.State)
			end)

			return Toggle
		end

		function section:CreateSlider(info)
			info = info or {}
			
			local Slider = {
				Name = info.name,
				Value = info.default or 0,
				Min = info.min or 0,
				Max = info.max or 100,
				Suffix = info.suffix or "",
				Callback = info.callback or function() end,
				Holding = false,
				Section = self
			}

			local Holder = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = self.ContentHolder;
				Size = UDim2.new(1, 0, 0, (Slider.Name and 34 or 23));
			})
			
			if Slider.Name then
				local Title = newObject("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0);
					BackgroundTransparency = 1;
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Parent = Holder;
					Position = UDim2.new(0, 41, 0, 4);
					Size = UDim2.new(1, -41, 0, 14);
					Font = "SourceSans";
					Text = Slider.Name;
					TextColor3 = Color3.fromRGB(205, 205, 205);
					TextSize = 14;
					TextXAlignment = "Left";
				})
			end
			
			local Outline = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 40, 0, Slider.Name and 23 or 8);
				Size = UDim2.new(1, -99, 0, 8);
			})
			
			local Inner = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(71, 71, 71);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Outline;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
			})
			
			local Fill = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 120, 30);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Inner;
				Position = UDim2.new(0, 0, 0, 0);
				Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0);
			})
			
			local ValueLabel = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(1, -85, 0, Slider.Name and 20 or 5);
				Size = UDim2.new(0, 80, 0, 14);
				Font = "SourceSans";
				Text = tostring(Slider.Value) .. Slider.Suffix;
				TextColor3 = Color3.fromRGB(205, 205, 205);
				TextSize = 14;
				TextXAlignment = "Right";
			})
			
			local Button = newObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Size = UDim2.new(1, 0, 1, 0);
				Text = "";
			})

			function Slider:Set(value)
				Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
				Fill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
				ValueLabel.Text = tostring(math.floor(Slider.Value * 10) / 10) .. Slider.Suffix
				Slider.Callback(Slider.Value)
			end

			function Slider:Get()
				return Slider.Value
			end

			Button.MouseButton1Down:Connect(function()
				Slider.Holding = true
			end)

			Button.MouseButton1Up:Connect(function()
				Slider.Holding = false
			)

			uis.InputChanged:Connect(function(input)
				if Slider.Holding and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mouse = uis:GetMouseLocation()
					local pos = Inner.AbsolutePosition.X
					local size = Inner.AbsoluteSize.X
					local percent = (mouse.X - pos) / size
					Slider:Set(Slider.Min + (Slider.Max - Slider.Min) * percent)
				end
			end)

			return Slider
		end

		function section:CreateDropdown(info)
			info = info or {}
			
			local Dropdown = {
				Name = info.name or "Dropdown",
				Value = info.default or 1,
				Options = info.options or {"Option 1", "Option 2"},
				Callback = info.callback or function() end,
				Open = false,
				Section = self
			}

			local Holder = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = self.ContentHolder;
				Size = UDim2.new(1, 0, 0, 44);
			})
			
			local Title = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 41, 0, 4);
				Size = UDim2.new(1, -41, 0, 14);
				Font = "SourceSans";
				Text = Dropdown.Name;
				TextColor3 = Color3.fromRGB(205, 205, 205);
				TextSize = 14;
				TextXAlignment = "Left";
			})
			
			local Outline = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(12, 12, 12);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 40, 0, 21);
				Size = UDim2.new(1, -98, 0, 20);
			})
			
			local Inner = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(36, 36, 36);
				BackgroundTransparency = 0;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Outline;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
			})
			
			local SelectedText = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Inner;
				Position = UDim2.new(0, 8, 0, 0);
				Size = UDim2.new(1, -30, 1, 0);
				Font = "SourceSans";
				Text = Dropdown.Options[Dropdown.Value];
				TextColor3 = Color3.fromRGB(205, 205, 205);
				TextSize = 14;
				TextXAlignment = "Left";
			})
			
			local Arrow = newObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Inner;
				Position = UDim2.new(1, -20, 0.5, -4);
				Size = UDim2.new(0, 12, 0, 8);
				Image = "rbxassetid://6031094678";
				ImageColor3 = Color3.fromRGB(205, 205, 205);
			})
			
			local Button = newObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Size = UDim2.new(1, 0, 1, 0);
				Text = "";
			})

			function Dropdown:Set(value)
				Dropdown.Value = value
				SelectedText.Text = Dropdown.Options[value]
				Dropdown.Callback(value)
			end

			function Dropdown:Get()
				return Dropdown.Value
			end

			Button.MouseButton1Click:Connect(function()
				-- Toggle dropdown logic here
				-- For simplicity, just cycle through options
				local new = Dropdown.Value + 1
				if new > #Dropdown.Options then new = 1 end
				Dropdown:Set(new)
			end)

			return Dropdown
		end

		function section:CreateKeybind(info)
			info = info or {}
			
			local Keybind = {
				Name = info.name or "Keybind",
				Key = info.default or Enum.KeyCode.RightShift,
				Mode = info.mode or "Hold",
				Callback = info.callback or function() end,
				Active = false,
				Listening = false,
				Section = self
			}

			local Holder = newObject("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = self.ContentHolder;
				Size = UDim2.new(1, 0, 0, 24);
			})
			
			local Title = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 41, 0, 0);
				Size = UDim2.new(1, -41, 1, 0);
				Font = "SourceSans";
				Text = Keybind.Name;
				TextColor3 = Color3.fromRGB(205, 205, 205);
				TextSize = 14;
				TextXAlignment = "Left";
			})
			
			local KeyLabel = newObject("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Position = UDim2.new(0, 41, 0, 0);
				Size = UDim2.new(1, -61, 1, 0);
				Font = "SourceSans";
				Text = Keybind.Key.Name;
				TextColor3 = Color3.fromRGB(155, 155, 155);
				TextSize = 14;
				TextXAlignment = "Right";
			})
			
			local Button = newObject("TextButton", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Parent = Holder;
				Size = UDim2.new(1, 0, 1, 0);
				Text = "";
			})

			function Keybind:Set(key)
				Keybind.Key = key
				KeyLabel.Text = key.Name
				Keybind.Callback(key)
			end

			function Keybind:Get()
				return Keybind.Key
			end

			Button.MouseButton1Click:Connect(function()
				Keybind.Listening = true
				KeyLabel.Text = "..."
			end)

			uis.InputBegan:Connect(function(input)
				if Keybind.Listening then
					Keybind:Set(input.KeyCode)
					Keybind.Listening = false
				end
			end)

			return Keybind
		end
	end

	return menu
end)

if Passed then
	return Statement
else
	warn("Library failed to load:", Statement)
end
