local P=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local RUN=game:GetService("RunService")
local SG=game:GetService("StarterGui")
local LP=P.LocalPlayer

local parent
pcall(function() parent=gethui and gethui() end)
if not parent then
    local ok,cg=pcall(function() return game:GetService("CoreGui") end)
    if ok then parent=cg end
end
if not parent then parent=LP:WaitForChild("PlayerGui") end

for _,n in ipairs({"ValriaHub","ValriaFOV","ValriaESP","ValriaItemESP"}) do
    local o=parent:FindFirstChild(n)
    if o then o:Destroy() end
end

local function ntf(a,b)
    pcall(function()
        SG:SetCore("SendNotification",{Title=tostring(a),Text=tostring(b),Duration=3})
    end)
end

local function fpr(p)
    if not (p and p:IsA("ProximityPrompt")) then return end
    if fireproximityprompt then
        if pcall(fireproximityprompt,p) then return end
    end
    pcall(function()
        local h,d,l=p.HoldDuration,p.MaxActivationDistance,p.RequiresLineOfSight
        p.HoldDuration=0
        p.MaxActivationDistance=1000
        p.RequiresLineOfSight=false
        p:InputHoldBegin()
        task.wait()
        p:InputHoldEnd()
        p.MaxActivationDistance=d
        p.HoldDuration=h
        p.RequiresLineOfSight=l
    end)
end

getgenv().SwimMethod=false
task.spawn(function()
    while task.wait() do
        if getgenv().SwimMethod then
            local c=LP.Character
            local h=c and c:FindFirstChildWhichIsA("Humanoid")
            if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.FallingDown) end) end
        end
    end
end)

local function tp(cf)
    local c=LP.Character
    local r=c and c:FindFirstChild("HumanoidRootPart")
    local h=c and c:FindFirstChildWhichIsA("Humanoid")
    if not r or not h or not cf then return end
    getgenv().SwimMethod=true
    pcall(function() h:ChangeState(Enum.HumanoidStateType.FallingDown) end)
    local t=os.clock()
    repeat task.wait() until not LP:GetAttribute("LastACPos") or (os.clock()-t>2.5)
    for i=1,3 do
        if not r.Parent then break end
        r.CFrame=cf
        r.AssemblyLinearVelocity=Vector3.zero
        r.AssemblyAngularVelocity=Vector3.zero
        task.wait()
    end
    pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    getgenv().SwimMethod=false
end

local function tpToPlayer(plr)
    if not plr or not plr.Character then return end
    local hr=plr.Character:FindFirstChild("HumanoidRootPart")
    if not hr then return end
    task.spawn(function()
        tp(hr.CFrame*CFrame.new(0,6,2))
        task.wait(0.35)
        local c=LP.Character
        local myRoot=c and c:FindFirstChild("HumanoidRootPart")
        if myRoot and hr and hr.Parent then
            myRoot.CFrame=hr.CFrame*CFrame.new(0,4,2)
            myRoot.AssemblyLinearVelocity=Vector3.zero
            myRoot.AssemblyAngularVelocity=Vector3.zero
        end
    end)
end

local function gM()
    local s=LP:FindFirstChild("stored")
    if s then
        for _,n in ipairs({"Money","Cash","Wallet","Coins"}) do
            local v=s:FindFirstChild(n)
            if v and v:IsA("ValueBase") then
                local x=tonumber(v.Value)
                if x then return x end
            end
        end
    end
    local ls=LP:FindFirstChild("leaderstats")
    if ls then
        for _,n in ipairs({"Money","Cash","Wallet","Coins"}) do
            local v=ls:FindFirstChild(n)
            if v and v:IsA("ValueBase") then
                local x=tonumber(v.Value)
                if x then return x end
            end
        end
    end
    return 0
end

local function fmt(n)
    n=math.floor(tonumber(n) or 0)
    local s=tostring(n)
    return "$"..s:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
end

