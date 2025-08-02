-- ULTIMATE FUTURISTIC ADMIN PANEL V2.0
-- Press F2 to open/close
-- Created for advanced server administration with stunning visuals

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

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
    ["Intense"] = "rbxassetid://1847115477",
    ["Synthwave"] = "rbxassetid://142376088",
    ["Cyberpunk"] = "rbxassetid://1848354536",
    ["Future Bass"] = "rbxassetid://1846431449",
    ["Ambient Space"] = "rbxassetid://1845554017",
    ["Neon Dreams"] = "rbxassetid://1847269395"
}

local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", -- Dance 1
    "rbxassetid://507770818", -- Dance 2
    "rbxassetid://507771019", -- Dance 3
    "rbxassetid://507771955", -- Dance 4
    "rbxassetid://507772104", -- Dance 5
    "rbxassetid://507777623", -- Dance 6
    "rbxassetid://507777268", -- Dance 7
    "rbxassetid://507776879"  -- Dance 8
}

-- Check if player is admin
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or false
end

if not isAdmin(LocalPlayer) then
    return -- Exit if not admin
end

-- Create main GUI with fullscreen design
local AdminGui = Instance.new("ScreenGui")
AdminGui.Name = "UltimateFuturisticAdminPanel"
AdminGui.Parent = PlayerGui
AdminGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AdminGui.ResetOnSpawn = false

-- Fullscreen Background with animated gradient
local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.Name = "BackgroundFrame"
BackgroundFrame.Parent = AdminGui
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundFrame.BorderSizePixel = 0
BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
BackgroundFrame.Visible = false

-- Animated background gradient
local BackgroundGradient = Instance.new("UIGradient")
BackgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 60))
}
BackgroundGradient.Rotation = 45
BackgroundGradient.Parent = BackgroundFrame

-- Animated particles background
local ParticlesFrame = Instance.new("Frame")
ParticlesFrame.Name = "ParticlesFrame"
ParticlesFrame.Parent = BackgroundFrame
ParticlesFrame.BackgroundTransparency = 1
ParticlesFrame.Size = UDim2.new(1, 0, 1, 0)

-- Create floating particles
local function createParticle()
    local particle = Instance.new("Frame")
    particle.Name = "Particle"
    particle.Parent = ParticlesFrame
    particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
    particle.BorderSizePixel = 0
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, 1.1, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    
    -- Animate particle movement
    local tween = TweenService:Create(particle,
        TweenInfo.new(math.random(10, 20), Enum.EasingStyle.Linear),
        {
            Position = UDim2.new(math.random(), 0, -0.1, 0),
            BackgroundTransparency = 1
        }
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- Particle spawner
spawn(function()
    while true do
        if BackgroundFrame.Visible then
            createParticle()
            wait(0.1)
        else
            wait(1)
        end
    end
end)

-- Main glassmorphism container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Parent = BackgroundFrame
MainContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainContainer.BackgroundTransparency = 0.9
MainContainer.BorderSizePixel = 0
MainContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
MainContainer.Size = UDim2.new(0.9, 0, 0.9, 0)

-- Glassmorphism effect
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainContainer

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 200, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.5
MainStroke.Parent = MainContainer

-- Holographic header
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Parent = MainContainer
HeaderFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
HeaderFrame.BackgroundTransparency = 0.7
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Size = UDim2.new(1, 0, 0, 80)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = HeaderFrame

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 255))
}
HeaderGradient.Rotation = 90
HeaderGradient.Parent = HeaderFrame

-- Animated title with holographic effect
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = HeaderFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 30, 0, 0)
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "🌟 ULTIMATE FUTURISTIC ADMIN PANEL 🌟"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(0, 255, 255)
TitleStroke.Thickness = 2
TitleStroke.Parent = TitleLabel

