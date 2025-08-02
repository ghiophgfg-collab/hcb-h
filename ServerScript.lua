-- PROFESSIONAL ADMIN PANEL SERVER SCRIPT V4.0
-- Place this in ServerScriptService
-- Enhanced live events with global visibility for all players

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

-- Create all remote events including new ones
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

-- Professional notification system - visible to ALL players
local function sendNotificationToAll(message, color, duration)
    for _, player in pairs(Players:GetPlayers()) do
        spawn(function()
            local gui = Instance.new("ScreenGui")
            gui.Name = "AdminNotification"
            gui.Parent = player:WaitForChild("PlayerGui")
            
            local frame = Instance.new("Frame")
            frame.Parent = gui
            frame.BackgroundColor3 = color or Color3.fromRGB(25, 35, 55)
            frame.BackgroundTransparency = 0.1
            frame.BorderSizePixel = 0
            frame.Position = UDim2.new(0.5, -300, 0, -80)
            frame.Size = UDim2.new(0, 600, 0, 60)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = color or Color3.fromRGB(80, 120, 180)
            stroke.Thickness = 1.5
            stroke.Transparency = 0.3
            stroke.Parent = frame
            
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 50, 70)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 50))
            }
            gradient.Rotation = 45
            gradient.Transparency = NumberSequence.new{
                ColorSequenceKeypoint.new(0, 0.2),
                ColorSequenceKeypoint.new(1, 0.4)
            }
            gradient.Parent = frame
            
            local text = Instance.new("TextLabel")
            text.Parent = frame
            text.BackgroundTransparency = 1
            text.Size = UDim2.new(1, -30, 1, 0)
            text.Position = UDim2.new(0, 15, 0, 0)
            text.Font = Enum.Font.SourceSansSemibold
            text.Text = message
            text.TextColor3 = Color3.fromRGB(240, 250, 260)
            text.TextSize = 16
            text.TextWrapped = true
            text.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Enhanced slide in animation
            local slideIn = TweenService:Create(frame,
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -300, 0, 30)}
            )
            slideIn:Play()
            
            wait(duration or 4)
            
            -- Enhanced slide out animation
            local slideOut = TweenService:Create(frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {
                    Position = UDim2.new(0.5, -300, 0, -80),
                    BackgroundTransparency = 1
                }
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
        sendNotificationToAll("PLAYER REMOVED: " .. targetPlayer.Name .. " has been removed from the server", Color3.fromRGB(220, 80, 80))
        targetPlayer:Kick("You have been removed from the server by " .. player.Name)
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
        sendNotificationToAll("PLAYER BANNED: " .. targetPlayer.Name .. " has been permanently banned", Color3.fromRGB(180, 60, 60))
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
            sendNotificationToAll("TELEPORT: Administrator teleported to " .. targetPlayer.Name, Color3.fromRGB(80, 180, 120))
        end
    elseif action == "bring" and targetPlayer then
        -- Teleport target to admin
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
            sendNotificationToAll("TELEPORT: " .. targetPlayer.Name .. " has been teleported", Color3.fromRGB(120, 160, 200))
        end
    end
end)

-- Handle server messages
remotes.ServerMessage.OnServerEvent:Connect(function(player, message)
    if not isAdmin(player) then return end
    
    sendNotificationToAll("SERVER ANNOUNCEMENT: " .. message, Color3.fromRGB(70, 130, 255), 6)
end)

-- Enhanced global music system - ALL players hear it
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
        
        sendNotificationToAll("MUSIC: Now playing " .. musicName, Color3.fromRGB(150, 80, 255))
    else
        sendNotificationToAll("MUSIC: All music stopped", Color3.fromRGB(220, 80, 80))
    end
end)

-- Handle workspace clearing
remotes.ClearWorkspace.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    local itemsCleared = 0
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= Workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
            itemsCleared = itemsCleared + 1
        elseif obj:IsA("Part") and obj.Name ~= "Baseplate" and obj.Name ~= "SpawnLocation" then
            obj:Destroy()
            itemsCleared = itemsCleared + 1
        end
    end
    
    sendNotificationToAll("WORKSPACE: Cleared " .. itemsCleared .. " items from workspace", Color3.fromRGB(255, 150, 80))
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
    
    sendNotificationToAll("GRAVITY: Set to " .. gravityText .. " (" .. gravityValue .. ")", Color3.fromRGB(150, 120, 255))
