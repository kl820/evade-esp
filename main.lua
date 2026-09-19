-- =============================================================================
-- Evade | Visuals — Final Build
-- =============================================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

-- ██████████████████████████████████████████████████████████████████████████
-- KEY SYSTEM
-- ██████████████████████████████████████████████████████████████████████████

local Win = Rayfield:CreateWindow({
    Name                   = "Evade | Visuals",
    LoadingTitle           = "Evade | Visuals",
    LoadingSubtitle        = "Checking key...",
    Theme                  = "Darker",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings   = true,
    ConfigurationSaving    = { Enabled = false },
    KeySystem              = true,
    KeySettings            = {
        Title           = "Evade | Visuals",
        Subtitle        = "Enter your key",
        Note            = "Contact the developer for a key",
        FileName        = "EvadeVisualsKey",
        SaveKey         = true,
        GrabKeyFromSite = false,
        Key             = { "kebab" },
    },
})

-- ██████████████████████████████████████████████████████████████████████████
-- STATE
-- ██████████████████████████████████████████████████████████████████████████

local State = {
    PlayerESP      = false,
    PlayerBoxes    = true,
    PlayerNames    = true,
    PlayerDistance = true,
    PlayerTracers  = true,
    PlayerColor    = Color3.fromRGB(0, 170, 255),

    NextbotESP      = false,
    NextbotBoxes    = true,
    NextbotNames    = true,
    NextbotDistance = true,
    NextbotTracers  = true,
    NextbotColor    = Color3.fromRGB(255, 50, 50),

    FOVEnabled  = false,
    FOVValue    = 70,
    OriginalFOV = 70,
    FOVTween    = nil,

    RadarEnabled = false,

    FullbrightEnabled = false,
    NoFogEnabled      = false,

    CrosshairEnabled = false,
    CrosshairColor   = Color3.new(1, 1, 1),
    CrosshairSize    = 10,
    CrosshairThick   = 1,

    FPSEnabled  = false,
    GUIVisible  = true,
}

-- ██████████████████████████████████████████████████████████████████████████
-- CONNECTIONS
-- ██████████████████████████████████████████████████████████████████████████

local Connections = {}
local function Track(c) table.insert(Connections, c); return c end
local function DisconnectAll()
    for _, c in ipairs(Connections) do
        pcall(function()
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end)
    end
    table.clear(Connections)
end

-- ██████████████████████████████████████████████████████████████████████████
-- GUI TOGGLE — direct ScreenGui visibility, bypasses Rayfield's handler
-- ██████████████████████████████████████████████████████████████████████████

local function ToggleGUI()
    State.GUIVisible = not State.GUIVisible
    -- Find Rayfield's ScreenGui and toggle it directly
    for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "Rayfield" then
            gui.Enabled = State.GUIVisible
        end
    end
end

-- ██████████████████████████████████████████████████████████████████████████
-- DRAWING
-- ██████████████████████████████████████████████████████████████████████████