local function oName(o)
    local v=""
    pcall(function()
        if o:IsA("StringValue") then v=tostring(o.Value)
        else v=o.Value and o.Value.Name or "" end
    end)
    return v
end

local function findMyHouse()
    for _,o in ipairs(workspace:GetDescendants()) do
        if o.Name:lower()=="owner" and (o:IsA("StringValue") or o:IsA("ObjectValue")) then
            local n=oName(o)
            if n==LP.Name or n==LP.DisplayName then return o.Parent end
        end
    end
    return nil
end

local function getSafe()
    for _,o in ipairs(workspace:GetDescendants()) do
        if o.Name:lower()=="owner" and (o:IsA("StringValue") or o:IsA("ObjectValue")) then
            local n=oName(o)
            if n==LP.Name or n==LP.DisplayName then
                local a=o.Parent
                while a and a~=workspace do
                    local s=a:FindFirstChild("Safe",true)
                    if s then
                        local p=s:IsA("BasePart") and s or s:FindFirstChildWhichIsA("BasePart",true)
                        return s,p and p.CFrame
                    end
                    a=a.Parent
                end
            end
        end
    end
    return nil,nil
end

local function buyHouse()
    for _,o in ipairs(workspace:GetDescendants()) do
        if o.Name:lower()=="owner" and (o:IsA("StringValue") or o:IsA("ObjectValue")) then
            local n=oName(o)
            if n=="None" or n=="" or n:lower()=="for sale" or n:lower()=="forsale" then
                local a=o.Parent
                for i=1,6 do
                    if not a then break end
                    for _,pr in ipairs(a:GetDescendants()) do
                        if pr:IsA("ProximityPrompt") then
                            local at=(tostring(pr.ActionText or "")):lower()
                            local ot=(tostring(pr.ObjectText or "")):lower()
                            if at:find("buy") or at:find("purchase") or at:find("own") or ot:find("buy") or ot:find("purchase") then
                                local part=pr.Parent
                                if part and part:IsA("BasePart") then
                                    local oc=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                    local orig=oc and oc.CFrame
                                    tp(part.CFrame)
                                    task.wait(0.6)
                                    pr.HoldDuration=0
                                    pr.MaxActivationDistance=9999
                                    pr.RequiresLineOfSight=false
                                    for j=1,15 do
                                        pcall(function() fpr(pr) end)
                                        task.wait(0.25)
                                    end
                                    task.wait(0.7)
                                    if orig then pcall(function() tp(orig) end) end
                                    return true
                                end
                            end
                        end
                    end
                    a=a.Parent
                end
            end
        end
    end
    return false
end

local function tools()
    local t={}
    local bl={Fists=1,Fist=1,Phone=1,Bandage=1,["Car Keys"]=1,Weight=1}
    local function scan(c)
        if c then
            for _,x in ipairs(c:GetChildren()) do
                if x:IsA("Tool") and not bl[x.Name] then table.insert(t,x.Name) end
            end
        end
    end
    scan(LP:FindFirstChild("Backpack"))
    scan(LP.Character)
    return t
end

local function dupe1(n)
    local s,cf=getSafe()
    if not s or not cf then return false end
    local c=LP.Character
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    local o=r.CFrame
    pcall(function()
        r.CFrame=cf*CFrame.new(0,2,0)
        task.wait(0.5)
        for _,pr in ipairs(s:GetDescendants()) do
            if pr:IsA("ProximityPrompt") and pr.Enabled then
                local od=pr.HoldDuration
                pr.HoldDuration=0
                pr.RequiresLineOfSight=false
                pcall(function() fpr(pr) end)
                pr.HoldDuration=od
            end
        end
        task.wait(0.5)
        task.spawn(function() RS:WaitForChild("BackpackRemote"):InvokeServer("Store",n) end)
        task.spawn(function() RS:WaitForChild("Inventory"):FireServer("Change",n,"Backpack",s) end)
        task.wait(0.7)
        r.CFrame=o
        task.wait(1.3)
        RS:WaitForChild("BackpackRemote"):InvokeServer("Grab",n)
        task.wait(0.4)
    end)
    return true
