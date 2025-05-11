local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "F4X Hub",
    LoadingTitle = "Loading F4X Hub...",
    LoadingSubtitle = "by Gizmoscat",
    ConfigurationSaving = {Enabled = true, FolderName = "F4XHubConfig", FileName = "F4XHubSettings"},
    Discord = {Enabled = false, Invite = "noinvitelink", RememberJoins = true},
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Player Modifications")

local flying = false
local FlyToggle = MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        flying = Value
        if flying then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Flying) end
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 10000
            bodyGyro.D = 1000
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = character.HumanoidRootPart.CFrame
            bodyGyro.Parent = character.HumanoidRootPart
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            local flySpeed = 50
            local control = {w = 0, s = 0, a = 0, d = 0}
            
            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.W then control.w = 1
                elseif input.KeyCode == Enum.KeyCode.S then control.s = 1
                elseif input.KeyCode == Enum.KeyCode.A then control.a = 1
                elseif input.KeyCode == Enum.KeyCode.D then control.d = 1
                elseif input.KeyCode == Enum.KeyCode.Space then bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then bodyVelocity.Velocity = Vector3.new(0, -flySpeed, 0) end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
                if input.KeyCode == Enum.KeyCode.W then control.w = 0
                elseif input.KeyCode == Enum.KeyCode.S then control.s = 0
                elseif input.KeyCode == Enum.KeyCode.A then control.a = 0
                elseif input.KeyCode == Enum.KeyCode.D then control.d = 0
                elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then bodyVelocity.Velocity = Vector3.new(0, 0, 0) end
            end)
            
            game:GetService("RunService").Heartbeat:Connect(function()
                if flying and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local newVelocity = (root.CFrame.LookVector * (control.w - control.s)) * flySpeed + (root.CFrame.RightVector * (control.d - control.a)) * flySpeed
                    newVelocity = Vector3.new(newVelocity.X, bodyVelocity.Velocity.Y, newVelocity.Z)
                    bodyVelocity.Velocity = newVelocity
                    bodyGyro.CFrame = root.CFrame
                end
            end)
        else
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(root:GetChildren()) do
                        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
                    end
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Landed) end
            end
        end
    end,
})

local NoClipToggle = MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        _G.NoClip = Value
        if Value then
            game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClip and game:GetService("Players").LocalPlayer.Character then
                    for _, part in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end,
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "Speed Hack",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = Value end
    end,
})

local JumpSlider = MainTab:CreateSlider({
    Name = "Jump Hack",
    Range = {50, 500},
    Increment = 10,
    Suffix = "height",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = Value end
    end,
})

local ClickTPToggle = MainTab:CreateToggle({
    Name = "Click to Teleport",
    CurrentValue = false,
    Flag = "ClickTPToggle",
    Callback = function(Value)
        _G.ClickTP = Value
        if Value then
            local UIS = game:GetService("UserInputService")
            local player = game:GetService("Players").LocalPlayer
            local mouse = player:GetMouse()
            
            mouse.Button1Down:Connect(function()
                if _G.ClickTP and player.Character then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local target = mouse.Hit.Position
                        rootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end,
})

local WalkInAirToggle = MainTab:CreateToggle({
    Name = "Walk in Air",
    CurrentValue = false,
    Flag = "WalkInAirToggle",
    Callback = function(Value)
        _G.WalkInAir = Value
        if Value then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not Value)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not Value)
            end
        else
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end,
})

local SitButton = MainTab:CreateButton({
    Name = "Sit",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Sit = true end
    end,
})

local EspToggle = MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "EspToggle",
    Callback = function(Value)
        _G.ESPEnabled = Value
        if Value then
            local function createESP(player)
                local character = player.Character or player.CharacterAdded:Wait()
                local highlight = Instance.new("Highlight")
                highlight.Name = player.Name .. "_ESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
                
                player.CharacterAdded:Connect(function(newChar)
                    local newHighlight = Instance.new("Highlight")
                    newHighlight.Name = player.Name .. "_ESP"
                    newHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                    newHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    newHighlight.FillTransparency = 0.5
                    newHighlight.OutlineTransparency = 0
                    newHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    newHighlight.Parent = newChar
                end)
            end
            
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then createESP(player) end
            end
            
            game:GetService("Players").PlayerAdded:Connect(function(player)
                if _G.ESPEnabled then createESP(player) end
            end)
        else
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character then
                    local esp = player.Character:FindFirstChild(player.Name .. "_ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end,
})

MainTab:CreateSection("Utility")

local RejoinButton = MainTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId) end,
})

