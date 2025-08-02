-- PROFESSIONAL ADMIN PANEL V3.0
-- Press F2 to open/close
-- Clean, modern design with game-wide functionality

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

-- Main container with modern styling
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AdminGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Visible = false

-- Modern rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Subtle border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 130, 255)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Drop shadow effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = AdminGui
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0.3, 3, 0.2, 3)
Shadow.Size = UDim2.new(0.4, 0, 0.6, 0)
Shadow.Visible = false
Shadow.ZIndex = -1

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 12)
ShadowCorner.Parent = Shadow

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix header corners to only round top
local HeaderMask = Instance.new("Frame")
HeaderMask.Parent = Header
HeaderMask.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
HeaderMask.BorderSizePixel = 0
HeaderMask.Position = UDim2.new(0, 0, 0.5, 0)
HeaderMask.Size = UDim2.new(1, 0, 0.5, 0)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Admin Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton

-- Content area
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 0, 0, 60)
Content.Size = UDim2.new(1, 0, 1, -60)
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = Content
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = Content
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 15)
ContentPadding.PaddingRight = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)

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
        "CreateParticles", "SpawnObject", "WeatherEffect", "PlayerEffect"
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

-- Modern button creation
local function createButton(parent, text, layoutOrder, callback, color)
    local buttonColor = color or Color3.fromRGB(70, 130, 255)
    
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = buttonColor
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.LayoutOrder = layoutOrder
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = Color3.new(
                math.min(buttonColor.R + 0.1, 1),
                math.min(buttonColor.G + 0.1, 1),
                math.min(buttonColor.B + 0.1, 1)
            )}
        )
        tween:Play()
    end)
    
    Button.MouseLeave:Connect(function()
        local tween = TweenService:Create(Button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = buttonColor}
        )
        tween:Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- Input field creation
local function createInputField(parent, placeholder, layoutOrder)
    local InputFrame = Instance.new("Frame")
    InputFrame.Parent = parent
    InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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

-- Section headers
local function createSection(parent, title, layoutOrder)
    local Section = Instance.new("TextLabel")
    Section.Parent = parent
    Section.BackgroundTransparency = 1
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.Font = Enum.Font.SourceSansBold
    Section.Text = title
    Section.TextColor3 = Color3.fromRGB(200, 200, 200)
    Section.TextSize = 16
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.LayoutOrder = layoutOrder
    
    return Section
end

-- Get player from input
local function getPlayerFromInput(input)
    local targetPlayer = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == input:lower() or player.DisplayName:lower() == input:lower() then
            targetPlayer = player
            break
        end
    end
    
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

-- Create GUI elements
local orderCounter = 1

-- Player Management Section
createSection(Content, "Player Management", orderCounter)
orderCounter = orderCounter + 1

local PlayerInput = createInputField(Content, "Enter player name...", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Kick Player", orderCounter, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.KickPlayer:FireServer(playerName)
        PlayerInput.Text = ""
    end
end, Color3.fromRGB(255, 100, 100))
orderCounter = orderCounter + 1

createButton(Content, "Ban Player", orderCounter, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.BanPlayer:FireServer(playerName)
        PlayerInput.Text = ""
    end
end, Color3.fromRGB(200, 50, 50))
orderCounter = orderCounter + 1

createButton(Content, "Teleport To Player", orderCounter, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.TeleportPlayer:FireServer("to", playerName)
        PlayerInput.Text = ""
    end
end, Color3.fromRGB(100, 200, 100))
orderCounter = orderCounter + 1

createButton(Content, "Bring Player", orderCounter, function()
    local playerName = PlayerInput.Text
    if playerName ~= "" then
        remoteEvents.TeleportPlayer:FireServer("bring", playerName)
        PlayerInput.Text = ""
    end
end, Color3.fromRGB(100, 150, 200))
orderCounter = orderCounter + 1

-- Server Management Section
createSection(Content, "Server Management", orderCounter)
orderCounter = orderCounter + 1

local MessageInput = createInputField(Content, "Enter server message...", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Send Server Message", orderCounter, function()
    local message = MessageInput.Text
    if message ~= "" then
        remoteEvents.ServerMessage:FireServer(message)
        MessageInput.Text = ""
    end
end, Color3.fromRGB(70, 130, 255))
orderCounter = orderCounter + 1

