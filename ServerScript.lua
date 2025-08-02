-- PROFESSIONAL ADMIN PANEL SERVER SCRIPT V3.0
-- Place this in ServerScriptService
-- Supports game-wide visibility for all admin actions

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Admin list (same as in client script)
local ADMIN_LIST = {
    -- Add admin user IDs here
    -- [123456789] = true,
}

-- Check if player is admin
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or player.UserId == game.CreatorId or false
end

-- Create RemoteEvents folder and events
local AdminFolder = ReplicatedStorage:FindFirstChild("AdminRemotes")
if not AdminFolder then
    AdminFolder = Instance.new("Folder")
    AdminFolder.Name = "AdminRemotes"
    AdminFolder.Parent = ReplicatedStorage
end

-- Create all remote events
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

-- Storage for active effects and bans
local bannedPlayers = {}
local activeEffects = {}
local globalMusic = nil

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

-- Global notification system - visible to ALL players
local function sendNotificationToAll(message, color)
    for _, player in pairs(Players:GetPlayers()) do
        spawn(function()
            local gui = Instance.new("ScreenGui")
            gui.Name = "AdminNotification"
            gui.Parent = player:WaitForChild("PlayerGui")
            
            local frame = Instance.new("Frame")
            frame.Parent = gui
            frame.BackgroundColor3 = color or Color3.fromRGB(70, 130, 255)
            frame.BackgroundTransparency = 0.1
            frame.BorderSizePixel = 0
            frame.Position = UDim2.new(0.5, -250, 0, -60)
            frame.Size = UDim2.new(0, 500, 0, 50)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = color or Color3.fromRGB(100, 150, 255)
            stroke.Thickness = 1
            stroke.Transparency = 0.5
            stroke.Parent = frame
            
            local text = Instance.new("TextLabel")
            text.Parent = frame
            text.BackgroundTransparency = 1
            text.Size = UDim2.new(1, -20, 1, 0)
            text.Position = UDim2.new(0, 10, 0, 0)
            text.Font = Enum.Font.SourceSansBold
            text.Text = message
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 14
            text.TextWrapped = true
            
            -- Slide in animation
            local slideIn = TweenService:Create(frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -250, 0, 20)}
            )
            slideIn:Play()
            
            wait(3)
            
            -- Slide out animation
            local slideOut = TweenService:Create(frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(0.5, -250, 0, -60)}
            )
            slideOut:Play()
            
            slideOut.Completed:Connect(function()
                gui:Destroy()
            end)
        end)
    end
end

-- Handle kick player
remotes.KickPlayer.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        sendNotificationToAll(targetPlayer.Name .. " has been kicked", Color3.fromRGB(255, 100, 100))
        targetPlayer:Kick("You have been kicked by " .. player.Name)
    end
end)

-- Handle ban player
remotes.BanPlayer.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        bannedPlayers[targetPlayer.UserId] = {
            name = targetPlayer.Name,
            bannedBy = player.Name,
            reason = "Banned by administrator",
            timestamp = os.time()
        }
        sendNotificationToAll(targetPlayer.Name .. " has been banned", Color3.fromRGB(200, 50, 50))
        targetPlayer:Kick("You have been permanently banned by " .. player.Name)
    end
end)

