-- ═══ valria juice module ═══
local P=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local SG=game:GetService("StarterGui")
local LP=P.LocalPlayer
local function ntf(a,b) pcall(function() SG:SetCore("SendNotification",{Title=tostring(a),Text=tostring(b),Duration=3}) end) end
local function fpr(p)
    if not (p and p:IsA("ProximityPrompt")) then return end
    if fireproximityprompt then if pcall(fireproximityprompt,p) then return end end
    pcall(function()
        local h,d,l=p.HoldDuration,p.MaxActivationDistance,p.RequiresLineOfSight
        p.HoldDuration=0 p.MaxActivationDistance=1000 p.RequiresLineOfSight=false
        p:InputHoldBegin() task.wait() p:InputHoldEnd()
        p.MaxActivationDistance=d p.HoldDuration=h p.RequiresLineOfSight=l
    end)
end
getgenv().SwimMethod=false
task.spawn(function() while task.wait() do if getgenv().SwimMethod then local c=LP.Character local h=c and c:FindFirstChildWhichIsA("Humanoid") if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.FallingDown) end) end end end end)
local function tp(cf)
    local c=LP.Character local r=c and c:FindFirstChild("HumanoidRootPart") local h=c and c:FindFirstChildWhichIsA("Humanoid")
    if not r or not h or not cf then return end
    getgenv().SwimMethod=true pcall(function() h:ChangeState(Enum.HumanoidStateType.FallingDown) end)
    local t=os.clock() repeat task.wait() until not LP:GetAttribute("LastACPos") or (os.clock()-t>2.5)
    for i=1,3 do if not r.Parent then break end r.CFrame=cf r.AssemblyLinearVelocity=Vector3.zero r.AssemblyAngularVelocity=Vector3.zero task.wait() end
    pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end) getgenv().SwimMethod=false
end
local function gM()
    for _,src in ipairs({LP:FindFirstChild("stored"),LP:FindFirstChild("leaderstats")}) do
        if src then for _,n in ipairs({"Money","Cash","Wallet","Coins"}) do local v=src:FindFirstChild(n) if v and v:IsA("ValueBase") then local x=tonumber(v.Value) if x then return x end end end end
    end
    return 0
end
local function fmt(n) n=math.floor(tonumber(n) or 0) local s=tostring(n) return "$"..s:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","") end
local function hasIt(n)
    local c=LP.Character
    if c then for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name==n then return true end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and t.Name==n then return true end end end
    return false
end
local function eqName(n)
    local c=LP.Character if not c then return false end
    local h=c:FindFirstChildWhichIsA("Humanoid") if not h then return false end
    local held=c:FindFirstChildWhichIsA("Tool") if held and held.Name==n then return true end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and t.Name==n then pcall(function() h:EquipTool(t) end) task.wait(0.3) return true end end end
    return false
end
local function findCup()
    local c=LP.Character
    if c then local h=c:FindFirstChildWhichIsA("Tool") if h and tostring(h.Name):lower():find("cupz") then return h end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and tostring(t.Name):lower():find("cupz") then return t end end end
    return nil
end
local function isFull(tool)
    if not tool then return false end
    local cp=tool:FindFirstChild("IceFruit Cup") or tool:FindFirstChildWhichIsA("BasePart",true)
    if not cp then return false end
    for _,d in ipairs(cp:GetDescendants()) do if d.Name:lower():find("punch") and d:IsA("BasePart") and d.Transparency<1 then return true end end
    return false
end
local function findFull()
    local c=LP.Character
    if c then local h=c:FindFirstChildWhichIsA("Tool") if h and isFull(h) then return h end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and isFull(t) then return t end end end
    return nil
end
local function findStove()
    local cps=workspace:FindFirstChild("CookingPots") if not cps then return nil,nil end
    for _,v in ipairs(cps:GetChildren()) do if v:IsA("Model") then local pr=v:FindFirstChildWhichIsA("ProximityPrompt",true) if pr then return v,pr end end end
    return nil,nil
