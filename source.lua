--[[
Check "ReadME" and "Version" File before using the loadstring

loadstring(game:HttpGet("https://raw.githubusercontent.com/Zakmapping/F4X-Hub/refs/heads/main/source.lua"))()

]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
   Name = "F4X Hub",
   Icon = 0,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Gizmoscat",
   Theme = "Ocean",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "M4X",
      FileName = "M4X Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local MM2 = Window:CreateTab("MM2 Commands", 10626050781)
local DeadRails = Window:CreateTab("Dead Rails", 10626050781)
local Others = Window:CreateTab("Others", 10626050781)

-- MM2 Section
local MM2Section = MM2:CreateSection("ESP")

-- Initialize globals
_G.MurdererESP = false
_G.MurdererColor = Color3.fromRGB(255, 0, 0)
_G.SheriffESP = false
_G.SheriffColor = Color3.fromRGB(0, 0, 255)
_G.AimbotEnabled = false
_G.KillTeleportEnabled = false
_G.ZombieESPEnabled = false
_G.GoldESPEnabled = false

-- Murderer ESP
local MurdererToggle = MM2:CreateToggle({
    Name = "Murderer ESP",
    CurrentValue = false,
    Flag = "MurdererESP",
    Callback = function(Value)
        _G.MurdererESP = Value
        if not Value then
            -- Remove all murderer ESP highlights when disabled
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild(player.Name .. "_MurdererESP")
                    if highlight then highlight:Destroy() end
                end
            end
        else
            updateESP()
        end
    end,
})

local MurdererColorPicker = MM2:CreateColorPicker({
    Name = "Murderer ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "MurdererColor",
    Callback = function(Value)
        _G.MurdererColor = Value
        -- Update existing murderer highlights
        if _G.MurdererESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild(player.Name .. "_MurdererESP")
                    if highlight then
                        highlight.FillColor = Value
                        highlight.OutlineColor = Value
                    end
                end
            end
        end
    end
})

-- Sheriff ESP
local SheriffToggle = MM2:CreateToggle({
    Name = "Sheriff ESP",
    CurrentValue = false,
    Flag = "SheriffESP",
    Callback = function(Value)
        _G.SheriffESP = Value
        if not Value then
            -- Remove all sheriff ESP highlights when disabled
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild(player.Name .. "_SheriffESP")
                    if highlight then highlight:Destroy() end
                end
            end
        else
            updateESP()
        end
    end,
})

local SheriffColorPicker = MM2:CreateColorPicker({
    Name = "Sheriff ESP Color",
    Color = Color3.fromRGB(0, 0, 255),
    Flag = "SheriffColor",
    Callback = function(Value)
        _G.SheriffColor = Value
        -- Update existing sheriff highlights
        if _G.SheriffESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild(player.Name .. "_SheriffESP")
                    if highlight then
                        highlight.FillColor = Value
                        highlight.OutlineColor = Value
                    end
                end
            end
        end
    end
})

local function hasKnife(player)
    local character = player.Character
    if not character then return false end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name:lower(), "knife") or tool.Name == "Knife") then
            return true
        end
    end
    return false
end

local function hasGun(player)
    local character = player.Character
    if not character then return false end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name:lower(), "gun") or tool.Name == "Gun") then
            return true
        end
    end
    return false
end

local function createESP(player, espType, color)
    local character = player.Character
    if not character then return nil end
    
    local highlightName = player.Name .. "_" .. espType .. "ESP"
    
    -- Remove existing highlight if it exists
    local existingHighlight = character:FindFirstChild(highlightName)
    if existingHighlight then existingHighlight:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = highlightName
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = character
    
    player.CharacterAdded:Connect(function(newChar)
        if highlight then highlight:Destroy() end
        task.wait(1) -- Wait for character to fully load
        
        if (espType == "Murderer" and _G.MurdererESP) or (espType == "Sheriff" and _G.SheriffESP) then
            highlight = Instance.new("Highlight")
            highlight.Name = highlightName
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.Parent = newChar
        end
    end)
    
    return highlight
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if player.Character then
                -- Remove old highlights
                local oldMurdererHighlight = player.Character:FindFirstChild(player.Name .. "_MurdererESP")
                if oldMurdererHighlight then oldMurdererHighlight:Destroy() end
                
                local oldSheriffHighlight = player.Character:FindFirstChild(player.Name .. "_SheriffESP")
                if oldSheriffHighlight then oldSheriffHighlight:Destroy() end
                
                -- Create new highlights if enabled
                if _G.MurdererESP and hasKnife(player) then
                    createESP(player, "Murderer", _G.MurdererColor)
                end
                
                if _G.SheriffESP and hasGun(player) then
                    createESP(player, "Sheriff", _G.SheriffColor)
                end
            end
        end
    end
