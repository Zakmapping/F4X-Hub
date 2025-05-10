local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "F4X Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "F4XHub"
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local noclip = false
local flyActive = false
local espColor = Color3.fromRGB(255, 0, 0)

local TabPlayer = Window:MakeTab({Name = "Player (You)", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabShooter = Window:MakeTab({Name = "Shooter Games", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabOther = Window:MakeTab({Name = "Other Hacks", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local TabBlox = Window:MakeTab({Name = "Blox Fruits", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TabPlayer:AddSlider({
    Name = "SpeedHack",
    Min = 16, Max = 200, Default = 16,
    Callback = function(Value) Humanoid.WalkSpeed = Value end
})

TabPlayer:AddButton({
    Name = "Fly",
    Callback = function()
        if flyActive then return end
        flyActive = true
        local BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)
        local BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
        BodyGyro.P = 9e4
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.CFrame = Character.HumanoidRootPart.CFrame
        BodyVelocity.Velocity = Vector3.new(0,0,0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not flyActive then
                BodyGyro:Destroy()
                BodyVelocity:Destroy()
                connection:Disconnect()
                return
            end
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
        end)
    end
})

TabPlayer:AddButton({
    Name = "Disable Fly",
    Callback = function() flyActive = false end
})

TabPlayer:AddButton({
    Name = "NoClip",
    Callback = function()
        noclip = not noclip
        local connection
        connection = game:GetService("RunService").Stepped:Connect(function()
            if not noclip then connection:Disconnect() return end
            for _,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
        OrionLib:Notify("NoClip "..(noclip and "Enabled" or "Disabled"))
    end
})

TabPlayer:AddButton({
    Name = "AddHDAdmin (Client-Side)",
    Callback = function()
        local hd = game:GetObjects("rbxassetid://2824391032")[1]
        hd.Parent = game.CoreGui
        OrionLib:Notify("HD Admin Loaded (Client Only)")
    end
})

TabPlayer:AddButton({
    Name = "AntiBan",
    Callback = function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "Kick" then return warn("Kick Attempt Blocked") end
            return old(self, unpack(args))
        end)
        setreadonly(mt, true)
        OrionLib:Notify("AntiBan Enabled")
    end
})

TabPlayer:AddButton({
    Name = "AntiLag",
    Callback = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then v:Destroy() end
        end
        OrionLib:Notify("AntiLag Applied!")
    end
})

TabShooter:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) espColor = Value end
})

TabShooter:AddButton({
    Name = "Enable ESP",
    Callback = function()
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
            end
        end
        OrionLib:Notify("ESP Enabled!")
    end
})

TabShooter:AddButton({
    Name = "Enable AimBot",
    Callback = function()
        OrionLib:Notify("AimBot Activated (placeholder)")
    end
})

TabShooter:AddSlider({
    Name = "HitBox Size Changer",
    Min = 2, Max = 10, Default = 5,
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

-- Blox Fruits Features
TabBlox:AddButton({
    Name = "AutoFarm",
    Callback = function()
        OrionLib:Notify("AutoFarm Feature Coming Soon!")
    end
})

OrionLib:Init()