local ServerHopButton = MainTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local API = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"
        local GameID = game.PlaceId
        
        local function servers()
            local servers = {}
            local req = Http:JSONDecode(game:HttpGet(API:format(GameID)))
            for _, server in next, req.data do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then table.insert(servers, server.id) end
            end
            return servers
        end
        
        local function teleport()
            local serv = servers()
            if #serv > 0 then
                TPS:TeleportToPlaceInstance(GameID, serv[math.random(1, #serv)])
            else
                Rayfield:Notify({Title = "Server Hop", Content = "No servers found", Duration = 3, Image = nil, Actions = {Ignore = {Name = "Okay", Callback = function() end}}})
            end
        end
        
        teleport()
    end,
})

local InfiniteJumpToggle = MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        _G.InfiniteJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump then
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid:ChangeState("Jumping") end
                end
            end
        end)
    end,
})

local FullBrightToggle = MainTab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(Value)
        _G.FullBrightEnabled = Value
        if Value then
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 10000
        end
    end,
})

local AntiAFKToggle = MainTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        _G.AntiAFK = Value
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                if _G.AntiAFK then VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end
            end)
        end
    end,
})

local RemoveFogToggle = MainTab:CreateToggle({
    Name = "Remove Fog",
    CurrentValue = false,
    Flag = "RemoveFogToggle",
    Callback = function(Value)
        _G.NoFog = Value
        if Value then game:GetService("Lighting").FogEnd = 100000 else game:GetService("Lighting").FogEnd = 10000 end
    end,
})

local FOVSlider = MainTab:CreateSlider({
    Name = "Set FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value) game:GetService("Workspace").CurrentCamera.FieldOfView = Value end,
})

local FakeLagToggle = MainTab:CreateToggle({
    Name = "Fake Lag",
    CurrentValue = false,
    Flag = "FakeLagToggle",
    Callback = function(Value)
        _G.FakeLag = Value
        if Value then settings().Network.IncomingReplicationLag = 1000 else settings().Network.IncomingReplicationLag = 0 end
    end,
})

MainTab:CreateSection("SkyBox Changer")
local SkyBoxInput = MainTab:CreateInput({
    Name = "SkyBox Asset ID",
    PlaceholderText = "Enter Asset ID",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) 
        _G.SkyBoxId = Text 
        if _G.SkyBoxEnabled then
            -- Update SkyBox immediately if it's already enabled
            SkyBoxToggle.Callback(_G.SkyBoxEnabled)
        end
    end,
})

local SkyBoxToggle = MainTab:CreateToggle({
    Name = "Enable Custom SkyBox",
    CurrentValue = false,
    Flag = "SkyBoxToggle",
    Callback = function(Value)
        _G.SkyBoxEnabled = Value
        if Value and _G.SkyBoxId then
            local sky = game:GetService("Lighting").Sky
            sky.SkyboxBk = "rbxassetid://".._G.SkyBoxId
            sky.SkyboxDn = "rbxassetid://".._G.SkyBoxId
            sky.SkyboxFt = "rbxassetid://".._G.SkyBoxId
            sky.SkyboxLf = "rbxassetid://".._G.SkyBoxId
            sky.SkyboxRt = "rbxassetid://".._G.SkyBoxId
            sky.SkyboxUp = "rbxassetid://".._G.SkyBoxId
        else
            local sky = game:GetService("Lighting").Sky
            sky.SkyboxBk = "rbxassetid://7018684000"
            sky.SkyboxDn = "rbxassetid://6334928194"
            sky.SkyboxFt = "rbxassetid://7018684000"
            sky.SkyboxLf = "rbxassetid://7018684000"
            sky.SkyboxRt = "rbxassetid://7018684000"
            sky.SkyboxUp = "rbxassetid://7018684000"
        end
    end,
})

MainTab:CreateSection("Spin")
local SpinToggle = MainTab:CreateToggle({
    Name = "Enable Spin",
    CurrentValue = false,
    Flag = "SpinToggle",
    Callback = function(Value)
        _G.SpinEnabled = Value
        if Value then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            
            local spinSpeed = _G.SpinSpeed or 50
            local spinConnection
            spinConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.SpinEnabled and root then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                else
                    spinConnection:Disconnect()
                end
            end)
        end
    end,
})

local SpinSpeedSlider = MainTab:CreateSlider({
    Name = "Spin Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = 50,
    Flag = "SpinSpeed",
    Callback = function(Value) 
        _G.SpinSpeed = Value
        if _G.SpinEnabled then
            SpinToggle.Callback(true)
        end
    end,
})