end

-- Connect events for ESP updates
local function setupPlayerConnections(player)
    player.CharacterAdded:Connect(function()
        if _G.MurdererESP or _G.SheriffESP then
            updateESP()
        end
    end)
end

-- Setup connections for existing players
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayerConnections(player)
end

-- Setup connections for new players
Players.PlayerAdded:Connect(function(player)
    setupPlayerConnections(player)
end)

-- Main ESP update loop
RunService.Heartbeat:Connect(function()
    if _G.MurdererESP or _G.SheriffESP then
        updateESP()
    end
end)

-- بقية السكريبت تبقى كما هي بدون تغيير...
-- EZ Win Section
local EZSection = MM2:CreateSection("EZ Win")

local Aimbot = MM2:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        _G.AimbotEnabled = Value
        
        if Value then
            spawn(function()
                while _G.AimbotEnabled and task.wait() do
                    local closestPlayer = nil
                    local closestDistance = math.huge
                    local localPlayer = game.Players.LocalPlayer
                    local localChar = localPlayer.Character
                    
                    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then continue end
                    
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (localChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                    
                    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localChar.HumanoidRootPart.CFrame = CFrame.new(localChar.HumanoidRootPart.Position, closestPlayer.Character.HumanoidRootPart.Position)
                    end
                end
            end)
        end
    end,
})

local KillTeleport = MM2:CreateToggle({
    Name = "Kill Teleporter",
    CurrentValue = false,
    Flag = "KillTP",
    Callback = function(Value)
        _G.KillTeleportEnabled = Value
        
        if Value then
            spawn(function()
                while _G.KillTeleportEnabled and task.wait(0.5) do
                    local localPlayer = game.Players.LocalPlayer
                    local character = localPlayer.Character
                    
                    if not character then continue end
                    
                    -- Check if player has a knife
                    local hasKnife = false
                    for _, tool in pairs(character:GetChildren()) do
                        if tool.Name == "Knife" then
                            hasKnife = true
                            break
                        end
                    end
                    
                    if not hasKnife then
                        Rayfield:Notify({
                            Title = "Kill Teleport",
                            Content = "Error: You need a knife to use kill teleporter",
                            Duration = 4,
                            Image = 4483362458,
                        })
                        KillTeleport:Set(false)
                        break
                    end
                    
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if not _G.KillTeleportEnabled then break end
                        
                        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                            local localRoot = character:FindFirstChild("HumanoidRootPart")
                            
                            if targetRoot and localRoot then
                                localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -2)
                                
                                local knife = character:FindFirstChild("Knife")
                                if knife then
                                    knife:Activate()
                                end
                                
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        end
    end,
})

local Hitbox = MM2:CreateInput({
    Name = "Hitbox Size",
    CurrentValue = "",
    PlaceholderText = "Put Hitbox Size",
    RemoveTextAfterFocusLost = false,
    Flag = "Hitbox",
    Callback = function(Text)
        local size = tonumber(Text)
        if size then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        if humanoidRootPart:FindFirstChild("Hitbox") then
                            humanoidRootPart.Hitbox:Destroy()
                        end
                        
                        local hitbox = Instance.new("Part")
                        hitbox.Name = "Hitbox"
                        hitbox.Size = Vector3.new(size, size, size)
                        hitbox.Transparency = 0.4
                        hitbox.Anchored = true
                        hitbox.CanCollide = false
                        hitbox.CFrame = humanoidRootPart.CFrame
                        hitbox.Parent = humanoidRootPart
                        
                        game:GetService("RunService").Heartbeat:Connect(function()
                            if humanoidRootPart and hitbox then
                                hitbox.CFrame = humanoidRootPart.CFrame
                            end
                        end)
                    end
                end
            end
        end
    end,
})

-- Dead Rails Section
local DRSection1 = DeadRails:CreateSection("Zombies ESP")

