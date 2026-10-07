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

for _,n in ipairs({"ValriaHub","ValriaFOV","ValriaESP","ValriaItemESP","B3Juice"}) do
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

local function getCleaner()
    local m=workspace:FindFirstChild("1# Map")
    if not m then return nil end
    local ci
    for _,v in m:GetChildren() do
        if v:FindFirstChild("CounterM") then ci=v break end
    end
    if not ci then return nil end
    for _,v in ci:GetChildren() do
        if v:FindFirstChild("CashPrompt",true) and v:FindFirstChild("GrabPrompt",true) then
            return v
        end
    end
    return nil
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

local function hasItem(n)
    local c=LP.Character
    if c then for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name==n then return true end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and t.Name==n then return true end end end
    return false
end
local function equipByName(n)
    local c=LP.Character if not c then return false end
    local h=c:FindFirstChildWhichIsA("Humanoid") if not h then return false end
    local held=c:FindFirstChildWhichIsA("Tool") if held and held.Name==n then return true end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and t.Name==n then
            pcall(function() h:EquipTool(t) end) task.wait(0.3) return true
        end
    end end
    return false
end
local function findCupTool()
    local c=LP.Character
    if c then local held=c:FindFirstChildWhichIsA("Tool") if held and tostring(held.Name):lower():find("cupz") then return held end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and tostring(t.Name):lower():find("cupz") then return t end end end
    return nil
end
local function equipCup()
    local c=LP.Character if not c then return false end
    local h=c:FindFirstChildWhichIsA("Humanoid") if not h then return false end
    local held=c:FindFirstChildWhichIsA("Tool")
    if held and tostring(held.Name):lower():find("cupz") then return true end
    local cup=findCupTool() if not cup then return false end
    pcall(function() h:EquipTool(cup) end) task.wait(0.3) return true
end
local function isCupFull(tool)
    if not tool then return false end
    local cp=tool:FindFirstChild("IceFruit Cup") or tool:FindFirstChildWhichIsA("BasePart",true)
    if not cp then return false end
    for _,d in ipairs(cp:GetDescendants()) do
        if d.Name:lower():find("punch") and d:IsA("BasePart") and d.Transparency<1 then return true end
    end
    return false
end
local function findFullCup()
    local c=LP.Character
    if c then local held=c:FindFirstChildWhichIsA("Tool") if held and isCupFull(held) then return held end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and isCupFull(t) then return t end end end
    return nil
end
local function findStove()
    local cps=workspace:FindFirstChild("CookingPots") if not cps then return nil,nil end
    for _,v in ipairs(cps:GetChildren()) do
        if v:IsA("Model") then
            local pr=v:FindFirstChildWhichIsA("ProximityPrompt",true)
            if pr then return v,pr end
        end
    end
    return nil,nil
end
local function findSeller()
    local s=workspace:FindFirstChild("IceFruit Sell") if not s then return nil,nil end
    local pr=s:FindFirstChild("ProximityPrompt") or s:FindFirstChildWhichIsA("ProximityPrompt",true)
    return s,pr
