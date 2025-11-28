local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "wow 5$";
    Text = "5$ (omg so rich) to anyone who makes a good ui (no librarys) join the discord for more info";
    Duration = 5;
})
StarterGui:SetCore("SendNotification", {
    Title = "Discord";
    Text = "Click JOIN to copy the Discord link!";
    Duration = 5;
    Button1 = "JOIN";
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/M87GafGepW")
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera


local AimEnabled = false
local TriggerEnabled = false
local SkeletonEnabled = false
local AntiFriendlyFire = false
local CircleSize = 150
local OverrideStrength = 0.15 
local CtrlHeld = false


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkiddieGUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,320,0,220)
Frame.Position = UDim2.new(0,10,0.25,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui


local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,20)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
TopBar.BorderSizePixel = 0
TopBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "skiddie-AIMBOT | v1.0"
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Position = UDim2.new(0,5,0,0)
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "x"
CloseButton.Size = UDim2.new(0,20,0,20)
CloseButton.Position = UDim2.new(1,-25,0,0)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.Code
CloseButton.TextSize = 14
CloseButton.Parent = TopBar
CloseButton.MouseButton1Click:Connect(function() Frame.Visible = false end)


local dragging, dragInput, dragStart, startPos = false,nil,nil,nil
local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)


local function createToggle(name,pos,varRef)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,280,0,25)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = Frame

    local txt = Instance.new("TextLabel")
    txt.Text = name
    txt.Size = UDim2.new(0,200,1,0)
    txt.Position = UDim2.new(0,25,0,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1,1,1)
    txt.Font = Enum.Font.Code
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = btn

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0,15,0,15)
    box.Position = UDim2.new(0,5,0,5)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30) 
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.new(0.3,0.3,0.3) 
    box.Parent = btn

    local function updateBox()
        if varRef[1] then
            box.BackgroundColor3 = Color3.new(0.7,0.7,0.7) 
        else
            box.BackgroundColor3 = Color3.fromRGB(30,30,30) 
        end
    end
    updateBox()

    btn.MouseButton1Click:Connect(function()
        varRef[1] = not varRef[1]
        updateBox()
    end)
    return updateBox
end

local AimVar = {AimEnabled}
local TriggerVar = {TriggerEnabled}
local ESPVar = {SkeletonEnabled}
local AFFVar = {AntiFriendlyFire}

local UpdateAimBox = createToggle("Aimbot (F1)",UDim2.new(0,20,0,25),AimVar)
local UpdateTriggerBox = createToggle("Triggerbot (F2)",UDim2.new(0,20,0,55),TriggerVar)
local UpdateESPBox = createToggle("ESP (F3)",UDim2.new(0,20,0,85),ESPVar)
local UpdateAFFBox = createToggle("Anti-Friendly-Fire",UDim2.new(0,20,0,115),AFFVar)


local SliderLabel = Instance.new("TextLabel")
SliderLabel.Text = "FOV Size: "..CircleSize
SliderLabel.Size = UDim2.new(0,120,0,20)
SliderLabel.Position = UDim2.new(0,20,0,145)
SliderLabel.BackgroundTransparency = 1
SliderLabel.TextColor3 = Color3.new(1,1,1)
SliderLabel.Font = Enum.Font.Code
SliderLabel.TextSize = 14
SliderLabel.Parent = Frame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0,200,0,10)
SliderBar.Position = UDim2.new(0,20,0,165)
SliderBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
SliderBar.BorderSizePixel = 0
SliderBar.BorderColor3 = Color3.new(0.3,0.3,0.3) 
SliderBar.Parent = Frame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(CircleSize/500,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255,0,0)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar


local AimCircle = Instance.new("Frame")
AimCircle.Name = "AimCircle"
AimCircle.Size = UDim2.new(0, CircleSize, 0, CircleSize)
AimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimCircle.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
AimCircle.BackgroundTransparency = 1
AimCircle.BorderSizePixel = 0
AimCircle.Parent = ScreenGui