end

local AutoRespawn={on=false,lastFire=0}
local function fireRespawn()
    local now=tick()
    if now-AutoRespawn.lastFire<1 then return end
    AutoRespawn.lastFire=now
    local lc=RS:FindFirstChild("LoadCharacter") or RS:FindFirstChild("LoadCharacter",true)
    if lc then pcall(function() lc:FireServer() end) end
    local re=RS:FindFirstChild("RespawnRE") or RS:FindFirstChild("RespawnRE",true)
    if re then pcall(function() re:FireServer() end) end
end
task.spawn(function()
    while task.wait(0.5) do
        if AutoRespawn.on then
            local c=LP.Character
            local h=c and c:FindFirstChildWhichIsA("Humanoid")
            if h and h.Health<=0 then fireRespawn() end
        end
    end
end)

local NoRent={on=false,saved={}}
local function scanRent()
    for _,c in ipairs({LP:FindFirstChild("PlayerGui"),LP:FindFirstChild("PlayerScripts"),game:GetService("StarterGui")}) do
        if c then
            for _,o in ipairs(c:GetDescendants()) do
                if (o:IsA("LocalScript") or o:IsA("Script") or o:IsA("ScreenGui")) and o.Name:lower():find("rent") then
                    if NoRent.saved[o]==nil then NoRent.saved[o]=o.Enabled end
                    pcall(function() o.Enabled=false end)
                end
            end
        end
    end
end
task.spawn(function()
    while task.wait(1) do
        if NoRent.on then scanRent()
        else
            for o,e in pairs(NoRent.saved) do pcall(function() if o and o.Parent then o.Enabled=e end end) end
            NoRent.saved={}
        end
    end
end)

local NoHunger={on=false,saved={}}
local function scanHunger()
    local gui=LP:FindFirstChild("PlayerGui") if not gui then return end
    local hg=gui:FindFirstChild("Hunger")
    if hg then for _,o in ipairs(hg:GetDescendants()) do
        if o:IsA("LocalScript") and (o.Name:lower():find("hunger") or o.Name:lower():find("bar")) then
            if NoHunger.saved[o]==nil then NoHunger.saved[o]=o.Enabled end
            pcall(function() o.Enabled=false end)
        end
    end end
end
task.spawn(function()
    while task.wait(1) do
        if NoHunger.on then scanHunger()
        else
            for o,e in pairs(NoHunger.saved) do pcall(function() if o and o.Parent then o.Enabled=e end end) end
            NoHunger.saved={}
        end
    end
end)

local NoSleep={on=false,saved={}}
local function scanSleep()
    local gui=LP:FindFirstChild("PlayerGui") if not gui then return end
    local sg=gui:FindFirstChild("SleepGui")
    if sg then for _,o in ipairs(sg:GetDescendants()) do
        if o:IsA("LocalScript") and (o.Name:lower():find("sleep") or o.Name:lower():find("bar")) then
            if NoSleep.saved[o]==nil then NoSleep.saved[o]=o.Enabled end
            pcall(function() o.Enabled=false end)
        end
    end end
end
task.spawn(function()
    while task.wait(1) do
        if NoSleep.on then scanSleep()
        else
            for o,e in pairs(NoSleep.saved) do pcall(function() if o and o.Parent then o.Enabled=e end end) end
            NoSleep.saved={}
        end
    end
end)

local NoStamina={on=false,saved={}}
local function scanStam()
    local gui=LP:FindFirstChild("PlayerGui") if not gui then return end
    local rg=gui:FindFirstChild("Run")
    if rg then for _,o in ipairs(rg:GetDescendants()) do
        if o:IsA("LocalScript") and (o.Name:lower():find("stamina") or o.Name:lower():find("run")) then
            if NoStamina.saved[o]==nil then NoStamina.saved[o]=o.Enabled end
            pcall(function() o.Enabled=false end)
        end
    end end
