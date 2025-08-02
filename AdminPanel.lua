-- ULTIMATE ADMIN PANEL
-- Press F2 to open/close
-- Created for advanced server administration

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local ADMIN_LIST = {
    [LocalPlayer.UserId] = true, -- Add your user ID here
    -- Add more admin user IDs as needed
}

local MUSIC_IDS = {
    ["Chill Vibes"] = "rbxassetid://1841647093",
    ["Epic Battle"] = "rbxassetid://1837879082",
    ["Dance Party"] = "rbxassetid://1845756489",
    ["Relaxing"] = "rbxassetid://1838819154",
    ["Intense"] = "rbxassetid://1847115477"
}

local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", -- Dance 1
    "rbxassetid://507770818", -- Dance 2
    "rbxassetid://507771019", -- Dance 3
    "rbxassetid://507771955", -- Dance 4
    "rbxassetid://507772104"  -- Dance 5
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
AdminGui.Name = "AdminPanel"
AdminGui.Parent = PlayerGui
AdminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AdminGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Visible = false

-- Add corner radius
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Add gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fix title bar corners
local TitleFix = Instance.new("Frame")
TitleFix.Parent = TitleBar
TitleFix.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "🛡️ ULTIMATE ADMIN PANEL"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.Size = UDim2.new(1, -20, 1, -60)

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = ContentFrame
TabsContainer.BackgroundTransparency = 1
TabsContainer.Size = UDim2.new(1, 0, 0, 40)

local TabsList = Instance.new("UIListLayout")
TabsList.Parent = TabsContainer
TabsList.FillDirection = Enum.FillDirection.Horizontal
TabsList.Padding = UDim.new(0, 5)

-- Content Pages
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = ContentFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 0, 0, 50)
PagesContainer.Size = UDim2.new(1, 0, 1, -50)

-- Tab System
local currentTab = nil
local tabs = {}

local function createTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 120, 1, 0)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextScaled = true
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.Parent = PagesContainer
    TabPage.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabPage.BorderSizePixel = 0
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 8
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 255)
    
    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 8)
    PageCorner.Parent = TabPage
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.Padding = UDim.new(0, 5)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = TabPage
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 10)
    
    tabs[name] = {button = TabButton, page = TabPage}
    
    TabButton.MouseButton1Click:Connect(function()
        for tabName, tab in pairs(tabs) do
            tab.page.Visible = false
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
        
        -- Animate tab selection
        local tween = TweenService:Create(TabButton, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}
        )
        tween:Play()
    end)
    
    return TabPage
end

-- Create button helper
local function createButton(parent, text, layoutOrder, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.LayoutOrder = layoutOrder
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(70, 120, 220)}
        )
        tween:Play()
    end)
    
    Button.MouseLeave:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.fromRGB(50, 100, 200)}
        )
        tween:Play()
    end)
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

-- Create input field helper
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
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderText = placeholder
    InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextScaled = true
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    
    return InputBox
end

-- Player Management Functions
local bannedPlayers = {}

local function getPlayerFromInput(input)
    local targetPlayer = nil
    
    -- Try exact username match first
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == input:lower() or player.DisplayName:lower() == input:lower() then
            targetPlayer = player
            break
        end
    end
    
    -- Try partial match
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

local function kickPlayer(playerName)
    local targetPlayer = getPlayerFromInput(playerName)
    if targetPlayer then
        targetPlayer:Kick("🔨 You have been kicked by an administrator")
        return true, targetPlayer.Name
    end
    return false, "Player not found"
end

local function banPlayer(playerName)
    local targetPlayer = getPlayerFromInput(playerName)
    if targetPlayer then
        bannedPlayers[targetPlayer.UserId] = {
            name = targetPlayer.Name,
            reason = "Banned by administrator",
            timestamp = os.time()
        }
        targetPlayer:Kick("🚫 You have been banned from this server")
        return true, targetPlayer.Name
    end
    return false, "Player not found"
end