-- Animated close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = HeaderFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.3
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -70, 0, 15)
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 100, 100)
CloseStroke.Thickness = 2
CloseStroke.Parent = CloseButton

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainContainer
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 20, 0, 100)
ContentContainer.Size = UDim2.new(1, -40, 1, -120)

-- Navigation sidebar
local NavigationFrame = Instance.new("Frame")
NavigationFrame.Name = "NavigationFrame"
NavigationFrame.Parent = ContentContainer
NavigationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
NavigationFrame.BackgroundTransparency = 0.3
NavigationFrame.BorderSizePixel = 0
NavigationFrame.Size = UDim2.new(0, 200, 1, 0)

local NavCorner = Instance.new("UICorner")
NavCorner.CornerRadius = UDim.new(0, 15)
NavCorner.Parent = NavigationFrame

local NavStroke = Instance.new("UIStroke")
NavStroke.Color = Color3.fromRGB(0, 255, 150)
NavStroke.Thickness = 1
NavStroke.Transparency = 0.5
NavStroke.Parent = NavigationFrame

local NavigationList = Instance.new("UIListLayout")
NavigationList.Parent = NavigationFrame
NavigationList.Padding = UDim.new(0, 5)
NavigationList.SortOrder = Enum.SortOrder.LayoutOrder

local NavPadding = Instance.new("UIPadding")
NavPadding.Parent = NavigationFrame
NavPadding.PaddingTop = UDim.new(0, 15)
NavPadding.PaddingLeft = UDim.new(0, 15)
NavPadding.PaddingRight = UDim.new(0, 15)
NavPadding.PaddingBottom = UDim.new(0, 15)

-- Content pages container
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = ContentContainer
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 220, 0, 0)
PagesContainer.Size = UDim2.new(1, -220, 1, 0)

-- Tab system with enhanced styling
local currentTab = nil
local tabs = {}

local function createTab(name, icon, color)
    -- Navigation button
    local NavButton = Instance.new("TextButton")
    NavButton.Name = name .. "NavButton"
    NavButton.Parent = NavigationFrame
    NavButton.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    NavButton.BackgroundTransparency = 0.3
    NavButton.BorderSizePixel = 0
    NavButton.Size = UDim2.new(1, 0, 0, 50)
    NavButton.Font = Enum.Font.SourceSansBold
    NavButton.Text = icon .. "  " .. name
    NavButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NavButton.TextScaled = true
    NavButton.TextXAlignment = Enum.TextXAlignment.Left
    NavButton.LayoutOrder = #NavigationFrame:GetChildren()
    
    local NavButtonCorner = Instance.new("UICorner")
    NavButtonCorner.CornerRadius = UDim.new(0, 10)
    NavButtonCorner.Parent = NavButton
    
    local NavButtonStroke = Instance.new("UIStroke")
    NavButtonStroke.Color = color or Color3.fromRGB(100, 100, 200)
    NavButtonStroke.Thickness = 1
    NavButtonStroke.Transparency = 0.7
    NavButtonStroke.Parent = NavButton
    
    -- Content page
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.Parent = PagesContainer
    TabPage.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    TabPage.BackgroundTransparency = 0.5
    TabPage.BorderSizePixel = 0
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 8
    TabPage.ScrollBarImageColor3 = color or Color3.fromRGB(0, 200, 255)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 15)
    PageCorner.Parent = TabPage
    
    local PageStroke = Instance.new("UIStroke")
    PageStroke.Color = color or Color3.fromRGB(0, 255, 150)
    PageStroke.Thickness = 1
    PageStroke.Transparency = 0.7
    PageStroke.Parent = TabPage
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = TabPage
    PagePadding.PaddingTop = UDim.new(0, 20)
    PagePadding.PaddingLeft = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 20)
    PagePadding.PaddingBottom = UDim.new(0, 20)
    
    tabs[name] = {button = NavButton, page = TabPage, color = color}
    
    -- Tab switching with animations
    NavButton.MouseButton1Click:Connect(function()
        for tabName, tab in pairs(tabs) do
            tab.page.Visible = false
            tab.button.BackgroundTransparency = 0.3
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        TabPage.Visible = true
        NavButton.BackgroundTransparency = 0.1
        NavButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
        
        -- Selection animation
        local tween = TweenService:Create(NavButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.1}
        )
        tween:Play()
    end)
    
    -- Hover effects
    NavButton.MouseEnter:Connect(function()
        if currentTab ~= name then
            local tween = TweenService:Create(NavButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.2}
            )
            tween:Play()
        end
    end)
    
    NavButton.MouseLeave:Connect(function()
        if currentTab ~= name then
            local tween = TweenService:Create(NavButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0.3}
            )
            tween:Play()
        end
    end)
    
    return TabPage
