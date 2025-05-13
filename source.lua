--[[
Hello, here is the exploit script. We worked hard on it, and added many commands while trying to fix the Callback function issues which are complex. Please appreciate our efforts to give you the best experience. 

This update is under development and will be V2.0.0. There are bugs in this script, we are trying to fix them. We have fixed some commands but some of them have many problems. It took us days to fix the callback function problems in some commands. 
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "F4X Hub",
    LoadingTitle = "F4X Hub is loading...",
    LoadingSubtitle = "by Gizmoscat",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "F4X Hub Configs",
        FileName = "F4X Hub Configuration"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Hack Commands")
local CreditsTab = Window:CreateTab("Credits")

-- ========== Movement Section ==========
local MovementSection = MainTab:CreateSection("Movement")

-- Fly System
local FlyEnabled = false
local BodyVelocity
local BodyGyro
local FlySpeed = 50
local FlyConnection
local TouchControls = {}

local function StartFlying()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return end

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 10000
    BodyGyro.D = 500
    BodyGyro.CFrame = humanoidRootPart.CFrame
    BodyGyro.Parent = humanoidRootPart

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.P = 10000
    BodyVelocity.Parent = humanoidRootPart

    humanoid.PlatformStand = true

    if not game:GetService("UserInputService").TouchEnabled then
        FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not FlyEnabled or not character or not humanoidRootPart then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * FlySpeed
                BodyVelocity.Velocity = moveDirection
            else
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end

            BodyGyro.CFrame = camera.CFrame
        end)
    else
        local touchGui = Instance.new("ScreenGui")
        touchGui.Name = "FlyMobileControls"
        touchGui.Parent = game.Players.LocalPlayer.PlayerGui

        local upButton = Instance.new("TextButton")
        upButton.Name = "UpButton"
        upButton.Size = UDim2.new(0.15, 0, 0.15, 0)
        upButton.Position = UDim2.new(0.8, 0, 0.7, 0)
        upButton.Text = "Up"
        upButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        upButton.TextColor3 = Color3.new(1, 1, 1)
        upButton.Parent = touchGui
        TouchControls.UpButton = upButton

        local downButton = Instance.new("TextButton")
        downButton.Name = "DownButton"
        downButton.Size = UDim2.new(0.15, 0, 0.15, 0)
        downButton.Position = UDim2.new(0.8, 0, 0.85, 0)
        downButton.Text = "Down"
        downButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        downButton.TextColor3 = Color3.new(1, 1, 1)
        downButton.Parent = touchGui
        TouchControls.DownButton = downButton

        FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not FlyEnabled or not character or not humanoidRootPart then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if TouchControls.UpButton and TouchControls.UpButton:IsActive() then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if TouchControls.DownButton and TouchControls.DownButton:IsActive() then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end

            moveDirection = moveDirection + camera.CFrame.LookVector

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * FlySpeed
                BodyVelocity.Velocity = moveDirection
            else
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end

            BodyGyro.CFrame = camera.CFrame
        end)
    end
end

local function StopFlying()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if TouchControls.UpButton then TouchControls.UpButton:Destroy() end
    if TouchControls.DownButton then TouchControls.DownButton:Destroy() end
    TouchControls = {}
end

MovementSection:CreateToggle({
    Name = "Fly (1)",
    CurrentValue = false,
    Callback = function(Value)
        FlyEnabled = Value
        if FlyEnabled then
            StartFlying()
            Rayfield:Notify({
                Title = "Fly Enabled (1)",
                Content = "Use WASD to move, Space to go up, Shift to go down",
                Duration = 5,
                Actions = {Ignore = {Name = "OK"}}
            })
        else
            StopFlying()
        end
    end
})

MovementSection:CreateButton({
    Name = "Unfly (2)",
    Callback = function()
        if FlyEnabled then
            FlyEnabled = false
            StopFlying()
            Rayfield:Notify({
                Title = "Fly Disabled (2)",
                Content = "Fly has been turned off",
                Duration = 3,
                Actions = {Ignore = {Name = "OK"}}
            })
        end
    end
})

