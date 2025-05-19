--[[
Before you start reading or testing the script, go to the ReadME file for more information. 
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
    end,
})

local MurdererColorPicker = MM2:CreateColorPicker({
    Name = "Select Murderer ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "MurdererColor1",
    Callback = function(Value)
        _G.MurdererColor = Value
    end
})

-- Sheriff ESP
local SheriffToggle = MM2:CreateToggle({
    Name = "Sheriff ESP",
    CurrentValue = false,
    Flag = "SheriffESP",
    Callback = function(Value)
        _G.SheriffESP = Value
    end,
})

local SheriffColorPicker = MM2:CreateColorPicker({
    Name = "Select Sheriff ESP",
    Color = Color3.fromRGB(0, 0, 255),
    Flag = "SheriffColor2",
    Callback = function(Value)
        _G.SheriffColor = Value
    end,
})

local function hasKnife(player)
    local character = player.Character
    if not character then return false end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "knife") then
            return true
        end
    end
    return false
end

local function hasGun(player)
    local character = player.Character
    if not character then return false end
    
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "gun") then
            return true
        end
    end
    return false
end

local function createESP(player, color)
    local character = player.Character
    if not character then return nil end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = character
    
    player.CharacterAdded:Connect(function(newChar)
        if highlight then highlight:Destroy() end
        task.wait(1) -- Wait for character to fully load
        highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_ESP"
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.Parent = newChar
    end)
    
    return highlight
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if player.Character then
                local oldHighlight = player.Character:FindFirstChild(player.Name .. "_ESP")
                if oldHighlight then oldHighlight:Destroy() end
                
                if _G.MurdererESP and hasKnife(player) then
                    createESP(player, _G.MurdererColor)
                end
                
                if _G.SheriffESP and hasGun(player) then
                    createESP(player, _G.SheriffColor)
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.MurdererESP or _G.SheriffESP then
        updateESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if _G.MurdererESP or _G.SheriffESP then
            updateESP()
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if _G.MurdererESP or _G.SheriffESP then
            updateESP()
        end
    end)
end

-- EZ Win Section
local EZSection = MM2:CreateSection("EZ Win")
local Aimbot = MM2:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        _G.AimbotEnabled = Value
        
        if Value then
            local player = game:GetService("Players").LocalPlayer
            local mouse = player:GetMouse()
            local camera = workspace.CurrentCamera
            
            mouse.Button2Down:Connect(function()
                if not _G.AimbotEnabled then return end
                
                local closestPlayer = nil
                local closestDistance = math.huge
                local localChar = player.Character
                if not localChar then return end
                local localRoot = localChar:FindFirstChild("HumanoidRootPart")
                if not localRoot then return end
                
                for _, target in pairs(game:GetService("Players"):GetPlayers()) do
                    if target ~= player and target.Character then
                        local targetChar = target.Character
                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHead = targetChar:FindFirstChild("Head")
                        
                        if targetRoot and targetHead then
                            local distance = (localRoot.Position - targetRoot.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = target
                            end
                        end
                    end
                end
                
                if closestPlayer then
                    local targetChar = closestPlayer.Character
                    local targetHead = targetChar:FindFirstChild("Head")
                    
                    if targetHead then
                        local con
                        con = game:GetService("RunService").RenderStepped:Connect(function()
                            if not _G.AimbotEnabled or not mouse.Button2Pressed then
                                con:Disconnect()
                                return
                            end
                            
                            if targetHead and targetHead.Parent and targetHead.Parent:FindFirstChild("Humanoid") and targetHead.Parent.Humanoid.Health > 0 then
                                camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
                            else
                                con:Disconnect()
                            end
                        end)
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
        _G.ZombieColor = Value
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
local FlyToggle = Others:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        _G.FlyEnabled = Value
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if Value then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
            
            local userInput = game:GetService("UserInputService")
            local control = {Forward = 0, Backward = 0, Left = 0, Right = 0}
            local flySpeed = 50
            
            local flyConnection = userInput.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.KeyCode == Enum.KeyCode.W then
                    control.Forward = 1
                elseif input.KeyCode == Enum.KeyCode.S then
                    control.Backward = -1
                elseif input.KeyCode == Enum.KeyCode.A then
                    control.Left = -1
                elseif input.KeyCode == Enum.KeyCode.D then
                    control.Right = 1
                elseif input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    bodyVelocity.Velocity = Vector3.new(0, -flySpeed, 0)
                end
            end)
            
            local flyEndConnection = userInput.InputEnded:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.W then
                    control.Forward = 0
                elseif input.KeyCode == Enum.KeyCode.S then
                    control.Backward = 0
                elseif input.KeyCode == Enum.KeyCode.A then
                    control.Left = 0
                elseif input.KeyCode == Enum.KeyCode.D then
                    control.Right = 0
                elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
            
            local renderStepped = game:GetService("RunService").RenderStepped:Connect(function()
                if not _G.FlyEnabled then return end
                
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local cf = workspace.CurrentCamera.CFrame
                    local direction = (cf.LookVector * (control.Forward + control.Backward) + 
                                     cf.RightVector * (control.Left + control.Right))
                    direction = direction.Unit
                    
                    bodyVelocity.Velocity = direction * flySpeed
                end
            end)
            
            _G.FlyConnections = {flyConnection, flyEndConnection, renderStepped}
        else
            if _G.FlyConnections then
                for _, conn in pairs(_G.FlyConnections) do
                    conn:Disconnect()
                end
                _G.FlyConnections = nil
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, v in pairs(rootPart:GetChildren()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end,
})

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