end

-- Enhanced button creation with futuristic styling
local function createButton(parent, text, layoutOrder, callback, color)
    local buttonColor = color or Color3.fromRGB(0, 150, 255)
    
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = buttonColor
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.LayoutOrder = layoutOrder
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = buttonColor
    ButtonStroke.Thickness = 2
    ButtonStroke.Transparency = 0.3
    ButtonStroke.Parent = Button
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, buttonColor),
        ColorSequenceKeypoint.new(1, Color3.new(
            math.min(buttonColor.R + 0.2, 1),
            math.min(buttonColor.G + 0.2, 1), 
            math.min(buttonColor.B + 0.2, 1)
        ))
    }
    ButtonGradient.Rotation = 90
    ButtonGradient.Parent = Button
    
    -- Enhanced hover effects
    Button.MouseEnter:Connect(function()
        local tween1 = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.1}
        )
        local tween2 = TweenService:Create(ButtonStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Transparency = 0.1}
        )
        tween1:Play()
        tween2:Play()
    end)
    
    Button.MouseLeave:Connect(function()
        local tween1 = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.2}
        )
        local tween2 = TweenService:Create(ButtonStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Transparency = 0.3}
        )
        tween1:Play()
        tween2:Play()
    end)
    
    -- Click animation
    Button.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(1, -4, 0, 46)}
        )
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(Button,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(1, 0, 0, 50)}
            )
            tween2:Play()
        end)
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- Enhanced input field creation
local function createInputField(parent, placeholder, layoutOrder, color)
    local inputColor = color or Color3.fromRGB(50, 50, 100)
    
    local InputFrame = Instance.new("Frame")
    InputFrame.Parent = parent
    InputFrame.BackgroundColor3 = inputColor
    InputFrame.BackgroundTransparency = 0.3
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, 50)
    InputFrame.LayoutOrder = layoutOrder
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 12)
    InputCorner.Parent = InputFrame
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(0, 200, 255)
    InputStroke.Thickness = 2
    InputStroke.Transparency = 0.5
    InputStroke.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Parent = InputFrame
    InputBox.BackgroundTransparency = 1
    InputBox.Position = UDim2.new(0, 15, 0, 0)
    InputBox.Size = UDim2.new(1, -30, 1, 0)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.PlaceholderText = placeholder
    InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 200)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextScaled = true
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Focus effects
    InputBox.Focused:Connect(function()
        local tween = TweenService:Create(InputStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Transparency = 0.2}
        )
        tween:Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        local tween = TweenService:Create(InputStroke,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {Transparency = 0.5}
        )
        tween:Play()
    end)
    
    return InputBox
end

-- Enhanced Player Management Functions with better visibility
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