local ZombieToggle = DeadRails:CreateToggle({
    Name = "Zombie ESP",
    CurrentValue = false,
    Flag = "ZombieESP",
    Callback = function(Value)
        _G.ZombieESPEnabled = Value
        
        if Value then
            spawn(function()
                local foundZombies = false
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("zombie") and obj:IsA("BasePart") then
                        foundZombies = true
                        break
                    end
                end
                
                if not foundZombies then
                    Rayfield:Notify({
                        Title = "Zombie ESP",
                        Content = "Failed: Failed to find zombie model, we will check if there in next updates",
                        Duration = 6,
                        Image = 4483362458,
                    })
                    ZombieToggle:Set(false)
                    return
                else
                    Rayfield:Notify({
                        Title = "Zombie ESP",
                        Content = "Success: The Zombie model has been found in the game",
                        Duration = 5,
                        Image = 4483362458,
                    })
                end
                
                while _G.ZombieESPEnabled and task.wait(0.5) do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("zombie") and obj:IsA("BasePart") then
                            if not obj:FindFirstChild("ZombieHighlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "ZombieHighlight"
                                highlight.FillColor = _G.MurdererColor or Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = obj
                            else
                                obj.ZombieHighlight.FillColor = _G.MurdererColor or Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
                
                if not _G.ZombieESPEnabled then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:FindFirstChild("ZombieHighlight") then
                            obj.ZombieHighlight:Destroy()
                        end
                    end
                end
            end)
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("ZombieHighlight") then
                    obj.ZombieHighlight:Destroy()
                end
            end
        end
    end,
})

local ZombieColorPicker = DeadRails:CreateColorPicker({
    Name = "Select Zombie ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ZombieColor1",
    Callback = function(Value)
        _G.MurdererColor = Value
        if _G.ZombieESPEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("ZombieHighlight") then
                    obj.ZombieHighlight.FillColor = Value
                end
            end
        end
    end
})

local DRSection2 = DeadRails:CreateSection("Gold ESP")

local GoldToggle = DeadRails:CreateToggle({
    Name = "Gold ESP",
    CurrentValue = false,
    Flag = "GoldESP",
    Callback = function(Value)
        _G.GoldESPEnabled = Value
        
        if Value then
            spawn(function()
                while _G.GoldESPEnabled and task.wait(0.5) do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("gold") and obj:IsA("BasePart") then
                            if not obj:FindFirstChild("GoldHighlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "GoldHighlight"
                                highlight.FillColor = _G.GoldColor or Color3.fromRGB(255, 215, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = obj
                            else
                                obj.GoldHighlight.FillColor = _G.GoldColor or Color3.fromRGB(255, 215, 0)
                            end
                        end
                    end
                end
                
                if not _G.GoldESPEnabled then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:FindFirstChild("GoldHighlight") then
                            obj.GoldHighlight:Destroy()
                        end
                    end
                end
            end)
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("GoldHighlight") then
                    obj.GoldHighlight:Destroy()
                end
            end
        end
    end,
})

local GoldColorPicker = DeadRails:CreateColorPicker({
    Name = "Select Gold ESP",
    Color = Color3.fromRGB(255, 215, 0),
    Flag = "GoldColor1",
    Callback = function(Value)
        _G.GoldColor = Value
        if _G.GoldESPEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("GoldHighlight") then
                    obj.GoldHighlight.FillColor = Value
                end
            end
        end
    end
})

local OthersSection = Others:CreateSection("Player Modifications")
local NoClipToggle = Others:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        _G.NoClipEnabled = Value
        if Value then
            game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClipEnabled and game.Players.LocalPlayer.Character then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end,
})

local SpeedInput = Others:CreateInput({
    Name = "Speed Hack",
    PlaceholderText = "Enter speed value",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end,
})

local DayButton = Others:CreateButton({
    Name = "Day (Client)",
    Callback = function()
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end,
})

local NightButton = Others:CreateButton({
    Name = "Night (Client)",
    Callback = function()
        game:GetService("Lighting").ClockTime = 0
        game:GetService("Lighting").Brightness = 0.1
        game:GetService("Lighting").Ambient = Color3.fromRGB(50, 50, 50)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(50, 50, 50)
    end,
})


Rayfield:LoadConfiguration()