end)

-- Handle lighting changes - visible to ALL players
remotes.ChangeLighting.OnServerEvent:Connect(function(player, lightingType)
    if not isAdmin(player) then return end
    
    if lightingType == "day" then
        Lighting.TimeOfDay = "12:00:00"
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
        sendNotificationToAll("WEATHER: Clear skies activated", Color3.fromRGB(255, 220, 100))
        
    elseif lightingType == "night" then
        Lighting.TimeOfDay = "00:00:00"
        Lighting.Ambient = Color3.fromRGB(50, 50, 100)
        Lighting.ColorShift_Top = Color3.fromRGB(100, 100, 150)
        Lighting.Brightness = 0.5
        Lighting.FogEnd = 100000
        sendNotificationToAll("WEATHER: Night mode activated", Color3.fromRGB(80, 100, 180))
        
    elseif lightingType == "sunset" then
        Lighting.TimeOfDay = "18:00:00"
        Lighting.Ambient = Color3.fromRGB(200, 100, 50)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 150, 100)
        Lighting.Brightness = 0.8
        Lighting.FogEnd = 100000
        sendNotificationToAll("WEATHER: Sunset atmosphere activated", Color3.fromRGB(255, 140, 80))
    end
end)

-- Enhanced Dance Party Event - affects ALL players
remotes.DanceParty.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.danceParty then
        -- Stop dance party
        activeEffects.danceParty = false
        sendNotificationToAll("LIVE EVENT: Dance party has ended", Color3.fromRGB(255, 140, 60))
    else
        -- Start dance party
        activeEffects.danceParty = true
        sendNotificationToAll("LIVE EVENT: Dance party started! Everyone dance!", Color3.fromRGB(255, 140, 60), 5)
        
        spawn(function()
            local danceAnimations = {
                "http://www.roblox.com/asset/?id=507770239", -- Dance
                "http://www.roblox.com/asset/?id=507770311", -- Dance2
                "http://www.roblox.com/asset/?id=507770887", -- Dance3
            }
            
            for _, dancingPlayer in pairs(Players:GetPlayers()) do
                if dancingPlayer.Character and dancingPlayer.Character:FindFirstChild("Humanoid") then
                    local humanoid = dancingPlayer.Character.Humanoid
                    local animator = humanoid:FindFirstChild("Animator")
                    
                    if animator then
                        local danceTrack = animator:LoadAnimation(Instance.new("Animation"))
                        danceTrack.AnimationId = danceAnimations[math.random(1, #danceAnimations)]
                        danceTrack:Play()
                        danceTrack.Looped = true
                        
                        -- Store track for cleanup
                        dancingPlayer.Character:SetAttribute("DanceTrack", danceTrack)
                    end
                end
            end
            
            -- Auto-stop after 30 seconds
            wait(30)
            if activeEffects.danceParty then
                activeEffects.danceParty = false
                
                -- Stop all dance animations
                for _, dancingPlayer in pairs(Players:GetPlayers()) do
                    if dancingPlayer.Character then
                        local danceTrack = dancingPlayer.Character:GetAttribute("DanceTrack")
                        if danceTrack then
                            danceTrack:Stop()
                            dancingPlayer.Character:SetAttribute("DanceTrack", nil)
                        end
                    end
                end
                
                sendNotificationToAll("LIVE EVENT: Dance party automatically ended", Color3.fromRGB(255, 140, 60))
            end
        end)
    end
end)

-- Enhanced Fireworks Show - visible to ALL players
remotes.FireworksShow.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.fireworks then
        activeEffects.fireworks = false
        sendNotificationToAll("LIVE EVENT: Fireworks show ended", Color3.fromRGB(255, 180, 40))
    else
        activeEffects.fireworks = true
        sendNotificationToAll("LIVE EVENT: Spectacular fireworks show started! Look up!", Color3.fromRGB(255, 180, 40), 5)
        
        spawn(function()
            for i = 1, 15 do
                if not activeEffects.fireworks then break end
                
                -- Create multiple fireworks for spectacular show
                for j = 1, 4 do
                    local firework = Instance.new("Explosion")
                    firework.Position = Vector3.new(
                        math.random(-150, 150),
                        math.random(60, 120),
                        math.random(-150, 150)
                    )
                    firework.BlastRadius = 30
                    firework.BlastPressure = 0
                    firework.Parent = Workspace
                    
                    -- Add colorful particles
                    local fireworkPart = Instance.new("Part")
                    fireworkPart.Position = firework.Position
                    fireworkPart.Size = Vector3.new(1, 1, 1)
                    fireworkPart.Anchored = true
                    fireworkPart.CanCollide = false
                    fireworkPart.Transparency = 1
                    fireworkPart.Parent = Workspace
                    
                    local attachment = Instance.new("Attachment")
                    attachment.Parent = fireworkPart
                    
                    local particles = Instance.new("ParticleEmitter")
                    particles.Parent = attachment
                    particles.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 1, 1))
                    }
                    particles.Lifetime = NumberRange.new(2, 4)
                    particles.Rate = 200
                    particles.Speed = NumberRange.new(20, 40)
                    particles.SpreadAngle = Vector2.new(360, 360)
                    
                    Debris:AddItem(fireworkPart, 5)
                    
                    wait(0.2)
                end
                wait(1.5)
            end
            
            activeEffects.fireworks = false
            sendNotificationToAll("LIVE EVENT: Fireworks show concluded", Color3.fromRGB(255, 180, 40))
        end)
    end
