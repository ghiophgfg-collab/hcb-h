-- SERVER SCRIPT FOR ADMIN PANEL
-- Place this in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Admin list (same as in client script)
local ADMIN_LIST = {
    -- Add admin user IDs here
    -- [123456789] = true,
}

-- Check if player is admin
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or player.UserId == game.CreatorId or false
end

-- Create RemoteEvents for admin commands
local AdminFolder = Instance.new("Folder")
AdminFolder.Name = "AdminRemotes"
AdminFolder.Parent = ReplicatedStorage

local KickPlayerRemote = Instance.new("RemoteEvent")
KickPlayerRemote.Name = "KickPlayer"
KickPlayerRemote.Parent = AdminFolder

local BanPlayerRemote = Instance.new("RemoteEvent")
BanPlayerRemote.Name = "BanPlayer"
BanPlayerRemote.Parent = AdminFolder

local TeleportRemote = Instance.new("RemoteEvent")
TeleportRemote.Name = "Teleport"
TeleportRemote.Parent = AdminFolder

local ServerMessageRemote = Instance.new("RemoteEvent")
ServerMessageRemote.Name = "ServerMessage"
ServerMessageRemote.Parent = AdminFolder

local DancePartyRemote = Instance.new("RemoteEvent")
DancePartyRemote.Name = "DanceParty"
DancePartyRemote.Parent = AdminFolder

local ForceAnimationRemote = Instance.new("RemoteEvent")
ForceAnimationRemote.Name = "ForceAnimation"
ForceAnimationRemote.Parent = AdminFolder

-- Banned players storage
local bannedPlayers = {}

-- Dance animations
local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", -- Dance 1
    "rbxassetid://507770818", -- Dance 2
    "rbxassetid://507771019", -- Dance 3
    "rbxassetid://507771955", -- Dance 4
    "rbxassetid://507772104"  -- Dance 5
}

-- Get player by name (partial matching)
local function getPlayerByName(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
        end
    end
    return nil
end

-- Handle kick player
KickPlayerRemote.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        targetPlayer:Kick("🔨 You have been kicked by " .. player.Name)
    end
end)

-- Handle ban player
BanPlayerRemote.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        bannedPlayers[targetPlayer.UserId] = {
            name = targetPlayer.Name,
            bannedBy = player.Name,
            reason = "Banned by administrator",
            timestamp = os.time()
        }
        targetPlayer:Kick("🚫 You have been permanently banned by " .. player.Name)
    end
end)

-- Handle teleportation
TeleportRemote.OnServerEvent:Connect(function(player, action, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    
    if action == "to" and targetPlayer then
        -- Teleport admin to target
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    elseif action == "bring" and targetPlayer then
        -- Teleport target to admin
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Handle server messages
ServerMessageRemote.OnServerEvent:Connect(function(player, message)
    if not isAdmin(player) then return end
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local gui = Instance.new("ScreenGui")
            gui.Parent = targetPlayer:WaitForChild("PlayerGui")
            
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
            
            game:GetService("Debris"):AddItem(gui, 5)
        end
    end
end)

-- Handle dance party
DancePartyRemote.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        -- Make all players dance
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = targetPlayer.Character.Humanoid
                local animator = humanoid:FindFirstChild("Animator")
                if animator then
                    local danceId = DANCE_ANIMATIONS[math.random(1, #DANCE_ANIMATIONS)]
                    ForceAnimationRemote:FireClient(targetPlayer, danceId, true)
                end
            end
        end
        
        -- Party lighting effects
        spawn(function()
            local originalBrightness = Lighting.Brightness
            local originalAmbient = Lighting.Ambient
            
            for i = 1, 60 do -- 30 seconds of party lighting
                Lighting.Brightness = math.random(50, 100) / 100
                Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
                wait(0.5)
            end
            
            Lighting.Brightness = originalBrightness
            Lighting.Ambient = originalAmbient
        end)
    end
end)

-- Handle force animations
ForceAnimationRemote.OnServerEvent:Connect(function(player, targetName, animationId)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        ForceAnimationRemote:FireClient(targetPlayer, animationId, false)
    end
end)

-- Check for banned players joining
Players.PlayerAdded:Connect(function(player)
    if bannedPlayers[player.UserId] then
        local banInfo = bannedPlayers[player.UserId]
        player:Kick("🚫 You are banned from this server.\nBanned by: " .. banInfo.bannedBy .. "\nReason: " .. banInfo.reason)
    end
end)

-- Admin join notification
Players.PlayerAdded:Connect(function(player)
    wait(1) -- Wait for character to load
    if isAdmin(player) then
        -- Notify other admins
        for _, admin in pairs(Players:GetPlayers()) do
            if isAdmin(admin) and admin ~= player then
                ServerMessageRemote:FireClient(admin, "👑 Admin " .. player.Name .. " has joined the server")
            end
        end
    end
end)

print("🛡️ Admin Panel Server Script loaded!")
print("✅ RemoteEvents created successfully!")