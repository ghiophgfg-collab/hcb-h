-- PROFESSIONAL ADMIN PANEL V4.0
-- Press F2 to open/close
-- Modern glassmorphism design with live global events

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local ADMIN_LIST = {
    [LocalPlayer.UserId] = true, -- Add your user ID here
    -- Add more admin user IDs as needed
}

-- Check if player is admin
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or false
end

if not isAdmin(LocalPlayer) then
    return -- Exit if not admin
end

-- Create main GUI
local AdminGui = Instance.new("ScreenGui")
AdminGui.Name = "ModernAdminPanel"
AdminGui.Parent = PlayerGui
AdminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AdminGui.ResetOnSpawn = false

-- Backdrop blur effect
local BackdropBlur = Instance.new("Frame")
BackdropBlur.Name = "BackdropBlur"
BackdropBlur.Parent = AdminGui
BackdropBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackdropBlur.BackgroundTransparency = 0.3
BackdropBlur.BorderSizePixel = 0
BackdropBlur.Size = UDim2.new(1, 0, 1, 0)
BackdropBlur.Visible = false
BackdropBlur.ZIndex = -2

-- Main container with glassmorphism styling
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AdminGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
MainFrame.Visible = false

-- Modern rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Glassmorphism border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 80, 120)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Subtle gradient overlay
local GradientOverlay = Instance.new("Frame")
GradientOverlay.Name = "GradientOverlay"
GradientOverlay.Parent = MainFrame
GradientOverlay.BackgroundTransparency = 1
GradientOverlay.BorderSizePixel = 0
GradientOverlay.Size = UDim2.new(1, 0, 1, 0)

local GradientCorner = Instance.new("UICorner")
GradientCorner.CornerRadius = UDim.new(0, 16)
GradientCorner.Parent = GradientOverlay

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 35, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 35))
}
Gradient.Rotation = 45
Gradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.8),
    NumberSequenceKeypoint.new(1, 0.9)
}
Gradient.Parent = GradientOverlay

-- Header with glass effect
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 60)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

-- Header mask to create top-only rounded corners
local HeaderMask = Instance.new("Frame")
HeaderMask.Parent = Header
HeaderMask.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
HeaderMask.BackgroundTransparency = 0.2
HeaderMask.BorderSizePixel = 0
HeaderMask.Position = UDim2.new(0, 0, 0.5, 0)
HeaderMask.Size = UDim2.new(1, 0, 0.5, 2)

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(70, 90, 130)
HeaderStroke.Thickness = 1
HeaderStroke.Transparency = 0.4
HeaderStroke.Parent = Header

-- Professional title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Font = Enum.Font.SourceSansSemibold
Title.Text = "ADMIN CONTROL PANEL"
Title.TextColor3 = Color3.fromRGB(220, 230, 250)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 20, 0, 25)
Subtitle.Size = UDim2.new(1, -120, 0, 20)
Subtitle.Font = Enum.Font.SourceSans
Subtitle.Text = "Global Server Management"
Subtitle.TextColor3 = Color3.fromRGB(150, 170, 200)
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Modern close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.BackgroundTransparency = 0.1
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -50, 0, 15)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 100, 100)
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0.5
CloseStroke.Parent = CloseButton

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.Size = UDim2.new(1, 0, 0, 50)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingLeft = UDim.new(0, 15)
TabPadding.PaddingRight = UDim.new(0, 15)

-- Content area with glass effect
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 0, 0, 130)
ContentFrame.Size = UDim2.new(1, 0, 1, -130)

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(50, 70, 100)
ContentStroke.Thickness = 1
ContentStroke.Transparency = 0.5
ContentStroke.Parent = ContentFrame

-- Scrolling content
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = ContentFrame
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 0, 0, 0)
Content.Size = UDim2.new(1, 0, 1, 0)
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 180)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = Content
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = Content
ContentPadding.PaddingTop = UDim.new(0, 20)
ContentPadding.PaddingLeft = UDim.new(0, 20)
ContentPadding.PaddingRight = UDim.new(0, 20)
ContentPadding.PaddingBottom = UDim.new(0, 20)