-- NoClip
local NoclipEnabled = false
local NoclipConnection

MovementSection:CreateToggle({
    Name = "Noclip (3)",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
        if NoclipConnection then NoclipConnection:Disconnect() end
        
        if NoclipEnabled then
            NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end)
            end)
        end
    end
})

MovementSection:CreateButton({
    Name = "Clip (4)",
    Callback = function()
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        pcall(function()
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end)
    end
})

-- Speed
MovementSection:CreateSlider({
    Name = "Walkspeed (11)",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end
})

-- Jump Power
MovementSection:CreateSlider({
    Name = "Jump Power (12)",
    Range = {50, 200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end)
    end
})

-- Infinite Jump
local InfiniteJumpEnabled = false
local InfiniteJumpConnection

MovementSection:CreateToggle({
    Name = "Infinite Jump (44)",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        
        if InfiniteJumpEnabled then
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                pcall(function()
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end)
            end)
        end
    end
})

MovementSection:CreateButton({
    Name = "No Infinite Jump (45)",
    Callback = function()
        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
            InfiniteJumpConnection = nil
        end
    end
})

-- Fly Speed
MovementSection:CreateSlider({
    Name = "Fly Speed (43)",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- Gravity
MovementSection:CreateSlider({
    Name = "Gravity (32)",
    Range = {0, 196.2},
    Increment = 1,
    CurrentValue = 196.2,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

-- No Fall Damage
MovementSection:CreateToggle({
    Name = "No Fall Damage (61)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            if Value then
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            else
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end)
    end
})

-- BHop
MovementSection:CreateToggle({
    Name = "Bunny Hop (96)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                pcall(function()
                    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    humanoid:ChangeState("Jumping")
                    wait(0.1)
                    humanoid:ChangeState("Running")
                end)
            end)
        end
    end
})

-- Double Jump
MovementSection:CreateToggle({
    Name = "Double Jump (97)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local char = game.Players.LocalPlayer.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            
            local canDoubleJump = true
            local connection
            
            connection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if not hum:GetState() == Enum.HumanoidStateType.Jumping and canDoubleJump then
                    canDoubleJump = false
                    hum:ChangeState("Jumping")
                    task.wait(0.1)
                    canDoubleJump = true
                end
            end)
        end
    end
})

-- ========== Player Mods Section ==========
local PlayerModsSection = MainTab:CreateSection("Player Modifications")

-- God Mode
PlayerModsSection:CreateToggle({
    Name = "God Mode (5)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            if Value then
                game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
            else
                game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
                game.Players.LocalPlayer.Character.Humanoid.Health = 100
            end
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "Ungod (6)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
            game.Players.LocalPlayer.Character.Humanoid.Health = 100
        end)
    end
})

-- Invisible
PlayerModsSection:CreateToggle({
    Name = "Invisible (7)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            if Value then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                end
            else
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    end
                end
            end
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "Visible (8)",
    Callback = function()
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end)
    end
})

-- Sit/Unsit
PlayerModsSection:CreateButton({
    Name = "Sit (19)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.Sit = true
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "Unsit (20)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end)
    end
})

-- Float
PlayerModsSection:CreateToggle({
    Name = "Float (21)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            if Value then
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            else
                game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            end
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "No Float (22)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        end)
    end
})

-- Size
PlayerModsSection:CreateSlider({
    Name = "Size (27)",
    Range = {0.1, 10},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Size = v.Size * Value
                end
            end
        end)
    end
})

-- Ninja
PlayerModsSection:CreateButton({
    Name = "Ninja (33)",
    Callback = function()
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            char.Humanoid:UnequipTools()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = char
                end
            end
        end)
    end
})

-- Swim
PlayerModsSection:CreateButton({
    Name = "Swim (34)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end)
    end
})