MainTab:CreateSection("FPS Booster")
local FPSButton = MainTab:CreateButton({
    Name = "Boost FPS",
    Callback = function()
        local settings = game:GetService("UserSettings")
        settings.RenderQuality = 1
        settings.SavedQualityLevel = 1
        settings:SetRenderingQuality(1)
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored then v.Material = Enum.Material.Plastic end
        end
        
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").QualityLevel = "Level01"
        Rayfield:Notify({Title = "FPS Boosted", Content = "Game quality reduced for better performance", Duration = 5, Image = nil, Actions = {Ignore = {Name = "Okay", Callback = function() end}}})
    end,
})

MainTab:CreateSection("Auto Clicker")
local AutoClickerToggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickerToggle",
    Callback = function(Value)
        _G.AutoClicker = Value
        if Value then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local clickSpeed = _G.ClickSpeed or 0.1
            local clickThread
            
            clickThread = task.spawn(function()
                while _G.AutoClicker do
                    task.wait(clickSpeed)
                    mouse1click()
                end
            end)
            
            _G.AutoClickerThread = clickThread
        else
            if _G.AutoClickerThread then
                task.cancel(_G.AutoClickerThread)
                _G.AutoClickerThread = nil
            end
        end
    end,
})

local ClickSpeedSlider = MainTab:CreateSlider({
    Name = "Click Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "seconds",
    CurrentValue = 0.1,
    Flag = "ClickSpeed",
    Callback = function(Value) 
        _G.ClickSpeed = Value 
        if _G.AutoClicker then
            AutoClickerToggle.Callback(false)
            AutoClickerToggle.Callback(true)
        end
    end,
})

local MM2Tab = Window:CreateTab("MM2", 4483362458)
MM2Tab:CreateSection("Murder Mystery 2 Features")

local function getPlayerRole(player)
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("knife") or toolName:find("murder") then return "MURDERER"
                elseif toolName:find("gun") or toolName:find("sheriff") then return "SHERIFF" end
            end
        end
        
        if player:FindFirstChild("Backpack") then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if toolName:find("knife") or toolName:find("murder") then return "MURDERER"
                    elseif toolName:find("gun") or toolName:find("sheriff") then return "SHERIFF" end
                end
            end
        end
    end
    return "INNOCENT"
end

local MurdererColor = Color3.fromRGB(255, 0, 0)
local SheriffColor = Color3.fromRGB(0, 0, 255)

local function createRoleESP(player, role, color)
    if not player.Character then return end
    
    if player.Character:FindFirstChild(player.Name.."_MM2ESP") then player.Character[player.Name.."_MM2ESP"]:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name.."_MM2ESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    if player.Character:FindFirstChild("Head") then
        if player.Character.Head:FindFirstChild("MM2RoleLabel") then player.Character.Head.MM2RoleLabel:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MM2RoleLabel"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = role
        label.TextColor3 = color
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.BackgroundTransparency = 1
        label.Parent = billboard
    end
end

local MurdererESP = MM2Tab:CreateToggle({
    Name = "Murderer ESP",
    CurrentValue = false,
    Flag = "MurdererESP",
    Callback = function(Value)
        _G.MurdererESP = Value
        if Value then
            local function updateMurdererESP(player)
                if getPlayerRole(player) == "MURDERER" then createRoleESP(player, "MURDERER", MurdererColor) end
            end
            
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                updateMurdererESP(player)
                
                player.CharacterAdded:Connect(function() if _G.MurdererESP then updateMurdererESP(player) end end)
                if player:FindFirstChild("Backpack") then
                    player.Backpack.ChildAdded:Connect(function() if _G.MurdererESP then updateMurdererESP(player) end end)
                end
            end
            
            game:GetService("Players").PlayerAdded:Connect(function(player)
                if _G.MurdererESP then
                    updateMurdererESP(player)
                    player.CharacterAdded:Connect(function() if _G.MurdererESP then updateMurdererESP(player) end end)
                    if player:FindFirstChild("Backpack") then
                        player.Backpack.ChildAdded:Connect(function() if _G.MurdererESP then updateMurdererESP(player) end end)
                    end
                end
            end)
        else
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild(player.Name.."_MM2ESP") then player.Character[player.Name.."_MM2ESP"]:Destroy() end
                if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("MM2RoleLabel") then player.Character.Head.MM2RoleLabel:Destroy() end
            end
        end
    end,
})

