--[[
currentVersion = "V1.0.1"

i think you guys seeing that we are changing and editing the source.lua very much, that beacuse we wanted to make it FE Exploit
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "F4X FE | V1.0.1",
   Icon = 116783337597674,
   LoadingTitle = "Exploit Is Loading....",
   LoadingSubtitle = "by Gizmoscat",
   Theme = "Ocean",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "F4X-FE",
      FileName = "F4X FE"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

Rayfield:Notify({
  Title = "What's New?! (V1.0.1)",
  Content = "F4X Hub become an F4X Hub FE",
  Duration = 5,
  Image = 0,
})


local AC = Window:CreateTab("🛡 Anti Protection 🛡", 4483362458)
local Cmds = Window:CreateTab("🔥 Commands 🔥", 4483362458)
local About = Window:CreateTab("🔱 About Us 🔱", 4483362458)
local Sus = Window:CreateTab("🥵 Sus Commands 🥵", 4483362458)

-- قسم الحماية
local Section = AC:CreateSection("👑 Anti Cheat 👑")

local Toggle = AC:CreateToggle({
    Name = "Anti-Cheat Disabler",
    CurrentValue = false,
    Flag = "AC-Disabler1",
    Callback = function(State)
        if State then
            Rayfield:Notify({
                Title = "Security Override Initiated",
                Content = "Bypassing protection systems...",
                Duration = 3,
                Image = 0
            })

            local function EstablishSafeEnvironment()
                getgenv().SecureMode = true
                
                if setthreadcontext then
                    setthreadcontext(7)
                end
                
                local originalNamecall
                originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    if method:lower():find("kick") or method:lower():find("ban") then
                        return nil
                    end
                    return originalNamecall(self, ...)
                end)
            end

            local function DismantleSecuritySystems()
                for _,v in pairs(getreg()) do
                    if type(v) == "function" and not is_synapse_function(v) then
                        if debug.getinfo(v).name:find("AntiCheat") then
                            hookfunction(v, function() return true end)
                        end
                    end
                end

                local CriticalServices = {
                    game:GetService("Players").LocalPlayer.PlayerScripts,
                    game:GetService("ServerScriptService"),
                    game:GetService("ReplicatedStorage"),
                    game:GetService("Workspace")
                }

                for _,service in pairs(CriticalServices) do
                    for _,obj in pairs(service:GetDescendants()) do
                        if obj:IsA("Script") or obj:IsA("LocalScript") then
                            if obj.Name:match("Anti") or obj.Name:match("AC") or obj.Name:match("Security") then
                                obj.Disabled = true
                                obj:Destroy()
                            end
                        elseif obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                            if obj.Name:match("Kick") or obj.Name:match("Ban") or obj.Name:match("Report") then
                                hookfunction(obj.FireServer, function() return nil end)
                                obj:Destroy()
                            end
                        end
                    end
                end

                pcall(function()
                    if game:GetService("ScriptContext") then
                        game:GetService("ScriptContext").ScriptsDisabled = false
                    end
                end)
            end

            pcall(EstablishSafeEnvironment)
            pcall(DismantleSecuritySystems)

            task.wait(1)

            Rayfield:Notify({
                Title = "Protection Override Complete",
                Content = "All security systems neutralized",
                Duration = 5,
                Image = 0,
                Actions = {
                    Confirm = {
                        Name = "Acknowledged",
                        Callback = function()
                            print("User confirmed security bypass")
                        end
                    }
                }
            })
        else
            Rayfield:Notify({
                Title = "Security Systems Active",
                Content = "Protection measures are operational",
                Duration = 5,
                Image = 0
            })
        end
    end
})
  
local Section = AC:CreateSection("Character")
  
local AntiFlingToggle = AC:CreateToggle({
    Name = "Anti-Fling",
    CurrentValue = false,
    Flag = "AntiFling_Pro",
    Callback = function(State)
        if State then
            Rayfield:Notify({
                Title = "Anti-Fling System",
                Content = "Activating collision protection...",
                Duration = 3,
                Image = 0
            })

            local Character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            local OriginalPosition = HumanoidRootPart.Position

            local VelocityControl = Instance.new("BodyVelocity")
            VelocityControl.Velocity = Vector3.new(0, 0, 0)
            VelocityControl.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            VelocityControl.P = 10000
            VelocityControl.Parent = HumanoidRootPart

            local function AntiFling()
                local LastSafePosition = HumanoidRootPart.Position
                
                HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function()
                    local CurrentPosition = HumanoidRootPart.Position
                    local Distance = (CurrentPosition - LastSafePosition).Magnitude
                    
                    if Distance > 50 then
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        HumanoidRootPart.CFrame = CFrame.new(LastSafePosition)
                    else
                        LastSafePosition = CurrentPosition
                    end
                end)

                local ForceField = Instance.new("ForceField")
                ForceField.Visible = false
                ForceField.Parent = Character
            end

            game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(newChar)
                Character = newChar
                HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
                VelocityControl.Parent = HumanoidRootPart
                AntiFling()
            end)

            AntiFling()

            Rayfield:Notify({
                Title = "Anti-Fling Active",
                Content = "Fling protection is now enabled",
                Duration = 5,
                Image = 0
            })
        else
            if game:GetService("Players").LocalPlayer.Character then
                local Character = game:GetService("Players").LocalPlayer.Character
                if Character:FindFirstChild("HumanoidRootPart") then
                    for _,v in pairs(Character.HumanoidRootPart:GetChildren()) do
                        if v:IsA("BodyVelocity") then
                            v:Destroy()
                        end
                    end
                end
                
                for _,v in pairs(Character:GetChildren()) do
                    if v:IsA("ForceField") then
                        v:Destroy()
                    end
                end
            end

            Rayfield:Notify({
                Title = "Anti-Fling Disabled",
                Content = "Fling protection has been turned off",
                Duration = 5,
                Image = 0
            })
        end
    end
})
   