-- Setup Remote Events
local function setupRemoteEvents()
    local AdminFolder = ReplicatedStorage:FindFirstChild("AdminRemotes")
    if not AdminFolder then
        AdminFolder = Instance.new("Folder")
        AdminFolder.Name = "AdminRemotes"
        AdminFolder.Parent = ReplicatedStorage
    end
    
    local remoteNames = {
        "KickPlayer", "BanPlayer", "TeleportPlayer", "ServerMessage",
        "GlobalMusic", "ClearWorkspace", "ChangeGravity", "ChangeLighting",
        "CreateParticles", "SpawnObject", "WeatherEffect", "PlayerEffect",
        "DanceParty", "FireworksShow", "LightningStorm", "MeteorShower",
        "DiscoMode", "RainbowSky", "FogControl"
    }
    
    local remotes = {}
    for _, remoteName in pairs(remoteNames) do
        local remote = AdminFolder:FindFirstChild(remoteName)
        if not remote then
            remote = Instance.new("RemoteEvent")
            remote.Name = remoteName
            remote.Parent = AdminFolder
        end
        remotes[remoteName] = remote
    end
    
    return remotes
end

local remoteEvents = setupRemoteEvents()

-- Modern tab system
local activeTab = "players"
local tabs = {}

local function createTab(name, title, color, layoutOrder)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Parent = TabContainer
    Tab.BackgroundColor3 = color
    Tab.BackgroundTransparency = 0.7
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(0.2, -2, 1, 0)
    Tab.Font = Enum.Font.SourceSansSemibold
    Tab.Text = title
    Tab.TextColor3 = Color3.fromRGB(200, 210, 230)
    Tab.TextSize = 13
    Tab.LayoutOrder = layoutOrder
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = Tab
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = color
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.6
    TabStroke.Parent = Tab
    
    tabs[name] = {
        button = Tab,
        color = color,
        content = {}
    }
    
    Tab.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
    
    return Tab
end

-- Create tabs
createTab("players", "PLAYERS", Color3.fromRGB(70, 130, 255), 1)
createTab("events", "EVENTS", Color3.fromRGB(255, 120, 60), 2)
createTab("music", "MUSIC", Color3.fromRGB(150, 80, 255), 3)
createTab("weather", "WEATHER", Color3.fromRGB(60, 180, 255), 4)
createTab("server", "SERVER", Color3.fromRGB(100, 200, 120), 5)

-- Tab switching function
local function switchTab(tabName)
    activeTab = tabName
    
    -- Update tab appearances
    for name, tab in pairs(tabs) do
        if name == tabName then
            tab.button.BackgroundTransparency = 0.2
            tab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tab.button.BackgroundTransparency = 0.7
            tab.button.TextColor3 = Color3.fromRGB(200, 210, 230)
        end
    end
    
    -- Clear current content
    for _, child in pairs(Content:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Load new content
    loadTabContent(tabName)
end

-- Modern button creation with glassmorphism
local function createButton(parent, text, layoutOrder, callback, color)
    local buttonColor = color or Color3.fromRGB(70, 130, 255)
    
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = buttonColor
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.LayoutOrder = layoutOrder
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = buttonColor
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.4
    ButtonStroke.Parent = Button
    
    -- Hover and click effects
    Button.MouseEnter:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, 0, 0, 47)
            }
        )
        tween:Play()
    end)
    
    Button.MouseLeave:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                BackgroundTransparency = 0.2,
                Size = UDim2.new(1, 0, 0, 45)
            }
        )
        tween:Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.05}
        )
        tween:Play()
        
        wait(0.1)
        
        local tween2 = TweenService:Create(Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.2}
        )
        tween2:Play()
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- Modern input field creation with glassmorphism
local function createInputField(parent, placeholder, layoutOrder)
    local InputFrame = Instance.new("Frame")
    InputFrame.Parent = parent
    InputFrame.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    InputFrame.BackgroundTransparency = 0.3
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, 40)
    InputFrame.LayoutOrder = layoutOrder
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputFrame
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(80, 100, 140)
    InputStroke.Thickness = 1
    InputStroke.Transparency = 0.5
    InputStroke.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Parent = InputFrame
    InputBox.BackgroundTransparency = 1
    InputBox.Position = UDim2.new(0, 15, 0, 0)
    InputBox.Size = UDim2.new(1, -30, 1, 0)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.PlaceholderText = placeholder
    InputBox.PlaceholderColor3 = Color3.fromRGB(140, 160, 190)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(240, 250, 260)
    InputBox.TextSize = 14
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Focus effects
    InputBox.Focused:Connect(function()
        local tween = TweenService:Create(InputStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                Transparency = 0.2,
                Color = Color3.fromRGB(100, 150, 255)
            }
        )
        tween:Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        local tween = TweenService:Create(InputStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                Transparency = 0.5,
                Color = Color3.fromRGB(80, 100, 140)
            }
        )
        tween:Play()
    end)
    
    return InputBox
end