MM2Tab:CreateColorPicker({
    Name = "Murderer Color",
    Color = MurdererColor,
    Flag = "MurdererColor",
    Callback = function(Value)
        MurdererColor = Value
        if _G.MurdererESP then
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if getPlayerRole(player) == "MURDERER" then
                    if player.Character and player.Character:FindFirstChild(player.Name.."_MM2ESP") then player.Character[player.Name.."_MM2ESP"].FillColor = Value end
                    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("MM2RoleLabel") then player.Character.Head.MM2RoleLabel.TextLabel.TextColor3 = Value end
                end
            end
        end
    end,
})

local SheriffESP = MM2Tab:CreateToggle({
    Name = "Sheriff ESP",
    CurrentValue = false,
    Flag = "SheriffESP",
    Callback = function(Value)
        _G.SheriffESP = Value
        if Value then
            local function updateSheriffESP(player)
                if getPlayerRole(player) == "SHERIFF" then createRoleESP(player, "SHERIFF", SheriffColor) end
            end
            
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                updateSheriffESP(player)
                
                player.CharacterAdded:Connect(function() if _G.SheriffESP then updateSheriffESP(player) end end)
                if player:FindFirstChild("Backpack") then
                    player.Backpack.ChildAdded:Connect(function() if _G.SheriffESP then updateSheriffESP(player) end end)
                end
            end
            
            game:GetService("Players").PlayerAdded:Connect(function(player)
                if _G.SheriffESP then
                    updateSheriffESP(player)
                    player.CharacterAdded:Connect(function() if _G.SheriffESP then updateSheriffESP(player) end end)
                    if player:FindFirstChild("Backpack") then
                        player.Backpack.ChildAdded:Connect(function() if _G.SheriffESP then updateSheriffESP(player) end end)
                    end
                end
            end)
        else
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild(player.Name.."_MM2ESP") then player.Character[player.Name.."_MM2ESP"]:Destroy() end
                if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("MM2RoleLabel") then player.Character.Head.MM2RoleLabel:Destroy() end
            end
        end
    end,
})

MM2Tab:CreateColorPicker({
    Name = "Sheriff Color",
    Color = SheriffColor,
    Flag = "SheriffColor",
    Callback = function(Value)
        SheriffColor = Value
        if _G.SheriffESP then
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if getPlayerRole(player) == "SHERIFF" then
                    if player.Character and player.Character:FindFirstChild(player.Name.."_MM2ESP") then player.Character[player.Name.."_MM2ESP"].FillColor = Value end
                    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("MM2RoleLabel") then player.Character.Head.MM2RoleLabel.TextLabel.TextColor3 = Value end
                end
            end
        end
    end,
})

local AimbotToggle = MM2Tab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        _G.AimbotEnabled = Value
        if Value then
            local function getClosestPlayer()
                local closestPlayer = nil
                local shortestDistance = math.huge
                local localPlayer = game:GetService("Players").LocalPlayer
                local localCharacter = localPlayer.Character
                local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                
                if localRoot then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= localPlayer and player.Character then
                            local character = player.Character
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            
                            if humanoid and humanoid.Health > 0 and rootPart then
                                local distance = (localRoot.Position - rootPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
                return closestPlayer
            end
            
            game:GetService("RunService").Heartbeat:Connect(function()
                if _G.AimbotEnabled then
                    local closestPlayer = getClosestPlayer()
                    if closestPlayer and closestPlayer.Character then
                        local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local localPlayer = game:GetService("Players").LocalPlayer
                        local localCharacter = localPlayer.Character
                        local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                        
                        if targetRoot and localRoot then
                            local camera = workspace.CurrentCamera
                            local smoothness = _G.AimbotSmoothness or 5
                            local targetPosition = targetRoot.Position
                            local currentPosition = camera.CFrame.Position
                            local newCFrame = CFrame.new(
                                currentPosition,
                                targetPosition
                            )
                            camera.CFrame = camera.CFrame:Lerp(newCFrame, 1/smoothness)
                        end
                    end
                end
            end)
        end
    end,
})

local AimbotSmoothness = MM2Tab:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {1, 10},
    Increment = 1,
    Suffix = "level",
    CurrentValue = 5,
    Flag = "AimbotSmooth",
    Callback = function(Value) _G.AimbotSmoothness = Value end,
})

local DeadRailsTab = Window:CreateTab("Dead Rails", 4483362458)
DeadRailsTab:CreateSection("Coming Soon...")
DeadRailsTab:CreateLabel("This section will be available soon!")
DeadRailsTab:CreateLabel("Stay tuned for updates!")

Rayfield:LoadConfiguration()