-- Enhanced Remote Event System
local function setupRemoteEvents()
    -- Wait for or create AdminRemotes folder
    local AdminFolder = ReplicatedStorage:FindFirstChild("AdminRemotes")
    if not AdminFolder then
        AdminFolder = Instance.new("Folder")
        AdminFolder.Name = "AdminRemotes"
        AdminFolder.Parent = ReplicatedStorage
    end
    
    -- Create remote events if they don't exist
    local remoteNames = {
        "KickPlayer", "BanPlayer", "TeleportPlayer", "ServerMessage",
        "DancePartyEvent", "FireworksEvent", "LightningEvent", 
        "MeteorEvent", "SnowEvent", "DiscoEvent", "GlobalMusic"
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

-- Enhanced Event Functions with Global Visibility
local activeEvents = {}
local eventMusic = nil

local function startDanceParty()
    if activeEvents.danceParty then return end
    
    activeEvents.danceParty = true
    
    -- Fire remote event to make ALL players dance (including non-admins)
    if remoteEvents.DancePartyEvent then
        remoteEvents.DancePartyEvent:FireServer("start")
    end
    
    -- Play party music for everyone
    if remoteEvents.GlobalMusic then
        remoteEvents.GlobalMusic:FireServer(MUSIC_IDS["Dance Party"], "Dance Party")
    end
    
    -- Visual effects
    spawn(function()
        while activeEvents.danceParty do
            -- Create disco ball effect
            local effect = Instance.new("Explosion")
            effect.Position = Vector3.new(
                math.random(-50, 50),
                math.random(20, 40),
                math.random(-50, 50)
            )
            effect.BlastRadius = 0
            effect.BlastPressure = 0
            effect.Visible = false
            effect.Parent = Workspace
            
            wait(0.5)
        end
    end)
end

local function stopDanceParty()
    activeEvents.danceParty = false
    
    if remoteEvents.DancePartyEvent then
        remoteEvents.DancePartyEvent:FireServer("stop")
    end
    
    if remoteEvents.GlobalMusic then
        remoteEvents.GlobalMusic:FireServer("", "stop")
    end
end

local function startFireworksEvent()
    if activeEvents.fireworks then return end
    
    activeEvents.fireworks = true
    
    if remoteEvents.FireworksEvent then
        remoteEvents.FireworksEvent:FireServer("start")
    end
    
    spawn(function()
        while activeEvents.fireworks do
            -- Create firework explosions
            for i = 1, 3 do
                local firework = Instance.new("Explosion")
                firework.Position = Vector3.new(
                    math.random(-100, 100),
                    math.random(50, 100),
                    math.random(-100, 100)
                )
                firework.BlastRadius = 20
                firework.BlastPressure = 0
                firework.Parent = Workspace
                
                wait(0.2)
            end
            wait(1)
        end
    end)
end

local function stopFireworksEvent()
    activeEvents.fireworks = false
    
    if remoteEvents.FireworksEvent then
        remoteEvents.FireworksEvent:FireServer("stop")
    end
end

local function startLightningEvent()
    if activeEvents.lightning then return end
    
    activeEvents.lightning = true
    
    if remoteEvents.LightningEvent then
        remoteEvents.LightningEvent:FireServer("start")
    end
    
    spawn(function()
        local originalAmbient = Lighting.Ambient
        local originalBrightness = Lighting.Brightness
        
        while activeEvents.lightning do
            -- Lightning flash
            Lighting.Ambient = Color3.fromRGB(200, 200, 255)
            Lighting.Brightness = 2
            
            -- Thunder sound
            local thunder = Instance.new("Sound")
            thunder.SoundId = "rbxassetid://131961136"
            thunder.Volume = 0.5
            thunder.Parent = Workspace
            thunder:Play()
            
            Debris:AddItem(thunder, 5)
            
            wait(0.1)
            Lighting.Ambient = originalAmbient
            Lighting.Brightness = originalBrightness
            
            wait(math.random(2, 8))
        end
        
        Lighting.Ambient = originalAmbient
        Lighting.Brightness = originalBrightness
    end)
end

local function stopLightningEvent()
    activeEvents.lightning = false
    
    if remoteEvents.LightningEvent then
        remoteEvents.LightningEvent:FireServer("stop")
    end
end

local function startMeteorEvent()
    if activeEvents.meteor then return end
    
    activeEvents.meteor = true
    
    if remoteEvents.MeteorEvent then
        remoteEvents.MeteorEvent:FireServer("start")
    end
    
    spawn(function()
        while activeEvents.meteor do
            -- Create meteor
            local meteor = Instance.new("Part")
            meteor.Name = "Meteor"
            meteor.Size = Vector3.new(4, 4, 4)
            meteor.Material = Enum.Material.Neon
            meteor.BrickColor = BrickColor.new("Bright orange")
            meteor.Shape = Enum.PartType.Ball
            meteor.TopSurface = Enum.SurfaceType.Smooth
            meteor.BottomSurface = Enum.SurfaceType.Smooth
            meteor.CanCollide = false
            meteor.Position = Vector3.new(
                math.random(-200, 200),
                200,
                math.random(-200, 200)
            )
            meteor.Parent = Workspace
            
            -- Add fire effect
            local fire = Instance.new("Fire")
            fire.Size = 10
            fire.Heat = 15
            fire.Parent = meteor
            
            -- Add velocity
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(
                math.random(-50, 50),
                -100,
                math.random(-50, 50)
            )
            bodyVelocity.Parent = meteor
            
            -- Destroy on impact
            meteor.Touched:Connect(function(hit)
                if hit.Name == "Baseplate" or hit.Parent:FindFirstChild("Humanoid") then
                    local explosion = Instance.new("Explosion")
                    explosion.Position = meteor.Position
                    explosion.BlastRadius = 25
                    explosion.BlastPressure = 500000
                    explosion.Parent = Workspace
                    
                    meteor:Destroy()
                end
            end)
            
            Debris:AddItem(meteor, 10)
            wait(2)
        end
    end)
end

local function stopMeteorEvent()
    activeEvents.meteor = false
    
    if remoteEvents.MeteorEvent then
        remoteEvents.MeteorEvent:FireServer("stop")
    end
    
    -- Clean up existing meteors
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Meteor" then
            obj:Destroy()
        end
    end
end

local function startSnowEvent()
    if activeEvents.snow then return end
    
    activeEvents.snow = true
    
    if remoteEvents.SnowEvent then
        remoteEvents.SnowEvent:FireServer("start")
    end
    
    -- Create snow effect for all players
    local snowPart = Instance.new("Part")
    snowPart.Name = "SnowCloud"
    snowPart.Size = Vector3.new(500, 1, 500)
    snowPart.Position = Vector3.new(0, 200, 0)
    snowPart.Anchored = true
    snowPart.CanCollide = false
    snowPart.Transparency = 1
    snowPart.Parent = Workspace
    
    local snowAttachment = Instance.new("Attachment")
    snowAttachment.Parent = snowPart
    
    local snowEffect = Instance.new("ParticleEmitter")
    snowEffect.Parent = snowAttachment
    snowEffect.Texture = "rbxasset://textures/particles/snow_main_01.dds"
    snowEffect.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    snowEffect.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.1)
    }
    snowEffect.Lifetime = NumberRange.new(8, 12)
    snowEffect.Rate = 1000
    snowEffect.SpreadAngle = Vector2.new(45, 45)
    snowEffect.Speed = NumberRange.new(5, 15)
    snowEffect.Acceleration = Vector3.new(0, -10, 0)
    
    activeEvents.snowPart = snowPart
    
    -- Change lighting for winter
    Lighting.Ambient = Color3.fromRGB(150, 150, 200)
    Lighting.ColorShift_Top = Color3.fromRGB(200, 200, 255)