end
local function stoveBusy(cp)
    if not cp then return false end
    local steam=cp:FindFirstChild("Steam",true) if not steam then return false end
    local lui=steam:FindFirstChild("LoadUI",true) if lui then return lui.Enabled end
    return false
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
                debug.setupvalue(env.Reload,3,80000)
                debug.setupvalue(env.Reload,5,80000)
            end
        end)
    end
    for _,v in ipairs(t:GetDescendants()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") then
            local nm=v.Name:lower()
            if nm:find("ammo") or nm:find("clip") or nm:find("mag") then
                pcall(function() v.Value=80000 end)
            end
        end
    end
    if GM.Rainbow or GM.SolidColor then
        for _,v in ipairs(t:GetDescendants()) do
            if v:IsA("BasePart") then
                if not gunOrigColors[v] then gunOrigColors[v]=v.Color end
                v.Color=GM.Rainbow and Color3.fromHSV((tick()%5)/5,1,1) or GM.ColorRGB
                v.Material=Enum.Material.Neon
            end
        end
    end
end
task.spawn(function()
    while task.wait(0.3) do
        local bp=LP:FindFirstChild("Backpack")
        if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then pcall(applyToGun,t) end end end
        local ch=LP.Character
        if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") then pcall(applyToGun,t) end end end
    end
end)

local WP={
    Bank=CFrame.new(-1217.30,253.88,-3635.04),
    Vault=CFrame.new(-217.57,373.80,-1216.21),
    ATM1=CFrame.new(-1011.91,253.75,-1153.73),
    Wash=CFrame.new(-1006.00,254.00,-701.00),
    MrMoney=CFrame.new(-1008.07,262.11,55.13),
    GunShop1=CFrame.new(92959.87,122098.50,17244.46),
    GunShop2=CFrame.new(66195.45,123615.71,5750.28),
    GunShop3=CFrame.new(60820.31,87609.15,-351.47),
    GunShopLobby=CFrame.new(-224.38,283.80,-794.72),
    Market=CFrame.new(-405.17,334.31,-562.63),
    SodaSeller=CFrame.new(-1292.22,253.30,-3003.05),
    Backpack=CFrame.new(-725.64,253.92,-684.30),
    Drip=CFrame.new(67462.00,10489.21,546.19),
    Frozen=CFrame.new(-216.31,284.03,-1169.03),
    Exotic=CFrame.new(-1523.57,273.97,-990.66),
    ChickenWings=CFrame.new(-957.91,253.54,-815.94),
    McD=CFrame.new(-423.00,254.00,-953.00),
    SwitchSeller=CFrame.new(-1446.22,256.06,2189.88),
    StrikerMan=CFrame.new(-1427.69,254.22,2777.21),
    SellSeeds=CFrame.new(-1419.40,253.28,2034.50),
    GrowSeeds=CFrame.new(-935.86,267.47,-1132.89),
    BuySeeds=CFrame.new(51371.57,21680.42,21681.04),
    NewSeller=CFrame.new(-965.27,260.19,-4244.83),
    PawnShop=CFrame.new(-1049.64,253.54,-814.27),
    Cook=CFrame.new(-198.89,283.85,-1170.45),
    Studio=CFrame.new(93408.45,14484.90,570.14),
    Construction=CFrame.new(-1731.83,370.81,-1176.84),
    Hospital=CFrame.new(-1587.46,254.27,18.42),
    Prison=CFrame.new(-1135.05,254.72,-3330.99),
    CarDealer=CFrame.new(-401.99,253.41,-1248.84),
    RPT=CFrame.new(-1744.10,236.95,-596.03),
    Court=CFrame.new(-1722.82,236.95,-589.07),
    PentHouse=CFrame.new(-178.27,397.14,-573.03),
    NewPenthouse=CFrame.new(-1488.06,476.30,-3747.01),
    MiniMansion=CFrame.new(-791.52,256.79,1414.42),
    Mansion=CFrame.new(-789.10,253.57,1380.76),
    RandomHouse=CFrame.new(-1228.93,261.04,-3758.50),
    TrailerPark=CFrame.new(-1522.77,253.16,2344.96),
    WoodysHotel=CFrame.new(-1022.62,325.84,-908.92),
    Basement=CFrame.new(-194.35,239.51,1238.92),
    Block600=CFrame.new(-990.68,253.71,-281.32),
    Roof3=CFrame.new(-1608.01,480.64,-501.50),
    Roof4=CFrame.new(-209.99,433.22,-1151.95)
}

local function mk(class,props)
    local o=Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    return o
end

local Th={
    bg=Color3.fromRGB(10,12,18),
    side=Color3.fromRGB(14,17,24),
    pS=Color3.fromRGB(20,24,34),
    pS2=Color3.fromRGB(26,30,42),
    str=Color3.fromRGB(38,44,58),
    ac=Color3.fromRGB(0,140,255),
    acD=Color3.fromRGB(0,90,180),
    sp=Color3.fromRGB(120,200,255),
    tx=Color3.fromRGB(230,236,244),
    sub=Color3.fromRGB(140,150,172),
    dim=Color3.fromRGB(90,100,120),
    on=Color3.fromRGB(0,150,255),
    off=Color3.fromRGB(45,52,66),
    fM=Enum.Font.GothamMedium,
    fB=Enum.Font.GothamBold
}

local gui=mk("ScreenGui",{Name="ValriaHub",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=500,Parent=parent})

-- smaller window, opens hidden
local W,H=460,290
local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
local sc=1
if vp and vp.X<520 then sc=math.max(0.75,vp.X/520) end

local win=mk("Frame",{Size=UDim2.fromOffset(W,H),Position=UDim2.new(0.5,-W/2,0.5,-H/2),BackgroundColor3=Th.bg,BorderSizePixel=0,ClipsDescendants=true,Parent=gui,Visible=false})
mk("UICorner",{CornerRadius=UDim.new(0,10),Parent=win})
mk("UIStroke",{Color=Th.str,Thickness=1,Parent=win})
mk("UIScale",{Scale=sc,Parent=win})

-- top bar (drag)
local tb=mk("Frame",{Size=UDim2.new(1,0,0,22),BackgroundColor3=Th.bg,BorderSizePixel=0,Parent=win})
mk("TextLabel",{BackgroundTransparency=1,Text="VALRIA",Font=Th.fB,TextSize=11,TextColor3=Th.ac,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-80,1,0),Parent=tb})

local cbtn=mk("TextButton",{Text="✕",Font=Th.fB,TextSize=11,TextColor3=Th.tx,BackgroundTransparency=1,Size=UDim2.fromOffset(22,18),Position=UDim2.new(1,-28,0,2),Parent=tb})
cbtn.MouseButton1Click:Connect(function() win.Visible=false end)

-- body: sidebar + content
local body=mk("Frame",{Position=UDim2.fromOffset(0,22),Size=UDim2.new(1,0,1,-22),BackgroundTransparency=1,Parent=win})

local sidebar=mk("Frame",{Size=UDim2.new(0,120,1,0),BackgroundColor3=Th.side,BorderSizePixel=0,Parent=body})
local sTop=mk("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Th.side,BorderSizePixel=0,Parent=sidebar})
mk("TextLabel",{BackgroundTransparency=1,Text="VALRIA",Font=Th.fB,TextSize=14,TextColor3=Th.ac,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-16,1,0),Parent=sTop})

local sideScroll=mk("ScrollingFrame",{Position=UDim2.fromOffset(0,32),Size=UDim2.new(1,0,1,-32),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=0,Parent=sidebar})