-- Headless
PlayerModsSection:CreateButton({
    Name = "Headless (53)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Head.Transparency = 1
            game.Players.LocalPlayer.Character.Head.face:Destroy()
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "Unheadless (54)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Head.Transparency = 0
            if not game.Players.LocalPlayer.Character.Head:FindFirstChild("face") then
                local face = Instance.new("Decal")
                face.Name = "face"
                face.Texture = "rbxasset://textures/face.png"
                face.Parent = game.Players.LocalPlayer.Character.Head
            end
        end)
    end
})

-- Faceless
PlayerModsSection:CreateButton({
    Name = "Faceless (55)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Head.face:Destroy()
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "Unfaceless (56)",
    Callback = function()
        pcall(function()
            if not game.Players.LocalPlayer.Character.Head:FindFirstChild("face") then
                local face = Instance.new("Decal")
                face.Name = "face"
                face.Texture = "rbxasset://textures/face.png"
                face.Parent = game.Players.LocalPlayer.Character.Head
            end
        end)
    end
})

-- Rainbow Character
local RainbowCharEnabled = false
local RainbowCharConnection

PlayerModsSection:CreateToggle({
    Name = "Rainbow Character (51)",
    CurrentValue = false,
    Callback = function(Value)
        RainbowCharEnabled = Value
        if RainbowCharConnection then RainbowCharConnection:Disconnect() end
        
        if RainbowCharEnabled then
            RainbowCharConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    local hue = tick() % 10 / 10
                    local color = Color3.fromHSV(hue, 1, 1)
                    
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = color
                        end
                    end
                end)
            end)
        end
    end
})

PlayerModsSection:CreateButton({
    Name = "No Rainbow (52)",
    Callback = function()
        if RainbowCharConnection then
            RainbowCharConnection:Disconnect()
            RainbowCharConnection = nil
        end
    end
})

-- Spin Character
local SpinCharEnabled = false
local SpinCharConnection

PlayerModsSection:CreateToggle({
    Name = "Spin Character (99)",
    CurrentValue = false,
    Callback = function(Value)
        SpinCharEnabled = Value
        if SpinCharConnection then SpinCharConnection:Disconnect() end
        
        if SpinCharEnabled then
            SpinCharConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
                end)
            end)
        end
    end
})

-- R6/R15
PlayerModsSection:CreateButton({
    Name = "R6 (66)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.RigType = Enum.HumanoidRigType.R6
        end)
    end
})

PlayerModsSection:CreateButton({
    Name = "R15 (67)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.RigType = Enum.HumanoidRigType.R15
        end)
    end
})

-- ========== Visuals Section ==========
local VisualsSection = MainTab:CreateSection("Visuals")

-- ESP
local EspEnabled = false
local EspHighlights = {}

VisualsSection:CreateToggle({
    Name = "ESP (9)",
    CurrentValue = false,
    Callback = function(Value)
        EspEnabled = Value
        if EspEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    EspHighlights[player] = highlight
                end
            end
        else
            for player, highlight in pairs(EspHighlights) do
                if highlight then highlight:Destroy() end
            end
            EspHighlights = {}
        end
    end
})

VisualsSection:CreateButton({
    Name = "No ESP (10)",
    Callback = function()
        for player, highlight in pairs(EspHighlights) do
            if highlight then highlight:Destroy() end
        end
        EspHighlights = {}
    end
})

-- FOV
VisualsSection:CreateSlider({
    Name = "FOV (23)",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Callback = function(Value)
        pcall(function()
            game:GetService("Workspace").CurrentCamera.FieldOfView = Value
        end)
    end
})

VisualsSection:CreateButton({
    Name = "Reset FOV (24)",
    Callback = function()
        pcall(function()
            game:GetService("Workspace").CurrentCamera.FieldOfView = 70
        end)
    end
})

-- XRay
VisualsSection:CreateToggle({
    Name = "XRay (46)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) then
                    part.LocalTransparencyModifier = 0.5
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end
})

VisualsSection:CreateButton({
    Name = "UnXRay (47)",
    Callback = function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
})

-- Night Vision
VisualsSection:CreateToggle({
    Name = "Night Vision (48)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
            game:GetService("Lighting").Brightness = 0
            game:GetService("Lighting").ClockTime = 14
        else
            game:GetService("Lighting").Ambient = Color3.new(0.5, 0.5, 0.5)
            game:GetService("Lighting").Brightness = 1
        end
    end
})

