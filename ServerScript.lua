-- ENHANCED SERVER SCRIPT FOR ULTIMATE FUTURISTIC ADMIN PANEL V2.0
-- Place this in ServerScriptService

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

-- Banned players storage
local bannedPlayers = {}

-- Active events tracking
local activeEvents = {}
local globalMusic = nil

-- Enhanced dance animations
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

-- Global notification system
local function sendNotificationToAll(message, color, excludePlayer)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= excludePlayer then
            spawn(function()
                local gui = Instance.new("ScreenGui")
                gui.Name = "AdminNotification"
                gui.Parent = player:WaitForChild("PlayerGui")
                
                local frame = Instance.new("Frame")
                frame.Parent = gui
                frame.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255)
                frame.BackgroundTransparency = 0.2
                frame.BorderSizePixel = 0
                frame.Position = UDim2.new(0.5, -250, 0, -60)
                frame.Size = UDim2.new(0, 500, 0, 60)
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 15)
                corner.Parent = frame
                
                local stroke = Instance.new("UIStroke")
                stroke.Color = color or Color3.fromRGB(0, 255, 200)
                stroke.Thickness = 2
                stroke.Parent = frame
                
                local text = Instance.new("TextLabel")
                text.Parent = frame
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, -20, 1, 0)
                text.Position = UDim2.new(0, 10, 0, 0)
                text.Font = Enum.Font.SourceSansBold
                text.Text = message
                text.TextColor3 = Color3.fromRGB(255, 255, 255)
                text.TextScaled = true
                
                -- Animate notification
                local slideIn = TweenService:Create(frame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0.5, -250, 0, 20)}
                )
                slideIn:Play()
                
                wait(4)
                
                local slideOut = TweenService:Create(frame,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Position = UDim2.new(0.5, -250, 0, -60)}
                )
                slideOut:Play()
                
                slideOut.Completed:Connect(function()
                    gui:Destroy()
                end)
            end)
        end
    end
end

-- Handle kick player
remotes.KickPlayer.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        sendNotificationToAll("🔨 " .. targetPlayer.Name .. " has been kicked by " .. player.Name, Color3.fromRGB(255, 100, 100))
        targetPlayer:Kick("🔨 You have been kicked by " .. player.Name)
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
        sendNotificationToAll("🚫 " .. targetPlayer.Name .. " has been banned by " .. player.Name, Color3.fromRGB(255, 50, 50))
        targetPlayer:Kick("🚫 You have been permanently banned by " .. player.Name)
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
            sendNotificationToAll("📍 " .. targetPlayer.Name .. " has been teleported by " .. player.Name, Color3.fromRGB(0, 255, 150))
        end
    end
end)

-- Handle server messages
remotes.ServerMessage.OnServerEvent:Connect(function(player, message)
    if not isAdmin(player) then return end
    
    sendNotificationToAll("📢 " .. message, Color3.fromRGB(60, 120, 255))
end)

-- Handle global music system
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
        
        sendNotificationToAll("🎵 Now playing: " .. musicName, Color3.fromRGB(150, 0, 255))
    else
        sendNotificationToAll("⏹️ Music stopped", Color3.fromRGB(255, 100, 100))
    end
end)