createButton(Content, "Clear Workspace", orderCounter, function()
    remoteEvents.ClearWorkspace:FireServer()
end, Color3.fromRGB(255, 150, 50))
orderCounter = orderCounter + 1

-- Environment Section
createSection(Content, "Environment", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Low Gravity", orderCounter, function()
    remoteEvents.ChangeGravity:FireServer(50)
end, Color3.fromRGB(150, 100, 255))
orderCounter = orderCounter + 1

createButton(Content, "Normal Gravity", orderCounter, function()
    remoteEvents.ChangeGravity:FireServer(196.2)
end, Color3.fromRGB(100, 255, 100))
orderCounter = orderCounter + 1

createButton(Content, "High Gravity", orderCounter, function()
    remoteEvents.ChangeGravity:FireServer(500)
end, Color3.fromRGB(255, 100, 150))
orderCounter = orderCounter + 1

-- Lighting Section
createSection(Content, "Lighting", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Day Time", orderCounter, function()
    remoteEvents.ChangeLighting:FireServer("day")
end, Color3.fromRGB(255, 255, 100))
orderCounter = orderCounter + 1

createButton(Content, "Night Time", orderCounter, function()
    remoteEvents.ChangeLighting:FireServer("night")
end, Color3.fromRGB(100, 100, 200))
orderCounter = orderCounter + 1

createButton(Content, "Sunset", orderCounter, function()
    remoteEvents.ChangeLighting:FireServer("sunset")
end, Color3.fromRGB(255, 150, 100))
orderCounter = orderCounter + 1

-- Music Section
createSection(Content, "Music", orderCounter)
orderCounter = orderCounter + 1

local MusicInput = createInputField(Content, "Enter music ID...", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Play Music", orderCounter, function()
    local musicId = MusicInput.Text
    if musicId ~= "" then
        if not musicId:find("rbxassetid://") then
            musicId = "rbxassetid://" .. musicId
        end
        remoteEvents.GlobalMusic:FireServer(musicId, "Custom Music")
        MusicInput.Text = ""
    end
end, Color3.fromRGB(150, 50, 255))
orderCounter = orderCounter + 1

createButton(Content, "Stop Music", orderCounter, function()
    remoteEvents.GlobalMusic:FireServer("", "stop")
end, Color3.fromRGB(255, 100, 100))
orderCounter = orderCounter + 1

-- Effects Section
createSection(Content, "Effects", orderCounter)
orderCounter = orderCounter + 1

createButton(Content, "Fireworks", orderCounter, function()
    remoteEvents.CreateParticles:FireServer("fireworks")
end, Color3.fromRGB(255, 200, 0))
orderCounter = orderCounter + 1

createButton(Content, "Snow", orderCounter, function()
    remoteEvents.WeatherEffect:FireServer("snow")
end, Color3.fromRGB(200, 200, 255))
orderCounter = orderCounter + 1

createButton(Content, "Lightning", orderCounter, function()
    remoteEvents.WeatherEffect:FireServer("lightning")
end, Color3.fromRGB(255, 255, 150))
orderCounter = orderCounter + 1

-- Toggle functionality
local isOpen = false

local function togglePanel()
    isOpen = not isOpen
    
    if isOpen then
        MainFrame.Visible = true
        Shadow.Visible = true
        
        -- Smooth fade in
        MainFrame.BackgroundTransparency = 1
        Shadow.BackgroundTransparency = 1
        
        local frameTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        )
        local shadowTween = TweenService:Create(Shadow,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.7}
        )
        
        frameTween:Play()
        shadowTween:Play()
        
    else
        local frameTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        local shadowTween = TweenService:Create(Shadow,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        
        frameTween:Play()
        shadowTween:Play()
        
        frameTween.Completed:Connect(function()
            MainFrame.Visible = false
            Shadow.Visible = false
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

-- Dragging functionality
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
        Shadow.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X + 3, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y + 3
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Professional Admin Panel V3.0 loaded! Press F2 to open.")
print("Admin: " .. LocalPlayer.Name)