-- Day/Night
VisualsSection:CreateButton({
    Name = "Day (49)",
    Callback = function()
        pcall(function()
            game:GetService("Lighting").TimeOfDay = "14:00:00"
        end)
    end
})

VisualsSection:CreateButton({
    Name = "Night (50)",
    Callback = function()
        pcall(function()
            game:GetService("Lighting").TimeOfDay = "00:00:00"
        end)
    end
})

-- Box ESP
VisualsSection:CreateToggle({
    Name = "Box ESP (57)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "BoxESP"
                    box.Adornee = player.Character.HumanoidRootPart
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = Vector3.new(2, 3, 1)
                    box.Transparency = 0.5
                    box.Color3 = Color3.new(1, 0, 0)
                    box.Parent = player.Character.HumanoidRootPart
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character.HumanoidRootPart:FindFirstChild("BoxESP") then
                    player.Character.HumanoidRootPart.BoxESP:Destroy()
                end
            end
        end
    end
})

-- Chams
VisualsSection:CreateToggle({
    Name = "Chams (58)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.ForceField
                            part.Transparency = 0.5
                        end
                    end
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.Plastic
                            part.Transparency = 0
                        end
                    end
                end
            end
        end
    end
})

-- Tracers
VisualsSection:CreateToggle({
    Name = "Tracers (59)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local tracer = Instance.new("LineHandleAdornment")
                    tracer.Name = "Tracer"
                    tracer.Adornee = player.Character.HumanoidRootPart
                    tracer.AlwaysOnTop = true
                    tracer.ZIndex = 10
                    tracer.Length = 100
                    tracer.Thickness = 1
                    tracer.Color3 = Color3.new(1, 0, 0)
                    tracer.Parent = player.Character.HumanoidRootPart
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character.HumanoidRootPart:FindFirstChild("Tracer") then
                    player.Character.HumanoidRootPart.Tracer:Destroy()
                end
            end
        end
    end
})

-- No Fog
VisualsSection:CreateToggle({
    Name = "No Fog (60)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end
})

VisualsSection:CreateToggle({
    Name = "No Fog (89)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end
})

VisualsSection:CreateToggle({
    Name = "No Fog (100)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end
})

-- Zoom
VisualsSection:CreateButton({
    Name = "Zoom (90)",
    Callback = function()
        game:GetService("Workspace").CurrentCamera.FieldOfView = 20
    end
})

VisualsSection:CreateButton({
    Name = "Super Zoom (91)",
    Callback = function()
        game:GetService("Workspace").CurrentCamera.FieldOfView = 10
    end
})

-- ========== Teleport Section ==========
local TeleportSection = MainTab:CreateSection("Teleport")

-- Click Teleport
local ClickTeleportEnabled = false
local ClickTeleportConnection

TeleportSection:CreateToggle({
    Name = "Click Teleport (62)",
    CurrentValue = false,
    Callback = function(Value)
        ClickTeleportEnabled = Value
        if ClickTeleportConnection then ClickTeleportConnection:Disconnect() end
        
        if ClickTeleportEnabled then
            ClickTeleportConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local player = game.Players.LocalPlayer
                    local mouse = player:GetMouse()
                    local targetPos = mouse.Hit.Position
                    
                    pcall(function()
                        player.Character:MoveTo(targetPos)
                    end)
                end
            end)
        end
    end
})

-- Teleport to Player
local TeleportPlayerName = ""

TeleportSection:CreateInput({
    Name = "Player Name (13)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TeleportPlayerName = Text
    end
})

TeleportSection:CreateButton({
    Name = "Teleport (13)",
    Callback = function()
        pcall(function()
            local target = game.Players[TeleportPlayerName]
            if target then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end)
    end
})

-- Bring Player
TeleportSection:CreateInput({
    Name = "Bring Player (14)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TeleportPlayerName = Text
    end
})