-- Enhanced Dance Party Event
remotes.DancePartyEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.danceParty then return end
        
        activeEvents.danceParty = true
        sendNotificationToAll("🕺 DANCE PARTY STARTED! Everyone dance! 💃", Color3.fromRGB(255, 100, 255))
        
        -- Make ALL players dance
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            spawn(function()
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                    local humanoid = targetPlayer.Character.Humanoid
                    local animator = humanoid:FindFirstChild("Animator")
                    if animator then
                        local danceId = DANCE_ANIMATIONS[math.random(1, #DANCE_ANIMATIONS)]
                        local animation = Instance.new("Animation")
                        animation.AnimationId = danceId
                        local track = animator:LoadAnimation(animation)
                        track.Looped = true
                        track:Play()
                        
                        -- Store for cleanup
                        if not activeEvents.danceTracks then
                            activeEvents.danceTracks = {}
                        end
                        activeEvents.danceTracks[targetPlayer.UserId] = track
                    end
                end
            end)
        end
        
        -- Party lighting effects for everyone
        spawn(function()
            local originalBrightness = Lighting.Brightness
            local originalAmbient = Lighting.Ambient
            
            while activeEvents.danceParty do
                Lighting.Brightness = math.random(80, 120) / 100
                Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
                Lighting.ColorShift_Top = Color3.fromHSV(math.random(), 1, 1)
                wait(0.3)
            end
            
            Lighting.Brightness = originalBrightness
            Lighting.Ambient = originalAmbient
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        end)
        
    elseif action == "stop" then
        activeEvents.danceParty = false
        sendNotificationToAll("⏹️ Dance party ended!", Color3.fromRGB(255, 150, 150))
        
        -- Stop all dance animations
        if activeEvents.danceTracks then
            for _, track in pairs(activeEvents.danceTracks) do
                if track then
                    track:Stop()
                end
            end
            activeEvents.danceTracks = {}
        end
    end
end)

-- Fireworks Event
remotes.FireworksEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.fireworks then return end
        
        activeEvents.fireworks = true
        sendNotificationToAll("🎆 FIREWORKS SHOW STARTED! Look up! 🎆", Color3.fromRGB(255, 200, 0))
        
        spawn(function()
            while activeEvents.fireworks do
                -- Create multiple fireworks for spectacular show
                for i = 1, 5 do
                    local firework = Instance.new("Explosion")
                    firework.Position = Vector3.new(
                        math.random(-150, 150),
                        math.random(60, 120),
                        math.random(-150, 150)
                    )
                    firework.BlastRadius = 30
                    firework.BlastPressure = 0
                    firework.Parent = Workspace
                    
                    wait(0.3)
                end
                wait(2)
            end
        end)
        
    elseif action == "stop" then
        activeEvents.fireworks = false
        sendNotificationToAll("🎆 Fireworks show ended!", Color3.fromRGB(255, 150, 0))
    end
end)

-- Lightning Storm Event
remotes.LightningEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.lightning then return end
        
        activeEvents.lightning = true
        sendNotificationToAll("⚡ LIGHTNING STORM INCOMING! ⚡", Color3.fromRGB(255, 255, 0))
        
        spawn(function()
            local originalAmbient = Lighting.Ambient
            local originalBrightness = Lighting.Brightness
            
            while activeEvents.lightning do
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
                
                wait(math.random(3, 10))
            end
            
            Lighting.Ambient = originalAmbient
            Lighting.Brightness = originalBrightness
        end)
        
    elseif action == "stop" then
        activeEvents.lightning = false
        sendNotificationToAll("☀️ Lightning storm ended!", Color3.fromRGB(255, 255, 100))
    end
end)

-- Meteor Shower Event
remotes.MeteorEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.meteors then return end
        
        activeEvents.meteors = true
        sendNotificationToAll("☄️ METEOR SHOWER! Take cover! ☄️", Color3.fromRGB(255, 100, 0))
        
        spawn(function()
            while activeEvents.meteors do
                -- Create meteors that everyone can see
                for i = 1, 3 do
                    local meteor = Instance.new("Part")
                    meteor.Name = "AdminMeteor"
                    meteor.Size = Vector3.new(6, 6, 6)
                    meteor.Material = Enum.Material.Neon
                    meteor.BrickColor = BrickColor.new("Bright orange")
                    meteor.Shape = Enum.PartType.Ball
                    meteor.TopSurface = Enum.SurfaceType.Smooth
                    meteor.BottomSurface = Enum.SurfaceType.Smooth
                    meteor.CanCollide = false
                    meteor.Position = Vector3.new(
                        math.random(-300, 300),
                        250,
                        math.random(-300, 300)
                    )
                    meteor.Parent = Workspace
                    
                    -- Add fire effect
                    local fire = Instance.new("Fire")
                    fire.Size = 15
                    fire.Heat = 20
                    fire.Parent = meteor
                    
                    -- Add velocity
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(8000, 8000, 8000)
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-80, 80),
                        -120,
                        math.random(-80, 80)
                    )
                    bodyVelocity.Parent = meteor
                    
                    -- Impact explosion
                    meteor.Touched:Connect(function(hit)
                        if hit.Name == "Baseplate" or hit.Parent:FindFirstChild("Humanoid") then
                            local explosion = Instance.new("Explosion")
                            explosion.Position = meteor.Position
                            explosion.BlastRadius = 40
                            explosion.BlastPressure = 500000
                            explosion.Parent = Workspace
                            
                            meteor:Destroy()
                        end
                    end)
                    
                    Debris:AddItem(meteor, 15)
                    wait(1)
                end
                wait(3)
            end
        end)
        
    elseif action == "stop" then
        activeEvents.meteors = false
        sendNotificationToAll("☄️ Meteor shower ended!", Color3.fromRGB(255, 150, 100))
        
        -- Clean up meteors
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name == "AdminMeteor" then
                obj:Destroy()
            end
        end
    end