end)

-- Enhanced Lightning Storm - visible to ALL players
remotes.LightningStorm.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.lightning then
        activeEffects.lightning = false
        sendNotificationToAll("LIVE EVENT: Lightning storm has passed", Color3.fromRGB(255, 220, 80))
    else
        activeEffects.lightning = true
        sendNotificationToAll("LIVE EVENT: Lightning storm incoming! Take cover!", Color3.fromRGB(255, 220, 80), 5)
        
        spawn(function()
            local originalAmbient = Lighting.Ambient
            local originalBrightness = Lighting.Brightness
            local originalFogEnd = Lighting.FogEnd
            
            -- Storm atmosphere
            Lighting.FogEnd = 500
            Lighting.FogColor = Color3.fromRGB(40, 40, 60)
            
            for i = 1, 15 do
                if not activeEffects.lightning then break end
                
                -- Lightning flash effect for everyone
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 4
                
                -- Thunder sound for all players
                local thunder = Instance.new("Sound")
                thunder.SoundId = "rbxassetid://131961136"
                thunder.Volume = 0.8
                thunder.Parent = Workspace
                thunder:Play()
                
                -- Lightning bolt visual effect
                for j = 1, 3 do
                    local bolt = Instance.new("Part")
                    bolt.Size = Vector3.new(1, math.random(100, 200), 1)
                    bolt.Position = Vector3.new(math.random(-200, 200), bolt.Size.Y/2, math.random(-200, 200))
                    bolt.Anchored = true
                    bolt.CanCollide = false
                    bolt.Material = Enum.Material.Neon
                    bolt.BrickColor = BrickColor.new("Institutional white")
                    bolt.Parent = Workspace
                    
                    spawn(function()
                        wait(0.1)
                        bolt:Destroy()
                    end)
                end
                
                Debris:AddItem(thunder, 5)
                
                wait(0.3)
                Lighting.Ambient = Color3.fromRGB(30, 30, 50)
                Lighting.Brightness = 0.3
                
                wait(math.random(3, 7))
            end
            
            Lighting.Ambient = originalAmbient
            Lighting.Brightness = originalBrightness
            Lighting.FogEnd = originalFogEnd
            activeEffects.lightning = false
            sendNotificationToAll("LIVE EVENT: Lightning storm has ended", Color3.fromRGB(255, 220, 80))
        end)
    end
end)