TeleportSection:CreateButton({
    Name = "Bring (14)",
    Callback = function()
        pcall(function()
            local target = game.Players[TeleportPlayerName]
            if target then
                target.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end)
    end
})

-- Goto Player
TeleportSection:CreateInput({
    Name = "Goto Player (15)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TeleportPlayerName = Text
    end
})

TeleportSection:CreateButton({
    Name = "Goto (15)",
    Callback = function()
        pcall(function()
            local target = game.Players[TeleportPlayerName]
            if target then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end)
    end
})

-- View Player
local ViewPlayerName = ""
local OriginalCameraSubject

TeleportSection:CreateInput({
    Name = "View Player (41)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ViewPlayerName = Text
    end
})

TeleportSection:CreateButton({
    Name = "View (41)",
    Callback = function()
        pcall(function()
            local target = game.Players[ViewPlayerName]
            if target then
                OriginalCameraSubject = game.Workspace.CurrentCamera.CameraSubject
                game.Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            end
        end)
    end
})

TeleportSection:CreateButton({
    Name = "Unview (42)",
    Callback = function()
        pcall(function()
            if OriginalCameraSubject then
                game.Workspace.CurrentCamera.CameraSubject = OriginalCameraSubject
            end
        end)
    end
})

-- Bring All
TeleportSection:CreateButton({
    Name = "Bring All (80)",
    Callback = function()
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    player.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end
})

-- Loop Bring
local LoopBringEnabled = false
local LoopBringConnection

TeleportSection:CreateToggle({
    Name = "Loop Bring (81)",
    CurrentValue = false,
    Callback = function(Value)
        LoopBringEnabled = Value
        if LoopBringConnection then LoopBringConnection:Disconnect() end
        
        if LoopBringEnabled then
            LoopBringConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer then
                            player.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                end)
            end)
        end
    end
})

-- ========== Combat Section ==========
local CombatSection = MainTab:CreateSection("Combat")

-- Kill Player
local KillPlayerName = ""

CombatSection:CreateInput({
    Name = "Kill Player (16)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        KillPlayerName = Text
    end
})

CombatSection:CreateButton({
    Name = "Kill (16)",
    Callback = function()
        pcall(function()
            local target = game.Players[KillPlayerName]
            if target then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                wait(0.1)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                wait(0.1)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            end
        end)
    end
})

-- Loop Kill
local LoopKillEnabled = false
local LoopKillConnection

CombatSection:CreateToggle({
    Name = "Loop Kill (17)",
    CurrentValue = false,
    Callback = function(Value)
        LoopKillEnabled = Value
        if LoopKillConnection then LoopKillConnection:Disconnect() end
        
        if LoopKillEnabled then
            LoopKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    local target = game.Players[KillPlayerName]
                    if target then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                        wait(0.1)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        wait(0.1)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    end
                end)
            end)
        end
    end
})

CombatSection:CreateButton({
    Name = "Unloop Kill (18)",
    Callback = function()
        if LoopKillConnection then
            LoopKillConnection:Disconnect()
            LoopKillConnection = nil
        end
    end
})

-- Loop Heal
local LoopHealEnabled = false
local LoopHealConnection

CombatSection:CreateToggle({
    Name = "Loop Heal (38)",
    CurrentValue = false,
    Callback = function(Value)
        LoopHealEnabled = Value
        if LoopHealConnection then LoopHealConnection:Disconnect() end
        
        if LoopHealEnabled then
            LoopHealConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.MaxHealth
                end)
            end)
        end
    end
})

CombatSection:CreateButton({
    Name = "Unloop Heal (39)",
    Callback = function()
        if LoopHealConnection then
            LoopHealConnection:Disconnect()
            LoopHealConnection = nil
        end
    end
})

-- Speed Glitch
CombatSection:CreateButton({
    Name = "Speed Glitch (40)",
    Callback = function()
        pcall(function()
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            humanoid:ChangeState("Running")
            wait(0.1)
            humanoid:ChangeState("Jumping")
            wait(0.1)
            humanoid:ChangeState("Running")
        end)
    end
})