local content=mk("Frame",{Position=UDim2.fromOffset(120,0),Size=UDim2.new(1,-120,1,0),BackgroundColor3=Th.bg,BorderSizePixel=0,Parent=body})
local cHead=mk("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Th.bg,BorderSizePixel=0,Parent=content})
local tl=mk("TextLabel",{BackgroundTransparency=1,Text="Home",Font=Th.fB,TextSize=13,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-28,1,0),Parent=cHead})

local gs=mk("ScrollingFrame",{Position=UDim2.fromOffset(0,28),Size=UDim2.new(1,0,1,-28),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=3,ScrollBarImageColor3=Th.ac,ScrollBarImageTransparency=0.4,Parent=content})
mk("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),Parent=gs})
local gl=mk("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=gs})
gl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    gs.CanvasSize=UDim2.new(0,0,0,gl.AbsoluteContentSize.Y+16)
end)

-- drag
do
    local d,ds,dp=false,nil,nil
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            d=true ds=i.Position dp=win.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local dd=i.Position-ds
            win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+dd.X,dp.Y.Scale,dp.Y.Offset+dd.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end
    end)
end

-- circle toggle
local circ=mk("TextButton",{Size=UDim2.fromOffset(46,46),Position=UDim2.new(0,12,0.5,-23),BackgroundColor3=Th.bg,BorderSizePixel=0,Text="V",Font=Th.fB,TextSize=18,TextColor3=Th.ac,Active=true,Draggable=true,Visible=true,Parent=gui})
mk("UICorner",{CornerRadius=UDim.new(1,0),Parent=circ})
mk("UIStroke",{Color=Th.ac,Thickness=2,Parent=circ})
circ.MouseButton1Click:Connect(function()
    if win.Visible then
        win.Visible=false circ.Text="V"
    else
        local cp=circ.AbsolutePosition
        local cs=circ.AbsoluteSize
        win.Position=UDim2.fromOffset(cp.X+cs.X+8,cp.Y+cs.Y/2-H/2)
        win.Visible=true circ.Text="—"
    end
end)

local function mkCard(t)
    local c=mk("Frame",{BackgroundColor3=Th.pS,BorderSizePixel=0,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=gs})
    mk("UICorner",{CornerRadius=UDim.new(0,7),Parent=c})
    mk("UIStroke",{Color=Th.str,Thickness=1,Parent=c})
    mk("UIPadding",{PaddingTop=UDim.new(0,7),PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=c})
    mk("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,Parent=c})
    mk("TextLabel",{BackgroundTransparency=1,Text=t,Font=Th.fB,TextSize=10,TextColor3=Th.sp,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,13),LayoutOrder=0,Parent=c})
    local r=mk("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=1,Parent=c})
    mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=r})
    return r,c
end

local function mkRow(rows,label,kind,value,cb,opts)
    opts=opts or {}
    local r=mk("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,AutoButtonColor=false,Text="",Parent=rows})
    local h={frame=r}
    if kind=="toggle" then
        local b=mk("Frame",{Size=UDim2.fromOffset(13,13),Position=UDim2.fromOffset(0,4),BackgroundColor3=value and Th.on or Th.off,BorderSizePixel=0,Parent=r})
        mk("UICorner",{CornerRadius=UDim.new(1,0),Parent=b})
        mk("UIStroke",{Color=value and Th.on or Th.str,Thickness=1,Parent=b})
        mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(20,0),Size=UDim2.new(1,-24,1,0),Parent=r})
        r.MouseButton1Click:Connect(function()
            value=not value
            b.BackgroundColor3=value and Th.on or Th.off
            b.UIStroke.Color=value and Th.on or Th.str
            if cb then pcall(cb,value) end
        end)
    elseif kind=="button" then
        mk("Frame",{Size=UDim2.fromOffset(3,13),Position=UDim2.fromOffset(0,4),BackgroundColor3=Th.ac,BorderSizePixel=0,Parent=r})
        mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-26,1,0),Parent=r})
        mk("TextLabel",{BackgroundTransparency=1,Text="›",Font=Th.fB,TextSize=13,TextColor3=Th.sub,TextXAlignment=Enum.TextXAlignment.Right,Position=UDim2.new(1,-14,0,0),Size=UDim2.new(0,12,1,0),Parent=r})
        r.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    elseif kind=="dropdown" then
        local vl=mk("TextLabel",{BackgroundTransparency=1,Text=tostring(value),Font=Th.fB,TextSize=9,TextColor3=Th.sp,TextXAlignment=Enum.TextXAlignment.Right,Position=UDim2.new(1,-100,0,0),Size=UDim2.new(0,80,1,0),Parent=r})
        mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-110,1,0),Parent=r})
        mk("TextLabel",{BackgroundTransparency=1,Text="▼",Font=Th.fB,TextSize=8,TextColor3=Th.sub,TextXAlignment=Enum.TextXAlignment.Right,Position=UDim2.new(1,-12,0,0),Size=UDim2.new(0,10,1,0),Parent=r})
        r.MouseButton1Click:Connect(function()
            local oo=opts.options or {}
            if #oo==0 then return end
            local idx=1
            for i,o in ipairs(oo) do if tostring(o)==tostring(value) then idx=i end end
            idx=(idx%#oo)+1
            value=oo[idx]
            vl.Text=tostring(value)
            if cb then pcall(cb,value) end
        end)
        h.setOptions=function(no,nv)
            opts.options=no or {}
            if nv~=nil then value=nv end
            vl.Text=tostring(value)
        end
    elseif kind=="label" then
        mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.sub,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-90,1,0),Parent=r})
        mk("TextLabel",{BackgroundTransparency=1,Text=tostring(value or ""),Font=Th.fM,TextSize=9,TextColor3=Th.sp,TextXAlignment=Enum.TextXAlignment.Right,Position=UDim2.new(1,-90,0,0),Size=UDim2.new(0,80,1,0),Parent=r})
    end
    return h