end

local function stopSnowEvent()
    activeEvents.snow = false
    
    if remoteEvents.SnowEvent then
        remoteEvents.SnowEvent:FireServer("stop")
    end
    
    if activeEvents.snowPart then
        activeEvents.snowPart:Destroy()
        activeEvents.snowPart = nil
    end
    
    -- Reset lighting
    Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
end

local function startDiscoEvent()
    if activeEvents.disco then return end
    
    activeEvents.disco = true
    
    if remoteEvents.DiscoEvent then
        remoteEvents.DiscoEvent:FireServer("start")
    end
    
    spawn(function()
        while activeEvents.disco do
            -- Disco lighting
            Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
            Lighting.ColorShift_Top = Color3.fromHSV(math.random(), 1, 1)
            Lighting.ColorShift_Bottom = Color3.fromHSV(math.random(), 1, 1)
            
            wait(0.2)
        end
        
        -- Reset lighting
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    end)
end

local function stopDiscoEvent()
    activeEvents.disco = false
    
    if remoteEvents.DiscoEvent then
        remoteEvents.DiscoEvent:FireServer("stop")
    end
end

-- Enhanced music system
local currentMusic = nil

local function playMusic(musicId, name)
    if remoteEvents.GlobalMusic then
        remoteEvents.GlobalMusic:FireServer(musicId, name)
    end