-- Aimbot
CombatSection:CreateToggle({
    Name = "Aimbot (70)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local target = game.Players[KillPlayerName]
            if target then
                game:GetService("RunService").RenderStepped:Connect(function()
                    pcall(function()
                        game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                    end)
                end)
            end
        end
    end
})

-- Silent Aim
CombatSection:CreateToggle({
    Name = "Silent Aim (71)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local target = game.Players[KillPlayerName]
            if target then
                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    local args = {...}
                    if getnamecallmethod() == "FindPartOnRayWithIgnoreList" and self == workspace then
                        args[1] = Ray.new(target.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
                        return oldNamecall(self, unpack(args))
                    end
                    return oldNamecall(self, ...)
                end)
            end
        end
    end
})

-- Triggerbot
CombatSection:CreateToggle({
    Name = "Triggerbot (72)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    local target = game.Players[KillPlayerName]
                    if target then
                        if (target.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                            mouse1click()
                        end
                    end
                end)
            end)
        end
    end
})

-- Fast Attack
CombatSection:CreateToggle({
    Name = "Fast Attack (73)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    mouse1click()
                end)
            end)
        end
    end
})

-- Rapid Fire
CombatSection:CreateToggle({
    Name = "Rapid Fire (74)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    mouse1click()
                    wait(0.1)
                    mouse1click()
                end)
            end)
        end
    end
})

-- Spinbot
CombatSection:CreateToggle({
    Name = "Spinbot (75)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
                end)
            end)
        end
    end
})

-- Reach
CombatSection:CreateSlider({
    Name = "Reach (78)",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.ReachDistance = Value
        end)
    end
})

-- Sword Aura
CombatSection:CreateToggle({
    Name = "Sword Aura (79)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                            mouse1click()
                        end
                    end
                end)
            end)
        end
    end
})

-- Hitbox Expander
CombatSection:CreateSlider({
    Name = "Hitbox Expander (87)",
    Range = {1, 10},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Size = part.Size * Value
                        end
                    end
                end
            end
        end)
    end
})

-- Small Hitbox
CombatSection:CreateSlider({
    Name = "Small Hitbox (88)",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Size = part.Size * Value
                        end
                    end
                end
            end
        end)
    end
})

-- Ragebot
CombatSection:CreateToggle({
    Name = "Ragebot (86)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            mouse1click()
                        end
                    end
                end)
            end)
        end
    end
})

-- Anti Aim
CombatSection:CreateToggle({
    Name = "Anti Aim (92)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
                end)
            end)
        end
    end
})

-- No Sway
CombatSection:CreateToggle({
    Name = "No Sway (93)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
                end)
            end)
        else
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
})

-- No Recoil
CombatSection:CreateToggle({
    Name = "No Recoil (94)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
                end)
            end)
        end
    end
})

-- No Slow
CombatSection:CreateToggle({
    Name = "No Slow (95)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end)
            end)
        end
    end
})

-- ========== Utility Section ==========
local UtilitySection = MainTab:CreateSection("Utility")