end

local Tabs={}
local sb={}
local function swt(i)
    for k,_ in ipairs(Tabs) do
        if sb[k] then
            local a=(k==i)
            sb[k].btn.BackgroundColor3=a and Th.pS2 or Th.side
            sb[k].btn.BackgroundTransparency=a and 0 or 1
            sb[k].ic.TextColor3=a and Th.ac or Th.dim
            sb[k].nm.TextColor3=a and Th.ac or Th.dim
        end
    end
    for _,c in ipairs(gs:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local t=Tabs[i]
    if t then tl.Text=t.title if t.build then t.build() end gs.CanvasPosition=Vector2.zero end
end
local function addT(icon,title,build)
    table.insert(Tabs,{ic=icon,title=title,build=build})
    local i=#Tabs
    local b=mk("TextButton",{Size=UDim2.new(1,-8,0,26),Position=UDim2.fromOffset(4,(i-1)*28+4),BackgroundColor3=Th.side,BackgroundTransparency=1,AutoButtonColor=false,Text="",Parent=sideScroll})
    mk("UICorner",{CornerRadius=UDim.new(0,6),Parent=b})
    local ic=mk("TextLabel",{BackgroundTransparency=1,Text=icon,Font=Th.fB,TextSize=13,TextColor3=Th.dim,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(8,0),Size=UDim2.fromOffset(20,26),Parent=b})
    local nm=mk("TextLabel",{BackgroundTransparency=1,Text=title,Font=Th.fM,TextSize=11,TextColor3=Th.dim,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(30,0),Size=UDim2.new(1,-34,1,0),Parent=b})
    sb[i]={btn=b,ic=ic,nm=nm}
    b.MouseButton1Click:Connect(function() swt(i) end)
    sideScroll.CanvasSize=UDim2.new(0,0,0,#Tabs*28+10)
end

addT("🏠","Home",function()
    local r=mkCard("QUICK")
    mkRow(r,"Rejoin","button",nil,function() pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end) end)
    mkRow(r,"Destroy Hub","button",nil,function() pcall(function() gui:Destroy() end) end)
    local r2=mkCard("STATS")
    mkRow(r2,"Money","label",fmt(gM()),nil)
    mkRow(r2,"Executor","label",(identifyexecutor and identifyexecutor()) or "?",nil)
end)

addT("👤","Player",function()
    local r=mkCard("ESP")
    mkRow(r,"Enable","toggle",ES.on,function(v) ES.on=v rESP() end)
    mkRow(r,"Boxes","toggle",ES.box,function(v) ES.box=v end)
    mkRow(r,"Tracer","toggle",ES.tracer,function(v) ES.tracer=v end)
    mkRow(r,"Highlight","toggle",ES.hl,function(v) ES.hl=v end)
    mkRow(r,"Name","toggle",ES.name,function(v) ES.name=v end)
    mkRow(r,"Health","toggle",ES.hp,function(v) ES.hp=v end)
    mkRow(r,"Items ESP","toggle",ItemES.on,function(v) ItemES.on=v end)

    local rA=mkCard("AIMBOT")
    mkRow(rA,"Enable","toggle",AIM.on,function(v) AIM.on=v end)
    mkRow(rA,"Part","dropdown","Head",function(v) AIM.part=v end,{options={"Head","HumanoidRootPart","UpperTorso","LowerTorso"}})
    mkRow(rA,"Auto Fire","toggle",AIM.fire,function(v) AIM.fire=v end)
    mkRow(rA,"Wall Check","toggle",AIM.wallCheck,function(v) AIM.wallCheck=v end)
    mkRow(rA,"FOV","dropdown","90",function(v) AIM.fovRadius=tonumber(v) or 90 end,{options={"60","90","120","180","250","400"}})
    mkRow(rA,"Smooth","dropdown","medium",function(v)
        if v=="fast" then AIM.smooth=0.2
        elseif v=="slow" then AIM.smooth=0.6
        else AIM.smooth=0.35 end
    end,{options={"fast","medium","slow"}})
    mkRow(rA,"Reset Circle","button",nil,function() AIM.circleOffset=Vector2.new(0,0) end)

    local r2=mkCard("MOVE")
    local wsOn=false local wsV=32
    mkRow(r2,"Walkspeed","toggle",false,function(v)
        wsOn=v
        local c=LP.Character
        local h=c and c:FindFirstChildWhichIsA("Humanoid")
        if h then h.WalkSpeed=v and wsV or 16 end
    end)
    mkRow(r2,"Speed","dropdown","32",function(v)
        wsV=tonumber(v) or 32
        local c=LP.Character
        local h=c and c:FindFirstChildWhichIsA("Humanoid")
        if h and wsOn then h.WalkSpeed=wsV end
    end,{options={"16","32","60","120","200","400"}})

    local r3=mkCard("PROTECT")
    mkRow(r3,"God Mode","toggle",false,function(v) G.on=v if v then enGod() else dGod() end end)

    local r4=mkCard("HITBOX")
    mkRow(r4,"Enable","toggle",false,function(v) HB.on=v if not v then clrHB() end end)
    mkRow(r4,"Size","dropdown","5",function(v) HB.size=tonumber(v) or 5 end,{options={"3","5","8","10","15","20","30"}})
    mkRow(r4,"Part","dropdown","Head",function(v) clrHB() HB.part=v end,{options={"Head","HumanoidRootPart","UpperTorso"}})

    local r5=mkCard("QoL")
    mkRow(r5,"Auto Respawn","toggle",false,function(v) AutoRespawn.on=v end)
    mkRow(r5,"No Rent","toggle",false,function(v) NoRent.on=v end)
    mkRow(r5,"No Hunger","toggle",false,function(v) NoHunger.on=v end)
    mkRow(r5,"No Sleep","toggle",false,function(v) NoSleep.on=v end)
    mkRow(r5,"No Stamina","toggle",false,function(v) NoStamina.on=v end)
end)

addT("📍","TP",function()
    local r=mkCard("TO PLAYER")
    local function pl()
        local n={}
        for _,p in ipairs(P:GetPlayers()) do if p~=LP then table.insert(n,p.Name) end end
        table.sort(n)
        if #n==0 then n={"(none)"} end
        return n
    end
    local pn=pl() local sp=pn[1]
    local pRow=mkRow(r,"Player","dropdown",sp,function(v) sp=v end,{options=pn})
    mkRow(r,"Refresh","button",nil,function() if pRow.setOptions then pRow.setOptions(pl()) end end)
    mkRow(r,"Go","button",nil,function()
        if not sp or sp=="(none)" then return end
        local p=P:FindFirstChild(sp)
        if not p or not p.Character then return end
        local hr=p.Character:FindFirstChild("HumanoidRootPart")
        if hr then task.spawn(function() tp(hr.CFrame*CFrame.new(3,0,0)) end) ntf("tp",sp) end
    end)

    local rH=mkCard("APTS")
    local apart={"PentHouse","NewPenthouse","MiniMansion","Mansion","RandomHouse","TrailerPark","WoodysHotel","Basement","Block600","Roof3","Roof4"}
    local sa=apart[1]
    mkRow(rH,"Apartment","dropdown",sa,function(v) sa=v end,{options=apart})
    mkRow(rH,"Go","button",nil,function() local cf=WP[sa] if cf then task.spawn(function() tp(cf) end) ntf("tp",sa) end end)

    local rD=mkCard("HOUSES")
    local houseList={} local selH="(none)"
    local function refreshHouses()
        houseList={}
        for _,o in ipairs(workspace:GetDescendants()) do
            if o.Name:lower()=="owner" and (o:IsA("StringValue") or o:IsA("ObjectValue")) then
                local n=oName(o)
                if n~="" and n~="None" then
                    local a=o.Parent local cf local isMine=(n==LP.Name or n==LP.DisplayName)
                    for i=1,6 do
                        if not a then break end
                        local bp=a:FindFirstChildWhichIsA("BasePart",true) or a.PrimaryPart
                        if bp then cf=bp.CFrame break end
                        a=a.Parent
                    end
                    if cf then table.insert(houseList,{label=isMine and "My House" or n,cf=cf,isMine=isMine}) end
                end
            end
        end
        table.sort(houseList,function(a,b)
            if a.isMine and not b.isMine then return true end
            if b.isMine and not a.isMine then return false end
            return a.label<b.label
        end)
    end
    refreshHouses()
    local hLabels={}
    for _,h in ipairs(houseList) do table.insert(hLabels,h.label) end
    if #hLabels==0 then hLabels={"(none)"} end
    selH=hLabels[1]
    local hRow=mkRow(rD,"House","dropdown",selH,function(v) selH=v end,{options=hLabels})
    mkRow(rD,"Refresh","button",nil,function()
        refreshHouses()
        local nl={}
        for _,h in ipairs(houseList) do table.insert(nl,h.label) end
        if #nl==0 then nl={"(none)"} end
        selH=nl[1]
        if hRow.setOptions then hRow.setOptions(nl,selH) end
    end)
    mkRow(rD,"Go","button",nil,function()
        for _,h in ipairs(houseList) do if h.label==selH then task.spawn(function() tp(h.cf+Vector3.new(0,5,0)) end) ntf("tp",h.label) return end end
    end)
    mkRow(rD,"Mine","button",nil,function()
        refreshHouses()
        for _,h in ipairs(houseList) do if h.isMine then task.spawn(function() tp(h.cf+Vector3.new(0,5,0)) end) ntf("tp","my house") return end end
        ntf("house","no owned house")
    end)

    local r2=mkCard("WP")
    local wn={}
    for k in pairs(WP) do table.insert(wn,k) end
    table.sort(wn)
    local sel=wn[1]
    mkRow(r2,"Location","dropdown",sel,function(v) sel=v end,{options=wn})
    mkRow(r2,"Go","button",nil,function() local cf=WP[sel] if cf then task.spawn(function() tp(cf) end) ntf("tp",sel) end end)
end)

addT("💼","Traders",function()
    local r=mkCard("TRADERS")
    local traders={
        MrMoney=WP.MrMoney,Exotic=WP.Exotic,SwitchSeller=WP.SwitchSeller,SodaSeller=WP.SodaSeller,
        StrikerMan=WP.StrikerMan,SellSeeds=WP.SellSeeds,GrowSeeds=WP.GrowSeeds,BuySeeds=WP.BuySeeds,
        NewSeller=WP.NewSeller,PawnShop=WP.PawnShop,ChickenWings=WP.ChickenWings,McD=WP.McD,
        Drip=WP.Drip,Frozen=WP.Frozen,Backpack=WP.Backpack
    }
    local tn={}
    for k in pairs(traders) do table.insert(tn,k) end
    table.sort(tn)
    local selT=tn[1]
    mkRow(r,"Trader","dropdown",selT,function(v) selT=v end,{options=tn})
    mkRow(r,"Go","button",nil,function() local cf=traders[selT] if cf then task.spawn(function() tp(cf) end) ntf("trader",selT) end end)
end)

addT("📦","Boxes",function()
    local r=mkCard("GUNS")
    local guns={
        {label="Draco + 7.62",gun="Draco",ammo="7.62"},
        {label="ClearMag + 7.62",gun="ClearMagDrac",ammo="7.62"},
        {label="AR Pistol + 5.56",gun="ARPistol",ammo="5.56"},
        {label="223 Tan + 5.56",gun="223Tan",ammo="5.56"},
        {label="Glock 17 + Ext",gun="Glock17",ammo=".Extended"},
        {label="Glock 22 + Ext",gun="Glock22",ammo=".Extended"},
        {label="Springfield",gun="SpringField XD",ammo=".Extended"},
        {label="HP Browning",gun="HPBrowning Ext",ammo=".Extended"},
        {label="Blade",gun="Blade",ammo=nil}
    }
    for _,g in ipairs(guns) do
        mkRow(r,g.label,"button",nil,function()
            task.spawn(function()
                local sr=RS:FindFirstChild("ShopRemote5") or RS:FindFirstChild("ShopRemote5",true)
                if sr then pcall(function() sr:InvokeServer(g.gun) end) end
                if g.ammo then
                    task.wait(0.4)
                    local ex=RS:FindFirstChild("ExoticShopRemote",true)
                    if ex then pcall(function() ex:InvokeServer(g.ammo) end) end
                end
                ntf("buy",g.gun)
            end)
        end)
    end
    local r2=mkCard("MAGS")
    local boxes={
        {label="Extended Mag",item=".Extended"},{label="Drum Mag",item=".Drum"},
        {label="10mm Ammo",item=".10mm"},{label="FN Mag",item=".FNMag"},
        {label="9mm",item="9mm"},{label="7.62",item="7.62"},{label="5.56",item="5.56"}
    }
    for _,b in ipairs(boxes) do
        mkRow(r2,b.label,"button",nil,function()
            local ex=RS:FindFirstChild("ExoticShopRemote",true)
            if ex then pcall(function() ex:InvokeServer(b.item) end) end
            ntf("buy",b.label)
        end)
    end
    local r3=mkCard("EXOTIC")
    local exo={
        {"FijiWater","FijiWater"},{"FreshWater","FreshWater"},{"Ice-Fruit Bag","Ice-Fruit Bag"},
        {"Ice-Fruit Cupz","Ice-Fruit Cupz"},{"Lemonade","Lemonade"},{"Bandage","Bandage"},
        {"G26","G26"},{"FakeCard","FakeCard"},{"Sledge Hammer","Sledge Hammer"},{"Screw","Screw"}
    }
    for _,e in ipairs(exo) do
        mkRow(r3,e[1],"button",nil,function()
            local ex=RS:FindFirstChild("ExoticShopRemote",true)
            if ex then pcall(function() ex:InvokeServer(e[2]) end) end
            ntf("buy",e[1])
        end)
    end
end)

addT("🧃","Juice",function()
    local JuiceRunning=false
    local AutoDeposit={on=false}
    local AutoDrop={on=false}
    local logLines={}
    local statusFrame

    local function rebuildLog()
        if not statusFrame then return end
        for _,c in ipairs(statusFrame:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        for i,line in ipairs(logLines) do
            local first=line:sub(1,1)
            local col=Th.tx
            if first=="!" then col=Color3.fromRGB(255,120,120)
            elseif first=="✓" then col=Color3.fromRGB(0,220,120)
            elseif first=="▶" then col=Th.sp
            elseif first=="■" then col=Color3.fromRGB(255,170,80)
            elseif first=="•" then col=Th.sub
            end
            mk("TextLabel",{BackgroundTransparency=1,Text=line,Font=Enum.Font.Code,TextSize=10,TextColor3=col,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=i,Parent=statusFrame})
        end
    end
    local function log(msg)
        table.insert(logLines,msg)
        while #logLines>30 do table.remove(logLines,1) end
        rebuildLog()
    end

    local rA=mkCard("ACTIONS")
    local startBtn=mk("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=Color3.fromRGB(0,150,220),BorderSizePixel=0,Text="▶  COOK + SELL",Font=Th.fB,TextSize=12,TextColor3=Color3.new(1,1,1),Parent=rA})
    mk("UICorner",{CornerRadius=UDim.new(0,8),Parent=startBtn})
    local stopBtn=mk("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=Color3.fromRGB(150,50,60),BorderSizePixel=0,Text="■  STOP",Font=Th.fB,TextSize=11,TextColor3=Color3.new(1,1,1),Parent=rA})
    mk("UICorner",{CornerRadius=UDim.new(0,8),Parent=stopBtn})

    local rM=mkCard("MONEY SPAM")
    local function mkTog(parent,label,getFn,setFn)
        local row=mk("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,AutoButtonColor=false,Text="",Parent=parent})
        local b=mk("Frame",{Size=UDim2.fromOffset(13,13),Position=UDim2.fromOffset(0,4),BackgroundColor3=getFn() and Th.on or Th.off,BorderSizePixel=0,Parent=row})
        mk("UICorner",{CornerRadius=UDim.new(1,0),Parent=b})
        mk("UIStroke",{Color=getFn() and Th.on or Th.str,Thickness=1,Parent=b})
        mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(20,0),Size=UDim2.new(1,-24,1,0),Parent=row})
        row.MouseButton1Click:Connect(function()
            local nv=not getFn()
            setFn(nv)
            b.BackgroundColor3=nv and Th.on or Th.off
            b.UIStroke.Color=nv and Th.on or Th.str
            log((nv and "✓ " or "■ ")..label..(nv and " ON" or " OFF"))
        end)
    end
    mkTog(rM,"Auto Deposit $30k",function() return AutoDeposit.on end,function(v) AutoDeposit.on=v end)
    mkTog(rM,"Auto Drop $10k",function() return AutoDrop.on end,function(v) AutoDrop.on=v end)

    task.spawn(function()
        while task.wait(0.5) do
            if AutoDeposit.on then
                pcall(function()
                    local ba=RS:FindFirstChild("BankAction",true)
                    if ba then ba:FireServer("depo",30000) end
                end)
            end
        end
    end)
    task.spawn(function()
        while task.wait(0.3) do
            if AutoDrop.on then
                pcall(function()
                    local bpr=RS:FindFirstChild("BankProcessRemote",true)
                    if bpr then bpr:InvokeServer("Drop",10000) end
                end)
            end
        end
    end)

    local rS=mkCard("STATUS")
    statusFrame=mk("ScrollingFrame",{Size=UDim2.new(1,0,0,140),BackgroundColor3=Th.bg,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=3,ScrollBarImageColor3=Th.ac,Parent=rS})
    mk("UICorner",{CornerRadius=UDim.new(0,6),Parent=statusFrame})
    mk("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),Parent=statusFrame})
    local sLay=mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=statusFrame})
    sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        statusFrame.CanvasSize=UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+10)
    end)
    log("Ready.")

    startBtn.MouseButton1Click:Connect(function()
        if JuiceRunning then log("already running") return end
        if not findStove() then log("! no CookingPots") return end
        if not findSeller() then log("! no IceFruit Sell") return end
        JuiceRunning=true
        logLines={}
        rebuildLog()
        log("▶ cook + sell")
        local startMoney=gM()
        log("• start: "..fmt(startMoney))
        task.spawn(function()
            local origCF=LP.Character and LP.Character.HumanoidRootPart and LP.Character.HumanoidRootPart.CFrame
            local exo=RS:FindFirstChild("ExoticShopRemote",true)
            if exo then
                for _,name in ipairs({"FijiWater","FreshWater","Ice-Fruit Bag","Ice-Fruit Cupz"}) do
                    if not hasItem(name) then pcall(function() exo:InvokeServer(name) end) task.wait(0.4) end
                end
            end
            log("• bought items")
            local stove,prompt=findStove()
            if stove and prompt then
                local cookPart=stove:FindFirstChild("CookPart") or stove.PrimaryPart or stove:FindFirstChildWhichIsA("BasePart",true)
                if cookPart then
                    log("• tp stove")
                    tp(cookPart.CFrame+Vector3.new(0,2,0))
                    task.wait(0.8)
                    local c=LP.Character
                    local hrp=c and c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Anchored=true end
                    task.wait(0.4)
                    log("• stove on")
                    fpr(prompt)
                    task.wait(1.8)
                    for _,name in ipairs({"FijiWater","FreshWater","Ice-Fruit Bag"}) do
                        if not JuiceRunning then break end
                        if equipByName(name) then
                            log("• +"..name)
                            task.wait(1)
                            fpr(prompt)
                            task.wait(3)
                        else log("! missing "..name) end
                    end
                    if equipCup() then
                        log("• brewing...")
                        local start=os.clock()
                        local cap=360
                        while JuiceRunning and (os.clock()-start)<cap do
                            fpr(prompt)
                            task.wait(0.5)
                            if findFullCup() then
                                log("✓ ready after "..math.floor(os.clock()-start).."s")
                                break
                            end
                            if not stoveBusy(cookPart) then
                                for _=1,10 do
                                    fpr(prompt)
                                    task.wait(0.3)
                                    if findFullCup() then break end
                                end
                            end
                        end
                    end
                    if hrp then hrp.Anchored=false end
                end
            end
            local sell,sPrompt=findSeller()
            if sell and sPrompt and findFullCup() then
                local c=LP.Character
                local h=c and c:FindFirstChildWhichIsA("Humanoid")
                local cup=findFullCup()
                if h and cup and cup.Parent~=c then pcall(function() h:EquipTool(cup) end) task.wait(0.5) end
                local cf
                if sell:IsA("BasePart") then cf=sell.CFrame
                else local p=sell:FindFirstChildWhichIsA("BasePart",true) cf=p and p.CFrame end
                if cf then
                    log("• tp seller")
                    tp(cf+Vector3.new(0,2,0))
                    task.wait(0.8)
                    sPrompt.HoldDuration=0
                    sPrompt.MaxActivationDistance=1000
                    sPrompt.RequiresLineOfSight=false
                    log("• burst sell...")
                    for _=1,4000 do task.spawn(function() pcall(function() fpr(sPrompt) end) end) end
                    task.wait(8)
                    log("✓ sell fired")
                end
            end
            task.wait(1)
            local now=gM()
            log("• made: "..fmt(now-startMoney))
            log("• total: "..fmt(now))
            JuiceRunning=false
            if origCF then pcall(function() tp(origCF) end) end
            log("■ done")
        end)
    end)
    stopBtn.MouseButton1Click:Connect(function()
        if JuiceRunning then JuiceRunning=false log("stopping...") else log("not running") end
    end)
end)