end

local function stopMusic()
    if remoteEvents.GlobalMusic then
        remoteEvents.GlobalMusic:FireServer("", "stop")
    end
end

-- Create enhanced tabs with new events
local PlayerTab = createTab("Players", "👤", Color3.fromRGB(0, 150, 255))
local EventsTab = createTab("Events", "🎉", Color3.fromRGB(255, 100, 0))
local MusicTab = createTab("Music", "🎵", Color3.fromRGB(150, 0, 255))
local ServerTab = createTab("Server", "⚙️", Color3.fromRGB(0, 255, 100))
local WeatherTab = createTab("Weather", "🌤️", Color3.fromRGB(100, 200, 255))

-- PLAYERS TAB CONTENT
local PlayerInputField = createInputField(PlayerTab, "Enter player name...", 1, Color3.fromRGB(0, 100, 200))

createButton(PlayerTab, "🔥 Kick Player", 2, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        if remoteEvents.KickPlayer then
            remoteEvents.KickPlayer:FireServer(playerName)
            PlayerInputField.Text = "✅ Kick request sent"
            wait(2)
            PlayerInputField.Text = ""
        end
    end
end, Color3.fromRGB(255, 50, 50))

createButton(PlayerTab, "🚫 Ban Player", 3, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        if remoteEvents.BanPlayer then
            remoteEvents.BanPlayer:FireServer(playerName)
            PlayerInputField.Text = "✅ Ban request sent"
            wait(2)
            PlayerInputField.Text = ""
        end
    end
end, Color3.fromRGB(255, 0, 0))

createButton(PlayerTab, "📍 Teleport To Player", 4, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        if remoteEvents.TeleportPlayer then
            remoteEvents.TeleportPlayer:FireServer("to", playerName)
            PlayerInputField.Text = "✅ Teleport request sent"
            wait(2)
            PlayerInputField.Text = ""
        end
    end
end, Color3.fromRGB(0, 255, 150))

createButton(PlayerTab, "📍 Bring Player", 5, function()
    local playerName = PlayerInputField.Text
    if playerName ~= "" then
        if remoteEvents.TeleportPlayer then
            remoteEvents.TeleportPlayer:FireServer("bring", playerName)
            PlayerInputField.Text = "✅ Bring request sent"
            wait(2)
            PlayerInputField.Text = ""
        end
    end
end, Color3.fromRGB(0, 255, 200))

createButton(PlayerTab, "👥 List Online Players", 6, function()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    PlayerInputField.Text = table.concat(playerList, ", ")
    wait(5)
    PlayerInputField.Text = ""
end, Color3.fromRGB(100, 150, 255))

-- ENHANCED EVENTS TAB CONTENT
createButton(EventsTab, "🕺 Start Dance Party", 1, startDanceParty, Color3.fromRGB(255, 100, 255))
createButton(EventsTab, "⏹️ Stop Dance Party", 2, stopDanceParty, Color3.fromRGB(255, 50, 50))