-- Rejoin
UtilitySection:CreateButton({
    Name = "Rejoin (28)",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- Server Hop
UtilitySection:CreateButton({
    Name = "Server Hop (29)",
    Callback = function()
        local servers = {}
        for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        end
    end
})

-- Refresh
UtilitySection:CreateButton({
    Name = "Refresh (30)",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- Respawn
UtilitySection:CreateButton({
    Name = "Respawn (31)",
    Callback = function()
        game.Players.LocalPlayer:LoadCharacter()
    end
})

-- Anti AFK
local AntiAfkEnabled = false
local AntiAfkConnection

UtilitySection:CreateToggle({
    Name = "Anti AFK (37)",
    CurrentValue = false,
    Callback = function(Value)
        AntiAfkEnabled = Value
        if AntiAfkConnection then AntiAfkConnection:Disconnect() end
        
        if AntiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            AntiAfkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- No Cooldowns
UtilitySection:CreateToggle({
    Name = "No Cooldowns (35)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                if v:IsA("Frame") and v.Name == "Cooldown" then
                    v:Destroy()
                end
            end
        end
    end
})

-- Auto Click
local AutoClickEnabled = false
local AutoClickConnection

UtilitySection:CreateToggle({
    Name = "Auto Click (36)",
    CurrentValue = false,
    Callback = function(Value)
        AutoClickEnabled = Value
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        
        if AutoClickEnabled then
            AutoClickConnection = game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    mouse1click()
                end)
            end)
        end
    end
})

-- Anti Kick
UtilitySection:CreateToggle({
    Name = "Anti Kick (76)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                if getnamecallmethod() == "Kick" then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Anti Log
UtilitySection:CreateToggle({
    Name = "Anti Log (77)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                if getnamecallmethod() == "Log" then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
        end
    end
})

-- Blink
UtilitySection:CreateButton({
    Name = "Blink (98)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
        end)
    end
})

-- Tool Steal
UtilitySection:CreateButton({
    Name = "Tool Steal (68)",
    Callback = function()
        pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = game.Players.LocalPlayer.Backpack
                        end
                    end
                end
            end
        end)
    end
})

-- Item ESP
UtilitySection:CreateToggle({
    Name = "Item ESP (69)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("BasePart") and item.Name == "Item" then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = item
                end
            end
        else
            for _, item in pairs(workspace:GetDescendants()) do
                if item:FindFirstChild("Highlight") then
                    item.Highlight:Destroy()
                end
            end
        end
    end
})

-- Freeze
local FreezePlayerName = ""

UtilitySection:CreateInput({
    Name = "Freeze Player (82)",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        FreezePlayerName = Text
    end
})

UtilitySection:CreateButton({
    Name = "Freeze (82)",
    Callback = function()
        pcall(function()
            local target = game.Players[FreezePlayerName]
            if target then
                for _, part in pairs(target.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            end
        end)
    end
})

UtilitySection:CreateButton({
    Name = "Unfreeze (83)",
    Callback = function()
        pcall(function()
            local target = game.Players[FreezePlayerName]
            if target then
                for _, part in pairs(target.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end)
    end
})

-- Anchor
UtilitySection:CreateButton({
    Name = "Anchor (84)",
    Callback = function()
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end)
    end
})

UtilitySection:CreateButton({
    Name = "Unanchor (85)",
    Callback = function()
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end)
    end
})

-- ========== Chat Section ==========
local ChatSection = MainTab:CreateSection("Chat")

-- Spam Chat
local SpamText = ""
local SpamDelay = 1
local SpamEnabled = false
local SpamTask

ChatSection:CreateInput({
    Name = "Spam Text (63)",
    PlaceholderText = "Enter text to spam",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        SpamText = Text
    end
})

ChatSection:CreateSlider({
    Name = "Spam Delay (seconds)",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(Value)
        SpamDelay = Value
    end
})

ChatSection:CreateToggle({
    Name = "Enable Spam (63)",
    CurrentValue = false,
    Callback = function(Value)
        SpamEnabled = Value
        if SpamEnabled then
            SpamTask = task.spawn(function()
                while SpamEnabled and SpamText ~= "" do
                    pcall(function()
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(SpamText, "All")
                    end)
                    task.wait(SpamDelay)
                end
            end)
        else
            if SpamTask then
                task.cancel(SpamTask)
                SpamTask = nil
            end
        end
    end
})

-- Crash
ChatSection:CreateButton({
    Name = "Crash (64)",
    Callback = function()
        while true do
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.rep("A", 1000), "All")
            end)
        end
    end
})

-- Lag Server
ChatSection:CreateButton({
    Name = "Lag Server (65)",
    Callback = function()
        while true do
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.rep("A", 100), "All")
                wait(0.1)
            end)
        end
    end
})

-- ========== Credits Tab ==========
local CreditsSection = CreditsTab:CreateSection("Credits")
CreditsSection:CreateLabel("F4X Hub (Exploit)")
CreditsSection:CreateLabel("Created By: Gizmoscat")
CreditsSection:CreateLabel("Visit our github to see the upcoming updates")

Rayfield:LoadConfiguration()