end
local function findSell()
    local s=workspace:FindFirstChild("IceFruit Sell") if not s then return nil,nil end
    return s,s:FindFirstChild("ProximityPrompt") or s:FindFirstChildWhichIsA("ProximityPrompt",true)
end
local function stoveBusy(cp)
    if not cp then return false end
    local steam=cp:FindFirstChild("Steam",true) if not steam then return false end
    local lui=steam:FindFirstChild("LoadUI",true) if lui then return lui.Enabled end
    return false
end

-- ═══ UI ═══
local parent=(gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
local old=parent:FindFirstChild("ValriaJuice")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="ValriaJuice"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=505
gui.Parent=parent

local Th={bg=Color3.fromRGB(10,12,18),side=Color3.fromRGB(14,17,24),pS=Color3.fromRGB(20,24,34),pS2=Color3.fromRGB(26,30,42),str=Color3.fromRGB(38,44,58),ac=Color3.fromRGB(0,140,255),acD=Color3.fromRGB(0,90,180),sp=Color3.fromRGB(120,200,255),tx=Color3.fromRGB(230,236,244),sub=Color3.fromRGB(140,150,172),on=Color3.fromRGB(0,150,255),off=Color3.fromRGB(45,52,66),fM=Enum.Font.GothamMedium,fB=Enum.Font.GothamBold}
local function mk(c,p) local o=Instance.new(c) for k,v in pairs(p or {}) do o[k]=v end return o end

local W,H=280,340
local win=mk("Frame",{Size=UDim2.fromOffset(W,H),Position=UDim2.new(0.5,-W/2,0.5,-H/2),BackgroundColor3=Th.bg,BorderSizePixel=0,ClipsDescendants=true,Parent=gui,Visible=false})
mk("UICorner",{CornerRadius=UDim.new(0,10),Parent=win})
mk("UIStroke",{Color=Th.str,Thickness=1,Parent=win})

local tb=mk("Frame",{Size=UDim2.new(1,0,0,24),BackgroundColor3=Th.side,BorderSizePixel=0,Parent=win})
mk("TextLabel",{BackgroundTransparency=1,Text="VALRIA JUICE",Font=Th.fB,TextSize=11,TextColor3=Th.ac,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-40,1,0),Parent=tb})
local cb=mk("TextButton",{Text="✕",Font=Th.fB,TextSize=11,TextColor3=Th.tx,BackgroundTransparency=1,Size=UDim2.fromOffset(22,20),Position=UDim2.new(1,-28,0,2),Parent=tb})
cb.MouseButton1Click:Connect(function() win.Visible=false end)

