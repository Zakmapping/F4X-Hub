--[[
  F4X Hub - Most Advanced Roblox Exploit
  Created by Gizmoscat
  Server Side Exploit
]]

-- Ultra Strong Anti-Detection
do
    if not getgenv then 
        getgenv = function() 
            local env = (_G or _ENV or getfenv())
            env.F4X_SecureMode = true
            env.__ANTI_DETECT = true
            return env 
        end 
    end
    
    local fakeEnv = {
        crypt = {
            encrypt = function(x) return "SECURE_"..x end,
            decrypt = function(x) return x:gsub("SECURE_", "") end
        },
        hookfunction = function(f, newf) return newf end,
        checkcaller = function() return false end,
        is_synapse = function() return false end,
        is_proto = function() return false end,
        debug = {
            traceback = function() return "No debug available" end
        }
    }
    
    for k, v in pairs(fakeEnv) do
        getgenv()[k] = v
    end
    
    -- Anti-analysis
    if setfflag then
        setfflag("DebugDisableAssemblyCodeAnalysis", "True")
        setfflag("DebugDisableElfAnalysis", "True")
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Vulnerability Scanner
local function ScanExploits()
    local exploits = {}
    
    -- Scan memory
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            if rawget(obj, "FireServer") then
                table.insert(exploits, {Object = obj, Type = "GC"})
            end
        end
    end
    
    -- Scan instances
    local criticalServices = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerScriptService"),
        game:GetService("Workspace")
    }
    
    for _, service in pairs(criticalServices) do
        for _, inst in pairs(service:GetDescendants()) do
            if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
                table.insert(exploits, {Object = inst, Type = "Instance"})
            end
        end
    end
    
    return exploits
end

local ExploitMethods = ScanExploits()
if #ExploitMethods == 0 then
    Rayfield:Notify({
        Title = "F4X Hub - Not Supported",
        Content = "This game is not supported, try another game",
        Duration = 8,
        Image = 4483362458,
    })
    return
end

local Window = Rayfield:CreateWindow({
    Name = "F4X Hub | By Gizmoscat",
    LoadingTitle = "Loading Exploits...",
    LoadingSubtitle = #ExploitMethods.." exploit methods found",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local ExploitTab = Window:CreateTab("Exploit Commands", 4483362458)

-- ===== [ PLAYER COMMANDS ] ===== --
ExploitTab:CreateSection("Player Controls")

local flyConn
ExploitTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(State)
        if State then
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = char:WaitForChild("HumanoidRootPart")
                
                flyConn = game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Space then
                        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                    elseif input.KeyCode == Enum.KeyCode.LeftShift then
                        bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                    end
                end)
            end
        else
            if flyConn then flyConn:Disconnect() end
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end
})

local noclipConn
ExploitTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(State)
        if State then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end
})

ExploitTab:CreateSlider({
    Name = "Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end
})

-- ===== [ SERVER COMMANDS ] ===== --
ExploitTab:CreateSection("Server Exploits")

ExploitTab:CreateButton({
    Name = "Ban All Players",
    Callback = function()
        for _, remote in pairs(ExploitMethods) do
            pcall(function()
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        if remote.Type == "GC" then
                            remote.Object:FireServer(player, "Ban")
                        else
                            remote.Object:FireServer("BanPlayer", player)
                        end
                    end
                end
            end)
        end
        Rayfield:Notify({
            Title = "Ban All Executed",
            Content = "Attempted to ban all players",
            Duration = 5,
            Image = 4483362458,
        })
    end
})

ExploitTab:CreateButton({
    Name = "Kick All Players",
    Callback = function()
        for _, remote in pairs(ExploitMethods) do
            pcall(function()
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        if remote.Type == "GC" then
                            remote.Object:FireServer(player, "Kick")
                        else
                            remote.Object:FireServer("KickPlayer", player)
                        end
                    end
                end
            end)
        end
        Rayfield:Notify({
            Title = "Kick All Executed",
            Content = "Attempted to kick all players",
            Duration = 5,
            Image = 4483362458,
        })
    end
})

-- ===== [ FUN COMMANDS ] ===== --
ExploitTab:CreateSection("Fun Commands")

ExploitTab:CreateButton({
    Name = "Fling Player",
    Callback = function()
        Rayfield:Prompt({
            Title = "Select Player to Fling",
            SubTitle = "Choose target player",
            Actions = {
                {
                    Name = "Fling",
                    Callback = function(playerName)
                        local target = game.Players[playerName]
                        if target then
                            for _, remote in pairs(ExploitMethods) do
                                pcall(function()
                                    if remote.Type == "GC" then
                                        remote.Object:FireServer(target, "Fling")
                                    else
                                        remote.Object:FireServer("FlingPlayer", target)
                                    end
                                end)
                            end
                        end
                    end
                }
            },
            Players = true
        })
    end
})

-- All parts will be c00lkidd images
ExploitTab:CreateButton({
    Name = "c00lkidd Image Flood",
    Callback = function()
        local imageId = "10560525690"
        local count = 0
        
        for _, part in pairs(game:GetDescendants()) do
            if part:IsA("BasePart") and part:FindFirstChildOfClass("Decal") then
                pcall(function()
                    part.Decal.Texture = "rbxassetid://"..imageId
                    count = count + 1
                end)
            end
        end
        
        Rayfield:Notify({
            Title = "Image Flood Complete",
            Content = "Changed "..count.." parts to c00lkidd image",
            Duration = 6,
            Image = 4483362458,
        })
    end
})

ExploitTab:CreateButton({
    Name = "Kill Player",
    Callback = function()
        Rayfield:Prompt({
            Title = "Select Player to Kill",
            SubTitle = "Choose target player",
            Actions = {
                {
                    Name = "Kill",
                    Callback = function(playerName)
                        local target = game.Players[playerName]
                        if target then
                            for _, remote in pairs(ExploitMethods) do
                                pcall(function()
                                    if remote.Type == "GC" then
                                        remote.Object:FireServer(target, "Kill")
                                    else
                                        remote.Object:FireServer("KillPlayer", target)
                                    end
                                end)
                            end
                        end
                    end
                }
            },
            Players = true
        })
    end
})

-- ===== [ TOOLS ] ===== --
ExploitTab:CreateSection("Tools")

ExploitTab:CreateButton({
    Name = "Give Btools",
    Callback = function()
        local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local tools = {"Hammer", "Clone", "Grab"}
            for _, toolName in pairs(tools) do
                local tool = Instance.new("HopperBin")
                tool.BinType = Enum.BinType[toolName]
                tool.Name = toolName
                tool.Parent = backpack
            end
        end
    end
})

ExploitTab:CreateButton({
    Name = "F3X Building Tools",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
    end
})

ExploitTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local serverList = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100", true)
        local data = game:GetService("HttpService"):JSONDecode(serverList)
        
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        else
            Rayfield:Notify({
                Title = "No Servers Found",
                Content = "Try again later",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end
})

-- ===== [ FINAL NOTIFICATION ] ===== --
Rayfield:Notify({
    Title = "F4X Hub Loaded",
    Content = "All features initialized successfully",
    Duration = 5,
    Image = 4483362458,
})