local AntiAfkToggle = AC:CreateToggle({
    Name = "AntiAfk",
    CurrentValue = false,
    Flag = "AntiAfkToggle",
    Callback = function(State)
        if State then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        else
            getconnections(game:GetService("Players").LocalPlayer.Idled)[1]:Disable()
        end
    end
})

local AntiLagToggle = AC:CreateToggle({
    Name = "AntiLag",
    CurrentValue = false,
    Flag = "AntiLagToggle",
    Callback = function(State)
        if State then
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Workspace").Terrain.WaterWaveSize = 0
            game:GetService("Workspace").Terrain.WaterWaveSpeed = 0
        else
            settings().Rendering.QualityLevel = 10
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})

local AntiFogToggle = AC:CreateToggle({
    Name = "AntiFog",
    CurrentValue = false,
    Flag = "AntiFogToggle",
    Callback = function(State)
        if State then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end
})

local AntiHeadSitToggle = AC:CreateToggle({
    Name = "AntiHeadSit",
    CurrentValue = false,
    Flag = "AntiHeadSitToggle",
    Callback = function(State)
        if State then
            game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.Seated then
                        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end)
        end
    end
})

local AntiBangToggle = AC:CreateToggle({
    Name = "AntiBang",
    CurrentValue = false,
    Flag = "AntiBangToggle",
    Callback = function(State)
        if State then
            game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
                char.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") then
                        child:Destroy()
                    end
                end)
            end)
        end
    end
})

-- قسم الأوامر السخيفة مع التصحيحات
local JerkSection = Sus:CreateSection("Jerk Tools (Fixed)")

local jerkAnimIds = {
    R6 = "rbxassetid://5918726674",
    R15 = "rbxassetid://148840371"
}

local jerkButton = Sus:CreateButton({
    Name = "Jerk (Fixed Animation)",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "Jerk off"
        tool.Parent = game:GetService("Players").LocalPlayer.Backpack
        
        local animTrack
        local currentSpeed = 1
        
        tool.Equipped:Connect(function()
            local humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
            local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
            
            local animId = humanoid.RigType == Enum.HumanoidRigType.R6 and jerkAnimIds.R6 or jerkAnimIds.R15
            local animation = Instance.new("Animation")
            animation.AnimationId = animId
            
            animTrack = animator:LoadAnimation(animation)
            animTrack.Looped = true
            animTrack:Play()
            animTrack:AdjustSpeed(currentSpeed)
        end)
        
        tool.Unequipped:Connect(function()
            if animTrack then
                animTrack:Stop()
            end
        end)
        
        local speedSlider = Sus:CreateSlider({
            Name = "Jerk Speed",
            Range = {0.1, 10},
            Increment = 0.1,
            Suffix = "x",
            CurrentValue = 1,
            Flag = "JerkSpeedSlider",
            Callback = function(value)
                currentSpeed = value
                if animTrack then
                    animTrack:AdjustSpeed(value)
                end
            end
        })
    end
})

-- إضافة أداة Bang كـ Input مع الانيميشنات الصحيحة
local BangSection = Sus:CreateSection("Bang Tools")

local bangAnimIds = {
    R6 = "rbxassetid://72042024",
    R15 = "rbxassetid://698251653"
}

