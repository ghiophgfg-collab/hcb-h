-- PROFESSIONAL ADMIN PANEL V3.0
-- Press F2 to toggle
-- True global visibility through ReplicatedStorage

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Admin Configuration
local ADMIN_LIST = {
    [LocalPlayer.UserId] = true, -- Add your user ID here
    -- Add more admin user IDs as needed
}

-- Music Library
local MUSIC_IDS = {
    ["Chill Vibes"] = "rbxassetid://1841647093",
    ["Epic Battle"] = "rbxassetid://1837879082",
    ["Dance Party"] = "rbxassetid://1845756489",
    ["Relaxing"] = "rbxassetid://1838819154",
    ["Intense"] = "rbxassetid://1847115477",
    ["Synthwave"] = "rbxassetid://142376088",
    ["Cyberpunk"] = "rbxassetid://1848354536",
    ["Future Bass"] = "rbxassetid://1846431449",
    ["Ambient Space"] = "rbxassetid://1845554017",
    ["Neon Dreams"] = "rbxassetid://1847269395"
}

-- Dance Animations
local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", "rbxassetid://507770818", "rbxassetid://507771019",
    "rbxassetid://507771955", "rbxassetid://507772104", "rbxassetid://507777623",
    "rbxassetid://507777268", "rbxassetid://507776879"
}

-- Check admin permissions
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or false
end

if not isAdmin(LocalPlayer) then
    return -- Exit if not admin
end

-- Create/Get ReplicatedStorage Values for Global Visibility
local function setupReplicatedStorage()
    local adminFolder = ReplicatedStorage:FindFirstChild("AdminPanelData")
    if not adminFolder then
        adminFolder = Instance.new("Folder")
        adminFolder.Name = "AdminPanelData"
        adminFolder.Parent = ReplicatedStorage
    end
    
    local values = {}
    local valueNames = {
        "DancePartyActive", "FireworksActive", "LightningActive", 
        "MeteorActive", "SnowActive", "DiscoActive",
        "CurrentMusic", "MusicName", "GlobalMessage"
    }
    
    for _, valueName in pairs(valueNames) do
        local value = adminFolder:FindFirstChild(valueName)
        if not value then
            if valueName:find("Active") then
                value = Instance.new("BoolValue")
            else
                value = Instance.new("StringValue")
            end
            value.Name = valueName
            value.Parent = adminFolder
        end
        values[valueName] = value
    end
    
    return values, adminFolder
end

local replicatedValues, adminFolder = setupReplicatedStorage()

-- Create RemoteEvents
local function setupRemoteEvents()
    local remoteFolder = ReplicatedStorage:FindFirstChild("AdminRemotes")
    if not remoteFolder then
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "AdminRemotes"
        remoteFolder.Parent = ReplicatedStorage
    end
    
    local remoteNames = {
        "KickPlayer", "BanPlayer", "TeleportPlayer", "ServerMessage",
        "ToggleEvent", "PlayMusic", "ClearWorkspace", "SetGravity",
        "SetLighting", "SetFog"
    }
    
    local remotes = {}
    for _, remoteName in pairs(remoteNames) do
        local remote = remoteFolder:FindFirstChild(remoteName)
        if not remote then
            remote = Instance.new("RemoteEvent")
            remote.Name = remoteName
            remote.Parent = remoteFolder
        end
        remotes[remoteName] = remote
    end
    
    return remotes
end

local remoteEvents = setupRemoteEvents()

-- Create Professional GUI
local AdminGui = Instance.new("ScreenGui")
AdminGui.Name = "ProfessionalAdminPanel"
AdminGui.Parent = PlayerGui
AdminGui.ResetOnSpawn = false
AdminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container (Clean Professional Design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AdminGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
MainFrame.Size = UDim2.new(0, 800, 0, 600)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Professional Header
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Parent = MainFrame
HeaderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = HeaderFrame

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = HeaderFrame
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = HeaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "ADMIN PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = HeaderFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 50)
ContentFrame.Size = UDim2.new(1, 0, 1, -50)

-- Sidebar Navigation
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Parent = ContentFrame
SidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Size = UDim2.new(0, 180, 1, 0)

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = SidebarFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = SidebarFrame
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.PaddingBottom = UDim.new(0, 10)

-- Main Content Area
local MainContentFrame = Instance.new("Frame")
MainContentFrame.Name = "MainContentFrame"
MainContentFrame.Parent = ContentFrame
MainContentFrame.BackgroundTransparency = 1
MainContentFrame.Position = UDim2.new(0, 190, 0, 0)
MainContentFrame.Size = UDim2.new(1, -190, 1, 0)

-- Tab System
local currentTab = nil
local tabs = {}

local function createTab(name, icon)
    -- Sidebar Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Button"
    TabButton.Parent = SidebarFrame
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.LayoutOrder = #SidebarFrame:GetChildren()
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabButton
    TabPadding.PaddingLeft = UDim.new(0, 15)
    
    -- Content Page
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.Parent = MainContentFrame
    TabPage.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabPage.BorderSizePixel = 0
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 6
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 8)
    PageCorner.Parent = TabPage
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = TabPage
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    
    tabs[name] = {button = TabButton, page = TabPage}
    
    TabButton.MouseButton1Click:Connect(function()
        for tabName, tab in pairs(tabs) do
            tab.page.Visible = false
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
    end)
    
    return TabPage