local body=mk("ScrollingFrame",{Position=UDim2.fromOffset(0,24),Size=UDim2.new(1,0,1,-24),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=3,ScrollBarImageColor3=Th.ac,Parent=win})
mk("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),Parent=body})
local bl=mk("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,Parent=body})
bl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() body.CanvasSize=UDim2.new(0,0,0,bl.AbsoluteContentSize.Y+16) end)

local circ=mk("TextButton",{Size=UDim2.fromOffset(46,46),Position=UDim2.new(0,12,0.4,-23),BackgroundColor3=Th.bg,BorderSizePixel=0,Text="💵",Font=Th.fB,TextSize=20,TextColor3=Th.ac,Active=true,Draggable=true,Visible=true,Parent=gui})
mk("UICorner",{CornerRadius=UDim.new(1,0),Parent=circ})
mk("UIStroke",{Color=Th.ac,Thickness=2,Parent=circ})
circ.MouseButton1Click:Connect(function()
    if win.Visible then win.Visible=false
    else local cp=circ.AbsolutePosition local cs=circ.AbsoluteSize win.Position=UDim2.fromOffset(cp.X+cs.X+8,cp.Y+cs.Y/2-H/2) win.Visible=true end
end)

local function mkCard(t)
    local c=mk("Frame",{BackgroundColor3=Th.pS,BorderSizePixel=0,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Parent=body})
    mk("UICorner",{CornerRadius=UDim.new(0,7),Parent=c})
    mk("UIStroke",{Color=Th.str,Thickness=1,Parent=c})
    mk("UIPadding",{PaddingTop=UDim.new(0,7),PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9),Parent=c})
    mk("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,Parent=c})
    mk("TextLabel",{BackgroundTransparency=1,Text=t,Font=Th.fB,TextSize=10,TextColor3=Th.sp,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,13),LayoutOrder=0,Parent=c})
    local r=mk("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=1,Parent=c})
    mk("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=r})
    return r,c
end

local logLines={}
local statusFrame
local function rebuildLog()
    if not statusFrame then return end
    for _,c in ipairs(statusFrame:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for i,line in ipairs(logLines) do
        local first=line:sub(1,1)
        local col=Th.tx
        if first=="!" then col=Color3.fromRGB(255,120,120)
        elseif first=="✓" then col=Color3.fromRGB(0,220,120)
        elseif first=="▶" then col=Th.sp
        elseif first=="■" then col=Color3.fromRGB(255,170,80)
        elseif first=="•" then col=Th.sub end
        mk("TextLabel",{BackgroundTransparency=1,Text=line,Font=Enum.Font.Code,TextSize=10,TextColor3=col,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=i,Parent=statusFrame})
    end
end
local function log(m) table.insert(logLines,m) while #logLines>30 do table.remove(logLines,1) end rebuildLog() end

local JuiceRunning=false
local AutoDeposit={on=false}
local AutoDrop={on=false}

local rA=mkCard("ACTIONS")
local startBtn=mk("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=Color3.fromRGB(0,150,220),BorderSizePixel=0,Text="▶  COOK + SELL",Font=Th.fB,TextSize=12,TextColor3=Color3.new(1,1,1),Parent=rA})
mk("UICorner",{CornerRadius=UDim.new(0,8),Parent=startBtn})
local stopBtn=mk("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundColor3=Color3.fromRGB(150,50,60),BorderSizePixel=0,Text="■  STOP",Font=Th.fB,TextSize=11,TextColor3=Color3.new(1,1,1),Parent=rA})
mk("UICorner",{CornerRadius=UDim.new(0,8),Parent=stopBtn})

local rM=mkCard("MONEY SPAM")
local function mkTog(parent,label,getFn,setFn)
    local row=mk("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,AutoButtonColor=false,Text="",Parent=parent})
    local b=mk("Frame",{Size=UDim2.fromOffset(13,13),Position=UDim2.fromOffset(0,4),BackgroundColor3=getFn() and Th.on or Th.off,BorderSizePixel=0,Parent=row})
    mk("UICorner",{CornerRadius=UDim.new(1,0),Parent=b})
    mk("UIStroke",{Color=getFn() and Th.on or Th.str,Thickness=1,Parent=b})
    mk("TextLabel",{BackgroundTransparency=1,Text=label,Font=Th.fM,TextSize=10,TextColor3=Th.tx,TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(20,0),Size=UDim2.new(1,-24,1,0),Parent=row})
    row.MouseButton1Click:Connect(function()
        local nv=not getFn() setFn(nv)
        b.BackgroundColor3=nv and Th.on or Th.off
        b.UIStroke.Color=nv and Th.on or Th.str
        log((nv and "✓ " or "■ ")..label..(nv and " ON" or " OFF"))
    end)
end
mkTog(rM,"Auto Deposit $30k",function() return AutoDeposit.on end,function(v) AutoDeposit.on=v end)
mkTog(rM,"Auto Drop $10k",function() return AutoDrop.on end,function(v) AutoDrop.on=v end)
task.spawn(function() while task.wait(0.5) do if AutoDeposit.on then pcall(function() local ba=RS:FindFirstChild("BankAction",true) if ba then ba:FireServer("depo",30000) end end) end end end)
task.spawn(function() while task.wait(0.3) do if AutoDrop.on then pcall(function() local bpr=RS:FindFirstChild("BankProcessRemote",true) if bpr then bpr:InvokeServer("Drop",10000) end end) end end end)

local rS=mkCard("STATUS")
statusFrame=mk("ScrollingFrame",{Size=UDim2.new(1,0,0,140),BackgroundColor3=Th.bg,BorderSizePixel=0,CanvasSize=UDim2.new(0,0,0,0),ScrollBarThickness=3,ScrollBarImageColor3=Th.ac,Parent=rS})
mk("UICorner",{CornerRadius=UDim.new(0,6),Parent=statusFrame})
mk("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),Parent=statusFrame})
local sLay=mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=statusFrame})
sLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() statusFrame.CanvasSize=UDim2.new(0,0,0,sLay.AbsoluteContentSize.Y+10) end)
log("Ready.")

startBtn.MouseButton1Click:Connect(function()
    if JuiceRunning then log("already running") return end
    if not findStove() then log("! no CookingPots") return end
    if not findSell() then log("! no IceFruit Sell") return end
    JuiceRunning=true
    logLines={} rebuildLog()
    log("▶ cook + sell")
    local startMoney=gM() log("• start: "..fmt(startMoney))
    task.spawn(function()
        local origCF=LP.Character and LP.Character.HumanoidRootPart and LP.Character.HumanoidRootPart.CFrame
        local exo=RS:FindFirstChild("ExoticShopRemote",true)
        if exo then for _,name in ipairs({"FijiWater","FreshWater","Ice-Fruit Bag","Ice-Fruit Cupz"}) do
            if not hasIt(name) then pcall(function() exo:InvokeServer(name) end) task.wait(0.4) end
        end end
        log("• bought items")
        local stove,prompt=findStove()
        if stove and prompt then
            local cp=stove:FindFirstChild("CookPart") or stove.PrimaryPart or stove:FindFirstChildWhichIsA("BasePart",true)
            if cp then
                log("• tp stove") tp(cp.CFrame+Vector3.new(0,2,0)) task.wait(0.8)
                local c=LP.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored=true end task.wait(0.4)
                log("• stove on") fpr(prompt) task.wait(1.8)
                for _,name in ipairs({"FijiWater","FreshWater","Ice-Fruit Bag"}) do
                    if not JuiceRunning then break end
                    if eqName(name) then log("• +"..name) task.wait(1) fpr(prompt) task.wait(3) else log("! missing "..name) end
                end
                if findCup() then
                    log("• brewing...")
                    local start=os.clock()
                    local cap=360
                    while JuiceRunning and (os.clock()-start)<cap do
                        fpr(prompt) task.wait(0.5)
                        if findFull() then log("✓ ready after "..math.floor(os.clock()-start).."s") break end
                        if not stoveBusy(cp) then for _=1,10 do fpr(prompt) task.wait(0.3) if findFull() then break end end end
                    end
                end
                if hrp then hrp.Anchored=false end
            end
        end
        local sell,sPrompt=findSell()
        if sell and sPrompt and findFull() then
            local c=LP.Character local h=c and c:FindFirstChildWhichIsA("Humanoid")
            local cup=findFull()
            if h and cup and cup.Parent~=c then pcall(function() h:EquipTool(cup) end) task.wait(0.5) end
            local cf if sell:IsA("BasePart") then cf=sell.CFrame else local p=sell:FindFirstChildWhichIsA("BasePart",true) cf=p and p.CFrame end
            if cf then
                log("• tp seller") tp(cf+Vector3.new(0,2,0)) task.wait(0.8)
                sPrompt.HoldDuration=0 sPrompt.MaxActivationDistance=1000 sPrompt.RequiresLineOfSight=false
                log("• burst sell...")
                for _=1,4000 do task.spawn(function() pcall(function() fpr(sPrompt) end) end) end
                task.wait(8) log("✓ sell fired")
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
stopBtn.MouseButton1Click:Connect(function() if JuiceRunning then JuiceRunning=false log("stopping...") else log("not running") end end)

ntf("valria","juice menu ready")
print("[valria-juice] loaded")