createButton(EventsTab, "🎆 Start Fireworks", 3, startFireworksEvent, Color3.fromRGB(255, 200, 0))
createButton(EventsTab, "⏹️ Stop Fireworks", 4, stopFireworksEvent, Color3.fromRGB(255, 50, 50))

createButton(EventsTab, "⚡ Start Lightning Storm", 5, startLightningEvent, Color3.fromRGB(255, 255, 0))
createButton(EventsTab, "⏹️ Stop Lightning", 6, stopLightningEvent, Color3.fromRGB(255, 50, 50))

createButton(EventsTab, "☄️ Start Meteor Shower", 7, startMeteorEvent, Color3.fromRGB(255, 100, 0))
createButton(EventsTab, "⏹️ Stop Meteors", 8, stopMeteorEvent, Color3.fromRGB(255, 50, 50))

createButton(EventsTab, "💃 Start Disco Mode", 9, startDiscoEvent, Color3.fromRGB(255, 0, 255))
createButton(EventsTab, "⏹️ Stop Disco", 10, stopDiscoEvent, Color3.fromRGB(255, 50, 50))

-- WEATHER TAB CONTENT
createButton(WeatherTab, "❄️ Start Snow Event", 1, startSnowEvent, Color3.fromRGB(200, 200, 255))
createButton(WeatherTab, "⏹️ Stop Snow", 2, stopSnowEvent, Color3.fromRGB(255, 50, 50))

createButton(WeatherTab, "🌙 Night Mode", 3, function()
    Lighting.TimeOfDay = "00:00:00"
    Lighting.Ambient = Color3.fromRGB(50, 50, 100)
    Lighting.ColorShift_Top = Color3.fromRGB(100, 100, 150)
end, Color3.fromRGB(50, 50, 150))

createButton(WeatherTab, "☀️ Day Mode", 4, function()
    Lighting.TimeOfDay = "12:00:00"
    Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
end, Color3.fromRGB(255, 255, 0))

createButton(WeatherTab, "🌅 Sunset Mode", 5, function()
    Lighting.TimeOfDay = "18:00:00"
    Lighting.Ambient = Color3.fromRGB(200, 100, 50)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 150, 100)
end, Color3.fromRGB(255, 150, 50))

createButton(WeatherTab, "🌈 Rainbow Sky", 6, function()
    spawn(function()
        for i = 1, 100 do
            Lighting.Ambient = Color3.fromHSV(i / 100, 1, 1)
            Lighting.ColorShift_Top = Color3.fromHSV((i + 50) / 100, 1, 1)
            wait(0.1)
        end
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    end)
end, Color3.fromRGB(255, 200, 100))

-- ENHANCED MUSIC TAB CONTENT
for musicName, musicId in pairs(MUSIC_IDS) do
    createButton(MusicTab, "🎵 " .. musicName, #MusicTab:GetChildren(), function()
        playMusic(musicId, musicName)
    end, Color3.fromRGB(150, 0, 255))
end

