-- PROFESSIONAL ADMIN PANEL SERVER V3.0
-- Place this in ServerScriptService
-- True global visibility through ReplicatedStorage

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Admin Configuration
local ADMIN_LIST = {
    -- Add admin user IDs here
    -- [123456789] = true,
}

-- Check admin permissions
local function isAdmin(player)
    return ADMIN_LIST[player.UserId] or player.UserId == game.CreatorId or false
end

-- Setup ReplicatedStorage for Global Visibility
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

-- Setup RemoteEvents
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

-- Global Variables
local bannedPlayers = {}
local globalMusic = nil
local activeEvents = {}

-- Dance Animations
local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", "rbxassetid://507770818", "rbxassetid://507771019",
    "rbxassetid://507771955", "rbxassetid://507772104", "rbxassetid://507777623",
    "rbxassetid://507777268", "rbxassetid://507776879"
}

-- Player Helper Functions
local function getPlayerByName(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
        end
    end
    return nil
end

-- Event Management Functions
local function toggleDanceParty()
    local isActive = replicatedValues.DancePartyActive.Value
    replicatedValues.DancePartyActive.Value = not isActive
    
    if not isActive then
        -- Start dance party
        activeEvents.danceParty = true
        
        -- Make all players dance
        for _, player in pairs(Players:GetPlayers()) do
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
        
        -- Party lighting
        spawn(function()
            local originalBrightness = Lighting.Brightness
            local originalAmbient = Lighting.Ambient
            
            while activeEvents.danceParty do
                Lighting.Brightness = math.random(80, 120) / 100
                Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
                wait(0.3)
            end
            
            Lighting.Brightness = originalBrightness
            Lighting.Ambient = originalAmbient
        end)
    else
        -- Stop dance party
        activeEvents.danceParty = false
        
        if activeEvents.danceTracks then
            for _, track in pairs(activeEvents.danceTracks) do
                if track then
                    track:Stop()
                end
            end
            activeEvents.danceTracks = {}
        end
    end
end

local function toggleFireworks()
    local isActive = replicatedValues.FireworksActive.Value
    replicatedValues.FireworksActive.Value = not isActive
    
    if not isActive then
        activeEvents.fireworks = true
        spawn(function()
            while activeEvents.fireworks do
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
    else
        activeEvents.fireworks = false
    end
end

local function toggleLightning()
    local isActive = replicatedValues.LightningActive.Value
    replicatedValues.LightningActive.Value = not isActive
    
    if not isActive then
        activeEvents.lightning = true
        spawn(function()
            local originalAmbient = Lighting.Ambient
            local originalBrightness = Lighting.Brightness
            
            while activeEvents.lightning do
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 3
                
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
    else
        activeEvents.lightning = false
    end
end

local function toggleMeteors()
    local isActive = replicatedValues.MeteorActive.Value
    replicatedValues.MeteorActive.Value = not isActive
    
    if not isActive then
        activeEvents.meteors = true
        spawn(function()
            while activeEvents.meteors do
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
                    
                    local fire = Instance.new("Fire")
                    fire.Size = 15
                    fire.Heat = 20
                    fire.Parent = meteor
                    
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(8000, 8000, 8000)
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-80, 80),
                        -120,
                        math.random(-80, 80)
                    )
                    bodyVelocity.Parent = meteor
                    
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
    else
        activeEvents.meteors = false
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name == "AdminMeteor" then
                obj:Destroy()
            end
        end
    end
end

local function toggleSnow()
    local isActive = replicatedValues.SnowActive.Value
    replicatedValues.SnowActive.Value = not isActive
    
    if not isActive then
        activeEvents.snow = true
        
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
        Lighting.Ambient = Color3.fromRGB(180, 180, 220)
    else
        activeEvents.snow = false
        if activeEvents.snowPart then
            activeEvents.snowPart:Destroy()
            activeEvents.snowPart = nil
        end
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    end
end

local function toggleDisco()
    local isActive = replicatedValues.DiscoActive.Value
    replicatedValues.DiscoActive.Value = not isActive
    
    if not isActive then
        activeEvents.disco = true
        spawn(function()
            while activeEvents.disco do
                Lighting.Ambient = Color3.fromHSV(math.random(), 1, 1)
                Lighting.ColorShift_Top = Color3.fromHSV(math.random(), 1, 1)
                Lighting.ColorShift_Bottom = Color3.fromHSV(math.random(), 1, 1)
                Lighting.Brightness = math.random(100, 150) / 100
                wait(0.2)
            end
            
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end)
    else
        activeEvents.disco = false
    end
end

-- Remote Event Handlers
remoteEvents.KickPlayer.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        targetPlayer:Kick("Kicked by " .. player.Name)
    end
end)

remoteEvents.BanPlayer.OnServerEvent:Connect(function(player, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    if targetPlayer then
        bannedPlayers[targetPlayer.UserId] = {
            name = targetPlayer.Name,
            bannedBy = player.Name,
            timestamp = os.time()
        }
        targetPlayer:Kick("Banned by " .. player.Name)
    end
end)

remoteEvents.TeleportPlayer.OnServerEvent:Connect(function(player, action, targetName)
    if not isAdmin(player) then return end
    
    local targetPlayer = getPlayerByName(targetName)
    
    if action == "to" and targetPlayer then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
        end
    elseif action == "bring" and targetPlayer then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
        end
    end
end)

remoteEvents.ServerMessage.OnServerEvent:Connect(function(player, message)
    if not isAdmin(player) then return end
    replicatedValues.GlobalMessage.Value = message
    wait(0.1)
    replicatedValues.GlobalMessage.Value = ""
end)

remoteEvents.ToggleEvent.OnServerEvent:Connect(function(player, eventType)
    if not isAdmin(player) then return end
    
    if eventType == "DanceParty" then
        toggleDanceParty()
    elseif eventType == "Fireworks" then
        toggleFireworks()
    elseif eventType == "Lightning" then
        toggleLightning()
    elseif eventType == "Meteor" then
        toggleMeteors()
    elseif eventType == "Snow" then
        toggleSnow()
    elseif eventType == "Disco" then
        toggleDisco()
    end
end)

remoteEvents.PlayMusic.OnServerEvent:Connect(function(player, musicId, musicName)
    if not isAdmin(player) then return end
    
    if globalMusic then
        globalMusic:Stop()
        globalMusic:Destroy()
        globalMusic = nil
    end
    
    if musicId ~= "" then
        globalMusic = Instance.new("Sound")
        globalMusic.Name = "GlobalAdminMusic"
        globalMusic.SoundId = musicId
        globalMusic.Volume = 0.5
        globalMusic.Looped = true
        globalMusic.Parent = Workspace
        globalMusic:Play()
        
        replicatedValues.CurrentMusic.Value = musicId
        replicatedValues.MusicName.Value = musicName
    else
        replicatedValues.CurrentMusic.Value = ""
        replicatedValues.MusicName.Value = ""
    end
end)

remoteEvents.ClearWorkspace.OnServerEvent:Connect(function(player)
    if not isAdmin(player) then return end
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= Workspace.CurrentCamera and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        elseif obj:IsA("Part") and obj.Name ~= "Baseplate" and obj.Name ~= "SpawnLocation" then
            obj:Destroy()
        end
    end
end)

remoteEvents.SetGravity.OnServerEvent:Connect(function(player, gravity)
    if not isAdmin(player) then return end
    Workspace.Gravity = gravity
end)

remoteEvents.SetLighting.OnServerEvent:Connect(function(player, timeOfDay)
    if not isAdmin(player) then return end
    Lighting.TimeOfDay = timeOfDay
end)

-- Handle banned players
Players.PlayerAdded:Connect(function(player)
    if bannedPlayers[player.UserId] then
        local banInfo = bannedPlayers[player.UserId]
        player:Kick("You are banned from this server. Banned by: " .. banInfo.bannedBy)
        return
    end
    
    -- If dance party is active, make new player dance
    if activeEvents.danceParty then
        wait(2)
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
end)

-- Clean up dance tracks when players leave
Players.PlayerRemoving:Connect(function(player)
    if activeEvents.danceTracks and activeEvents.danceTracks[player.UserId] then
        activeEvents.danceTracks[player.UserId] = nil
    end
end)

-- Auto-cleanup system
spawn(function()
    while true do
        wait(300) -- Every 5 minutes
        
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name == "AdminMeteor" and obj.Parent then
                Debris:AddItem(obj, 10)
            end
        end
    end
end)

print("Professional Admin Panel Server V3.0 loaded!")
print("ReplicatedStorage system enabled for global event visibility!")
print("Events: Dance Party, Fireworks, Lightning, Meteors, Snow, Disco Mode")