local function D(class, props)
    local ok, obj = pcall(Drawing.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do pcall(function() obj[k] = v end) end
    return obj
end
local function DS(o,k,v) if o then pcall(function() o[k]=v end) end end
local function DR(o)     if o then pcall(function() o:Remove() end) end end

-- ██████████████████████████████████████████████████████████████████████████
-- ESP BUNDLES
-- ██████████████████████████████████████████████████████████████████████████

local function NewBundle(color)
    return {
        box     = D("Square",{Visible=false,Color=color,Thickness=2,Filled=false,Transparency=1}),
        outline = D("Square",{Visible=false,Color=Color3.new(0,0,0),Thickness=3.5,Filled=false,Transparency=1}),
        name    = D("Text",  {Visible=false,Color=Color3.new(1,1,1),OutlineColor=Color3.new(0,0,0),Outline=true,Center=true,Size=14,Text=""}),
        dist    = D("Text",  {Visible=false,Color=color,OutlineColor=Color3.new(0,0,0),Outline=true,Center=true,Size=13,Text=""}),
        tracer  = D("Line",  {Visible=false,Color=color,Thickness=1.2,Transparency=1}),
    }
end
local function BHide(b)
    if not b then return end
    DS(b.box,"Visible",false) DS(b.outline,"Visible",false)
    DS(b.name,"Visible",false) DS(b.dist,"Visible",false) DS(b.tracer,"Visible",false)
end
local function BDestroy(b)
    if not b then return end
    DR(b.box) DR(b.outline) DR(b.name) DR(b.dist) DR(b.tracer)
end
local function BRecolor(b,c)
    if not b then return end
    DS(b.box,"Color",c) DS(b.dist,"Color",c) DS(b.tracer,"Color",c)
end

-- ██████████████████████████████████████████████████████████████████████████
-- BOX CALC
-- ██████████████████████████████████████████████████████████████████████████

local function CalcBox(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local pos   = hrp.Position
    local topSS = Camera:WorldToViewportPoint(pos + Vector3.new(0, 3.5, 0))
    local botSS = Camera:WorldToViewportPoint(pos - Vector3.new(0, 3.2, 0))
    if topSS.Z < 0 and botSS.Z < 0 then return nil end
    local topV = Vector2.new(topSS.X, topSS.Y)
    local botV = Vector2.new(botSS.X, botSS.Y)
    local h    = math.max(math.abs(topV.Y - botV.Y), 10)
    local w    = h * 0.45
    local cx   = (topV.X + botV.X) / 2
    return {
        topV=topV, botV=botV, h=h, w=w, cx=cx,
        hrpPos=pos,
        dist=math.floor((Camera.CFrame.Position - pos).Magnitude),
    }
end

local function ScreenMid()
    local vp = Camera.ViewportSize
    return Vector2.new(vp.X/2, vp.Y - 8)
end

local function RenderBundle(b, char, label, cfg, color)
    local bd = CalcBox(char)
    if not bd then BHide(b); return end
    local left = bd.cx - bd.w/2
    if cfg.boxes then
        if b.outline then b.outline.Visible=true b.outline.Size=Vector2.new(bd.w+2,bd.h+2) b.outline.Position=Vector2.new(left-1,bd.topV.Y-1) end
        if b.box     then b.box.Visible=true b.box.Color=color b.box.Size=Vector2.new(bd.w,bd.h) b.box.Position=Vector2.new(left,bd.topV.Y) end
    else DS(b.outline,"Visible",false) DS(b.box,"Visible",false) end
    if cfg.names    and b.name   then b.name.Visible=true b.name.Text=label b.name.Position=Vector2.new(bd.cx,bd.topV.Y-17)        else DS(b.name,"Visible",false) end
    if cfg.distance and b.dist   then b.dist.Visible=true b.dist.Color=color b.dist.Text=bd.dist.."m" b.dist.Position=Vector2.new(bd.cx,bd.botV.Y+3) else DS(b.dist,"Visible",false) end
    if cfg.tracers  and b.tracer then b.tracer.Visible=true b.tracer.Color=color b.tracer.From=ScreenMid() b.tracer.To=bd.botV    else DS(b.tracer,"Visible",false) end
end

-- ██████████████████████████████████████████████████████████████████████████
-- NEXTBOT DETECTION
-- ██████████████████████████████████████████████████████████████████████████

local EXCLUDED = {Baseplate=true,Terrain=true,Camera=true,SpawnLocation=true}
local CharSet  = {}

local function RefreshCharSet()
    table.clear(CharSet)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then CharSet[p.Character] = true end
    end
end

local function IsNextbot(inst)
    if not inst or not inst:IsA("Model") then return false end
    if EXCLUDED[inst.Name] then return false end
    if CharSet[inst] then return false end
    if LocalPlayer.Character == inst then return false end
    return inst:FindFirstChild("HumanoidRootPart") ~= nil
end

local function ScanNextbots()
    RefreshCharSet()
    local found = {}
    local function recurse(parent, depth)
        if depth > 4 then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and IsNextbot(child) then found[child]=true
            elseif child:IsA("Folder") or child:IsA("Model") then recurse(child,depth+1) end
        end
    end
    recurse(Workspace, 0)
    return found
end

-- ██████████████████████████████████████████████████████████████████████████
-- ESP TABLES
-- ██████████████████████████████████████████████████████████████████████████

local PB = {}
local NB = {}
local function AddP(p) if p==LocalPlayer or PB[p] then return end PB[p]=NewBundle(State.PlayerColor) end
local function DropP(p) BDestroy(PB[p]); PB[p]=nil end
local function AddN(m) if NB[m] then return end NB[m]=NewBundle(State.NextbotColor) end
local function DropN(m) BDestroy(NB[m]); NB[m]=nil end
local function ClearAll()
    for _,b in pairs(PB) do BDestroy(b) end
    for _,b in pairs(NB) do BDestroy(b) end
    table.clear(PB); table.clear(NB)
end

-- ██████████████████████████████████████████████████████████████████████████
-- FPS COUNTER
-- ██████████████████████████████████████████████████████████████████████████

local FPSDrawing = D("Text", {
    Visible      = false,
    Color        = Color3.fromRGB(0, 255, 100),
    OutlineColor = Color3.new(0, 0, 0),
    Outline      = true,
    Size         = 16,
    Text         = "FPS: 0",
    Position     = Vector2.new(8, 8),
})

local FPSClock  = 0
local FPSFrames = 0
local FPSLast   = 0

local function UpdateFPS(dt)
    if not State.FPSEnabled then
        DS(FPSDrawing,"Visible",false)
        return
    end
    FPSFrames = FPSFrames + 1
    FPSClock  = FPSClock + dt
    if FPSClock >= 0.5 then
        FPSLast   = math.floor(FPSFrames / FPSClock)
        FPSFrames = 0
        FPSClock  = 0
        local col
        if FPSLast >= 55 then
            col = Color3.fromRGB(0, 255, 100)
        elseif FPSLast >= 30 then
            col = Color3.fromRGB(255, 200, 0)
        else
            col = Color3.fromRGB(255, 60, 60)
        end
        DS(FPSDrawing,"Color",   col)
        DS(FPSDrawing,"Text",    "FPS: "..FPSLast)
        DS(FPSDrawing,"Visible", true)
    end
end

-- ██████████████████████████████████████████████████████████████████████████
-- RADAR
-- ██████████████████████████████████████████████████████████████████████████

local RADAR_RANGE   = 300
local RadarDrawings = { dots = {} }

local function InitRadar()
    local vp   = Camera.ViewportSize
    local size = 200
    local pad  = 10
    local rx   = vp.X - size - pad
    local ry   = pad
    RadarDrawings.bg     = D("Square",{Visible=false,Color=Color3.fromRGB(15,15,20),Size=Vector2.new(size,size),Position=Vector2.new(rx,ry),Filled=true,Transparency=0.35})
    RadarDrawings.border = D("Square",{Visible=false,Color=Color3.fromRGB(60,60,80),Size=Vector2.new(size,size),Position=Vector2.new(rx,ry),Filled=false,Thickness=1.5,Transparency=1})
    RadarDrawings.label  = D("Text",  {Visible=false,Text="RADAR",Color=Color3.fromRGB(180,180,220),OutlineColor=Color3.new(0,0,0),Outline=true,Center=true,Size=11,Position=Vector2.new(rx+100,ry+3)})
    RadarDrawings.crossH = D("Line",  {Visible=false,Color=Color3.fromRGB(50,50,70),Thickness=1,Transparency=1,From=Vector2.new(rx,ry+100),To=Vector2.new(rx+200,ry+100)})
    RadarDrawings.crossV = D("Line",  {Visible=false,Color=Color3.fromRGB(50,50,70),Thickness=1,Transparency=1,From=Vector2.new(rx+100,ry),To=Vector2.new(rx+100,ry+200)})
end

local function SetRadarVisible(vis)
    DS(RadarDrawings.bg,"Visible",vis) DS(RadarDrawings.border,"Visible",vis)
    DS(RadarDrawings.label,"Visible",vis) DS(RadarDrawings.crossH,"Visible",vis)
    DS(RadarDrawings.crossV,"Visible",vis)
end

local function GetOrCreateDot(key, color, sz)
    if not RadarDrawings.dots[key] then
        RadarDrawings.dots[key] = D("Square",{Visible=false,Color=color,Filled=true,Size=Vector2.new(sz,sz),Transparency=1})
    end
    return RadarDrawings.dots[key]
end

local function UpdateRadar()
    if not State.RadarEnabled then
        SetRadarVisible(false)
        for _, dot in pairs(RadarDrawings.dots) do DS(dot,"Visible",false) end
        return
    end
    SetRadarVisible(true)
    local vp   = Camera.ViewportSize
    local size = 200
    local pad  = 10
    local rx   = vp.X - size - pad
    local ry   = pad
    local cx   = rx + size/2
    local cy   = ry + size/2
    DS(RadarDrawings.bg,    "Position",Vector2.new(rx,ry))
    DS(RadarDrawings.border,"Position",Vector2.new(rx,ry))
    DS(RadarDrawings.label, "Position",Vector2.new(cx,ry+3))
    DS(RadarDrawings.crossH,"From",    Vector2.new(rx,cy))
    DS(RadarDrawings.crossH,"To",      Vector2.new(rx+size,cy))
    DS(RadarDrawings.crossV,"From",    Vector2.new(cx,ry))
    DS(RadarDrawings.crossV,"To",      Vector2.new(cx,ry+size))
    local myChar = LocalPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local myCF = myHRP.CFrame
    local activeDots = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local key = "p_"..p.UserId
                activeDots[key] = true
                local dot = GetOrCreateDot(key, State.PlayerColor, 5)
                local rel = myCF:PointToObjectSpace(hrp.Position)
                local dx  = math.clamp(cx+(rel.X/RADAR_RANGE)*(size/2),rx+3,rx+size-3)
                local dy  = math.clamp(cy-(rel.Z/RADAR_RANGE)*(size/2),ry+3,ry+size-3)
                dot.Visible=true dot.Color=State.PlayerColor dot.Position=Vector2.new(dx-2,dy-2)
            end
        end
    end
    for model in pairs(NB) do
        if model and model.Parent then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hrp then
                local key = "n_"..model:GetDebugId()
                activeDots[key] = true
                local dot = GetOrCreateDot(key, State.NextbotColor, 6)
                local rel = myCF:PointToObjectSpace(hrp.Position)
                local dx  = math.clamp(cx+(rel.X/RADAR_RANGE)*(size/2),rx+3,rx+size-3)
                local dy  = math.clamp(cy-(rel.Z/RADAR_RANGE)*(size/2),ry+3,ry+size-3)
                dot.Visible=true dot.Color=State.NextbotColor dot.Position=Vector2.new(dx-3,dy-3)
            end
        end
    end
    local selfKey = "self"
    activeDots[selfKey] = true
    local selfDot = GetOrCreateDot(selfKey, Color3.new(1,1,1), 5)
    selfDot.Visible=true selfDot.Position=Vector2.new(cx-2,cy-2)
    for key, dot in pairs(RadarDrawings.dots) do
        if not activeDots[key] then DS(dot,"Visible",false) end
    end
end

-- ██████████████████████████████████████████████████████████████████████████
-- CROSSHAIR
-- ██████████████████████████████████████████████████████████████████████████

local CrosshairDrawings = {}

local function InitCrosshair()
    CrosshairDrawings.top     = D("Line",{Visible=false,Color=State.CrosshairColor,Thickness=1,Transparency=1})
    CrosshairDrawings.bottom  = D("Line",{Visible=false,Color=State.CrosshairColor,Thickness=1,Transparency=1})
    CrosshairDrawings.left    = D("Line",{Visible=false,Color=State.CrosshairColor,Thickness=1,Transparency=1})
    CrosshairDrawings.right   = D("Line",{Visible=false,Color=State.CrosshairColor,Thickness=1,Transparency=1})
    CrosshairDrawings.topO    = D("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=2.5,Transparency=1})
    CrosshairDrawings.bottomO = D("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=2.5,Transparency=1})
    CrosshairDrawings.leftO   = D("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=2.5,Transparency=1})
    CrosshairDrawings.rightO  = D("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=2.5,Transparency=1})
end

local function UpdateCrosshair()
    local vis = State.CrosshairEnabled
    local vp  = Camera.ViewportSize
    local cx  = vp.X/2
    local cy  = vp.Y/2
    local s   = State.CrosshairSize
    local gap = 4
    local col = State.CrosshairColor
    local th  = State.CrosshairThick
    local function setLine(line, outline, fx, fy, tx, ty)
        if outline then
            DS(outline,"Visible",vis) DS(outline,"From",Vector2.new(fx,fy))
            DS(outline,"To",Vector2.new(tx,ty)) DS(outline,"Thickness",th+1.5)
        end
        DS(line,"Visible",vis) DS(line,"Color",col) DS(line,"Thickness",th)
        DS(line,"From",Vector2.new(fx,fy)) DS(line,"To",Vector2.new(tx,ty))
    end
    setLine(CrosshairDrawings.top,    CrosshairDrawings.topO,    cx,cy-gap,  cx,cy-gap-s)
    setLine(CrosshairDrawings.bottom, CrosshairDrawings.bottomO, cx,cy+gap,  cx,cy+gap+s)
    setLine(CrosshairDrawings.left,   CrosshairDrawings.leftO,   cx-gap,cy,  cx-gap-s,cy)
    setLine(CrosshairDrawings.right,  CrosshairDrawings.rightO,  cx+gap,cy,  cx+gap+s,cy)
end

-- ██████████████████████████████████████████████████████████████████████████
-- FULLBRIGHT / FOG
-- ██████████████████████████████████████████████████████████████████████████

local OrigBright=1
local OrigAmb=Color3.new(0,0,0)
local OrigOut=Color3.new(0,0,0)
local OrigFog=100000

local function EnableFullbright()
    OrigBright=Lighting.Brightness OrigAmb=Lighting.Ambient
    OrigOut=Lighting.OutdoorAmbient OrigFog=Lighting.FogEnd
    Lighting.Brightness=10 Lighting.Ambient=Color3.new(1,1,1)
    Lighting.OutdoorAmbient=Color3.new(1,1,1)
    Lighting.GlobalShadows=false Lighting.FogEnd=1e9
end
local function DisableFullbright()
    Lighting.Brightness=OrigBright Lighting.Ambient=OrigAmb
    Lighting.OutdoorAmbient=OrigOut Lighting.GlobalShadows=true
    if not State.NoFogEnabled then Lighting.FogEnd=OrigFog end
end
local function EnableNoFog()
    OrigFog=Lighting.FogEnd
    Lighting.FogEnd=1e9 Lighting.FogStart=1e9
end
local function DisableNoFog()
    if not State.FullbrightEnabled then
        Lighting.FogEnd=OrigFog Lighting.FogStart=0
    end
end

-- ██████████████████████████████████████████████████████████████████████████
-- FOV
-- ██████████████████████████████████████████████████████████████████████████

local function TweenFOV(target)
    if State.FOVTween then State.FOVTween:Cancel(); State.FOVTween=nil end
    local tw = TweenService:Create(Camera,
        TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {FieldOfView=target})
    State.FOVTween=tw; tw:Play()
end

local function InitFOV()
    Track(Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        if not State.FOVEnabled then return end
        if State.FOVTween and State.FOVTween.PlaybackState==Enum.PlaybackState.Playing then return end
        if math.abs(Camera.FieldOfView-State.FOVValue)>0.5 then Camera.FieldOfView=State.FOVValue end
    end))
    Track(LocalPlayer.CharacterAdded:Connect(function()
        if State.FOVEnabled then task.wait(0.2); TweenFOV(State.FOVValue) end
    end))
end

-- ██████████████████████████████████████████████████████████████████████████
-- ENTITY TRACKERS
-- ██████████████████████████████████████████████████████████████████████████

local function InitPlayers()
    for _, p in ipairs(Players:GetPlayers()) do AddP(p) end
    Track(Players.PlayerAdded:Connect(function(p) AddP(p); RefreshCharSet() end))
    Track(Players.PlayerRemoving:Connect(function(p) DropP(p); RefreshCharSet() end))
    Track(LocalPlayer.CharacterAdded:Connect(function() task.defer(RefreshCharSet) end))
end

local function InitNextbots()
    for m in pairs(ScanNextbots()) do AddN(m) end
    Track(Workspace.ChildAdded:Connect(function(c)
        task.defer(function()
            if not c or not c.Parent then return end
            RefreshCharSet()
            if IsNextbot(c) then AddN(c)
            elseif c:IsA("Folder") or c:IsA("Model") then
                task.wait(0.3)
                for m in pairs(ScanNextbots()) do AddN(m) end
            end
        end)
    end))
    Track(Workspace.ChildRemoved:Connect(function(c) if NB[c] then DropN(c) end end))
    task.spawn(function()
        while task.wait(5) do
            RefreshCharSet()
            for m in pairs(ScanNextbots()) do AddN(m) end
            for m in pairs(NB) do
                if not m or not m.Parent then DropN(m) end
            end
        end
    end)
end

-- ██████████████████████████████████████████████████████████████████████████
-- RENDER LOOP
-- ██████████████████████████████████████████████████████████████████████████

local function StartRender()
    Track(RunService.RenderStepped:Connect(function(dt)
        for plr, bundle in pairs(PB) do
            if State.PlayerESP and plr~=LocalPlayer and plr.Character and plr.Character.Parent then
                RenderBundle(bundle, plr.Character, plr.DisplayName,
                    {boxes=State.PlayerBoxes,names=State.PlayerNames,
                     distance=State.PlayerDistance,tracers=State.PlayerTracers},
                    State.PlayerColor)
            else BHide(bundle) end
        end
        for model, bundle in pairs(NB) do
            if State.NextbotESP and model and model.Parent then
                RenderBundle(bundle, model, model.Name,
                    {boxes=State.NextbotBoxes,names=State.NextbotNames,
                     distance=State.NextbotDistance,tracers=State.NextbotTracers},
                    State.NextbotColor)
            else
                BHide(bundle)
                if not model or not model.Parent then task.defer(function() DropN(model) end) end
            end
        end
        UpdateRadar()
        if State.CrosshairEnabled then UpdateCrosshair() end
        UpdateFPS(dt)
    end))
end

-- ██████████████████████████████████████████████████████████████████████████
-- GUI TABS
-- ██████████████████████████████████████████████████████████████████████████

local PT = Win:CreateTab("Players","user")
PT:CreateSection("Player ESP")
PT:CreateToggle({Name="Enable Player ESP",CurrentValue=false,Flag="PE",
    Callback=function(v) State.PlayerESP=v; if not v then for _,b in pairs(PB) do BHide(b) end end end})
PT:CreateToggle({Name="Boxes",    CurrentValue=true,Flag="PBX",Callback=function(v) State.PlayerBoxes=v end})
PT:CreateToggle({Name="Names",    CurrentValue=true,Flag="PNM",Callback=function(v) State.PlayerNames=v end})
PT:CreateToggle({Name="Distance", CurrentValue=true,Flag="PDS",Callback=function(v) State.PlayerDistance=v end})
PT:CreateToggle({Name="Tracers",  CurrentValue=true,Flag="PTR",Callback=function(v) State.PlayerTracers=v end})
PT:CreateColorPicker({Name="Color",Color=Color3.fromRGB(0,170,255),Flag="PCOL",
    Callback=function(v) State.PlayerColor=v; for _,b in pairs(PB) do BRecolor(b,v) end end})

local NT = Win:CreateTab("Nextbots","zap")
NT:CreateSection("Nextbot ESP")
NT:CreateToggle({Name="Enable Nextbot ESP",CurrentValue=false,Flag="NE",
    Callback=function(v) State.NextbotESP=v; if not v then for _,b in pairs(NB) do BHide(b) end end end})
NT:CreateToggle({Name="Boxes",    CurrentValue=true,Flag="NBX",Callback=function(v) State.NextbotBoxes=v end})
NT:CreateToggle({Name="Names",    CurrentValue=true,Flag="NNM",Callback=function(v) State.NextbotNames=v end})
NT:CreateToggle({Name="Distance", CurrentValue=true,Flag="NDS",Callback=function(v) State.NextbotDistance=v end})
NT:CreateToggle({Name="Tracers",  CurrentValue=true,Flag="NTR",Callback=function(v) State.NextbotTracers=v end})
NT:CreateColorPicker({Name="Color",Color=Color3.fromRGB(255,50,50),Flag="NCOL",
    Callback=function(v) State.NextbotColor=v; for _,b in pairs(NB) do BRecolor(b,v) end end})
NT:CreateButton({Name="Force Rescan",Callback=function()
    local n=0; for m in pairs(ScanNextbots()) do AddN(m); n=n+1 end
    Rayfield:Notify({Title="Rescan",Content=n.." nextbot(s)",Duration=3}) end})

local VT = Win:CreateTab("Visuals","eye")
VT:CreateSection("Radar")
VT:CreateToggle({Name="Enable Radar",CurrentValue=false,Flag="RAD",
    Callback=function(v)
        State.RadarEnabled=v
        if not v then
            SetRadarVisible(false)
            for _,d in pairs(RadarDrawings.dots) do DS(d,"Visible",false) end
        end
    end})
VT:CreateSection("Crosshair")
VT:CreateToggle({Name="Enable Crosshair",CurrentValue=false,Flag="CHR",
    Callback=function(v)
        State.CrosshairEnabled=v
        if not v then for _,d in pairs(CrosshairDrawings) do DS(d,"Visible",false) end end
    end})
VT:CreateSlider({Name="Size",Range={4,30},Increment=1,CurrentValue=10,Flag="CHS",
    Callback=function(v) State.CrosshairSize=v end})
VT:CreateSlider({Name="Thickness",Range={1,4},Increment=1,CurrentValue=1,Flag="CHT",
    Callback=function(v) State.CrosshairThick=v end})
VT:CreateColorPicker({Name="Crosshair Color",Color=Color3.new(1,1,1),Flag="CHCOL",
    Callback=function(v) State.CrosshairColor=v end})
VT:CreateSection("Environment")
VT:CreateToggle({Name="Fullbright",CurrentValue=false,Flag="FB",
    Callback=function(v) State.FullbrightEnabled=v; if v then EnableFullbright() else DisableFullbright() end end})
VT:CreateToggle({Name="No Fog",CurrentValue=false,Flag="NF",
    Callback=function(v) State.NoFogEnabled=v; if v then EnableNoFog() else DisableNoFog() end end})
VT:CreateSection("FPS Counter")
VT:CreateToggle({Name="Enable FPS Counter",CurrentValue=false,Flag="FPS",
    Callback=function(v)
        State.FPSEnabled=v
        if not v then DS(FPSDrawing,"Visible",false) end
    end})

local FT = Win:CreateTab("FOV","camera")
FT:CreateSection("Field of View")
FT:CreateToggle({Name="Enable FOV",CurrentValue=false,Flag="FOVE",
    Callback=function(v)
        State.FOVEnabled=v
        if v then State.OriginalFOV=Camera.FieldOfView; TweenFOV(State.FOVValue)
        else TweenFOV(State.OriginalFOV) end
    end})
FT:CreateSlider({Name="FOV",Range={70,120},Increment=1,Suffix="°",CurrentValue=70,Flag="FOVS",
    Callback=function(v) State.FOVValue=v; if State.FOVEnabled then TweenFOV(v) end end})
FT:CreateButton({Name="Reset to 70°",Callback=function()
    State.FOVValue=70; if State.FOVEnabled then TweenFOV(70) end
    Rayfield:Notify({Title="FOV",Content="Reset to 70°",Duration=2}) end})

local ST = Win:CreateTab("Settings","settings")
ST:CreateSection("Info")
ST:CreateParagraph({Title="Keybind",Content="RightShift — Hide / Show GUI"})
ST:CreateSection("Actions")
ST:CreateButton({Name="Destroy & Cleanup",Callback=function()
    DisconnectAll(); ClearAll()
    DisableFullbright(); DisableNoFog()
    if State.FOVEnabled then Camera.FieldOfView=State.OriginalFOV end
    for _,d in pairs(CrosshairDrawings) do DR(d) end
    SetRadarVisible(false)
    for _,dot in pairs(RadarDrawings.dots) do DR(dot) end
    DR(FPSDrawing)
    Rayfield:Destroy()
end})

-- ██████████████████████████████████████████████████████████████████████████
-- RIGHTSHIFT — direct ScreenGui toggle, not Rayfield:Toggle()
-- ██████████████████████████████████████████████████████████████████████████

Track(UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleGUI()
    end
end))

-- ██████████████████████████████████████████████████████████████████████████
-- BOOT
-- ██████████████████████████████████████████████████████████████████████████

InitFOV()
InitPlayers()
InitNextbots()
InitRadar()
InitCrosshair()
StartRender()

Rayfield:Notify({
    Title   = "Evade | Visuals",
    Content = "Ready. RightShift = hide GUI.",
    Duration = 4,
})