end)

-- Snow Event
remotes.SnowEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.snow then return end
        
        activeEvents.snow = true
        sendNotificationToAll("❄️ It's snowing! Winter wonderland! ❄️", Color3.fromRGB(200, 200, 255))
        
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
        snowEffect.Lifetime = NumberRange.new(12, 18)
        snowEffect.Rate = 2000
        snowEffect.SpreadAngle = Vector2.new(45, 45)
        snowEffect.Speed = NumberRange.new(8, 20)
        snowEffect.Acceleration = Vector3.new(0, -15, 0)
        
        activeEvents.snowPart = snowPart
        
        -- Winter lighting
        Lighting.Ambient = Color3.fromRGB(180, 180, 220)
        Lighting.ColorShift_Top = Color3.fromRGB(220, 220, 255)
        
    elseif action == "stop" then
        activeEvents.snow = false
        sendNotificationToAll("☀️ Snow stopped!", Color3.fromRGB(255, 255, 150))
        
        if activeEvents.snowPart then
            activeEvents.snowPart:Destroy()
            activeEvents.snowPart = nil
        end
        
        -- Reset lighting
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    end
end)

-- Disco Event
remotes.DiscoEvent.OnServerEvent:Connect(function(player, action)
    if not isAdmin(player) then return end
    
    if action == "start" then
        if activeEvents.disco then return end
        
        activeEvents.disco = true
        sendNotificationToAll("💃 DISCO MODE ACTIVATED! Feel the groove! 🕺", Color3.fromRGB(255, 0, 255))
        
        spawn(function()
            while activeEvents.disco do
                -- Disco lighting effects
                Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
                Lighting.ColorShift_Top = Color3.fromHSV(math.random(), 1, 1)
                Lighting.ColorShift_Bottom = Color3.fromHSV(math.random(), 1, 1)
                Lighting.Brightness = math.random(100, 150) / 100
                
                wait(0.2)
            end
            
            -- Reset lighting
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end)
        
    elseif action == "stop" then
        activeEvents.disco = false
        sendNotificationToAll("💃 Disco mode ended!", Color3.fromRGB(255, 150, 255))
    end
end)

-- Handle new players joining during events
Players.PlayerAdded:Connect(function(player)
    -- Check for bans
    if bannedPlayers[player.UserId] then
        local banInfo = bannedPlayers[player.UserId]
        player:Kick("🚫 You are banned from this server.\nBanned by: " .. banInfo.bannedBy .. "\nReason: " .. banInfo.reason)
        return
    end
    
    -- If dance party is active, make new player dance
    if activeEvents.danceParty then
        wait(2) -- Wait for character to load
        spawn(function()
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
                    
                    if not activeEvents.danceTracks then
                        activeEvents.danceTracks = {}
                    end
                    activeEvents.danceTracks[player.UserId] = track
                end
            end
        end)
    end
    
    -- Welcome message
    wait(1)
    if isAdmin(player) then
        sendNotificationToAll("👑 Admin " .. player.Name .. " has joined the server!", Color3.fromRGB(255, 215, 0))
    end
end)

-- Clean up dance tracks when players leave
Players.PlayerRemoving:Connect(function(player)
    if activeEvents.danceTracks and activeEvents.danceTracks[player.UserId] then
        activeEvents.danceTracks[player.UserId] = nil
    end
end)

-- Auto-cleanup for events (safety measure)
spawn(function()
    while true do
        wait(300) -- Every 5 minutes
        
        -- Clean up any orphaned meteors
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name == "AdminMeteor" and obj.Parent then
                Debris:AddItem(obj, 10)
            end
        end
    end
end)

print("🌟 Enhanced Admin Panel Server Script V2.0 loaded!")
print("✅ All RemoteEvents created successfully!")
print("🎉 Enhanced events with global visibility enabled!")
print("🔧 Features: Global music, dance parties, fireworks, lightning, meteors, snow, disco mode!")