end
task.spawn(function()
    while task.wait(1) do
        if NoStamina.on then scanStam()
        else
            for o,e in pairs(NoStamina.saved) do pcall(function() if o and o.Parent then o.Enabled=e end end) end
            NoStamina.saved={}
        end
    end
end)

-- AUTO-ENABLE QoL ON LOAD
AutoRespawn.on=true
NoRent.on=true
NoHunger.on=true
NoSleep.on=true
NoStamina.on=true
task.wait(1)

local HB={on=false,size=5,part="Head",cache={}}
local function doHB()
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character then
            local pt=p.Character:FindFirstChild(HB.part)
            if pt and pt:IsA("BasePart") then
                if not HB.cache[p] then HB.cache[p]={pt.Size,pt.Transparency,pt.Color,pt.Material} end
                pt.Size=Vector3.new(HB.size,HB.size,HB.size)
                pt.Transparency=0.5
                pt.Color=Color3.fromRGB(0,140,255)
                pt.Material=Enum.Material.Neon
                pt.CanCollide=false
            end
        end
    end
end
local function clrHB()
    for p,c in pairs(HB.cache) do
        local pt=p.Character and p.Character:FindFirstChild(HB.part)
        if pt and pt:IsA("BasePart") then
            pt.Size=c[1] pt.Transparency=c[2] pt.Color=c[3] pt.Material=c[4]
        end
    end
    HB.cache={}
end
task.spawn(function() while task.wait(0.2) do if HB.on then doHB() end end end)

local ES={on=false,box=true,tracer=false,name=true,hp=true,hl=true}
local tracerGui=Instance.new("ScreenGui")
tracerGui.Name="ValriaESP"
tracerGui.ResetOnSpawn=false
tracerGui.IgnoreGuiInset=true
tracerGui.DisplayOrder=499
tracerGui.Parent=parent

local cache={}
local function kESP(p)
    local e=cache[p] if not e then return end
    if e.c then pcall(function() e.c:Disconnect() end) end
    if e.bb then pcall(function() e.bb:Destroy() end) end
    if e.tf then pcall(function() e.tf:Destroy() end) end
    if e.box then pcall(function() e.box:Destroy() end) end
    if e.hl then pcall(function() e.hl:Destroy() end) end
    cache[p]=nil