local UICornerCircle = Instance.new("UICorner")
UICornerCircle.CornerRadius = UDim.new(1, 0)
UICornerCircle.Parent = AimCircle

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.new(1, 0, 0) 
Stroke.Parent = AimCircle


local function updateFOVSize(newSize)
    CircleSize = math.clamp(newSize, 50, 500)
    
    
    SliderFill.Size = UDim2.new(CircleSize/500, 0, 1, 0)
    SliderLabel.Text = "FOV Size: " .. CircleSize
    
    
    AimCircle.Size = UDim2.new(0, CircleSize, 0, CircleSize)
    
    print("FOV UPDATED TO: " .. CircleSize) 
end


local draggingSlider = false
SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        draggingSlider = true 
    end
end)

SliderBar.InputEnded:Connect(function(input) 
    draggingSlider = false 
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local x = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local newSize = 50 + math.floor((x / SliderBar.AbsoluteSize.X) * 450)
        updateFOVSize(newSize)
    end
end)


local SkeletonSettings = {
    Color = Color3.new(0, 1, 0),
    Thickness = 2,
    Transparency = 1
}

local skeletons = {}

local function createLine()
    local line = Drawing.new("Line")
    return line
end

local function removeSkeleton(skeleton)
    for _, line in pairs(skeleton) do
        line:Remove()
    end
end

local function trackPlayer(plr)
    local skeleton = {}

    local function updateSkeleton()
        if not SkeletonEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
            return
        end

        local character = plr.Character
        local humanoid = character:FindFirstChild("Humanoid")

        local joints = {}
        local connections = {}

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["UpperTorso"] = character:FindFirstChild("UpperTorso"),
                ["LowerTorso"] = character:FindFirstChild("LowerTorso"),
                ["LeftUpperArm"] = character:FindFirstChild("LeftUpperArm"),
                ["LeftLowerArm"] = character:FindFirstChild("LeftLowerArm"),
                ["LeftHand"] = character:FindFirstChild("LeftHand"),
                ["RightUpperArm"] = character:FindFirstChild("RightUpperArm"),
                ["RightLowerArm"] = character:FindFirstChild("RightLowerArm"),
                ["RightHand"] = character:FindFirstChild("RightHand"),
                ["LeftUpperLeg"] = character:FindFirstChild("LeftUpperLeg"),
                ["LeftLowerLeg"] = character:FindFirstChild("LeftLowerLeg"),
                ["RightUpperLeg"] = character:FindFirstChild("RightUpperLeg"),
                ["RightLowerLeg"] = character:FindFirstChild("RightLowerLeg"),
            }
            connections = {
                { "Head", "UpperTorso" },
                { "UpperTorso", "LowerTorso" },
                { "LowerTorso", "LeftUpperLeg" },
                { "LeftUpperLeg", "LeftLowerLeg" },
                { "LowerTorso", "RightUpperLeg" },
                { "RightUpperLeg", "RightLowerLeg" },
                { "UpperTorso", "LeftUpperArm" },
                { "LeftUpperArm", "LeftLowerArm" },
                { "LeftLowerArm", "LeftHand" },
                { "UpperTorso", "RightUpperArm" },
                { "RightUpperArm", "RightLowerArm" },
                { "RightLowerArm", "RightHand" },
            }
        elseif humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["Torso"] = character:FindFirstChild("Torso"),
                ["LeftLeg"] = character:FindFirstChild("Left Leg"),
                ["RightLeg"] = character:FindFirstChild("Right Leg"),
                ["LeftArm"] = character:FindFirstChild("Left Arm"),
                ["RightArm"] = character:FindFirstChild("Right Arm"),
            }
            connections = {
                { "Head", "Torso" },
                { "Torso", "LeftArm" },
                { "Torso", "RightArm" },
                { "Torso", "LeftLeg" },
                { "Torso", "RightLeg" },
            }
        end

        for index, connection in ipairs(connections) do
            local jointA = joints[connection[1]]
            local jointB = joints[connection[2]]

            if jointA and jointB then
                local posA, onScreenA = camera:WorldToViewportPoint(jointA.Position)
                local posB, onScreenB = camera:WorldToViewportPoint(jointB.Position)

                local line = skeleton[index] or createLine()
                skeleton[index] = line

                line.Color = SkeletonSettings.Color
                line.Thickness = SkeletonSettings.Thickness
                line.Transparency = SkeletonSettings.Transparency

                if onScreenA and onScreenB then
                    if connection[2] == "LeftArm" or connection[2] == "RightArm" then
                        local offsetY = 0.5
                        posB = camera:WorldToViewportPoint(jointB.Position + Vector3.new(0, offsetY, 0))
                    end

                    line.From = Vector2.new(posA.X, posA.Y)
                    line.To = Vector2.new(posB.X, posB.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif skeleton[index] then
                skeleton[index].Visible = false
            end
        end
    end

    skeletons[plr] = skeleton

    RunService.RenderStepped:Connect(function()
        if plr and plr.Parent then
            updateSkeleton()
        else
            removeSkeleton(skeleton)
        end
    end)
end

local function untrackPlayer(plr)
    if skeletons[plr] then
        removeSkeleton(skeletons[plr])
        skeletons[plr] = nil
    end
end


for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        trackPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        trackPlayer(plr)
    end
end)

