local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "F4X Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "F4XHub",
    IntroEnabled = false,
    IntroText = "F4X Hub",
    Color = Color3.fromRGB(0, 0, 139) -- Dark blue color
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local noclip = false
local flyActive = false
local espColor = Color3.fromRGB(255, 0, 0)
local flyConnection, noclipConnection

local TabPlayer = Window:MakeTab({Name = "Player (You)", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabShooter = Window:MakeTab({Name = "Shooter Games", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabOther = Window:MakeTab({Name = "Other Hacks", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabBlox = Window:MakeTab({Name = "Blox Fruits", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TabPlayer:AddSlider({
    Name = "SpeedHack",
    Min = 16, 
    Max = 200, 
    Default = 16,
    Color = Color3.fromRGB(0, 0, 139),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value) 
        Humanoid.WalkSpeed = Value 
    end
})

TabPlayer:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        flyActive = Value
        if flyActive then
            if not Character:FindFirstChild("HumanoidRootPart") then return end
            
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            local BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)
            local BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
            BodyGyro.P = 9e4
            BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.CFrame = Character.HumanoidRootPart.CFrame
            BodyVelocity.Velocity = Vector3.new(0,0,0)
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

            flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not flyActive or not Character or not Character:FindFirstChild("HumanoidRootPart") then
                    if BodyGyro then BodyGyro:Destroy() end
                    if BodyVelocity then BodyVelocity:Destroy() end
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                local cam = workspace.CurrentCamera
                if cam then
                    BodyGyro.CFrame = cam.CFrame
                    local moveDir = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - cam.CFrame.RightVector
                    end
                    
                    moveDir = moveDir.Unit * 50
                    BodyVelocity.Velocity = moveDir
                end
            end)
            OrionLib:Notify("Fly Enabled (WASD to move)")
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            OrionLib:Notify("Fly Disabled")
        end
    end
})

TabPlayer:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(Value)
        noclip = Value
        if noclip then
            -- Clean up previous connections
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if not noclip or not Character then
                    if noclipConnection then
                        noclipConnection:Disconnect()
                    end
                    return
                end
                
                for _,v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then 
                        v.CanCollide = false 
                    end
                end
            end)
            OrionLib:Notify("NoClip Enabled")
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            OrionLib:Notify("NoClip Disabled")
        end
    end
})

TabPlayer:AddButton({
    Name = "Reset Character",
    Callback = function()
        Humanoid.Health = 0
        wait(2)
        Character = Player.Character or Player.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
        OrionLib:Notify("Character Reset")
    end
})

TabPlayer:AddButton({
    Name = "AddHDAdmin (Client-Side)",
    Callback = function()
        local success, err = pcall(function()
            local hd = game:GetObjects("rbxassetid://2824391032")[1]
            hd.Parent = game.CoreGui
        end)
        
        if success then
            OrionLib:Notify("HD Admin Loaded (Client Only)")
        else
            OrionLib:Notify("Failed to load HD Admin: "..tostring(err))
        end
    end
})

TabPlayer:AddButton({
    Name = "AntiBan",
    Callback = function()
        local success, err = pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" then 
                    return warn("Kick Attempt Blocked") 
                end
                return old(self, unpack(args))
            end)
            setreadonly(mt, true)
        end)
        
        if success then
            OrionLib:Notify("AntiBan Enabled")
        else
            OrionLib:Notify("AntiBan Failed: "..tostring(err))
        end
    end
})

TabPlayer:AddButton({
    Name = "AntiLag",
    Callback = function()
        local count = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then 
                v:Destroy()
                count = count + 1
            end
        end
        OrionLib:Notify(string.format("AntiLag Removed %d Items!", count))
    end
})

-- Shooter Games Features
TabShooter:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) 
        espColor = Value 
    end
})

TabShooter:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = plr.Character.HumanoidRootPart
                    box.Size = plr.Character.HumanoidRootPart.Size + Vector3.new(0.1,0.1,0.1)
                    box.Color3 = espColor
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Transparency = 0.4
                    box.Parent = plr.Character.HumanoidRootPart
                    
                    if not plr.Character.HumanoidRootPart:FindFirstChild("F4X_ESP") then
                        local folder = Instance.new("Folder")
                        folder.Name = "F4X_ESP"
                        folder.Parent = plr.Character.HumanoidRootPart
                    end
                    box.Parent = plr.Character.HumanoidRootPart.F4X_ESP
                end
            end
            
            game.Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char)
                    if char:FindFirstChild("HumanoidRootPart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = char.HumanoidRootPart
                        box.Size = char.HumanoidRootPart.Size + Vector3.new(0.1,0.1,0.1)
                        box.Color3 = espColor
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Transparency = 0.4
                        
                        if not char.HumanoidRootPart:FindFirstChild("F4X_ESP") then
                            local folder = Instance.new("Folder")
                            folder.Name = "F4X_ESP"
                            folder.Parent = char.HumanoidRootPart
                        end
                        box.Parent = char.HumanoidRootPart.F4X_ESP
                    end
                end)
            end)
            
            OrionLib:Notify("ESP Enabled!")
        else
            -- Disable ESP
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local espFolder = plr.Character.HumanoidRootPart:FindFirstChild("F4X_ESP")
                    if espFolder then
                        espFolder:Destroy()
                    end
                end
            end
            OrionLib:Notify("ESP Disabled")
        end
    end
})

TabShooter:AddButton({
    Name = "AimBot (Placeholder)",
    Callback = function()
        OrionLib:Notify("AimBot Feature Coming Soon!")
    end
})

TabShooter:AddSlider({
    Name = "HitBox Size",
    Min = 2, 
    Max = 10, 
    Default = 5,
    Color = Color3.fromRGB(0, 0, 139),
    Increment = 1,
    ValueName = "Size",
    Callback = function(Value)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.Size = Vector3.new(Value, Value, Value)
                plr.Character.HumanoidRootPart.Transparency = 0.4
                plr.Character.HumanoidRootPart.Material = Enum.Material.ForceField
            end
        end
        OrionLib:Notify("HitBox Size set to "..Value)
    end
})

TabOther:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        OrionLib:Notify("Infinite Yield Loaded!")
    end
})

TabOther:AddButton({
    Name = "Dex Explorer",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
        OrionLib:Notify("Dex Explorer Loaded!")
    end
})

TabOther:AddButton({
    Name = "QuirkyCMD",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Quirky-CMD/main/Source"))()
        OrionLib:Notify("QuirkyCMD Loaded!")
    end
})

TabBlox:AddToggle({
    Name = "AutoFarm (Placeholder)",
    Default = false,
    Callback = function(Value)
        if Value then
            OrionLib:Notify("AutoFarm Enabled (Placeholder)")
        else
            OrionLib:Notify("AutoFarm Disabled")
        end
    end
})

OrionLib:Init()