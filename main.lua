local _0x01AB = game:GetService("Players")
local _0x1A80 = game:GetService("RunService")
local _0x6BC1 = game:GetService("TweenService")
local _0x9748 = game:GetService("UserInputService")
local _0x7B18 = game:GetService("Lighting")
local _0x2283 = game:GetService("Workspace")
local _0x7183 = _0x01AB.LocalPlayer
local _0xF314 = _0x2283.CurrentCamera
local _0x0015 = loadstring(
game:HttpGet("https://sirius.menu/rayfield")
)()local _0x5D7B = {PlayerESP = false,
PlayerBoxes = true,
PlayerNames = true,
PlayerDistance = true,
PlayerTracers = true,
PlayerColor = Color3.fromRGB(0, 170, 255),NextbotESP = false,
NextbotBoxes = true,
NextbotNames = true,
NextbotDistance = true,
NextbotTracers = true,
NextbotColor = Color3.fromRGB(255, 50, 50),FOVEnabled = false,
FOVValue = 70,
OriginalFOV = 70,
FOVTween = nil,WalkspeedEnabled = false,
WalkspeedValue = 16,
OriginalSpeed = 16,
JumpEnabled = false,
JumpValue = 50,
OriginalJump = 50,RadarEnabled = false,
RadarSize = 200,FullbrightEnabled = false,
OriginalBrightness = 1,
OriginalAmbient = Color3.new(0,0,0),
OriginalOutdoor = Color3.new(0,0,0),
OriginalFogEnd = 100000,NoFogEnabled = false,CrosshairEnabled = false,
CrosshairColor = Color3.fromRGB(255, 255, 255),
CrosshairSize = 10,
CrosshairThick = 1,
}local _0x3B30 = {}
local function _0x8B91(_0xCA67) table.insert(_0x3B30, _0xCA67); return _0xCA67 end
local function _0xBD6C()
for _, _0xCA67 in ipairs(_0x3B30) do
pcall(function()
if typeof(_0xCA67) =="RBXScriptConnection"then _0xCA67:Disconnect() end
end)
end
table.clear(_0x3B30)
endlocal function _0x17C6(class, props)
local _0xCEA3, _0x062B = pcall(Drawing.new, class)
if not _0xCEA3 then return nil end
for k, v in pairs(props) do pcall(function() _0x062B[k] = v end) end
return _0x062B
end
local function _0xC27F(o,k,v) if o then pcall(function() o[k]=v end) end end
local function _0xE804(o) if o then pcall(function() o:Remove() end) end endlocal function _0xCCAC(color)
return {
box = _0x17C6("Square",{Visible=false,Color=color,Thickness=2,Filled=false,Transparency=1}),
outline = _0x17C6("Square",{Visible=false,Color=Color3.new(0,0,0),Thickness=3.5,Filled=false,Transparency=1}),
name = _0x17C6("Text", {Visible=false,Color=Color3.new(1,1,1),OutlineColor=Color3.new(0,0,0),Outline=true,Center=true,Size=14,Text=""}),
dist = _0x17C6("Text", {Visible=false,Color=color,OutlineColor=Color3.new(0,0,0),Outline=true,Center=true,Size=13,Text=""}),
tracer = _0x17C6("Line", {Visible=false,Color=color,Thickness=1.2,Transparency=1}),
}
end
local function _0xE5C4(b)
if not b then return end
_0xC27F(b.box,"Visible",false) _0xC27F(b.outline,"Visible",false)
_0xC27F(b.name,"Visible",false) _0xC27F(b.dist,"Visible",false) _0xC27F(b.tracer,"Visible",false)
end
local function _0x9987(b)
if not b then return end
_0xE804(b.box) _0xE804(b.outline) _0xE804(b.name) _0xE804(b.dist) _0xE804(b.tracer)
end
local function _0xBE45(b,_0xCA67)
if not b then return end
_0xC27F(b.box,"Color",_0xCA67) _0xC27F(b.dist,"Color",_0xCA67) _0xC27F(b.tracer,"Color",_0xCA67)
endlocal function _0x2BF6(character)
local _0x0678 = character:FindFirstChild("HumanoidRootPart")
if not _0x0678 then return nil end
local _0xD4D0 = _0x0678.Position
local _0xDB5B = _0xF314:WorldToViewportPoint(_0xD4D0 + Vector3.new(0, 3.5, 0))
local _0x9AC5 = _0xF314:WorldToViewportPoint(_0xD4D0 - Vector3.new(0, 3.2, 0))
if _0xDB5B.Z < 0 and _0x9AC5.Z < 0 then return nil end
local _0xDEF7 = Vector2.new(_0xDB5B.X, _0xDB5B.Y)
local _0x24E5 = Vector2.new(_0x9AC5.X, _0x9AC5.Y)
local _0xB76A = math.max(math.abs(_0xDEF7.Y - _0x24E5.Y), 10)
local _0x023D = _0xB76A * 0.45
local _0xDE93 = (_0xDEF7.X + _0x24E5.X) / 2
return {
_0xDEF7=_0xDEF7, _0x24E5=_0x24E5, _0xB76A=_0xB76A, _0x023D=_0x023D, _0xDE93=_0xDE93,
hrpPos=_0xD4D0,
dist=math.floor((_0xF314.CFrame.Position - _0xD4D0).Magnitude),
}
end
local function _0x7EF4()
local _0x9D08 = _0xF314.ViewportSize
return Vector2.new(_0x9D08.X/2, _0x9D08.Y - 8)
end
local function _0x8344(b, char, label, cfg, color)
local _0xCE47 = _0x2BF6(char)
if not _0xCE47 then _0xE5C4(b); return end
local _0xEBBC = _0xCE47.cx - _0xCE47.w/2
if cfg.boxes then
if b.outline then b.outline.Visible=true b.outline.Size=Vector2.new(_0xCE47.w+2,_0xCE47.h+2) b.outline.Position=Vector2.new(_0xEBBC-1,_0xCE47.topV.Y-1) end
if b.box then b.box.Visible=true b.box.Color=color b.box.Size=Vector2.new(_0xCE47.w,_0xCE47.h) b.box.Position=Vector2.new(_0xEBBC,_0xCE47.topV.Y) end
else _0xC27F(b.outline,"Visible",false) _0xC27F(b.box,"Visible",false) end
if cfg.names and b.name then b.name.Visible=true b.name.Text=label b.name.Position=Vector2.new(_0xCE47.cx,_0xCE47.topV.Y-17) else _0xC27F(b.name,"Visible",false) end
if cfg.distance and b.dist then b.dist.Visible=true b.dist.Color=color b.dist.Text=_0xCE47.dist.."m"b.dist.Position=Vector2.new(_0xCE47.cx,_0xCE47.botV.Y+3) else _0xC27F(b.dist,"Visible",false) end
if cfg.tracers and b.tracer then b.tracer.Visible=true b.tracer.Color=color b.tracer.From=_0x7EF4() b.tracer.To=_0xCE47.botV else _0xC27F(b.tracer,"Visible",false) end
endlocal _0x24D5 = {
bg = nil,
border = nil,
label = nil,
dots = {},}
local function _0xB051()
local _0x9D08 = _0xF314.ViewportSize
local _0x9A9E = _0x5D7B.RadarSize
local _0xF57E = 10
local _0x7FE5 = _0x9D08.X - _0x9A9E - _0xF57E
local _0xF907 = _0xF57E
_0x24D5.bg = _0x17C6("Square",{
Visible=false, Color=Color3.fromRGB(15,15,20),
Size=Vector2.new(_0x9A9E,_0x9A9E), Position=Vector2.new(_0x7FE5,_0xF907),
Filled=true, Transparency=0.35,
})
_0x24D5.border = _0x17C6("Square",{
Visible=false, Color=Color3.fromRGB(60,60,80),
Size=Vector2.new(_0x9A9E,_0x9A9E), Position=Vector2.new(_0x7FE5,_0xF907),
Filled=false, Thickness=1.5, Transparency=1,
})
_0x24D5.label = _0x17C6("Text",{
Visible=false, Text="RADAR",
Color=Color3.fromRGB(180,180,220),
OutlineColor=Color3.new(0,0,0), Outline=true,
Center=true, Size=11,
Position=Vector2.new(_0x7FE5 + _0x9A9E/2, _0xF907 + 3),
})_0x24D5.crossH = _0x17C6("Line",{
Visible=false, Color=Color3.fromRGB(50,50,70),
Thickness=1, Transparency=1,
From=Vector2.new(_0x7FE5, _0xF907+_0x9A9E/2),
To=Vector2.new(_0x7FE5+_0x9A9E, _0xF907+_0x9A9E/2),
})
_0x24D5.crossV = _0x17C6("Line",{
Visible=false, Color=Color3.fromRGB(50,50,70),
Thickness=1, Transparency=1,
From=Vector2.new(_0x7FE5+_0x9A9E/2, _0xF907),
To=Vector2.new(_0x7FE5+_0x9A9E/2, _0xF907+_0x9A9E),
})
end
local function _0xD91B(_0x3BFA)
_0xC27F(_0x24D5.bg,"Visible", _0x3BFA)
_0xC27F(_0x24D5.border,"Visible", _0x3BFA)
_0xC27F(_0x24D5.label,"Visible", _0x3BFA)
_0xC27F(_0x24D5.crossH,"Visible", _0x3BFA)
_0xC27F(_0x24D5.crossV,"Visible", _0x3BFA)
end
local function _0x09C1(_0x849E, color, _0x9A9E)
if not _0x24D5.dots[_0x849E] then
_0x24D5.dots[_0x849E] = _0x17C6("Square",{
Visible=false, Color=color, Filled=true,
Size=Vector2.new(_0x9A9E,_0x9A9E), Transparency=1,
})
end
return _0x24D5.dots[_0x849E]
end
local function _0xBBC2(_0x849E)
if _0x24D5.dots[_0x849E] then
_0xE804(_0x24D5.dots[_0x849E])
_0x24D5.dots[_0x849E] = nil
end
endlocal _0x85B4 = 300
local function _0x3347()
if not _0x5D7B.RadarEnabled then
_0xD91B(false)
for _0x849E, _0x83FB in pairs(_0x24D5.dots) do
_0xC27F(_0x83FB,"Visible",false)
end
return
end
_0xD91B(true)
local _0x9D08 = _0xF314.ViewportSize
local _0x9A9E = _0x5D7B.RadarSize
local _0xF57E = 10
local _0x7FE5 = _0x9D08.X - _0x9A9E - _0xF57E
local _0xF907 = _0xF57E
local _0xDE93 = _0x7FE5 + _0x9A9E/2
local _0x03AF = _0xF907 + _0x9A9E/2_0xC27F(_0x24D5.bg,"Position", Vector2.new(_0x7FE5, _0xF907))
_0xC27F(_0x24D5.border,"Position", Vector2.new(_0x7FE5, _0xF907))
_0xC27F(_0x24D5.label,"Position", Vector2.new(_0xDE93, _0xF907+3))
_0xC27F(_0x24D5.crossH,"From", Vector2.new(_0x7FE5, _0x03AF))
_0xC27F(_0x24D5.crossH,"To", Vector2.new(_0x7FE5+_0x9A9E, _0x03AF))
_0xC27F(_0x24D5.crossV,"From", Vector2.new(_0xDE93, _0xF907))
_0xC27F(_0x24D5.crossV,"To", Vector2.new(_0xDE93, _0xF907+_0x9A9E))
local _0x47D5 = _0x7183.Character
local _0x081F = _0x47D5 and _0x47D5:FindFirstChild("HumanoidRootPart")
if not _0x081F then return end
local _0x3D8F = _0x081F.CFrame
local _0x5CFA = _0x081F.Position
local _0x0B65 = {}for _, p in ipairs(_0x01AB:GetPlayers()) do
if p ~= _0x7183 and p.Character then
local _0x0678 = p.Character:FindFirstChild("HumanoidRootPart")
if _0x0678 then
local _0x849E ="p_"..p.UserId
_0x0B65[_0x849E] = true
local _0x83FB = _0x09C1(_0x849E, _0x5D7B.PlayerColor, 5)
local _0x027B = _0x3D8F:PointToObjectSpace(_0x0678.Position)
local _0x8E12 = _0xDE93 + (_0x027B.X / _0x85B4) * (_0x9A9E/2)
local _0x427A = _0x03AF - (_0x027B.Z / _0x85B4) * (_0x9A9E/2)_0x8E12 = math.clamp(_0x8E12, _0x7FE5+3, _0x7FE5+_0x9A9E-3)
_0x427A = math.clamp(_0x427A, _0xF907+3, _0xF907+_0x9A9E-3)
_0x83FB.Visible = true
_0x83FB.Color = _0x5D7B.PlayerColor
_0x83FB.Position = Vector2.new(_0x8E12-2, _0x427A-2)
end
end
endfor model, _ in pairs(NB) do
if model and model.Parent then
local _0x0678 = model:FindFirstChild("HumanoidRootPart")
if _0x0678 then
local _0x849E ="n_"..model:GetDebugId()
_0x0B65[_0x849E] = true
local _0x83FB = _0x09C1(_0x849E, _0x5D7B.NextbotColor, 6)
local _0x027B = _0x3D8F:PointToObjectSpace(_0x0678.Position)
local _0x8E12 = _0xDE93 + (_0x027B.X / _0x85B4) * (_0x9A9E/2)
local _0x427A = _0x03AF - (_0x027B.Z / _0x85B4) * (_0x9A9E/2)
_0x8E12 = math.clamp(_0x8E12, _0x7FE5+3, _0x7FE5+_0x9A9E-3)
_0x427A = math.clamp(_0x427A, _0xF907+3, _0xF907+_0x9A9E-3)
_0x83FB.Visible = true
_0x83FB.Color = _0x5D7B.NextbotColor
_0x83FB.Position = Vector2.new(_0x8E12-3, _0x427A-3)
end
end
endlocal _0x422C ="self"_0x0B65[_0x422C] = true
local _0x157B = _0x09C1(_0x422C, Color3.new(1,1,1), 5)
_0x157B.Visible = true
_0x157B.Position = Vector2.new(_0xDE93-2, _0x03AF-2)for _0x849E, _0x83FB in pairs(_0x24D5.dots) do
if not _0x0B65[_0x849E] then
_0xC27F(_0x83FB,"Visible",false)
end
end
endlocal _0xA9BC = {}
local function _0xA1ED()_0xA9BC.top = _0x17C6("Line",{Visible=false,Color=_0x5D7B.CrosshairColor,Thickness=_0x5D7B.CrosshairThick,Transparency=1})
_0xA9BC.bottom = _0x17C6("Line",{Visible=false,Color=_0x5D7B.CrosshairColor,Thickness=_0x5D7B.CrosshairThick,Transparency=1})
_0xA9BC.left = _0x17C6("Line",{Visible=false,Color=_0x5D7B.CrosshairColor,Thickness=_0x5D7B.CrosshairThick,Transparency=1})
_0xA9BC.right = _0x17C6("Line",{Visible=false,Color=_0x5D7B.CrosshairColor,Thickness=_0x5D7B.CrosshairThick,Transparency=1})_0xA9BC.topO = _0x17C6("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=_0x5D7B.CrosshairThick+1.5,Transparency=1})
_0xA9BC.bottomO = _0x17C6("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=_0x5D7B.CrosshairThick+1.5,Transparency=1})
_0xA9BC.leftO = _0x17C6("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=_0x5D7B.CrosshairThick+1.5,Transparency=1})
_0xA9BC.rightO = _0x17C6("Line",{Visible=false,Color=Color3.new(0,0,0),Thickness=_0x5D7B.CrosshairThick+1.5,Transparency=1})
end
local function _0xD523()
local _0x3BFA = _0x5D7B.CrosshairEnabled
local _0x9D08 = _0xF314.ViewportSize
local _0xDE93 = _0x9D08.X / 2
local _0x03AF = _0x9D08.Y / 2
local _0xC679 = _0x5D7B.CrosshairSize
local _0x67A7 = 4
local _0xDFC2 = _0x5D7B.CrosshairColor
local _0xE92E = _0x5D7B.CrosshairThick
local function _0x900D(line, outline, fx, fy, tx, ty)
if outline then
_0xC27F(outline,"Visible", _0x3BFA)
_0xC27F(outline,"From", Vector2.new(fx,fy))
_0xC27F(outline,"To", Vector2.new(tx,ty))
_0xC27F(outline,"Thickness", _0xE92E+1.5)
end
_0xC27F(line,"Visible", _0x3BFA)
_0xC27F(line,"Color", _0xDFC2)
_0xC27F(line,"Thickness", _0xE92E)
_0xC27F(line,"From", Vector2.new(fx,fy))
_0xC27F(line,"To", Vector2.new(tx,ty))
end
_0x900D(_0xA9BC.top, _0xA9BC.topO, _0xDE93, _0x03AF-_0x67A7, _0xDE93, _0x03AF-_0x67A7-_0xC679)
_0x900D(_0xA9BC.bottom, _0xA9BC.bottomO, _0xDE93, _0x03AF+_0x67A7, _0xDE93, _0x03AF+_0x67A7+_0xC679)
_0x900D(_0xA9BC.left, _0xA9BC.leftO, _0xDE93-_0x67A7, _0x03AF, _0xDE93-_0x67A7-_0xC679, _0x03AF)
_0x900D(_0xA9BC.right, _0xA9BC.rightO, _0xDE93+_0x67A7, _0x03AF, _0xDE93+_0x67A7+_0xC679, _0x03AF)
end
local function _0x968D()
for _, d in pairs(_0xA9BC) do _0xE804(d) end
endlocal function _0x6349()
_0x5D7B.OriginalBrightness = _0x7B18.Brightness
_0x5D7B.OriginalAmbient = _0x7B18.Ambient
_0x5D7B.OriginalOutdoor = _0x7B18.OutdoorAmbient
_0x7B18.Brightness = 10
_0x7B18.Ambient = Color3.new(1, 1, 1)
_0x7B18.OutdoorAmbient = Color3.new(1, 1, 1)
_0x7B18.GlobalShadows = false
_0x7B18.FogEnd = 1e9
end
local function _0x3D67()
_0x7B18.Brightness = _0x5D7B.OriginalBrightness
_0x7B18.Ambient = _0x5D7B.OriginalAmbient
_0x7B18.OutdoorAmbient = _0x5D7B.OriginalOutdoor
_0x7B18.GlobalShadows = true
if not _0x5D7B.NoFogEnabled then
_0x7B18.FogEnd = _0x5D7B.OriginalFogEnd
end
endlocal function _0x7CEE()
_0x5D7B.OriginalFogEnd = _0x7B18.FogEnd
_0x7B18.FogEnd = 1e9
_0x7B18.FogStart = 1e9
end
local function _0xB800()
if not _0x5D7B.FullbrightEnabled then
_0x7B18.FogEnd = _0x5D7B.OriginalFogEnd
_0x7B18.FogStart = 0
end
endlocal _0x30D4 = nil
local function _0xB55B(speed)
local _0xCA67 = _0x7183.Character
if not _0xCA67 then return end
local _0xB76A = _0xCA67:FindFirstChildOfClass("Humanoid")
if _0xB76A then _0xB76A.WalkSpeed = speed end
end
local function _0x9B5B(power)
local _0xCA67 = _0x7183.Character
if not _0xCA67 then return end
local _0xB76A = _0xCA67:FindFirstChildOfClass("Humanoid")
if _0xB76A then _0xB76A.JumpPower = power end
end
local function _0xEEE4()
local _0xCA67 = _0x7183.Character
if _0xCA67 then
local _0xB76A = _0xCA67:FindFirstChildOfClass("Humanoid")
if _0xB76A then
_0x5D7B.OriginalSpeed = _0xB76A.WalkSpeed
_0x5D7B.OriginalJump = _0xB76A.JumpPower
end
end
if _0x30D4 then _0x30D4:Disconnect() end
_0x30D4 = _0x1A80.Heartbeat:Connect(function()
local _0x2018 = _0x7183.Character
if not _0x2018 then return end
local _0x1BCB = _0x2018:FindFirstChildOfClass("Humanoid")
if not _0x1BCB then return end
if _0x5D7B.WalkspeedEnabled and math.abs(_0x1BCB.WalkSpeed - _0x5D7B.WalkspeedValue) > 0.5 then
_0x1BCB.WalkSpeed = _0x5D7B.WalkspeedValue
end
if _0x5D7B.JumpEnabled and math.abs(_0x1BCB.JumpPower - _0x5D7B.JumpValue) > 0.5 then
_0x1BCB.JumpPower = _0x5D7B.JumpValue
end
end)
table.insert(_0x3B30, _0x30D4)
_0x8B91(_0x7183.CharacterAdded:Connect(function(char)
task.wait(0.1)
local _0x1BCB = char:FindFirstChildOfClass("Humanoid")
if not _0x1BCB then return end
if _0x5D7B.WalkspeedEnabled then _0x1BCB.WalkSpeed = _0x5D7B.WalkspeedValue end
if _0x5D7B.JumpEnabled then _0x1BCB.JumpPower = _0x5D7B.JumpValue end
end))
endlocal function _0x0B14(target)
if _0x5D7B.FOVTween then _0x5D7B.FOVTween:Cancel(); _0x5D7B.FOVTween=nil end
local _0x37C7 = _0x6BC1:Create(_0xF314,
TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
{FieldOfView=target})
_0x5D7B.FOVTween=_0x37C7; _0x37C7:Play()
end
local function _0x0029()
_0x8B91(_0xF314:GetPropertyChangedSignal("FieldOfView"):Connect(function()
if not _0x5D7B.FOVEnabled then return end
if _0x5D7B.FOVTween and _0x5D7B.FOVTween.PlaybackState==Enum.PlaybackState.Playing then return end
if math.abs(_0xF314.FieldOfView-_0x5D7B.FOVValue)>0.5 then _0xF314.FieldOfView=_0x5D7B.FOVValue end
end))
_0x8B91(_0x7183.CharacterAdded:Connect(function()
if _0x5D7B.FOVEnabled then task.wait(0.2); _0x0B14(_0x5D7B.FOVValue) end
end))
endlocal _0xDB6D = {Baseplate=true,Terrain=true,_0xF314=true,SpawnLocation=true}
local _0xEDAF = {}
local function _0x5CA7()
table.clear(_0xEDAF)
for _, p in ipairs(_0x01AB:GetPlayers()) do
if p.Character then _0xEDAF[p.Character] = true end
end
end
local function _0xE568(inst)
if not inst or not inst:IsA("Model") then return false end
if _0xDB6D[inst.Name] then return false end
if _0xEDAF[inst] then return false end
if _0x7183.Character == inst then return false end
return inst:FindFirstChild("HumanoidRootPart") ~= nil
end
local function _0xA192()
_0x5CA7()
local _0x96EA = {}
local function _0x372B(parent, depth)
if depth > 4 then return end
for _, child in ipairs(parent:GetChildren()) do
if child:IsA("Model") and _0xE568(child) then _0x96EA[child]=true
elseif child:IsA("Folder") or child:IsA("Model") then _0x372B(child,depth+1) end
end
end
_0x372B(_0x2283, 0)
return _0x96EA
endPB = {}
NB = {}
local function _0xABDD(p) if p==_0x7183 or PB[p] then return end PB[p]=_0xCCAC(_0x5D7B.PlayerColor) end
local function _0xBD9A(p) _0x9987(PB[p]); PB[p]=nil end
local function _0x32C3(m) if NB[m] then return end NB[m]=_0xCCAC(_0x5D7B.NextbotColor) end
local function _0x95C0(m) _0x9987(NB[m]); NB[m]=nil end
local function _0x29E2()
for _,b in pairs(PB) do _0x9987(b) end
for _,b in pairs(NB) do _0x9987(b) end
table.clear(PB); table.clear(NB)
endlocal function _0xF493()
for _, p in ipairs(_0x01AB:GetPlayers()) do _0xABDD(p) end
_0x8B91(_0x01AB.PlayerAdded:Connect(function(p) _0xABDD(p); _0x5CA7() end))
_0x8B91(_0x01AB.PlayerRemoving:Connect(function(p) _0xBD9A(p); _0x5CA7() end))
_0x8B91(_0x7183.CharacterAdded:Connect(function() task.defer(_0x5CA7) end))
end
local function _0x50EA()
for m in pairs(_0xA192()) do _0x32C3(m) end
_0x8B91(_0x2283.ChildAdded:Connect(function(_0xCA67)
task.defer(function()
if not _0xCA67 or not _0xCA67.Parent then return end
_0x5CA7()
if _0xE568(_0xCA67) then _0x32C3(_0xCA67)
elseif _0xCA67:IsA("Folder") or _0xCA67:IsA("Model") then
task.wait(0.3)
for m in pairs(_0xA192()) do _0x32C3(m) end
end
end)
end))
_0x8B91(_0x2283.ChildRemoved:Connect(function(_0xCA67) if NB[_0xCA67] then _0x95C0(_0xCA67) end end))
task.spawn(function()
while task.wait(5) do
_0x5CA7()
for m in pairs(_0xA192()) do _0x32C3(m) end
for m in pairs(NB) do
if not m or not m.Parent then _0x95C0(m) end
end
end
end)
endlocal function _0x1AB6()
_0x8B91(_0x1A80.RenderStepped:Connect(function()for plr, bundle in pairs(PB) do
if _0x5D7B.PlayerESP and plr~=_0x7183 and plr.Character and plr.Character.Parent then
_0x8344(bundle, plr.Character, plr.DisplayName,
{boxes=_0x5D7B.PlayerBoxes,names=_0x5D7B.PlayerNames,
distance=_0x5D7B.PlayerDistance,tracers=_0x5D7B.PlayerTracers},
_0x5D7B.PlayerColor)
else _0xE5C4(bundle) end
endfor model, bundle in pairs(NB) do
if _0x5D7B.NextbotESP and model and model.Parent then
_0x8344(bundle, model, model.Name,
{boxes=_0x5D7B.NextbotBoxes,names=_0x5D7B.NextbotNames,
distance=_0x5D7B.NextbotDistance,tracers=_0x5D7B.NextbotTracers},
_0x5D7B.NextbotColor)
else
_0xE5C4(bundle)
if not model or not model.Parent then task.defer(function() _0x95C0(model) end) end
end
end_0x3347()if _0x5D7B.CrosshairEnabled then _0xD523() end
end))
endlocal _0xC7BA = _0x0015:CreateWindow({
Name ="Evade | Visuals",
LoadingTitle ="Evade | Visuals",
LoadingSubtitle ="Loading...",
Theme ="Darker",
DisableRayfieldPrompts = true,
DisableBuildWarnings = true,
ConfigurationSaving = { Enabled = false },
KeySystem = false,
})local _0x1950 = _0xC7BA:CreateTab("Players","user")
_0x1950:CreateSection("Player ESP")
_0x1950:CreateToggle({Name="Enable Player ESP",CurrentValue=false,Flag="PE",
Callback=function(v) _0x5D7B.PlayerESP=v; if not v then for _,b in pairs(PB) do _0xE5C4(b) end end end})
_0x1950:CreateToggle({Name="Boxes", CurrentValue=true, Flag="PBX",Callback=function(v) _0x5D7B.PlayerBoxes=v end})
_0x1950:CreateToggle({Name="Names", CurrentValue=true, Flag="PNM",Callback=function(v) _0x5D7B.PlayerNames=v end})
_0x1950:CreateToggle({Name="Distance", CurrentValue=true, Flag="PDS",Callback=function(v) _0x5D7B.PlayerDistance=v end})
_0x1950:CreateToggle({Name="Tracers", CurrentValue=true, Flag="PTR",Callback=function(v) _0x5D7B.PlayerTracers=v end})
_0x1950:CreateColorPicker({Name="Color",Color=Color3.fromRGB(0,170,255),Flag="PCOL",
Callback=function(v) _0x5D7B.PlayerColor=v; for _,b in pairs(PB) do _0xBE45(b,v) end end})local _0x583C = _0xC7BA:CreateTab("Nextbots","zap")
_0x583C:CreateSection("Nextbot ESP")
_0x583C:CreateToggle({Name="Enable Nextbot ESP",CurrentValue=false,Flag="NE",
Callback=function(v) _0x5D7B.NextbotESP=v; if not v then for _,b in pairs(NB) do _0xE5C4(b) end end end})
_0x583C:CreateToggle({Name="Boxes", CurrentValue=true, Flag="NBX",Callback=function(v) _0x5D7B.NextbotBoxes=v end})
_0x583C:CreateToggle({Name="Names", CurrentValue=true, Flag="NNM",Callback=function(v) _0x5D7B.NextbotNames=v end})
_0x583C:CreateToggle({Name="Distance", CurrentValue=true, Flag="NDS",Callback=function(v) _0x5D7B.NextbotDistance=v end})
_0x583C:CreateToggle({Name="Tracers", CurrentValue=true, Flag="NTR",Callback=function(v) _0x5D7B.NextbotTracers=v end})
_0x583C:CreateColorPicker({Name="Color",Color=Color3.fromRGB(255,50,50),Flag="NCOL",
Callback=function(v) _0x5D7B.NextbotColor=v; for _,b in pairs(NB) do _0xBE45(b,v) end end})
_0x583C:CreateButton({Name="Force Rescan",Callback=function()
local _0x5DCB=0; for m in pairs(_0xA192()) do _0x32C3(m); _0x5DCB=_0x5DCB+1 end
_0x0015:Notify({Title="Rescan",Content=_0x5DCB.." nextbot(s)",Duration=3}) end})local _0xCB5B = _0xC7BA:CreateTab("Visuals","eye")
_0xCB5B:CreateSection("Radar")
_0xCB5B:CreateToggle({Name="Enable Radar",CurrentValue=false,Flag="RAD",
Callback=function(v)
_0x5D7B.RadarEnabled=v
if not v then
_0xD91B(false)
for _,_0x83FB in pairs(_0x24D5.dots) do _0xC27F(_0x83FB,"Visible",false) end
end
end})
_0xCB5B:CreateSlider({Name="Radar Range",Range={100,600},Increment=25,Suffix=" studs",CurrentValue=300,Flag="RADR",
Callback=function(v) _0x85B4=v end})
_0xCB5B:CreateSection("Crosshair")
_0xCB5B:CreateToggle({Name="Enable Crosshair",CurrentValue=false,Flag="CHR",
Callback=function(v)
_0x5D7B.CrosshairEnabled=v
if not v then
for _,d in pairs(_0xA9BC) do _0xC27F(d,"Visible",false) end
end
end})
_0xCB5B:CreateSlider({Name="Size",Range={4,30},Increment=1,CurrentValue=10,Flag="CHS",
Callback=function(v) _0x5D7B.CrosshairSize=v end})
_0xCB5B:CreateSlider({Name="Thickness",Range={1,4},Increment=1,CurrentValue=1,Flag="CHT",
Callback=function(v) _0x5D7B.CrosshairThick=v end})
_0xCB5B:CreateColorPicker({Name="Crosshair Color",Color=Color3.new(1,1,1),Flag="CHCOL",
Callback=function(v)
_0x5D7B.CrosshairColor=v
for k,d in pairs(_0xA9BC) do
if not string.find(k,"O") then _0xC27F(d,"Color",v) end
end
end})
_0xCB5B:CreateSection("Environment")
_0xCB5B:CreateToggle({Name="Fullbright",CurrentValue=false,Flag="FB",
Callback=function(v)
_0x5D7B.FullbrightEnabled=v
if v then _0x6349() else _0x3D67() end
end})
_0xCB5B:CreateToggle({Name="No Fog",CurrentValue=false,Flag="NF",
Callback=function(v)
_0x5D7B.NoFogEnabled=v
if v then _0x7CEE() else _0xB800() end
end})local _0xEFA4 = _0xC7BA:CreateTab("Movement","trending-up")
_0xEFA4:CreateSection("Walk Speed")
_0xEFA4:CreateToggle({Name="Enable Walkspeed",CurrentValue=false,Flag="WSE",
Callback=function(v)
_0x5D7B.WalkspeedEnabled=v
if v then _0xEEE4() else _0xB55B(_0x5D7B.OriginalSpeed) end
end})
_0xEFA4:CreateSlider({Name="Speed",Range={16,150},Increment=1,Suffix=" s/s",CurrentValue=16,Flag="WSV",
Callback=function(v) _0x5D7B.WalkspeedValue=v; if _0x5D7B.WalkspeedEnabled then _0xB55B(v) end end})
_0xEFA4:CreateSection("Jump Power")
_0xEFA4:CreateToggle({Name="Enable Jump",CurrentValue=false,Flag="JPE",
Callback=function(v)
_0x5D7B.JumpEnabled=v
if v then _0xEEE4() else _0x9B5B(_0x5D7B.OriginalJump) end
end})
_0xEFA4:CreateSlider({Name="Jump Power",Range={50,300},Increment=5,Suffix=" power",CurrentValue=50,Flag="JPV",
Callback=function(v) _0x5D7B.JumpValue=v; if _0x5D7B.JumpEnabled then _0x9B5B(v) end end})local _0x69F0 = _0xC7BA:CreateTab("FOV","camera")
_0x69F0:CreateSection("Field of View")
_0x69F0:CreateToggle({Name="Enable FOV",CurrentValue=false,Flag="FOVE",
Callback=function(v)
_0x5D7B.FOVEnabled=v
if v then _0x5D7B.OriginalFOV=_0xF314.FieldOfView; _0x0B14(_0x5D7B.FOVValue)
else _0x0B14(_0x5D7B.OriginalFOV) end
end})
_0x69F0:CreateSlider({Name="FOV",Range={70,120},Increment=1,Suffix="°",CurrentValue=70,Flag="FOVS",
Callback=function(v) _0x5D7B.FOVValue=v; if _0x5D7B.FOVEnabled then _0x0B14(v) end end})
_0x69F0:CreateButton({Name="Reset to 70°",Callback=function()
_0x5D7B.FOVValue=70; if _0x5D7B.FOVEnabled then _0x0B14(70) end
_0x0015:Notify({Title="FOV",Content="Reset to 70°",Duration=2}) end})local _0x89D2 = _0xC7BA:CreateTab("Settings","settings")
_0x89D2:CreateSection("Info")
_0x89D2:CreateParagraph({Title="Keybind",Content="RightShift — Hide / Show GUI"})
_0x89D2:CreateSection("Actions")
_0x89D2:CreateButton({Name="Destroy & Cleanup",Callback=function()
_0xBD6C(); _0x29E2()
_0x3D67(); _0xB800()
if _0x5D7B.WalkspeedEnabled then _0xB55B(_0x5D7B.OriginalSpeed) end
if _0x5D7B.JumpEnabled then _0x9B5B(_0x5D7B.OriginalJump) end
if _0x5D7B.FOVEnabled then _0xF314.FieldOfView = _0x5D7B.OriginalFOV end
_0x968D()
_0xD91B(false)
for _,_0x83FB in pairs(_0x24D5.dots) do _0xE804(_0x83FB) end
_0x0015:Destroy()
end})_0x8B91(_0x9748.InputBegan:Connect(function(i,gpe)
if gpe then return end
if i.KeyCode==Enum.KeyCode.RightShift then _0x0015:Toggle() end
end))_0x0029()
_0xF493()
_0x50EA()
_0xB051()
_0xA1ED()
_0xEEE4()
_0x1AB6()
_0x0015:Notify({
Title ="Evade | Visuals",
Content ="Ready. RightShift = hide GUI.",
Duration = 4,
})