-- Professional section headers
local function createSection(parent, title, layoutOrder)
    local Section = Instance.new("Frame")
    Section.Parent = parent
    Section.BackgroundTransparency = 1
    Section.Size = UDim2.new(1, 0, 0, 35)
    Section.LayoutOrder = layoutOrder
    
    local SectionLine = Instance.new("Frame")
    SectionLine.Parent = Section
    SectionLine.BackgroundColor3 = Color3.fromRGB(80, 120, 180)
    SectionLine.BackgroundTransparency = 0.5
    SectionLine.BorderSizePixel = 0
    SectionLine.Position = UDim2.new(0, 0, 1, -2)
    SectionLine.Size = UDim2.new(1, 0, 0, 1)
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, 0, 1, -5)
    SectionLabel.Font = Enum.Font.SourceSansBold
    SectionLabel.Text = title
    SectionLabel.TextColor3 = Color3.fromRGB(180, 200, 230)
    SectionLabel.TextSize = 16
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return Section
end

-- Enhanced spacer
local function createSpacer(parent, layoutOrder, height)
    local Spacer = Instance.new("Frame")
    Spacer.Parent = parent
    Spacer.BackgroundTransparency = 1
    Spacer.Size = UDim2.new(1, 0, 0, height or 15)
    Spacer.LayoutOrder = layoutOrder
    return Spacer
end

-- Get player from input with improved matching
local function getPlayerFromInput(input)
    local targetPlayer = nil
    
    -- Exact name match first
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == input:lower() or player.DisplayName:lower() == input:lower() then
            targetPlayer = player
            break
        end
    end
    
    -- Partial match if no exact match
    if not targetPlayer then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(input:lower()) or player.DisplayName:lower():find(input:lower()) then
                targetPlayer = player
                break
            end
        end
    end
    
    return targetPlayer
end