createButton(MusicTab, "⏹️ Stop Music", #MusicTab:GetChildren() + 1, stopMusic, Color3.fromRGB(255, 50, 50))

local CustomMusicInput = createInputField(MusicTab, "Enter music ID...", #MusicTab:GetChildren() + 2, Color3.fromRGB(100, 0, 200))

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
end, Color3.fromRGB(150, 0, 255))

-- SERVER TAB CONTENT
createButton(ServerTab, "🧹 Clear Workspace", 1, function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= Workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        elseif obj:IsA("Part") and obj.Name ~= "Baseplate" and obj.Name ~= "SpawnLocation" then
            obj:Destroy()
        end
    end
end, Color3.fromRGB(255, 150, 0))

createButton(ServerTab, "💨 Low Gravity", 2, function()
    Workspace.Gravity = 50
end, Color3.fromRGB(100, 255, 200))

createButton(ServerTab, "🌍 Normal Gravity", 3, function()
    Workspace.Gravity = 196.2
end, Color3.fromRGB(0, 255, 100))

createButton(ServerTab, "🚀 High Gravity", 4, function()
    Workspace.Gravity = 500
end, Color3.fromRGB(255, 100, 0))

createButton(ServerTab, "🌫️ Add Fog", 5, function()
    Lighting.FogStart = 0
    Lighting.FogEnd = 100
    Lighting.FogColor = Color3.fromRGB(100, 100, 100)
end, Color3.fromRGB(150, 150, 150))

createButton(ServerTab, "🌞 Remove Fog", 6, function()
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end, Color3.fromRGB(255, 255, 0))

local MessageInput = createInputField(ServerTab, "Enter server message...", 7, Color3.fromRGB(0, 150, 100))

createButton(ServerTab, "📢 Send Server Message", 8, function()
    local message = MessageInput.Text
    if message ~= "" then
        if remoteEvents.ServerMessage then
            remoteEvents.ServerMessage:FireServer(message)
            MessageInput.Text = "✅ Message sent!"
            wait(2)
            MessageInput.Text = ""
        end
    end
end, Color3.fromRGB(0, 255, 150))

-- Set default tab
tabs["Players"].page.Visible = true
tabs["Players"].button.BackgroundTransparency = 0.1
tabs["Players"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
currentTab = "Players"

-- Enhanced toggle functionality with fullscreen
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    
    if isOpen then
        BackgroundFrame.Visible = true
        MainContainer.Position = UDim2.new(0.05, 0, 1, 0)
        
        -- Background fade in
        local backgroundTween = TweenService:Create(BackgroundFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0.2}
        )
        backgroundTween:Play()
        
        -- Main container slide in
        local containerTween = TweenService:Create(MainContainer,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.05, 0, 0.05, 0)}
        )
        containerTween:Play()
        
        -- Title animation
        spawn(function()
            while isOpen do
                local tween = TweenService:Create(TitleStroke,
                    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Color = Color3.fromHSV(math.random(), 1, 1)}
                )
                tween:Play()
                wait(2)
            end
        end)
        
        -- Background gradient animation
        spawn(function()
            local rotation = 0
            while isOpen do
                rotation = rotation + 1
                BackgroundGradient.Rotation = rotation
                wait(0.1)
            end
        end)
        
    else
        -- Container slide out
        local containerTween = TweenService:Create(MainContainer,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.05, 0, 1, 0)}
        )
        containerTween:Play()
        
        -- Background fade out
        local backgroundTween = TweenService:Create(BackgroundFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        )
        backgroundTween:Play()
        
        backgroundTween.Completed:Connect(function()
            BackgroundFrame.Visible = false
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

-- Enhanced dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

HeaderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(
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

-- Enhanced banned players handling
Players.PlayerAdded:Connect(function(player)
    if bannedPlayers[player.UserId] then
        player:Kick("🚫 You are banned from this server")
    end
end)

-- Success notification
local function showNotification(message, color)
    local notif = Instance.new("Frame")
    notif.Parent = BackgroundFrame
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 255, 100)
    notif.BackgroundTransparency = 0.3
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 0, 0, 20)
    notif.Size = UDim2.new(0, 300, 0, 60)
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.BackgroundTransparency = 1
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.Font = Enum.Font.SourceSansBold
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    
    -- Animate notification
    local slideIn = TweenService:Create(notif,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 0, 20)}
    )
    slideIn:Play()
    
    wait(3)
    
    local slideOut = TweenService:Create(notif,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 0, 0, 20)}
    )
    slideOut:Play()
    
    slideOut.Completed:Connect(function()
        notif:Destroy()
    end)
end

print("🌟 Ultimate Futuristic Admin Panel V2.0 loaded! Press F2 to open.")
print("👑 Admin: " .. LocalPlayer.Name)
print("✨ New features: Fullscreen GUI, Enhanced Events, Better Visibility!")