local BangInput = Sus:CreateInput({
    Name = "Bang Player",
    PlaceholderText = "Enter username",
    RemoveTextAfterFocusLost = false,
    Callback = function(PlayerName)
        local targetPlayer = game.Players:FindFirstChild(PlayerName)
        if not targetPlayer then
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found!",
                Duration = 3,
                Image = 4483362458
            })
            return
        end

        local character = game.Players.LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- الانتقال خلف اللاعب
        local targetChar = targetPlayer.Character
        if not targetChar then return end
        
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            Rayfield:Notify({
                Title = "Error",
                Content = "Target player doesn't have HumanoidRootPart",
                Duration = 3,
                Image = 4483362458
            })
            return
        end
        
        -- الانتقال إلى خلف اللاعب مع مسافة آمنة
        local offset = CFrame.new(0, 0, -2.5) -- خلف اللاعب بمسافة 2.5 دراسة
        character:MoveTo(targetRoot.Position + offset.Position)
        
        -- تشغيل الانميشن
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
        local animId = humanoid.RigType == Enum.HumanoidRigType.R6 and bangAnimIds.R6 or bangAnimIds.R15
        local animation = Instance.new("Animation")
        animation.AnimationId = animId
        
        local animTrack = animator:LoadAnimation(animation)
        animTrack.Looped = true
        animTrack:Play()
        
        -- التتبع المستمر للاعب مع إشعار
        Rayfield:Notify({
            Title = "Bang Active",
            Content = "Now banging "..PlayerName.." (Press UNEQUIP to stop)",
            Duration = 6,
            Image = 4483362458
        })
        
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if targetChar and targetRoot and character and humanoid then
                -- حساب الموضع خلف اللاعب مع الحفاظ على مسافة
                local backPosition = targetRoot.Position + (targetRoot.CFrame.LookVector * -2.5)
                character:MoveTo(backPosition)
                
                -- توجيه شخصيتك نحو اللاعب
                humanoid:MoveTo(targetRoot.Position)
            else
                -- التوقف عند فقدان الهدف
                connection:Disconnect()
                if animTrack then
                    animTrack:Stop()
                end
                Rayfield:Notify({
                    Title = "Bang Stopped",
                    Content = "Stopped banging "..PlayerName,
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end)
        
        -- إضافة طريقة للإيقاف عند نزع الأداة
        local tool = Instance.new("Tool")
        tool.Name = "Bang Tool"
        tool.Parent = game.Players.LocalPlayer.Backpack
        
        tool.Unequipped:Connect(function()
            connection:Disconnect()
            if animTrack then
                animTrack:Stop()
            end
            tool:Destroy()
            Rayfield:Notify({
                Title = "Bang Stopped",
                Content = "Stopped banging "..PlayerName,
                Duration = 3,
                Image = 4483362458
            })
        end)
    end
})

-- قسم معلومات السكربت مع تعديل الألوان
local AboutSection = About:CreateSection("About F4X FE")

local Label1 = About:CreateLabel("Created by Gizmoscat (F4X)", 4483362458, false)
local Label2 = About:CreateLabel("F4X FE is a client-side exploit", 4483362458, false)
local Label3 = About:CreateLabel("You can try dex explorer, remotespy, infiniteyield for more commands", 4483362458, false)
   
local Dex = About:CreateButton({
   Name = "Dex Explorer",
   Callback = function()
      Rayfield:Notify({
         Title = "Dex Explorer",
         Content = "Dex Explorer is loading, hold on a sec",
         Duration = 5,
         Image = 4483362458,
      })

      local success, dex = pcall(function()
         return loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))()
      end)

      if success then
         dex()
      else
         Rayfield:Notify({
            Title = "Dex Explorer",
            Content = "Failed To Load Dex Explorer: It might be because your country is banned from using GitHub (try a VPN), or there are issues with loadstring. Try again later.",
            Duration = 8,
            Image = 4483362458,
         })
         warn("Dex Explorer Load Error:", dex)
      end
   end,
})   
   
local IY = About:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      Rayfield:Notify({
         Title = "Infinite Yield",
         Content = "Loading Infinite Yield... (by EdgeIY)",
         Duration = 3,
         Image = 4483362458,
      })

      local success, response = pcall(function()
         return loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
      end)

      if success then
         response()
         Rayfield:Notify({
            Title = "Infinite Yield",
            Content = "Infinite Yield successfully loaded! Try their 300+ commands (e.g. ;fly, ;ctrl)",
            Duration = 6.5,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Infinite Yield",
            Content = "Failed to load Infinite Yield: This might be a geo-block (Syria, Afghanistan, Palestine, Yemen). Try a VPN, or check loadstring issues.",
            Duration = 6.5,
            Image = 4483362458,
         })
         warn("IY Load Error:", response)
      end
   end,
})   

-- قسم الأوامر
local Section = Cmds:CreateSection("😎 Commands 😎")

local noclipConn
local NoClipToggle = Cmds:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      if noclipConn then noclipConn:Disconnect() end
      
      if Value then
         noclipConn = game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
               for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if v:IsA("BasePart") then v.CanCollide = false end
               end
            end)
         end)
      end
   end
})

