-- // Wait BS


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local cref = cloneref
-- Services
local Workspace = cref(game:GetService("Workspace"))
local Players = cref(game:GetService("Players"))
local RunService = cref(game:GetService("RunService"))
local Lighting = cref(game:GetService("Lighting"))
-- Color Locals
local phantomcolor = Color3.fromRGB(255, 0, 0)
local ghostcolor = Color3.fromRGB(0, 0, 255)
local color = Color3.fromRGB(255, 255, 255) -- Gun ESP COLOR

-- // Plr esp
local plrfolder = cloneref(game:GetService("Workspace").Players)
-- // Player ESP
local function phantomesp(character, container)
    local highlight = Instance.new("BillboardGui", container)
    highlight.Name = "Player ESP - Phantom"
    highlight.Size = UDim2.new(2, 0, 2, 0)
    highlight.StudsOffset = Vector3.new(0, 2, 0)
    highlight.AlwaysOnTop = true
    highlight.Adornee = character
    local fill = Instance.new("Frame", highlight)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = phantomcolor -- Red for phantoms
    fill.BackgroundTransparency = 0.2

    character.AncestryChanged:Connect(function()
        if not character:IsDescendantOf(game) then
            highlight:Destroy()
        end
    end)
end

local function ghostesp(character, container)
    local highlight = Instance.new("BillboardGui", container)
    highlight.Name = "Player ESP - Ghost"
    highlight.Size = UDim2.new(2, 0, 2, 0)
    highlight.StudsOffset = Vector3.new(0, 2, 0)
    highlight.AlwaysOnTop = true
    highlight.Adornee = character
    local fill = Instance.new("Frame", highlight)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = ghostcolor
    fill.BackgroundTransparency = 0.2

    character.AncestryChanged:Connect(function()
        if not character:IsDescendantOf(game) then
            highlight:Destroy()
        end
    end)
end

local function createESP(container)
    local firstFolderFound = false
    local secondFolderFound = false

    for _, child in ipairs(plrfolder:GetChildren()) do
        if not firstFolderFound and child:IsA("Folder") then
            firstFolderFound = true
            for _, team in ipairs(child:GetChildren()) do
                phantomesp(team, container)
            end
            child.ChildAdded:Connect(function(team)
                phantomesp(team, container)
            end)
        elseif firstFolderFound and not secondFolderFound and child:IsA("Folder") then
            secondFolderFound = true
            for _, team in ipairs(child:GetChildren()) do
                ghostesp(team, container)
            end
            child.ChildAdded:Connect(function(team)
                ghostesp(team, container)
            end)
        end
    end
end

-- Dropped Weapon ESP
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))


local processedModels = {} 

local function onDescendantAdded(descendant)
    if descendant:IsA("Part") then
        local model = descendant.Parent
        if model and not processedModels[model] then
            print("Part added:", descendant.Name)
            esp(descendant)
            processedModels[model] = true 
        end
    end
end

local camera = Workspace.CurrentCamera
local runservice = cref(game:GetService("RunService"))

function esp(Part)
    local Partesp = Drawing.new("Text")
    Partesp.Visible = true
    Partesp.Center = true
    Partesp.Outline = true
    Partesp.Font = 2
    Partesp.Color = Color3.fromRGB(255,255,255)
    Partesp.Size = 13

    local renderstepped
    renderstepped = runservice.RenderStepped:Connect(function()
        if Part and Part:IsDescendantOf(Workspace.Ignore.GunDrop) then
            local Part_pos, Part_onscreen = camera:WorldToViewportPoint(Part.Position)

            if Part_onscreen then
                Partesp.Position = Vector2.new(Part_pos.X, Part_pos.Y)
                Partesp.Text = Part.Parent.Gun.Value
                Partesp.Visible = true
            else 
                Partesp.Visible = false
            end
        else
            Partesp.Visible = false
            Partesp:Remove()
            renderstepped:Disconnect()
        end
    end)
end

-- Function to recursively listen for new parts being added
local function listenForParts(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Player") then
            print("Player Added", child.Name)
            esp(child)
        end
    end
    parent.DescendantAdded:Connect(onDescendantAdded)
end



local Window = Rayfield:CreateWindow({
    Name = "O2 Hub",
    LoadingTitle = "Phantom Forces",
    LoadingSubtitle = "by ThatsMyMute",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "O2_Hub",
        FileName = "O2-PF"
    },
    Discord = {
        Enabled = true,
        Invite = "vwK4gZfVHw",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "I'm Broke as hell",
        Subtitle = "Key System",
        Note = "Key in discord",
        FileName = "PF-Key",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"enjoy :)"}
    }
})

local Tab = Window:CreateTab("ESP", 4483362458)
local Tab2 = Window:CreateTab("Lighting/Misc")
local Toggle1 = Tab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            local container = Instance.new("Folder", game.CoreGui)
            container.Name = "ESPContainer"
            createESP(container)
        else
            local container = game.CoreGui:FindFirstChild("ESPContainer")
            if container then
                container:Destroy()
            end
        end
    end,
})

local Toggle2 = Tab:CreateToggle({
    Name = "Dropped Gun ESP",
    CurrentValue = false,
    Flag = "Gun",
    Callback = function(Value)
        if Value then
            listenForParts(Workspace.Ignore.GunDrop)
        else
            Drawing.clear()
        end
    end,
})

local PhantomespColor = Tab:CreateColorPicker({
    Name = "Phantom ESP Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker2",
    Callback = function(Color)
        phantomcolor = Color
    end
})

local GhostespColor = Tab:CreateColorPicker({
    Name = "Ghosts Color Esp",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker3",
    Callback = function(Color)
        ghostcolor = Color
    end
})


local AimbientColorPicker = Tab2:CreateColorPicker({
  Name = "Aimbient",
  Color = Color3.fromRGB(255,255,255),
  Flag = "ColorPicker4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
  Callback = function(Value)
    Lighting.MapLighting.Aimbient.Value = Value
  end
})

local BrightnessSlider = Tab2:CreateSlider({
  Name = "Brightness",
  Range = {0, 1},
  Increment = .1,
  Suffix = "Brightness",
  CurrentValue = 1,
  Flag = "Bright", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
  Callback = function(Value)
 Lighting.MapLighting.Brightness.Value = Value
  end,
})


--[[
  game:GetService("Lighting").MapLighting.Brightness
]]
--[[
  
Aimbient.Value = Color3.fromRGB(22,55,22)
]]