end
local function bESP(p)
    if p==LP then return end
    kESP(p)
    local c=p.Character if not c then return end
    if not c:IsDescendantOf(workspace) then return end
    local hd=c:FindFirstChild("Head")
    local h=c:FindFirstChildWhichIsA("Humanoid")
    local root=c:FindFirstChild("HumanoidRootPart")
    if not hd or not h or not root then return end
    if h.Parent~=c then return end
    local bb=Instance.new("BillboardGui")
    bb.Adornee=hd bb.Size=UDim2.new(0,220,0,50) bb.StudsOffset=Vector3.new(0,2.4,0) bb.AlwaysOnTop=true bb.Parent=hd
    local n=Instance.new("TextLabel")
    n.BackgroundTransparency=1 n.Size=UDim2.new(1,0,0,18) n.Font=Enum.Font.GothamBold n.TextSize=13
    n.TextColor3=Color3.fromRGB(220,230,255) n.TextStrokeTransparency=0.4 n.Text=p.Name n.Parent=bb
    local hp=Instance.new("TextLabel")
    hp.BackgroundTransparency=1 hp.Position=UDim2.new(0,0,0,18) hp.Size=UDim2.new(1,0,0,14)
    hp.Font=Enum.Font.GothamMedium hp.TextSize=11 hp.TextColor3=Color3.fromRGB(80,170,255) hp.Parent=bb
    local box=Instance.new("Frame")
    box.BackgroundTransparency=1 box.BorderSizePixel=0 box.Visible=false box.ZIndex=3 box.Parent=tracerGui
    local bs=Instance.new("UIStroke") bs.Color=Color3.fromRGB(0,140,255) bs.Thickness=1.5 bs.Parent=box
    local hi=Instance.new("Highlight")
    hi.FillColor=Color3.fromRGB(0,140,255) hi.FillTransparency=0.6 hi.OutlineColor=Color3.fromRGB(120,200,255) hi.Adornee=c hi.Parent=c
    local tf=Instance.new("Frame")
    tf.BackgroundColor3=Color3.fromRGB(0,140,255) tf.BorderSizePixel=0 tf.AnchorPoint=Vector2.new(0,0.5) tf.Visible=false tf.ZIndex=2 tf.Parent=tracerGui
    local conn
    conn=RUN.Heartbeat:Connect(function()
        if not ES.on then if conn then conn:Disconnect() end kESP(p) return end
        if p.Character~=c or not c.Parent or not h.Parent or h.Parent~=c or h.Health<=0 then
            if conn then conn:Disconnect() end kESP(p) return
        end
        n.Visible=ES.name hp.Visible=ES.hp
        if ES.hp then hp.Text=math.floor(h.Health).." HP" end
        hi.Enabled=ES.hl
        local cam=workspace.CurrentCamera if not cam then return end
        if ES.box then
            local hW=hd.Position+Vector3.new(0,0.5,0)
            local fW=root.Position-Vector3.new(0,3,0)
            local hV=cam:WorldToViewportPoint(hW)
            local fV=cam:WorldToViewportPoint(fW)
            if hV.Z>0 and fV.Z>0 then
                local ht2=math.abs(fV.Y-hV.Y)
                local wt=ht2*0.55
                box.Position=UDim2.fromOffset(fV.X-wt/2,hV.Y)
                box.Size=UDim2.fromOffset(wt,ht2)
                box.Visible=true
            else box.Visible=false end
        else box.Visible=false end
        if ES.tracer then
            local vp2=cam.ViewportSize
            local pos=cam:WorldToViewportPoint(hd.Position)
            if pos and pos.Z>0 then
                local fx,fy=vp2.X/2,vp2.Y
                local dx,dy=pos.X-fx,pos.Y-fy
                local len=math.sqrt(dx*dx+dy*dy)
                local ang=math.deg(math.atan2(dy,dx))
                tf.Position=UDim2.fromOffset(fx,fy)
                tf.Size=UDim2.fromOffset(len,2)
                tf.Rotation=ang
                tf.Visible=true
            else tf.Visible=false end
        else tf.Visible=false end
    end)
    cache[p]={bb=bb,c=conn,tf=tf,box=box,hl=hi,char=c}
end
local function rESP()
    for p in pairs(cache) do kESP(p) end
    if not ES.on then return end
    for _,p in ipairs(P:GetPlayers()) do if p~=LP then bESP(p) end end
end
P.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if ES.on then task.wait(0.6) bESP(p) end end)
end)
for _,p in ipairs(P:GetPlayers()) do
    p.CharacterAdded:Connect(function() if ES.on then task.wait(0.6) bESP(p) end end)
end
P.PlayerRemoving:Connect(kESP)

local ItemES={on=false,partCache={}}
local itemGui=Instance.new("ScreenGui")
itemGui.Name="ValriaItemESP"
itemGui.ResetOnSpawn=false
itemGui.IgnoreGuiInset=true
itemGui.DisplayOrder=498
itemGui.Parent=parent
local function itemHL(obj)
    if not obj or not obj:IsDescendantOf(workspace) then return end
    if ItemES.partCache[obj] then return end
    local h=Instance.new("Highlight")
    h.FillColor=Color3.fromRGB(255,200,60) h.FillTransparency=0.55
    h.OutlineColor=Color3.fromRGB(255,240,180) h.OutlineTransparency=0
    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop h.Adornee=obj h.Parent=obj
    ItemES.partCache[obj]=h