local speedConn
local SpeedSlider = Cmds:CreateSlider({
   Name = "SpeedHack",
   Range = {16, 200},
   Increment = 1,
   Suffix = "studs/s",
   CurrentValue = 16,
   Callback = function(Value)
      if speedConn then speedConn:Disconnect() end
      
      speedConn = game:GetService("RunService").Heartbeat:Connect(function()
         pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
         end)
      end)
   end
})

local jumpConn
local InfiniteJump = Cmds:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      if jumpConn then jumpConn:Disconnect() end
      
      if Value then
         jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            pcall(function()
               game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
         end)
      end
   end
})

local Teleport = Cmds:CreateButton({
   Name = "Click Teleport",
   Callback = function()
      local mouse = game.Players.LocalPlayer:GetMouse()
      local conn
      
      conn = mouse.Button1Down:Connect(function()
         pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
               char:MoveTo(mouse.Hit.Position)
            end
         end)
      end)
      
      Rayfield:Notify({
         Title = "Teleport Active",
         Content = "Click anywhere to teleport (Lasts 30 seconds)",
         Duration = 5,
         Image = 4483362458
      })
      
      task.delay(30, function() conn:Disconnect() end)
   end
})

local espCache = {}
local ESPToggle = Cmds:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Callback = function(Value)
      for player, parts in pairs(espCache) do
         for _, part in pairs(parts) do
            part:Destroy()
         end
      end
      table.clear(espCache)
      
      if Value then
         for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
               CreateESP(player)
            end
         end
         
         game.Players.PlayerAdded:Connect(CreateESP)
      end
   end
})

local ESPColor = Cmds:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 0, 0),
   Callback = function(Color)
      for _, parts in pairs(espCache) do
         for _, part in pairs(parts) do
            part.Color = Color
         end
      end
   end
})

function CreateESP(player)
   if espCache[player] then return end
   
   local highlight = Instance.new("Highlight")
   highlight.Parent = player.Character or player.CharacterAdded:Wait()
   highlight.Adornee = highlight.Parent
   highlight.Color3 = ESPColor.Color
   
   espCache[player] = {highlight}
   
   player.CharacterAdded:Connect(function(char)
      highlight.Adornee = char
   end)
end

local xrayParts = {}
local XRayToggle = Cmds:CreateToggle({
   Name = "XRay",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Parent:FindFirstChildOfClass("Humanoid") then
               table.insert(xrayParts, part)
               part.LocalTransparencyModifier = 0.7
            end
         end
      else
         for _, part in ipairs(xrayParts) do
            pcall(function() part.LocalTransparencyModifier = 0 end)
         end
         table.clear(xrayParts)
      end
   end
})

local godConn
local GodMode = Cmds:CreateToggle({
   Name = "God Mode",
   CurrentValue = false,
   Callback = function(Value)
      if godConn then godConn:Disconnect() end
      
      if Value then
         local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
         humanoid:SetAttribute("SavedHealth", humanoid.Health)
         
         godConn = humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid:GetAttribute("SavedHealth") then
               humanoid.Health = humanoid:GetAttribute("SavedHealth")
            end
         end)
      end
   end
})

local Input = Cmds:CreateInput({
   Name = "Join Date Checker",
   PlaceholderText = "Enter username",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local player = game.Players:FindFirstChild(Text)
      if player then
         local joinDate = os.date("%Y-%m-%d", os.time() - (player.AccountAge * 86400))
         Rayfield:Notify({
            Title = "Join Date",
            Content = string.format("%s joined on %s (%d days ago)", Text, joinDate, player.AccountAge),
            Duration = 6,
            Image = 4483362458
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Player not found!",
            Duration = 3,
            Image = 4483362458
         })
      end
   end
})

local Button = Cmds:CreateButton({
   Name = "Server Age",
   Callback = function()
      local age = os.time() - workspace:GetServerTimeNow()
      local days = math.floor(age/86400)
      local hours = math.floor((age%86400)/3600)
      local minutes = math.floor((age%3600)/60)
      local seconds = math.floor(age%60)
      
      Rayfield:Notify({
         Title = "Server Age",
         Content = string.format("%dd %dh %dm %ds", days, hours, minutes, seconds),
         Duration = 6,
         Image = 4483362458
      })
   end
})

local Button = Cmds:CreateButton({
   Name = "Rejoin",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
   end
})

local Button = Cmds:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
      
      for _, server in ipairs(servers.data) do
         if server.playing < server.maxPlayers and server.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
            return
         end
      end
      
      Rayfield:Notify({
         Title = "Error",
         Content = "No available servers found!",
         Duration = 3,
         Image = 4483362458
      })
   end
})

Rayfield:LoadConfiguration()