-- Handle teleportation
remotes.TeleportPlayer.OnServerEvent:Connect(function(player, action, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    
    if action == "to" and targetPlayer then
        -- Teleport admin to target
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
        end
    elseif action == "bring" and targetPlayer then
        -- Teleport target to admin
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
            sendNotificationToAll(targetPlayer.Name .. " has been teleported", Color3.fromRGB(100, 200, 100))
        end
    end
end)

-- Handle server messages
remotes.ServerMessage.OnServerEvent:Connect(function(player, message)
    if not isAdmin(player) then return end
    
    sendNotificationToAll("📢 " .. message, Color3.fromRGB(70, 130, 255))
end)

-- Handle global music system - ALL players hear it
remotes.GlobalMusic.OnServerEvent:Connect(function(player, musicId, musicName)
    if not isAdmin(player) then return end
    
    -- Stop current music
    if globalMusic then
        globalMusic:Stop()
        globalMusic:Destroy()
        globalMusic = nil
    end
    
    if musicId ~= "" and musicName ~= "stop" then
        -- Create new global music
        globalMusic = Instance.new("Sound")
        globalMusic.Name = "GlobalAdminMusic"
        globalMusic.SoundId = musicId
        globalMusic.Volume = 0.5
        globalMusic.Looped = true
        globalMusic.Parent = Workspace
        globalMusic:Play()
        
        sendNotificationToAll("🎵 Now playing: " .. musicName, Color3.fromRGB(150, 50, 255))
    else
        sendNotificationToAll("⏹️ Music stopped", Color3.fromRGB(255, 100, 100))
    end
end)

-- Handle workspace clearing
remotes.ClearWorkspace.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= Workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        elseif obj:IsA("Part") and obj.Name ~= "Baseplate" and obj.Name ~= "SpawnLocation" then
            obj:Destroy()
        end
    end
    
    sendNotificationToAll("🧹 Workspace cleared", Color3.fromRGB(255, 150, 50))
end)

-- Handle gravity changes - affects ALL players
remotes.ChangeGravity.OnServerEvent:Connect(function(player, gravityValue)
    if not isAdmin(player) then return end
    
    Workspace.Gravity = gravityValue
    
    local gravityText = "Normal"
    if gravityValue < 100 then
        gravityText = "Low"
    elseif gravityValue > 300 then
        gravityText = "High"
    end
    
    sendNotificationToAll("🌍 Gravity set to " .. gravityText .. " (" .. gravityValue .. ")", Color3.fromRGB(150, 100, 255))
end)

-- Handle lighting changes - visible to ALL players
remotes.ChangeLighting.OnServerEvent:Connect(function(player, lightingType)
    if not isAdmin(player) then return end
    
    if lightingType == "day" then
        Lighting.TimeOfDay = "12:00:00"
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.Brightness = 1
        sendNotificationToAll("☀️ Day time activated", Color3.fromRGB(255, 255, 100))
        
    elseif lightingType == "night" then
        Lighting.TimeOfDay = "00:00:00"
        Lighting.Ambient = Color3.fromRGB(50, 50, 100)
        Lighting.ColorShift_Top = Color3.fromRGB(100, 100, 150)
        Lighting.Brightness = 0.5
        sendNotificationToAll("🌙 Night time activated", Color3.fromRGB(100, 100, 200))
        
    elseif lightingType == "sunset" then
        Lighting.TimeOfDay = "18:00:00"
        Lighting.Ambient = Color3.fromRGB(200, 100, 50)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 150, 100)
        Lighting.Brightness = 0.8
        sendNotificationToAll("🌅 Sunset mode activated", Color3.fromRGB(255, 150, 100))
    end
end)

-- Handle particle effects - visible to ALL players
remotes.CreateParticles.OnServerEvent:Connect(function(player, effectType)
    if not isAdmin(player) then return end
    
    if effectType == "fireworks" then
        if activeEffects.fireworks then return end
        
        activeEffects.fireworks = true
        sendNotificationToAll("🎆 Fireworks show started!", Color3.fromRGB(255, 200, 0))
        
        spawn(function()
            for i = 1, 10 do
                if not activeEffects.fireworks then break end
                
                -- Create multiple fireworks for spectacular show
                for j = 1, 3 do
                    local firework = Instance.new("Explosion")
                    firework.Position = Vector3.new(
                        math.random(-100, 100),
                        math.random(50, 100),
                        math.random(-100, 100)
                    )
                    firework.BlastRadius = 25
                    firework.BlastPressure = 0
                    firework.Parent = Workspace
                    
                    wait(0.3)
                end
                wait(1)
            end
            
            activeEffects.fireworks = false
            sendNotificationToAll("🎆 Fireworks show ended", Color3.fromRGB(255, 150, 0))
        end)
    end
end)

