local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "F4X Hub",
    LoadingTitle = "F4X Hub Loading...",
    LoadingSubtitle = "By Gizmoscat",
    ConfigurationSaving = {
        Enabled = false
    }
})

Rayfield:SetConfiguration({
    ThemeColor = Color3.fromRGB(25, 25, 112),
    DarkTheme = true,
    TitleColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(200, 200, 200),
    ElementColor = Color3.fromRGB(40, 40, 40)
})

local MainTab = Window:CreateTab("Hack Commands")
local MainSection = MainTab:CreateSection("Main Hacks")
MainSection:CreateLabel("Some commands may not work, due to new Roblox protection, or the commands are (Client)")

local flyEnabled = false
MainSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        flyEnabled = Value
        if flyEnabled then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end
    end
})

local noclip = false
MainSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        noclip = Value
        if noclip then
            game:GetService('RunService').Stepped:Connect(function()
                if noclip then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
                end
            end)
        end
    end
})

MainSection:CreateSlider({
    Name = "Speed Hack",
    Range = {16, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MainSection:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJump = Value
        game:GetService("UserInputService").JumpRequest:connect(function()
            if InfiniteJump then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
})

local teleporting = false
MainSection:CreateToggle({
    Name = "Click to Teleport",
    CurrentValue = false,
    Callback = function(Value)
        teleporting = Value
        if teleporting then
            local UIS = game:GetService("UserInputService")
            local Player = game.Players.LocalPlayer
            local Mouse = Player:GetMouse()
            
            local connection
            connection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed and teleporting then
                    Player.Character:MoveTo(Mouse.Hit.p)
                    teleporting = false
                    connection:Disconnect()
                end
            end)
        end
    end
})

MainSection:CreateSlider({
    Name = "Jump Hack",
    Range = {50, 200},
    Increment = 1,
    Suffix = "Jump Power",
    CurrentValue = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

MainSection:CreateButton({
    Name = "Exit Roblox",
    Callback = function()
        game:Shutdown()
    end
})

MainSection:CreateToggle({
    Name = "Swim in Air",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        else
            game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        end
    end
})

local chatLogsWindow
MainSection:CreateButton({
    Name = "Chat Logs",
    Callback = function()
        if chatLogsWindow then chatLogsWindow:Destroy() end
        chatLogsWindow = Rayfield:CreateWindow({
            Name = "Chat Logs",
            LoadingTitle = "Loading Chat History",
            LoadingSubtitle = "Please wait..."
        })
    end
})

local spamText = ""
local spamActive = false
MainSection:CreateInput({
    Name = "Spam Text",
    PlaceholderText = "Enter text to spam",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        spamText = Text
    end
})

MainSection:CreateToggle({
    Name = "Spam",
    CurrentValue = false,
    Callback = function(Value)
        spamActive = Value
        if spamActive then
            spawn(function()
                while spamActive and task.wait(1) do
                    if spamText ~= "" then
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamText, "All")
                    end
                end
            end)
        end
    end
})

MainSection:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
        end
    end
})

MainSection:CreateToggle({
    Name = "Freecam",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Freecam.lua'))()
        end
    end
})

MainSection:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Callback = function(Value)
        game:GetService("Workspace").Camera.FieldOfView = Value
    end
})

MainSection:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
        end
    end
})

MainSection:CreateButton({
    Name = "BTools (Client)",
    Callback = function()
        local tool1 = Instance.new("HopperBin")
        tool1.BinType = Enum.BinType.Hammer
        tool1.Parent = game.Players.LocalPlayer.Backpack
        
        local tool2 = Instance.new("HopperBin")
        tool2.BinType = Enum.BinType.Clone
        tool2.Parent = game.Players.LocalPlayer.Backpack
        
        local tool3 = Instance.new("HopperBin")
        tool3.BinType = Enum.BinType.Grab
        tool3.Parent = game.Players.LocalPlayer.Backpack
    end
})