end
local function scanItems()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then itemHL(obj)
        elseif obj:IsA("Model") then
            local nm=obj.Name:lower()
            if nm:find("drop") or nm:find("loot") or nm:find("bag") or nm:find("cash") or nm:find("money") or nm:find("weapon") then
                itemHL(obj)
            end
        end
    end
end
task.spawn(function()
    while task.wait(1) do
        if ItemES.on then scanItems()
        else
            for obj,h in pairs(ItemES.partCache) do pcall(function() h:Destroy() end) end
            ItemES.partCache={}
        end
    end
end)

local AIM={on=false,part="Head",smooth=0.35,fire=false,target=nil,fovRadius=90,circleOffset=Vector2.new(0,0),wallCheck=true}

local fovGui=Instance.new("ScreenGui")
fovGui.Name="ValriaFOV"
fovGui.ResetOnSpawn=false
fovGui.IgnoreGuiInset=true
fovGui.DisplayOrder=501
fovGui.Parent=parent

local fovCircle=Instance.new("TextButton")
fovCircle.Text=""
fovCircle.AutoButtonColor=false
fovCircle.BackgroundTransparency=1
fovCircle.BorderSizePixel=0
fovCircle.AnchorPoint=Vector2.new(0.5,0.5)
fovCircle.Visible=false
fovCircle.ZIndex=10
fovCircle.Active=true
fovCircle.Parent=fovGui
local fovStroke=Instance.new("UIStroke")
fovStroke.Color=Color3.fromRGB(0,140,255)
fovStroke.Thickness=1.5
fovStroke.Transparency=0.25
fovStroke.Parent=fovCircle
local fovCorner=Instance.new("UICorner")
fovCorner.CornerRadius=UDim.new(1,0)
fovCorner.Parent=fovCircle