-- New Meteor Shower Event
remotes.MeteorShower.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.meteors then
        activeEffects.meteors = false
        sendNotificationToAll("LIVE EVENT: Meteor shower has ended", Color3.fromRGB(255, 120, 40))
    else
        activeEffects.meteors = true
        sendNotificationToAll("LIVE EVENT: Meteor shower! Watch the sky!", Color3.fromRGB(255, 120, 40), 5)
        
        spawn(function()
            for i = 1, 20 do
                if not activeEffects.meteors then break end
                
                local meteor = Instance.new("Part")
                meteor.Size = Vector3.new(math.random(3, 8), math.random(3, 8), math.random(3, 8))
                meteor.Shape = Enum.PartType.Ball
                meteor.Material = Enum.Material.Neon
                meteor.BrickColor = BrickColor.new("Bright orange")
                meteor.Position = Vector3.new(math.random(-300, 300), 300, math.random(-300, 300))
                meteor.Parent = Workspace
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(math.random(-50, 50), -100, math.random(-50, 50))
                bodyVelocity.Parent = meteor
                
                -- Fire trail effect
                local attachment = Instance.new("Attachment")
                attachment.Parent = meteor
                
                local fire = Instance.new("ParticleEmitter")
                fire.Parent = attachment
                fire.Texture = "rbxasset://textures/particles/fire_main.dds"
                fire.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                fire.Size = NumberSequence.new(meteor.Size.X)
                fire.Lifetime = NumberRange.new(0.5, 1.5)
                fire.Rate = 100
                fire.Speed = NumberRange.new(5, 15)
                
                -- Impact detection
                local connection
                connection = meteor.Touched:Connect(function(hit)
                    if hit.Name == "Baseplate" or hit.Parent == Workspace then
                        connection:Disconnect()
                        
                        -- Impact explosion
                        local explosion = Instance.new("Explosion")
                        explosion.Position = meteor.Position
                        explosion.BlastRadius = meteor.Size.X * 3
                        explosion.BlastPressure = 0
                        explosion.Parent = Workspace
                        
                        meteor:Destroy()
                    end
                end)
                
                Debris:AddItem(meteor, 10)
                wait(math.random(1, 3))
            end
            
            activeEffects.meteors = false
            sendNotificationToAll("LIVE EVENT: Meteor shower concluded", Color3.fromRGB(255, 120, 40))
        end)
    end
end)

-- Enhanced Disco Mode - affects lighting for ALL players
remotes.DiscoMode.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.disco then
        activeEffects.disco = false
        sendNotificationToAll("LIVE EVENT: Disco mode ended", Color3.fromRGB(200, 80, 255))
        
        -- Reset lighting
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.Brightness = 1
    else
        activeEffects.disco = true
        sendNotificationToAll("LIVE EVENT: Disco mode activated! Let's groove!", Color3.fromRGB(200, 80, 255), 5)
        
        spawn(function()
            while activeEffects.disco do
                -- Rapidly changing colorful lights
                Lighting.Ambient = Color3.fromHSV(math.random(), 0.8, 0.8)
                Lighting.ColorShift_Top = Color3.fromHSV(math.random(), 1, 1)
                Lighting.Brightness = math.random(50, 200) / 100
                
                wait(0.3)
            end
        end)
    end
end)

-- Enhanced weather effects - visible to ALL players
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
            Lighting.FogEnd = 100000
            sendNotificationToAll("WEATHER: Snow has stopped", Color3.fromRGB(180, 220, 255))
        else
            -- Start snow
            activeEffects.snow = true
            sendNotificationToAll("WEATHER: Snow is falling! Winter wonderland!", Color3.fromRGB(180, 220, 255), 5)
            
            -- Create enhanced snow effect visible to all
            local snowPart = Instance.new("Part")
            snowPart.Name = "AdminSnowCloud"
            snowPart.Size = Vector3.new(2000, 1, 2000)
            snowPart.Position = Vector3.new(0, 300, 0)
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
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(1, 0.1)
            }
            snowEffect.Lifetime = NumberRange.new(15, 20)
            snowEffect.Rate = 2000
            snowEffect.SpreadAngle = Vector2.new(45, 45)
            snowEffect.Speed = NumberRange.new(10, 25)
            snowEffect.Acceleration = Vector3.new(0, -20, 0)
            
            activeEffects.snowPart = snowPart
            
            -- Enhanced winter lighting
            Lighting.Ambient = Color3.fromRGB(180, 190, 220)
            Lighting.ColorShift_Top = Color3.fromRGB(220, 230, 255)
            Lighting.FogEnd = 1000
            Lighting.FogColor = Color3.fromRGB(230, 240, 255)
        end
    end