MainSection:CreateButton({
    Name = "F3X (Client)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

MainSection:CreateToggle({
    Name = "Remove Fog",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game.Lighting.FogEnd = 1000000
        else
            game.Lighting.FogEnd = 1000
        end
    end
})

local playerToKill = ""
local killTool = ""
MainSection:CreateInput({
    Name = "Player to Kill",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        playerToKill = Text
    end
})

MainSection:CreateInput({
    Name = "Tool Name",
    PlaceholderText = "Enter tool name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        killTool = Text
    end
})

MainSection:CreateButton({
    Name = "Kill Player",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(playerToKill) then
                local tool = game.Players.LocalPlayer.Character:FindFirstChild(killTool) or game.Players.LocalPlayer.Backpack:FindFirstChild(killTool)
                if tool then
                    tool.Parent = game.Players.LocalPlayer.Character
                    tool:Activate()
                    task.wait(0.1)
                    tool:Deactivate()
                end
            end
        end
    end
})

local flingActive = false
MainSection:CreateToggle({
    Name = "Fling",
    CurrentValue = false,
    Callback = function(Value)
        flingActive = Value
        if flingActive then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
                if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= game.Players.LocalPlayer.Character then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(math.random(-100,100), math.random(50,100), math.random(-100,100))
                    bodyVelocity.Parent = hit.Parent.HumanoidRootPart
                    game.Debris:AddItem(bodyVelocity, 0.1)
                end
            end)
        end
    end
})

MainSection:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
        else
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
            game.Players.LocalPlayer.Character.Humanoid.Health = 100
        end
    end
})

MainSection:CreateToggle({
    Name = "Naked (Client)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        else
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
            end
        end
    end
})

local spinning = false
MainSection:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Callback = function(Value)
        spinning = Value
        if spinning then
            game:GetService("RunService").Stepped:Connect(function()
                if spinning then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
                end
            end)
        end
    end
})

MainSection:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

MainSection:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

MainSection:CreateButton({
    Name = "Server Age",
    Callback = function()
        local serverTime = os.time() - game:GetService("Workspace").DistributedGameTime
        local hours = math.floor(serverTime / 3600)
        local minutes = math.floor((serverTime % 3600) / 60)
        local seconds = math.floor(serverTime % 60)
        Rayfield:Notify({
            Title = "Server Age",
            Content = string.format("%d hours, %d minutes, %d seconds", hours, minutes, seconds),
            Duration = 6
        })
    end
})

local friendName = ""
MainSection:CreateInput({
    Name = "Friend Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        friendName = Text
    end
})

MainSection:CreateButton({
    Name = "Send Friend Request",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(friendName) then
                game:GetService("Players").LocalPlayer:RequestFriendship(player)
            end
        end
    end
})

local joinDatePlayer = ""
MainSection:CreateInput({
    Name = "Join Date Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        joinDatePlayer = Text
    end
})

MainSection:CreateButton({
    Name = "Get Join Date",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(joinDatePlayer) then
                Rayfield:Notify({
                    Title = "Join Date",
                    Content = player.Name.." joined Roblox on "..player.AccountAge.." days ago",
                    Duration = 6
                })
            end
        end
    end
})

MainSection:CreateButton({
    Name = "Day (Client)",
    Callback = function()
        game.Lighting.ClockTime = 14
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end
})

MainSection:CreateButton({
    Name = "Night (Client)",
    Callback = function()
        game.Lighting.ClockTime = 0
        game.Lighting.Brightness = 0.1
        game.Lighting.GlobalShadows = false
    end
})

local idPlayer = ""
MainSection:CreateInput({
    Name = "Get User ID",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        idPlayer = Text
    end
})

MainSection:CreateButton({
    Name = "Copy User ID",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(idPlayer) then
                setclipboard(tostring(player.UserId))
                Rayfield:Notify({
                    Title = "User ID Copied",
                    Content = player.Name.."'s ID: "..player.UserId,
                    Duration = 5
                })
            end
        end
    end
})

Rayfield:LoadConfiguration()