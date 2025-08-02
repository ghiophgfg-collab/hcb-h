-- CLIENT EVENT MONITOR
-- Place this in StarterPlayerScripts (separate from AdminPanel.lua)
-- This allows ALL players to see events globally

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Wait for ReplicatedStorage setup
local adminFolder = ReplicatedStorage:WaitForChild("AdminPanelData")

-- Get all the values
local DancePartyActive = adminFolder:WaitForChild("DancePartyActive")
local FireworksActive = adminFolder:WaitForChild("FireworksActive")
local LightningActive = adminFolder:WaitForChild("LightningActive")
local MeteorActive = adminFolder:WaitForChild("MeteorActive")
local SnowActive = adminFolder:WaitForChild("SnowActive")
local DiscoActive = adminFolder:WaitForChild("DiscoActive")
local CurrentMusic = adminFolder:WaitForChild("CurrentMusic")
local MusicName = adminFolder:WaitForChild("MusicName")
local GlobalMessage = adminFolder:WaitForChild("GlobalMessage")

-- Local variables
local clientMusic = nil
local clientActiveEvents = {}

-- Dance animations
local DANCE_ANIMATIONS = {
    "rbxassetid://507770239", "rbxassetid://507770818", "rbxassetid://507771019",
    "rbxassetid://507771955", "rbxassetid://507772104", "rbxassetid://507777623",
    "rbxassetid://507777268", "rbxassetid://507776879"
}

-- Show message to player
local function showMessage(message)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[ADMIN] " .. message;
        Color = Color3.fromRGB(0, 162, 255);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size18;
    })
end

-- Monitor Dance Party
DancePartyActive.Changed:Connect(function()
    if DancePartyActive.Value then
        -- Start dancing
        showMessage("🕺 Dance Party Started! 💃")
        clientActiveEvents.dancing = true
        
        wait(1) -- Wait for character
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                local danceId = DANCE_ANIMATIONS[math.random(1, #DANCE_ANIMATIONS)]
                local animation = Instance.new("Animation")
                animation.AnimationId = danceId
                local track = animator:LoadAnimation(animation)
                track.Looped = true
                track:Play()
                clientActiveEvents.danceTrack = track
            end
        end
    else
        -- Stop dancing
        showMessage("⏹️ Dance Party Ended!")
        clientActiveEvents.dancing = false
        if clientActiveEvents.danceTrack then
            clientActiveEvents.danceTrack:Stop()
            clientActiveEvents.danceTrack = nil
        end
    end
end)

-- Monitor Fireworks
FireworksActive.Changed:Connect(function()
    if FireworksActive.Value then
        showMessage("🎆 Fireworks Show Started! Look up!")
    else
        showMessage("🎆 Fireworks Show Ended!")
    end
end)

-- Monitor Lightning
LightningActive.Changed:Connect(function()
    if LightningActive.Value then
        showMessage("⚡ Lightning Storm Incoming!")
    else
        showMessage("☀️ Lightning Storm Ended!")
    end
end)

-- Monitor Meteors
MeteorActive.Changed:Connect(function()
    if MeteorActive.Value then
        showMessage("☄️ Meteor Shower! Take cover!")
    else
        showMessage("☄️ Meteor Shower Ended!")
    end
end)

-- Monitor Snow
SnowActive.Changed:Connect(function()
    if SnowActive.Value then
        showMessage("❄️ It's snowing! Winter wonderland!")
    else
        showMessage("☀️ Snow stopped!")
    end
end)

-- Monitor Disco
DiscoActive.Changed:Connect(function()
    if DiscoActive.Value then
        showMessage("💃 Disco Mode Activated! Feel the groove!")
    else
        showMessage("💃 Disco Mode Ended!")
    end
end)

-- Monitor Music
CurrentMusic.Changed:Connect(function()
    -- Stop current music
    if clientMusic then
        clientMusic:Stop()
        clientMusic:Destroy()
        clientMusic = nil
    end
    
    if CurrentMusic.Value ~= "" then
        -- Play new music
        clientMusic = Instance.new("Sound")
        clientMusic.SoundId = CurrentMusic.Value
        clientMusic.Volume = 0.5
        clientMusic.Looped = true
        clientMusic.Parent = SoundService
        clientMusic:Play()
        
        if MusicName.Value ~= "" then
            showMessage("🎵 Now playing: " .. MusicName.Value)
        end
    else
        showMessage("⏹️ Music stopped")
    end
end)

-- Monitor Global Messages
GlobalMessage.Changed:Connect(function()
    if GlobalMessage.Value ~= "" then
        showMessage("📢 " .. GlobalMessage.Value)
    end
end)

-- Make new players dance if dance party is active
LocalPlayer.CharacterAdded:Connect(function()
    wait(2) -- Wait for character to fully load
    
    if DancePartyActive.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
            local danceId = DANCE_ANIMATIONS[math.random(1, #DANCE_ANIMATIONS)]
            local animation = Instance.new("Animation")
            animation.AnimationId = danceId
            local track = animator:LoadAnimation(animation)
            track.Looped = true
            track:Play()
            clientActiveEvents.danceTrack = track
        end
    end
end)

print("Global Event Monitor loaded! All players can now see admin events.")