-- Tab content loading function
function loadTabContent(tabName)
    local orderCounter = 1
    
    if tabName == "players" then
        createSection(Content, "PLAYER MANAGEMENT", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 10)
        orderCounter = orderCounter + 1
        
        local PlayerInput = createInputField(Content, "Enter player name...", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 8)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Remove Player", orderCounter, function()
            local playerName = PlayerInput.Text
            if playerName ~= "" then
                remoteEvents.KickPlayer:FireServer(playerName)
                PlayerInput.Text = ""
            end
        end, Color3.fromRGB(220, 80, 80))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Ban Player", orderCounter, function()
            local playerName = PlayerInput.Text
            if playerName ~= "" then
                remoteEvents.BanPlayer:FireServer(playerName)
                PlayerInput.Text = ""
            end
        end, Color3.fromRGB(180, 60, 60))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Teleport To Player", orderCounter, function()
            local playerName = PlayerInput.Text
            if playerName ~= "" then
                remoteEvents.TeleportPlayer:FireServer("to", playerName)
                PlayerInput.Text = ""
            end
        end, Color3.fromRGB(80, 180, 120))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Bring Player", orderCounter, function()
            local playerName = PlayerInput.Text
            if playerName ~= "" then
                remoteEvents.TeleportPlayer:FireServer("bring", playerName)
                PlayerInput.Text = ""
            end
        end, Color3.fromRGB(120, 160, 200))
        orderCounter = orderCounter + 1
        
    elseif tabName == "events" then
        createSection(Content, "LIVE GLOBAL EVENTS", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 10)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Dance Party Event", orderCounter, function()
            remoteEvents.DanceParty:FireServer()
        end, Color3.fromRGB(255, 140, 60))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Fireworks Show", orderCounter, function()
            remoteEvents.FireworksShow:FireServer()
        end, Color3.fromRGB(255, 180, 40))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Lightning Storm", orderCounter, function()
            remoteEvents.LightningStorm:FireServer()
        end, Color3.fromRGB(255, 220, 80))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Meteor Shower", orderCounter, function()
            remoteEvents.MeteorShower:FireServer()
        end, Color3.fromRGB(255, 120, 40))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Disco Mode", orderCounter, function()
            remoteEvents.DiscoMode:FireServer()
        end, Color3.fromRGB(200, 80, 255))
        orderCounter = orderCounter + 1
        
    elseif tabName == "music" then
        createSection(Content, "GLOBAL MUSIC SYSTEM", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 10)
        orderCounter = orderCounter + 1
        
        local MusicInput = createInputField(Content, "Enter music ID...", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 8)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Play Custom Music", orderCounter, function()
            local musicId = MusicInput.Text
            if musicId ~= "" then
                if not musicId:find("rbxassetid://") then
                    musicId = "rbxassetid://" .. musicId
                end
                remoteEvents.GlobalMusic:FireServer(musicId, "Custom Track")
                MusicInput.Text = ""
            end
        end, Color3.fromRGB(150, 80, 255))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Stop All Music", orderCounter, function()
            remoteEvents.GlobalMusic:FireServer("", "stop")
        end, Color3.fromRGB(220, 80, 80))
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 8)
        orderCounter = orderCounter + 1
        
        createSection(Content, "PRESET TRACKS", orderCounter)
        orderCounter = orderCounter + 1
        
        local presetTracks = {
            {name = "Ambient Chill", id = "1837879082"},
            {name = "Electronic Beat", id = "1841647093"},
            {name = "Orchestral Epic", id = "1847488632"},
            {name = "Lo-Fi Study", id = "1839853464"}
        }
        
        for _, track in pairs(presetTracks) do
            createButton(Content, track.name, orderCounter, function()
                remoteEvents.GlobalMusic:FireServer("rbxassetid://" .. track.id, track.name)
            end, Color3.fromRGB(120, 100, 200))
            orderCounter = orderCounter + 1
        end
        
    elseif tabName == "weather" then
        createSection(Content, "WEATHER CONTROL", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 10)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Clear Skies", orderCounter, function()
            remoteEvents.ChangeLighting:FireServer("day")
        end, Color3.fromRGB(255, 220, 100))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Night Mode", orderCounter, function()
            remoteEvents.ChangeLighting:FireServer("night")
        end, Color3.fromRGB(80, 100, 180))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Sunset Atmosphere", orderCounter, function()
            remoteEvents.ChangeLighting:FireServer("sunset")
        end, Color3.fromRGB(255, 140, 80))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Snow Weather", orderCounter, function()
            remoteEvents.WeatherEffect:FireServer("snow")
        end, Color3.fromRGB(180, 220, 255))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Rainbow Sky", orderCounter, function()
            remoteEvents.RainbowSky:FireServer()
        end, Color3.fromRGB(200, 150, 255))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Fog Control", orderCounter, function()
            remoteEvents.FogControl:FireServer()
        end, Color3.fromRGB(160, 160, 200))
        orderCounter = orderCounter + 1
        
    elseif tabName == "server" then
        createSection(Content, "SERVER ADMINISTRATION", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 10)
        orderCounter = orderCounter + 1
        
        local MessageInput = createInputField(Content, "Enter server announcement...", orderCounter)
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 8)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Send Announcement", orderCounter, function()
            local message = MessageInput.Text
            if message ~= "" then
                remoteEvents.ServerMessage:FireServer(message)
                MessageInput.Text = ""
            end
        end, Color3.fromRGB(70, 130, 255))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Clear Workspace", orderCounter, function()
            remoteEvents.ClearWorkspace:FireServer()
        end, Color3.fromRGB(255, 150, 80))
        orderCounter = orderCounter + 1
        
        createSpacer(Content, orderCounter, 8)
        orderCounter = orderCounter + 1
        
        createSection(Content, "GRAVITY CONTROL", orderCounter)
        orderCounter = orderCounter + 1
        
        createButton(Content, "Low Gravity", orderCounter, function()
            remoteEvents.ChangeGravity:FireServer(50)
        end, Color3.fromRGB(150, 120, 255))
        orderCounter = orderCounter + 1
        
        createButton(Content, "Normal Gravity", orderCounter, function()
            remoteEvents.ChangeGravity:FireServer(196.2)
        end, Color3.fromRGB(100, 255, 120))
        orderCounter = orderCounter + 1
        
        createButton(Content, "High Gravity", orderCounter, function()
            remoteEvents.ChangeGravity:FireServer(500)
        end, Color3.fromRGB(255, 120, 150))
        orderCounter = orderCounter + 1
    end
end

-- Toggle functionality with smooth animations
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    
    if isOpen then
        MainFrame.Visible = true
        BackdropBlur.Visible = true
        
        -- Initial transparency
        MainFrame.BackgroundTransparency = 1
        BackdropBlur.BackgroundTransparency = 1
        MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
        
        -- Smooth entrance animation
        local frameTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                BackgroundTransparency = 0.15,
                Size = UDim2.new(0.5, 0, 0.7, 0)
            }
        )
        local blurTween = TweenService:Create(BackdropBlur,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.3}
        )
        
        frameTween:Play()
        blurTween:Play()
        
        -- Load initial tab content
        switchTab(activeTab)
        
    else
        local frameTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.3, 0, 0.5, 0)
            }
        )
        local blurTween = TweenService:Create(BackdropBlur,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        
        frameTween:Play()
        blurTween:Play()
        
        frameTween.Completed:Connect(function()
            MainFrame.Visible = false
            BackdropBlur.Visible = false
        end)
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        togglePanel()
    end
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    togglePanel()
end)

-- Enhanced dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Professional Admin Panel V4.0 loaded successfully!")
print("Press F2 to open the control panel")
print("Administrator: " .. LocalPlayer.Name)