do
    local drag=false local ds=nil local so=nil
    fovCircle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true ds=i.Position so=AIM.circleOffset
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
            local d=i.Position-ds
            AIM.circleOffset=Vector2.new(so.X+d.X,so.Y+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

RUN.RenderStepped:Connect(function()
    if AIM.on then
        local d=AIM.fovRadius*2
        if fovCircle.AbsoluteSize.X~=d then fovCircle.Size=UDim2.fromOffset(d,d) end
        fovCircle.Position=UDim2.new(0.5,AIM.circleOffset.X,0.5,AIM.circleOffset.Y)
        fovCircle.Visible=true
    else fovCircle.Visible=false end
end)

RUN.RenderStepped:Connect(function(dt)
    if not AIM.on then AIM.target=nil return end
    local cam=workspace.CurrentCamera if not cam then return end
    local myChar=LP.Character if not myChar then return end
    local myRoot=myChar:FindFirstChild("HumanoidRootPart") if not myRoot then AIM.target=nil return end
    local vp2=cam.ViewportSize
    local cx=vp2.X/2+AIM.circleOffset.X
    local cy=vp2.Y/2+AIM.circleOffset.Y
    local r=AIM.fovRadius
    local r2=r*r
    local best,bestScore=nil,math.huge
    for _,p in ipairs(P:GetPlayers()) do
        if p~=LP and p.Character and p.Character.Parent==workspace then
            local h=p.Character:FindFirstChildWhichIsA("Humanoid")
            if h and h.Health>0 and h.Parent==p.Character then
                local pt=p.Character:FindFirstChild(AIM.part)
                if not pt or not pt:IsA("BasePart") then pt=p.Character:FindFirstChild("Head") end
                if pt then
                    local sPos,onS=cam:WorldToViewportPoint(pt.Position)
                    if onS and sPos.Z>0 then
                        local dx=sPos.X-cx
                        local dy=sPos.Y-cy
                        local d2=dx*dx+dy*dy
                        if d2<=r2 then
                            local worldD=(myRoot.Position-pt.Position).Magnitude
                            if worldD<800 then
                                local visible=true
                                if AIM.wallCheck then
                                    local params=RaycastParams.new()
                                    params.FilterType=Enum.RaycastFilterType.Exclude
                                    params.FilterDescendantsInstances={myChar,p.Character}
                                    local origin=cam.CFrame.Position
                                    local dir=(pt.Position-origin).Unit
                                    local hit=workspace:Raycast(origin,dir*(worldD+5),params)
                                    if hit then visible=false end
                                end
                                if visible then
                                    local score=d2+worldD*worldD*0.01
                                    if score<bestScore then bestScore=score best=pt end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if best then
        AIM.target=best
        local camPos=cam.CFrame.Position
        local lookCF=CFrame.lookAt(camPos,best.Position)
        local newRot=cam.CFrame.Rotation:Lerp(lookCF.Rotation,math.clamp(AIM.smooth,0.05,1))
        cam.CFrame=CFrame.new(camPos)*newRot
        if AIM.fire then
            local tool=myChar:FindFirstChildOfClass("Tool")
            if tool and type(tool.Activate)=="function" then pcall(function() tool:Activate() end) end
        end
    else AIM.target=nil end
end)

local G={on=false,cons={}}
local function enGod()
    local c=LP.Character if not c then return end
    local h=c:FindFirstChildWhichIsA("Humanoid") if not h then return end
    pcall(function()
        h.MaxHealth=math.huge h.Health=math.huge
        h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
        h.BreakJointsOnDeath=false
    end)
    table.insert(G.cons,h.HealthChanged:Connect(function(x)
        if G.on and x<h.MaxHealth then pcall(function() h.Health=h.MaxHealth end) end
    end))
end
local function dGod()
    for _,c in ipairs(G.cons) do pcall(function() c:Disconnect() end) end
    G.cons={}
end
LP.CharacterAdded:Connect(function() if G.on then task.wait(0.5) enGod() end end)

local GM={InfAmmo=false,InfClips=false,Bullets80k=false,Recoil=false,Spread=false,NoJam=false,InstReload=false,InstEquip=false,FireRate=false,Auto=false,InfDmg=false,Rainbow=false,SolidColor=false,ColorRGB=Color3.fromRGB(0,140,255)}
local gunOrigColors={}
local function applyToGun(t)
    if not t:FindFirstChild("Setting") then return end
    local ok,s=pcall(require,t.Setting) if not ok or type(s)~="table" then return end
    pcall(function()
        if GM.InfAmmo then s.Ammo=99999 s.AmmoPerMag=99999 s.LimitedAmmoEnabled=false end
        if GM.InfClips or GM.Bullets80k then
            s.Ammo=80000 s.AmmoPerMag=80000 s.LimitedAmmoEnabled=false
            s.MagCount=80000 s.StoredAmmo=80000 s.MaxAmmo=80000
        end
        if GM.Recoil then s.Recoil=0 s.CameraRecoilingEnabled=false end
        if GM.Spread then s.Spread=0 s.SpreadX=0 s.SpreadY=0 s.SpreadXY=0 s.SpreadYX=0 s.Accuracy=1 end
        if GM.NoJam then s.JamChance=0 end
        if GM.InstReload then s.ReloadTime=0.05 s.ReloadSpeed=0.05 end
        if GM.InstEquip then s.EquipTime=0.05 s.EquippingTime=0.05 end
        if GM.FireRate then s.FireRate=0 end
        if GM.Auto then s.Auto=true end
        if GM.InfDmg then s.BaseDamage=1e9 end
    end)
    local gl=t:FindFirstChild("GunScript_Local")
    if gl and type(getsenv)=="function" and type(debug.setupvalue)=="function" then
        pcall(function()
            local env=getsenv(gl)
            if env and env.Reload then
                debug.setupvalue(env.Reload,1,80000)
                debug.setupvalue(env.Reload,3,800