end

-- Create Professional Buttons
local function createButton(parent, text, layoutOrder, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.LayoutOrder = layoutOrder
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    end)
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

-- Create Input Fields
local function createInputField(parent, placeholder, layoutOrder)
    local InputFrame = Instance.new("Frame")
    InputFrame.Parent = parent
    InputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, 35)
    InputFrame.LayoutOrder = layoutOrder
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Parent = InputFrame
    InputBox.BackgroundTransparency = 1
    InputBox.Position = UDim2.new(0, 10, 0, 0)
    InputBox.Size = UDim2.new(1, -20, 1, 0)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.PlaceholderText = placeholder
    InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 14
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    
    return InputBox
end

-- Helper Functions
local function getPlayerByName(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
        end
    end
    return nil
end

-- Create Tabs
local PlayersTab = createTab("Players", "👤")
local EventsTab = createTab("Events", "🎉")
local MusicTab = createTab("Music", "🎵")
local ServerTab = createTab("Server", "⚙️")

-- PLAYERS TAB
local PlayerInput = createInputField(PlayersTab, "Enter player name...", 1)

createButton(PlayersTab, "Kick Player", 2, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.KickPlayer:FireServer(playerName)
        PlayerInput.Text = ""
    end
end)

createButton(PlayersTab, "Ban Player", 3, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.BanPlayer:FireServer(playerName)
        PlayerInput.Text = ""
    end
end)

createButton(PlayersTab, "Teleport To Player", 4, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.TeleportPlayer:FireServer("to", playerName)
        PlayerInput.Text = ""
    end
end)

createButton(PlayersTab, "Bring Player", 5, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.TeleportPlayer:FireServer("bring", playerName)
        PlayerInput.Text = ""
    end
end)

-- EVENTS TAB
createButton(EventsTab, "Toggle Dance Party", 1, function()
    remoteEvents.ToggleEvent:FireServer("DanceParty")
end)

createButton(EventsTab, "Toggle Fireworks", 2, function()
    remoteEvents.ToggleEvent:FireServer("Fireworks")
end)

createButton(EventsTab, "Toggle Lightning Storm", 3, function()
    remoteEvents.ToggleEvent:FireServer("Lightning")
end)

createButton(EventsTab, "Toggle Meteor Shower", 4, function()
    remoteEvents.ToggleEvent:FireServer("Meteor")
end)

createButton(EventsTab, "Toggle Snow", 5, function()
    remoteEvents.ToggleEvent:FireServer("Snow")
end)

createButton(EventsTab, "Toggle Disco Mode", 6, function()
    remoteEvents.ToggleEvent:FireServer("Disco")
end)

-- MUSIC TAB
for i, musicName in pairs({"Chill Vibes", "Epic Battle", "Dance Party", "Synthwave", "Cyberpunk"}) do
    createButton(MusicTab, musicName, i, function()
        remoteEvents.PlayMusic:FireServer(MUSIC_IDS[musicName], musicName)
    end)
end

local CustomMusicInput = createInputField(MusicTab, "Enter music ID...", 10)
createButton(MusicTab, "Play Custom Music", 11, function()
    local musicId = CustomMusicInput.Text
    if musicId ~= "" then
        if not musicId:find("rbxassetid://") then
            musicId = "rbxassetid://" .. musicId
        end
        remoteEvents.PlayMusic:FireServer(musicId, "Custom")
        CustomMusicInput.Text = ""
    end
end)

createButton(MusicTab, "Stop Music", 12, function()
    remoteEvents.PlayMusic:FireServer("", "")
end)

-- SERVER TAB
createButton(ServerTab, "Clear Workspace", 1, function()
    remoteEvents.ClearWorkspace:FireServer()
end)

createButton(ServerTab, "Low Gravity", 2, function()
    remoteEvents.SetGravity:FireServer(50)
end)

createButton(ServerTab, "Normal Gravity", 3, function()
    remoteEvents.SetGravity:FireServer(196.2)
end)

createButton(ServerTab, "High Gravity", 4, function()
    remoteEvents.SetGravity:FireServer(500)
end)

createButton(ServerTab, "Day Time", 5, function()
    remoteEvents.SetLighting:FireServer("12:00:00")
end)

createButton(ServerTab, "Night Time", 6, function()
    remoteEvents.SetLighting:FireServer("00:00:00")
end)

local MessageInput = createInputField(ServerTab, "Enter server message...", 7)
createButton(ServerTab, "Send Message", 8, function()
    local message = MessageInput.Text
    if message ~= "" then
        remoteEvents.ServerMessage:FireServer(message)
        MessageInput.Text = ""
    end
end)

-- Set default tab
tabs["Players"].page.Visible = true
tabs["Players"].button.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
tabs["Players"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
currentTab = "Players"

-- Toggle functionality
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
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

-- Dragging
local dragging = false
local dragStart = nil
local startPos = nil

HeaderFrame.InputBegan:Connect(function(input)
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

print("Professional Admin Panel V3.0 loaded! Press F2 to open.")