end)

-- New Rainbow Sky Effect
remotes.RainbowSky.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.rainbow then
        activeEffects.rainbow = false
        sendNotificationToAll("WEATHER: Rainbow sky effect ended", Color3.fromRGB(200, 150, 255))
        
        -- Reset sky
        if Lighting:FindFirstChild("Sky") then
            Lighting.Sky:Destroy()
        end
    else
        activeEffects.rainbow = true
        sendNotificationToAll("WEATHER: Rainbow sky activated! Look around!", Color3.fromRGB(200, 150, 255), 5)
        
        spawn(function()
            local sky = Instance.new("Sky")
            sky.Parent = Lighting
            
            while activeEffects.rainbow do
                sky.SkyboxBk = "http://www.roblox.com/asset/?id=271042516"
                sky.SkyboxDn = "http://www.roblox.com/asset/?id=271042516"
                sky.SkyboxFt = "http://www.roblox.com/asset/?id=271042516"
                sky.SkyboxLf = "http://www.roblox.com/asset/?id=271042516"
                sky.SkyboxRt = "http://www.roblox.com/asset/?id=271042516"
                sky.SkyboxUp = "http://www.roblox.com/asset/?id=271042516"
                
                -- Animate colors
                Lighting.Ambient = Color3.fromHSV((tick() * 0.1) % 1, 0.3, 0.8)
                Lighting.ColorShift_Top = Color3.fromHSV((tick() * 0.15) % 1, 0.5, 1)
                
                wait(0.1)
            end
            
            if sky then
                sky:Destroy()
            end
        end)
    end
end)

-- New Fog Control
remotes.FogControl.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    if activeEffects.fog then
        activeEffects.fog = false
        Lighting.FogEnd = 100000
        sendNotificationToAll("WEATHER: Fog has been cleared", Color3.fromRGB(160, 160, 200))
    else
        activeEffects.fog = true
        Lighting.FogEnd = 200
        Lighting.FogColor = Color3.fromRGB(200, 200, 220)
        sendNotificationToAll("WEATHER: Mysterious fog has rolled in", Color3.fromRGB(160, 160, 200))
    end
end)

-- Handle new players joining
Players.PlayerAdded:Connect(function(newPlayer)
    -- Check for bans
    if bannedPlayers[newPlayer.UserId] then
        local banInfo = bannedPlayers[newPlayer.UserId]
        newPlayer:Kick("ACCESS DENIED: You are banned from this server.\nBanned by: " .. banInfo.bannedBy .. "\nReason: " .. banInfo.reason)
        return
    end
    
    -- Professional join message
    wait(1)
    sendNotificationToAll("PLAYER JOINED: " .. newPlayer.Name .. " has connected to the server", Color3.fromRGB(100, 200, 100))
end)

-- Handle players leaving
Players.PlayerRemoving:Connect(function(leavingPlayer)
    sendNotificationToAll("PLAYER LEFT: " .. leavingPlayer.Name .. " has disconnected", Color3.fromRGB(200, 150, 100))
    
    -- Clean up any player-specific effects
    if leavingPlayer.Character then
        local danceTrack = leavingPlayer.Character:GetAttribute("DanceTrack")
        if danceTrack then
            danceTrack:Stop()
        end
    end
end)

-- Enhanced auto-cleanup system
spawn(function()
    while true do
        wait(300) -- Every 5 minutes
        
        -- Clean up any orphaned admin objects
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Admin") and obj.Parent then
                if obj.Name == "AdminSnowCloud" and not activeEffects.snow then
                    obj:Destroy()
                elseif obj.Name:find("Firework") and not activeEffects.fireworks then
                    obj:Destroy()
                end
            end
        end
        
        -- Clean up old sounds
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Sound") and obj.Name:find("Admin") then
                if not obj.IsPlaying then
                    obj:Destroy()
                end
            end
        end
    end
end)

print("Professional Admin Panel Server Script V4.0 loaded successfully!")
print("Enhanced live events system enabled!")
print("Global visibility active for all admin actions!")
print("Features: Player management, music, lighting, weather, live events!")