Players.PlayerRemoving:Connect(untrackPlayer)


RunService.RenderStepped:Connect(function()
    SkeletonEnabled = ESPVar[1]
    if not SkeletonEnabled then
        for _, skeleton in pairs(skeletons) do
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
        end
    end
end)


local function canSeeTarget(target)
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then
        return false
    end
    
    local head = target.Character.Head
    local origin = camera.CFrame.Position
    local targetPos = head.Position
    
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, target.Character}
    
    local raycastResult = workspace:Raycast(origin, (targetPos - origin), raycastParams)
    
    
    if not raycastResult then
        return true
    end
    
    
    local hitDistance = (raycastResult.Position - origin).Magnitude
    local targetDistance = (targetPos - origin).Magnitude
    
    return hitDistance >= targetDistance - 2 
end

local function getClosestPlayer()
    local closest = nil
    local dist = CircleSize / 2
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            if AFFVar[1] and plr.Team == LocalPlayer.Team then 
                continue 
            end
            
            local headPos = plr.Character.Head.Position
            local screenPos, onScreen = camera:WorldToViewportPoint(headPos)
            
            if onScreen then
                local dx, dy = screenPos.X - Mouse.X, screenPos.Y - Mouse.Y
                local magnitude = math.sqrt(dx * dx + dy * dy)
                
                if magnitude < dist then
                    dist = magnitude
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function skidgo()
    local target = getClosestPlayer()
    if target and canSeeTarget(target) then
        mouse1press()
        wait(0.05)
        mouse1release()
    end
end


UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        CtrlHeld = true
    end
    
    
    if input.KeyCode == Enum.KeyCode.F1 then 
        AimVar[1] = not AimVar[1] 
        UpdateAimBox() 
    end
    if input.KeyCode == Enum.KeyCode.F2 then 
        TriggerVar[1] = not TriggerVar[1] 
        UpdateTriggerBox() 
    end
    if input.KeyCode == Enum.KeyCode.F3 then 
        ESPVar[1] = not ESPVar[1] 
        UpdateESPBox() 
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    
    
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        CtrlHeld = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    
    if input.UserInputType == Enum.UserInputType.MouseWheel and CtrlHeld then
        local newSize = CircleSize + (input.Position.Z * 10)
        updateFOVSize(newSize)
    end
end)


RunService.RenderStepped:Connect(function()
    AimCircle.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
    AimCircle.Visible = AimVar[1]

    if AimVar[1] then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local camPos = camera.CFrame.Position
            local targetPos = target.Character.Head.Position
            camera.CFrame = CFrame.new(camPos, targetPos):Lerp(camera.CFrame, OverrideStrength)
        end
    end

    if TriggerVar[1] then 
        skidgo() 
    end
end)