-- Handle weather effects - visible to ALL players
remotes.WeatherEffect.OnServerEvent:Connect(function(player, effectType)
    if not isAdmin(player) then return end
    
    if effectType == "snow" then
        if activeEffects.snow then
            -- Stop snow
            activeEffects.snow = false
            if activeEffects.snowPart then
                activeEffects.snowPart:Destroy()
                activeEffects.snowPart = nil
            end
            -- Reset lighting
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            sendNotificationToAll("☀️ Snow stopped", Color3.fromRGB(255, 255, 150))
        else
            -- Start snow
            activeEffects.snow = true
            sendNotificationToAll("❄️ It's snowing! Winter wonderland!", Color3.fromRGB(200, 200, 255))
            
            -- Create snow effect visible to all
            local snowPart = Instance.new("Part")
            snowPart.Name = "AdminSnowCloud"
            snowPart.Size = Vector3.new(1000, 1, 1000)
            snowPart.Position = Vector3.new(0, 250, 0)
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
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 0.1)
            }
            snowEffect.Lifetime = NumberRange.new(10, 15)
            snowEffect.Rate = 1500
            snowEffect.SpreadAngle = Vector2.new(45, 45)
            snowEffect.Speed = NumberRange.new(8, 20)
            snowEffect.Acceleration = Vector3.new(0, -15, 0)
            
            activeEffects.snowPart = snowPart
            
            -- Winter lighting
            Lighting.Ambient = Color3.fromRGB(180, 180, 220)
            Lighting.ColorShift_Top = Color3.fromRGB(220, 220, 255)
        end
        
    elseif effectType == "lightning" then
        if activeEffects.lightning then
            -- Stop lightning
            activeEffects.lightning = false
            sendNotificationToAll("☀️ Lightning storm ended", Color3.fromRGB(255, 255, 100))
        else
            -- Start lightning
            activeEffects.lightning = true
            sendNotificationToAll("⚡ Lightning storm incoming!", Color3.fromRGB(255, 255, 150))
            
            spawn(function()
                local originalAmbient = Lighting.Ambient
                local originalBrightness = Lighting.Brightness
                
                for i = 1, 10 do
                    if not activeEffects.lightning then break end
                    
                    -- Lightning flash effect for everyone
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.Brightness = 3
                    
                    -- Thunder sound for all players
                    local thunder = Instance.new("Sound")
                    thunder.SoundId = "rbxassetid://131961136"
                    thunder.Volume = 0.7
                    thunder.Parent = Workspace
                    thunder:Play()
                    
                    Debris:AddItem(thunder, 5)
                    
                    wait(0.2)
                    Lighting.Ambient = Color3.fromRGB(50, 50, 80)
                    Lighting.Brightness = 0.5
                    
                    wait(math.random(2, 5))
                end
                
                Lighting.Ambient = originalAmbient
                Lighting.Brightness = originalBrightness
                activeEffects.lightning = false
            end)
        end
    end
end)

-- Handle new players joining
Players.PlayerAdded:Connect(function(player)
    -- Check for bans
    if bannedPlayers[player.UserId] then
        local banInfo = bannedPlayers[player.UserId]
        player:Kick("🚫 You are banned from this server.\nBanned by: " .. banInfo.bannedBy .. "\nReason: " .. banInfo.reason)
        return
    end
    
    -- Simple join message (no admin detection announcement)
    wait(1)
    sendNotificationToAll("👋 " .. player.Name .. " joined the server", Color3.fromRGB(100, 200, 100))
end)

-- Clean up effects when players leave
Players.PlayerRemoving:Connect(function(player)
    -- No special handling needed for basic version
end)

-- Auto-cleanup for effects (safety measure)
spawn(function()
    while true do
        wait(300) -- Every 5 minutes
        
        -- Clean up any orphaned admin objects
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Admin") and obj.Parent then
                if obj.Name == "AdminSnowCloud" and not activeEffects.snow then
                    obj:Destroy()
                end
            end
        end
    end
end)

print("🔧 Professional Admin Panel Server Script V3.0 loaded!")
print("✅ All RemoteEvents created successfully!")
print("🌍 Game-wide visibility enabled for all admin actions!")
print("🎯 Features: Player management, music, lighting, weather, particles!")