addT("🔐","Dupe",function()
    local r=mkCard("SAFE DUPE")
    local on=false
    mkRow(r,"Auto Dupe","toggle",false,function(v)
        on=v
        if v then
            task.spawn(function()
                if not findMyHouse() then
                    ntf("dupe","buying house...")
                    local ok=buyHouse()
                    if not ok then ntf("dupe","no for-sale") on=false return end
                    task.wait(2.5)
                end
                ntf("dupe","started")
                while on do
                    local t=tools()
                    if #t==0 then task.wait(1)
                    else
                        if not getSafe() then ntf("dupe","lost safe") on=false break end
                        dupe1(t[math.random(1,#t)])
                        task.wait(0.15)
                    end
                end
                ntf("dupe","stopped")
            end)
        end
    end)
    mkRow(r,"Dupe Once","button",nil,function()
        if not findMyHouse() then
            local ok=buyHouse()
            if not ok then ntf("dupe","no house") return end
            task.wait(2)
        end
        local t=tools()
        if #t==0 then ntf("dupe","no tools") return end
        dupe1(t[math.random(1,#t)])
        ntf("dupe","duped")
    end)
    mkRow(r,"Buy House","button",nil,function()
        task.spawn(function()
            if findMyHouse() then ntf("dupe","already own") return end
            local ok=buyHouse()
            if ok then ntf("dupe","bought") else ntf("dupe","no for-sale") end
        end)
    end)
end)

addT("🔫","Guns",function()
    local r=mkCard("AMMO")
    mkRow(r,"Infinite Ammo","toggle",false,function(v) GM.InfAmmo=v end)
    mkRow(r,"80k Bullets","toggle",false,function(v) GM.InfClips=v GM.Bullets80k=v end)
    mkRow(r,"Apply Now","button",nil,function()
        local c=LP.Character if not c then return end
        local t=c:FindFirstChildOfClass("Tool")
        if not t then ntf("guns","no gun") return end
        pcall(applyToGun,t)
        ntf("guns","applied")
    end)
    local r2=mkCard("CONTROL")
    mkRow(r2,"No Recoil","toggle",false,function(v) GM.Recoil=v end)
    mkRow(r2,"No Spread","toggle",false,function(v) GM.Spread=v end)
    mkRow(r2,"No Jam","toggle",false,function(v) GM.NoJam=v end)
    mkRow(r2,"Fully Auto","toggle",false,function(v) GM.Auto=v end)
    local r3=mkCard("SPEED / DMG")
    mkRow(r3,"Instant Reload","toggle",false,function(v) GM.InstReload=v end)
    mkRow(r3,"Instant Equip","toggle",false,function(v) GM.InstEquip=v end)
    mkRow(r3,"No Fire Rate","toggle",false,function(v) GM.FireRate=v end)
    mkRow(r3,"Infinite Damage","toggle",false,function(v) GM.InfDmg=v end)
    local r4=mkCard("VISUALS")
    mkRow(r4,"Rainbow Gun","toggle",false,function(v) GM.Rainbow=v end)
    mkRow(r4,"Solid Color","toggle",false,function(v) GM.SolidColor=v end)
    mkRow(r4,"Blue","button",nil,function() GM.ColorRGB=Color3.fromRGB(0,140,255) GM.SolidColor=true end)
    mkRow(r4,"Red","button",nil,function() GM.ColorRGB=Color3.fromRGB(255,60,60) GM.SolidColor=true end)
    mkRow(r4,"Green","button",nil,function() GM.ColorRGB=Color3.fromRGB(0,255,100) GM.SolidColor=true end)
end)

addT("⚙️","Set",function()
    local r=mkCard("HUB")
    mkRow(r,"Executor","label",(identifyexecutor and identifyexecutor()) or "?",nil)
    mkRow(r,"Rejoin","button",nil,function() pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end) end)
    mkRow(r,"Unload","button",nil,function() pcall(function() gui:Destroy() end) end)
end)

swt(1)
ntf("valria","loaded — tap V")
print("[valria] loaded")