local function teleportToPlayer(playerName)
    local targetPlayer = getPlayerFromInput(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            return true, targetPlayer.Name
        end
    end
    return false, "Unable to teleport"
end

local function teleportPlayerToMe(playerName)
    local targetPlayer = getPlayerFromInput(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            return true, targetPlayer.Name
        end
    end
    return false, "Unable to teleport player"
end

-- Live Events System
local activeEvents = {}
local eventMusic = nil

local function startDanceParty()
    if activeEvents.danceParty then return end
    
    activeEvents.danceParty = true
    
    -- Play party music
    if eventMusic then
        eventMusic:Stop()
        eventMusic:Destroy()
    end
    
    eventMusic = Instance.new("Sound")
    eventMusic.Name = "PartyMusic"
    eventMusic.SoundId = MUSIC_IDS["Dance Party"]
    eventMusic.Volume = 0.5
    eventMusic.Looped = true
    eventMusic.Parent = Workspace
    eventMusic:Play()
    
    -- Make all players dance
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                local danceId = DANCE_ANIMATIONS[math.random(1, #DANCE_ANIMATIONS)]
                local animation = Instance.new("Animation")
                animation.AnimationId = danceId
                local track = animator:LoadAnimation(animation)
                track.Looped = true
                track:Play()
                
                -- Store track for cleanup
                if not activeEvents.danceTracks then
                    activeEvents.danceTracks = {}
                end
                table.insert(activeEvents.danceTracks, track)
            end
        end
    end
    
    -- Party lighting effects
    spawn(function()
        local originalBrightness = Lighting.Brightness
        local originalAmbient = Lighting.Ambient
        
        while activeEvents.danceParty do
            Lighting.Brightness = math.random(50, 100) / 100
            Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
            wait(0.5)
        end
        
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
    end)
end

local function stopDanceParty()
    activeEvents.danceParty = false
    
    if eventMusic then
        eventMusic:Stop()
        eventMusic:Destroy()
        eventMusic = nil
    end
    
    if activeEvents.danceTracks then
        for _, track in pairs(activeEvents.danceTracks) do
            track:Stop()
        end
        activeEvents.danceTracks = {}
    end
end

local function startRainEvent()
    if activeEvents.rain then return end
    
    activeEvents.rain = true
    
    -- Create rain effect
    local rainPart = Instance.new("Part")
    rainPart.Name = "RainCloud"
    rainPart.Size = Vector3.new(200, 1, 200)
    rainPart.Position = Vector3.new(0, 100, 0)
    rainPart.Anchored = true
    rainPart.CanCollide = false
    rainPart.Transparency = 1
    rainPart.Parent = Workspace
    
    local rainAttachment = Instance.new("Attachment")
    rainAttachment.Parent = rainPart
    
    local rainEffect = Instance.new("ParticleEmitter")
    rainEffect.Parent = rainAttachment
    rainEffect.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    rainEffect.Color = ColorSequence.new(Color3.fromRGB(100, 150, 255))
    rainEffect.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.1)
    }
    rainEffect.Lifetime = NumberRange.new(3, 5)
    rainEffect.Rate = 500
    rainEffect.SpreadAngle = Vector2.new(0, 0)
    rainEffect.Speed = NumberRange.new(20, 30)
    rainEffect.Acceleration = Vector3.new(0, -50, 0)
    
    activeEvents.rainPart = rainPart
    
    -- Change lighting for rain
    local originalAmbient = Lighting.Ambient
    Lighting.Ambient = Color3.fromRGB(50, 50, 80)
    activeEvents.originalAmbient = originalAmbient
end

local function stopRainEvent()
    activeEvents.rain = false
    
    if activeEvents.rainPart then
        activeEvents.rainPart:Destroy()
        activeEvents.rainPart = nil
    end
    
    if activeEvents.originalAmbient then
        Lighting.Ambient = activeEvents.originalAmbient
        activeEvents.originalAmbient = nil
    end
end

-- Create tabs
local PlayerTab = createTab("Players", "👤")
local EventsTab = createTab("Events", "🎉")
local MusicTab = createTab("Music", "🎵")
local ServerTab = createTab("Server", "⚙️")

-- PLAYERS TAB CONTENT
local PlayerInputField = createInputField(PlayerTab, "Enter player name...", 1)

createButton(PlayerTab, "🔥 Kick Player", 2, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        local success, result = kickPlayer(playerName)
        PlayerInputField.Text = success and ("✅ Kicked " .. result) or ("❌ " .. result)
        wait(2)
        PlayerInputField.Text = ""
    end
end)

createButton(PlayerTab, "🚫 Ban Player", 3, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        local success, result = banPlayer(playerName)
        PlayerInputField.Text = success and ("✅ Banned " .. result) or ("❌ " .. result)
        wait(2)
        PlayerInputField.Text = ""
    end
end)

createButton(PlayerTab, "📍 Teleport To Player", 4, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        local success, result = teleportToPlayer(playerName)
        PlayerInputField.Text = success and ("✅ Teleported to " .. result) or ("❌ " .. result)
        wait(2)
        PlayerInputField.Text = ""
    end
end)

createButton(PlayerTab, "📍 Bring Player", 5, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        local success, result = teleportPlayerToMe(playerName)
        PlayerInputField.Text = success and ("✅ Brought " .. result) or ("❌ " .. result)
        wait(2)
        PlayerInputField.Text = ""
    end
end)

createButton(PlayerTab, "👥 List Online Players", 6, function()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    PlayerInputField.Text = table.concat(playerList, ", ")
    wait(5)
    PlayerInputField.Text = ""
end)

-- EVENTS TAB CONTENT
createButton(EventsTab, "🕺 Start Dance Party", 1, function()
    startDanceParty()
end)

createButton(EventsTab, "⏹️ Stop Dance Party", 2, function()
    stopDanceParty()
end)

createButton(EventsTab, "🌧️ Start Rain Event", 3, function()
    startRainEvent()
end)

createButton(EventsTab, "☀️ Stop Rain Event", 4, function()
    stopRainEvent()
end)

createButton(EventsTab, "🌙 Night Mode", 5, function()
    Lighting.TimeOfDay = "00:00:00"
    Lighting.Ambient = Color3.fromRGB(50, 50, 100)
end)

createButton(EventsTab, "☀️ Day Mode", 6, function()
    Lighting.TimeOfDay = "12:00:00"
    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
end)

createButton(EventsTab, "🌈 Rainbow Sky", 7, function()
    spawn(function()
        for i = 1, 50 do
            Lighting.Ambient = Color3.fromHSV(i / 50, 1, 1)
            wait(0.1)
        end
        Lighting.Ambient = Color3.fromRGB(150, 150, 150)
    end)
end)

-- MUSIC TAB CONTENT
local currentMusic = nil

local function playMusic(musicId, name)
    if currentMusic then
        currentMusic:Stop()
        currentMusic:Destroy()
    end
    
    currentMusic = Instance.new("Sound")
    currentMusic.Name = "AdminMusic"
    currentMusic.SoundId = musicId
    currentMusic.Volume = 0.5
    currentMusic.Looped = true
    currentMusic.Parent = Workspace
    currentMusic:Play()
end

local function stopMusic()
    if currentMusic then
        currentMusic:Stop()
        currentMusic:Destroy()
        currentMusic = nil
    end
end

for musicName, musicId in pairs(MUSIC_IDS) do
    createButton(MusicTab, "🎵 " .. musicName, #MusicTab:GetChildren(), function()
        playMusic(musicId, musicName)
    end)
end

createButton(MusicTab, "⏹️ Stop Music", #MusicTab:GetChildren() + 1, function()
    stopMusic()
end)

local CustomMusicInput = createInputField(MusicTab, "Enter music ID...", #MusicTab:GetChildren() + 2)

createButton(MusicTab, "🎶 Play Custom Music", #MusicTab:GetChildren() + 1, function()
    local musicId = CustomMusicInput.Text
    if musicId ~= "" then
        if not musicId:find("rbxassetid://") then
            musicId = "rbxassetid://" .. musicId
        end
        playMusic(musicId, "Custom")
        CustomMusicInput.Text = "✅ Playing custom music"
        wait(2)
        CustomMusicInput.Text = ""
    end
end)

-- SERVER TAB CONTENT
createButton(ServerTab, "🧹 Clear Workspace", 1, function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= Workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        elseif obj:IsA("Part") and obj.Name ~= "Baseplate" then
            obj:Destroy()
        end
    end
end)

createButton(ServerTab, "💨 Low Gravity", 2, function()
    Workspace.Gravity = 50
end)

createButton(ServerTab, "🌍 Normal Gravity", 3, function()
    Workspace.Gravity = 196.2
end)

createButton(ServerTab, "🚀 High Gravity", 4, function()
    Workspace.Gravity = 500
end)

createButton(ServerTab, "🌫️ Add Fog", 5, function()
    Lighting.FogStart = 0
    Lighting.FogEnd = 100
    Lighting.FogColor = Color3.fromRGB(100, 100, 100)
end)

createButton(ServerTab, "🌞 Remove Fog", 6, function()
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end)

local MessageInput = createInputField(ServerTab, "Enter server message...", 7)

createButton(ServerTab, "📢 Send Server Message", 8, function()
    local message = MessageInput.Text
    if message ~= "" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local gui = Instance.new("ScreenGui")
                gui.Parent = player:WaitForChild("PlayerGui")
                
                local frame = Instance.new("Frame")
                frame.Parent = gui
                frame.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
                frame.BorderSizePixel = 0
                frame.Position = UDim2.new(0.5, -200, 0, -50)
                frame.Size = UDim2.new(0, 400, 0, 50)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = frame
                
                local text = Instance.new("TextLabel")
                text.Parent = frame
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Font = Enum.Font.GothamBold
                text.Text = "📢 " .. message
                text.TextColor3 = Color3.fromRGB(255, 255, 255)
                text.TextScaled = true
                
                -- Animate message
                local tween1 = TweenService:Create(frame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0.5, -200, 0, 20)}
                )
                tween1:Play()
                
                wait(3)
                
                local tween2 = TweenService:Create(frame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Position = UDim2.new(0.5, -200, 0, -50)}
                )
                tween2:Play()
                
                tween2.Completed:Connect(function()
                    gui:Destroy()
                end)
            end
        end
        MessageInput.Text = "✅ Message sent!"
        wait(2)
        MessageInput.Text = ""
    end
end)

-- Set default tab
tabs["Players"].page.Visible = true
tabs["Players"].button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
tabs["Players"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
currentTab = "Players"

-- Toggle functionality
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Position = UDim2.new(0.5, -300, 1, 0)
        
        local tween = TweenService:Create(MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -300, 0.5, -250)}
        )
        tween:Play()
    else
        local tween = TweenService:Create(MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -300, 1, 0)}
        )
        tween:Play()
        
        tween.Completed:Connect(function()
            MainFrame.Visible = false
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

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    togglePanel()
end)

-- Handle banned players
Players.PlayerAdded:Connect(function(player)
    if bannedPlayers[player.UserId] then
        player:Kick("🚫 You are banned from this server")
    end
end)

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🛡️ Ultimate Admin Panel loaded! Press F2 to open.")
print("👑 Admin: " .. LocalPlayer.Name)