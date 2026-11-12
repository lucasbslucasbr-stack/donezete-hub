-- Donezete Hub v2 | LocalScript em StarterPlayerScripts no seu jogo.
local Players=game:GetService('Players')
local Run=game:GetService('RunService')
local Input=game:GetService('UserInputService')
local Tween=game:GetService('TweenService')
local Lighting=game:GetService('Lighting')
local Tags=game:GetService('CollectionService')
local Http=game:GetService('HttpService')
local RS=game:GetService('ReplicatedStorage')
local me=Players.LocalPlayer
assert(me,'Execute no cliente')
local pg=me:WaitForChild('PlayerGui')
local previous=pg:FindFirstChild('PainelMira')
if previous then previous:Destroy() end
local defaults={aim=false,rage=false,pullLevel=2,visualEnabled=false,fovOverride=false,part=1,nearest=false,fovEnabled=false,fov=90,distance=100,speed=14,switch=false,wall=false,prediction=false,lead=.08,legit=false,smooth=50,horizontal=50,vertical=55,accel=false,decel=false,dynamic=false,micro=false,tracking=false,deadzone=3,team=false,box=false,skeleton=false,name=false,health=false,distanceESP=false,weapon=false,head=false,line=false,teamESP=false,armor=false,visibility=false,item=false,ammo=false,objective=false,radar=false,outline=false,espDistance=300,thickness=1,textSize=12,transparency=.1,color=1,saturation=100,brightness=0,contrast=0,cameraFov=70,filter=1,performance=false,preset=1,compact=false,opacity=.95,privacy=false,presentation=false,logo='',gamma=1,sharpness=0,stretch=1,effects=1}
local cfg={}
for k,v in pairs(defaults) do cfg[k]=v end
local cons,visuals,markers={}, {}, {}
local dead=false
local palette={Color3.fromRGB(145,255,45),Color3.fromRGB(60,205,255),Color3.fromRGB(255,175,65),Color3.fromRGB(230,100,255)}
local color=palette[1]
local integration={}
local adapter=script and script:FindFirstChild('Integration')
if adapter and adapter:IsA('ModuleScript') then integration=require(adapter) end
local function make(class,props,parent)
 local o=Instance.new(class); for k,v in pairs(props) do o[k]=v end; o.Parent=parent; return o
end
local function on(sig,fn) local c=sig:Connect(fn); table.insert(cons,c); return c end
local gui=make('ScreenGui',{Name='PainelMira',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=50,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
local overlay=make('Frame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false},gui)
local panel=make('Frame',{Size=UDim2.fromOffset(780,490),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),BackgroundColor3=Color3.fromRGB(15,17,18),BorderSizePixel=0,ZIndex=5},gui)
make('UICorner',{CornerRadius=UDim.new(0,12)},panel)
make('UIStroke',{Color=color,Transparency=.6},panel)
local scale=make('UIScale',{Scale=1},panel)
local header=make('TextButton',{Text='DONEZETE  /  HUB  v2',Font=Enum.Font.GothamBold,TextSize=19,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=color,BackgroundTransparency=1,Position=UDim2.fromOffset(20,0),Size=UDim2.new(1,-80,0,56),ZIndex=6},panel)
local close=make('TextButton',{Text='×',TextSize=26,TextColor3=color,BackgroundTransparency=1,Size=UDim2.fromOffset(44,44),Position=UDim2.new(1,-48,0,5),ZIndex=7},panel)
local tabs=make('Frame',{Position=UDim2.fromOffset(14,58),Size=UDim2.new(1,-28,0,38),BackgroundTransparency=1,ZIndex=6},panel)
make('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},tabs)
local footer=make('TextLabel',{Text='AMBIENTE AUTORIZADO  /  CLIENTE',TextColor3=Color3.fromRGB(130,140,130),Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.new(0,18,1,-34),Size=UDim2.new(1,-130,0,24),ZIndex=6},panel)
local logo=make('ImageLabel',{BackgroundTransparency=1,Position=UDim2.new(1,-100,1,-48),Size=UDim2.fromOffset(80,40),ScaleType=Enum.ScaleType.Fit,ZIndex=6},panel)
local signature=make('TextLabel',{Text='DONEZETE HUB',Font=Enum.Font.GothamBold,TextColor3=color,TextSize=10,BackgroundTransparency=1,Position=logo.Position,Size=logo.Size,ZIndex=6},panel)
local floating=make('TextButton',{Name='FloatingToggle',Text='DH',Font=Enum.Font.GothamBold,TextSize=16,TextColor3=color,BackgroundColor3=Color3.fromRGB(20,24,20),Position=UDim2.fromOffset(18,100),Size=UDim2.fromOffset(48,48),ZIndex=40,Visible=true},gui)
make('UICorner',{CornerRadius=UDim.new(1,0)},floating)
make('UIStroke',{Color=color,Thickness=2,Transparency=.15},floating)
local centerButton=make('TextButton',{Name='InvisibleCenterToggle',Text='',AutoButtonColor=false,BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(24,24),ZIndex=30},gui)
-- No crosshair or FOV circle is rendered. The center hit area is transparent.
local function showToggle() panel.Visible=not panel.Visible end
on(close.Activated,showToggle); on(floating.Activated,showToggle); on(centerButton.Activated,showToggle)
on(Input.InputBegan,function(i,used) if not used and i.KeyCode==Enum.KeyCode.RightShift then showToggle() end end)
local drag,start,origin
on(header.InputBegan,function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=i; start=i.Position; origin=panel.Position end
end)
on(Input.InputChanged,function(i)
 if drag and (i==drag or i.UserInputType==Enum.UserInputType.MouseMovement) then
  local d=i.Position-start
  local v=workspace.CurrentCamera.ViewportSize
  panel.Position=UDim2.fromOffset(math.clamp(origin.X.Scale*v.X+origin.X.Offset+d.X,70,v.X-70),math.clamp(origin.Y.Scale*v.Y+origin.Y.Offset+d.Y,60,v.Y-60))
 end
end)
on(Input.InputEnded,function(i) if i==drag then drag=nil end end)
local refreshers={}
local pages,tabButtons={},{}
local current='AIMBOT'
local function selectPage(name)
 current=name
 for n,page in pairs(pages) do page.Visible=n==name; tabButtons[n].TextColor3=n==name and color or Color3.fromRGB(145,150,145) end
end
local function page(name)
 local b=make('TextButton',{Size=UDim2.new(.2,-4,1,0),Text=name,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=color,BackgroundColor3=Color3.fromRGB(27,30,28),BorderSizePixel=0,ZIndex=6},tabs)
 make('UICorner',{CornerRadius=UDim.new(0,5)},b)
 local f=make('ScrollingFrame',{Position=UDim2.fromOffset(16,110),Size=UDim2.new(1,-32,1,-160),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=color,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ZIndex=6,Visible=false},panel)
 make('UIListLayout',{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},f)
 pages[name]=f; tabButtons[name]=b; on(b.Activated,function() selectPage(name) end); return f
end
local rowOrder=0
local function row(parent,title)
 rowOrder=rowOrder+1
 local f=make('Frame',{LayoutOrder=rowOrder,Size=UDim2.new(1,-8,0,42),BackgroundColor3=Color3.fromRGB(24,27,25),BorderSizePixel=0,ZIndex=6},parent)
 make('UICorner',{CornerRadius=UDim.new(0,6)},f)
 make('TextLabel',{Text=title,Font=Enum.Font.Gotham,TextSize=13,TextColor3=Color3.fromRGB(220,225,220),TextXAlignment=Enum.TextXAlignment.Left,Position=UDim2.fromOffset(12,0),Size=UDim2.new(.53,-12,1,0),BackgroundTransparency=1,ZIndex=7},f)
 return f
end
local function toggle(parent,title,key)
 local f=row(parent,title)
 local b=make('TextButton',{Size=UDim2.fromOffset(58,26),Position=UDim2.new(1,-70,.5,-13),TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=7},f)
 make('UICorner',{CornerRadius=UDim.new(1,0)},b)
 local function update() b.Text=cfg[key] and 'ON' or 'OFF'; Tween:Create(b,TweenInfo.new(.12),{BackgroundColor3=cfg[key] and color or Color3.fromRGB(65,70,65)}):Play() end
 on(b.Activated,function()
  cfg[key]=not cfg[key]
  if key=='aim' and cfg.aim then cfg.rage=false end
  if key=='rage' and cfg.rage then cfg.aim=false end
  for _,refresh in ipairs(refreshers) do refresh() end
 end); table.insert(refreshers,update); update()
end
local function slider(parent,title,key,lo,hi,step)
 local f=row(parent,title)
 local track=make('TextButton',{Text='',AutoButtonColor=false,Position=UDim2.new(.57,0,.5,-3),Size=UDim2.new(.28,0,0,6),BackgroundColor3=Color3.fromRGB(60,65,60),BorderSizePixel=0,ZIndex=7},f)
 local fill=make('Frame',{BackgroundColor3=color,BorderSizePixel=0,Size=UDim2.new(),ZIndex=8},track)
 local hit=make('TextButton',{Text='',BackgroundTransparency=1,Position=UDim2.fromOffset(0,-15),Size=UDim2.new(1,0,0,36),ZIndex=9},track)
 local val=make('TextLabel',{BackgroundTransparency=1,TextColor3=color,TextSize=11,Position=UDim2.new(.86,0,0,0),Size=UDim2.new(.14,0,1,0),ZIndex=7},f)
 local function update() fill.Size=UDim2.fromScale((cfg[key]-lo)/(hi-lo),1); val.Text=string.format(step<1 and '%.2f' or '%.0f',cfg[key]) end
 local held
 local function set(x) cfg[key]=math.clamp(math.floor((lo+math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)*(hi-lo))/step+.5)*step,lo,hi); update() end
 on(hit.InputBegan,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then held=i; set(i.Position.X) end end)
 on(Input.InputChanged,function(i) if held and (i==held or i.UserInputType==Enum.UserInputType.MouseMovement) then set(i.Position.X) end end)
 on(Input.InputEnded,function(i) if i==held then held=nil end end)
 table.insert(refreshers,update); update()
end
local function action(parent,title,fn)
 local f=row(parent,title)
 local b=make('TextButton',{Text='APLICAR',Size=UDim2.fromOffset(125,28),Position=UDim2.new(1,-137,.5,-14),TextSize=11,TextColor3=color,BackgroundColor3=Color3.fromRGB(40,47,38),BorderSizePixel=0,ZIndex=7},f)
 on(b.Activated,function() fn(b) end); return b
end
local function choice(parent,title,key,items)
 local b=action(parent,title,function(btn) cfg[key]=cfg[key]%#items+1; btn.Text=items[cfg[key]] end)
 local function update() b.Text=items[cfg[key]] end
 table.insert(refreshers,update); update()
end
local a=page('AIMBOT')
toggle(a,'Aimbot suave','aim')
toggle(a,'Aimbot Rage','rage')
choice(a,'Forca da puxada','pullLevel',{'Leve','Medio','Forte','Muito forte','Instantaneo'})
 choice(a,'Regiao: Head / Body / Leg','part',{'Cabeca','Corpo','Perna'})
toggle(a,'Alvo mais proximo (distancia)','nearest'); toggle(a,'FOV personalizado (padrao: 90 px)','fovEnabled')
slider(a,'Raio FOV (pixels)','fov',20,300,1); slider(a,'Distancia maxima (studs)','distance',10,500,1)
slider(a,'Velocidade de mira','speed',1,25,1); toggle(a,'Trocar apos eliminacao','switch')
toggle(a,'Verificar visibilidade','wall'); toggle(a,'Prever movimento','prediction')
slider(a,'Antecipacao (segundos)','lead',0,.3,.01); toggle(a,'Ignorar aliados','team')
local l=page('LEGITBOT')
toggle(l,'Legitbot / respeitar movimento','legit'); slider(l,'Smooth Aim (%)','smooth',0,100,1)
slider(l,'Suavidade horizontal','horizontal',0,100,1); slider(l,'Suavidade vertical','vertical',0,100,1)
toggle(l,'Aceleracao gradual','accel'); toggle(l,'Desacelerar perto do alvo','decel')
toggle(l,'Suavidade dinamica','dynamic'); toggle(l,'Microajustes','micro')
toggle(l,'Acompanhar alvo atual','tracking'); slider(l,'Deadzone (pixels)','deadzone',0,30,1)
local e=page('ESP')
for _,v in ipairs({{'Box','box'},{'Skeleton','skeleton'},{'Nome','name'},{'Vida','health'},{'Distancia','distanceESP'},{'Arma equipada','weapon'},{'Head Dot','head'},{'Snaplines','line'},{'Equipe','teamESP'},{'Armadura [atributo Armor]','armor'},{'Cor por visibilidade','visibility'},{'Itens [tag FPSItem]','item'},{'Municao [atributo Ammo]','ammo'},{'Objetivos [tag FPSObjective]','objective'},{'Radar','radar'},{'Contorno','outline'}}) do toggle(e,v[1],v[2]) end
slider(e,'Distancia ESP (studs)','espDistance',20,1000,10); choice(e,'Cor','color',{'Neon','Azul','Laranja','Roxo'})
slider(e,'Espessura','thickness',1,4,1); slider(e,'Tamanho do texto','textSize',10,20,1); slider(e,'Transparencia','transparency',0,.9,.05)
local v=page('VISUAL')
toggle(v,'Ativar ajustes de imagem','visualEnabled')
toggle(v,'Alterar FOV da camera','fovOverride')
slider(v,'Saturacao (%)','saturation',0,200,1); slider(v,'Brilho','brightness',-.5,.5,.01); slider(v,'Contraste','contrast',-.5,.5,.01)
slider(v,'Campo de visao','cameraFov',40,110,1); choice(v,'Filtro','filter',{'Original','Frio','Quente','Verde'})
toggle(v,'Modo desempenho','performance')
local function hookControl(name,title,key,lo,hi,step)
 if type(integration[name])=='function' then slider(v,title,key,lo,hi,step)
 else action(v,title..' / requer renderer',function(b) b.Text='INDISPONIVEL' end).Text='SEM API ROBLOX' end
end
hookControl('SetGamma','Gamma','gamma',.5,2,.05); hookControl('SetSharpness','Nitidez','sharpness',0,1,.05)
hookControl('SetCameraEffects','Efeitos de camera','effects',0,1,.05)
if type(integration.SetStretch)=='function' then choice(v,'Tela esticada real','stretch',{'Original','4:3','5:4','16:10'})
else action(v,'Tela esticada real / requer renderer',function(b) b.Text='INDISPONIVEL' end).Text='SEM API ROBLOX' end
action(v,'Restaurar proporcao',function() cfg.stretch=1; if integration.SetStretch then integration.SetStretch('original') end end)
choice(v,'Perfil visual','preset',{'Neutro','Vivo','Cinema'})
action(v,'Aplicar perfil visual',function()
 local presets={{100,0,0,1},{145,.03,.12,1},{85,-.03,.18,2}}
 local p=presets[cfg.preset]; cfg.saturation=p[1]; cfg.brightness=p[2]; cfg.contrast=p[3]; cfg.filter=p[4]
 for _,f in ipairs(refreshers) do f() end
end)
local c=page('CONFIG')
toggle(c,'Modo compacto','compact'); slider(c,'Opacidade do painel','opacity',.4,1,.05)
toggle(c,'Ocultar nomes pessoais','privacy'); toggle(c,'Apresentacao: ocultar overlays','presentation')
local logoRow=row(c,'Logo: ID de imagem Roblox')
local logoInput=make('TextBox',{Text='',PlaceholderText='rbxassetid://...',ClearTextOnFocus=false,Size=UDim2.new(.45,-12,0,28),Position=UDim2.new(.55,0,.5,-14),BackgroundColor3=Color3.fromRGB(35,40,35),TextColor3=color,TextSize=11,ZIndex=7},logoRow)
on(logoInput.FocusLost,function() local id=logoInput.Text:match('%d+'); cfg.logo=id and 'rbxassetid://'..id or '' end)
local remote=RS:FindFirstChild('DonezeteSettings')
local function apply(data)
 if type(data)~='table' then return end
 for k,d in pairs(defaults) do
  local x=data[k]
  if type(x)==type(d) and (type(x)~='number' or (x==x and math.abs(x)<10000)) then cfg[k]=x end
 end
 -- Import parameters only: even old profiles must not enable features.
 for k,d in pairs(defaults) do if type(d)=='boolean' then cfg[k]=false end end
 -- Only accept numbers from our own bounded controls, with the same limits.
 local ranges={pullLevel={1,5},part={1,3},color={1,4},filter={1,4},preset={1,3},stretch={1,4},smooth={0,100},horizontal={0,100},vertical={0,100},opacity={.4,1},fov={20,300},distance={10,500},speed={1,25},lead={0,.3},deadzone={0,30},espDistance={20,1000},thickness={1,4},textSize={10,20},transparency={0,.9},saturation={0,200},brightness={-.5,.5},contrast={-.5,.5},cameraFov={40,110},gamma={.5,2},sharpness={0,1},effects={0,1}}
 for k,r in pairs(ranges) do cfg[k]=math.clamp(cfg[k],r[1],r[2]) end
 for _,k in ipairs({'part','color','filter','preset','stretch','pullLevel'}) do cfg[k]=math.floor(cfg[k]) end
 for _,f in ipairs(refreshers) do f() end
 logoInput.Text=cfg.logo
end
action(c,'Salvar configuracoes',function(b)
 remote=RS:FindFirstChild('DonezeteSettings')
 if not remote then b.Text='INSTALE O SERVER'; return end
 local ok,result=pcall(function() return remote:InvokeServer('save',cfg) end)
 b.Text=ok and result and 'SALVO' or 'FALHA AO SALVAR'
end)
action(c,'Carregar ajustes (funcoes OFF)',function(b)
 remote=RS:FindFirstChild('DonezeteSettings')
 if not remote then b.Text='INSTALE O SERVER'; return end
 local ok,data=pcall(function() return remote:InvokeServer('load') end)
 if ok and type(data)=='table' then apply(data); b.Text='CARREGADO' else b.Text='SEM DADOS / FALHA' end
end)
action(c,'Restaurar padrao',function() apply(defaults) end)
action(c,'Remover painel',function() gui:Destroy() end)
selectPage('AIMBOT')
local parts={{'Head'},{'UpperTorso','Torso','HumanoidRootPart'},{'LeftLowerLeg','Left Leg','RightLowerLeg','Right Leg'}}
local function eligible(p)
 if p==me or (cfg.team and me.Team~=nil and p.Team==me.Team) then return end
 local ch=p.Character; local hum=ch and ch:FindFirstChildOfClass('Humanoid')
 if hum and hum.Health>0 then return ch,hum end
end
local function targetPart(ch)
 for _,name in ipairs(parts[cfg.part]) do local p=ch:FindFirstChild(name); if p and p:IsA('BasePart') then return p end end
end
local function visible(cam,ch,part)
 local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=me.Character and {me.Character} or {}
 local hit=workspace:Raycast(cam.CFrame.Position,part.Position-cam.CFrame.Position,params)
 return not hit or hit.Instance:IsDescendantOf(ch)
end
local function newVisual()
 local root=make('Frame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false},overlay)
 local box=make('Frame',{BackgroundTransparency=1,BorderSizePixel=0},root)
 make('UIStroke',{Color=color,Thickness=1.5},box)
 local line=make('Frame',{BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(.5,.5)},root)
 local health=make('Frame',{BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0},root)
 local fill=make('Frame',{BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1)},health)
 local text=make('TextLabel',{BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=.3,TextSize=12,Font=Enum.Font.Gotham},root)
 local hl=make('Highlight',{FillTransparency=1,OutlineColor=color,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Enabled=false},gui)
 local details=make('TextLabel',{BackgroundTransparency=1,TextColor3=Color3.fromRGB(210,220,210),TextStrokeTransparency=.25,TextWrapped=true,TextSize=12,Font=Enum.Font.Gotham},root)
 local armor=make('Frame',{BorderSizePixel=0,BackgroundColor3=Color3.fromRGB(45,95,130),Visible=false},root)
 local armorFill=make('Frame',{BorderSizePixel=0,BackgroundColor3=Color3.fromRGB(85,190,255)},armor)
 return {root=root,box=box,line=line,health=health,fill=fill,text=text,details=details,armor=armor,armorFill=armorFill,hl=hl}
end
-- Use direct character parts, excluding accessory handles, tools and VFX.
-- Recompute body extent at 10 Hz; project eight corners at the overlay cadence.
local function bounds(cam,ch,v,now)
 local root=ch:FindFirstChild('HumanoidRootPart')
 if not root then return end
 if v.boundsCharacter~=ch or now>=(v.boundsAt or 0) then
  v.boundsCharacter=ch; v.boundsAt=now+.1
  local low=Vector3.new(math.huge,math.huge,math.huge)
  local high=Vector3.new(-math.huge,-math.huge,-math.huge)
  local count=0
  for _,part in ipairs(ch:GetChildren()) do
   if part:IsA('BasePart') and part~=root and part.Transparency<1 then
    for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
     local q=root.CFrame:PointToObjectSpace(part.CFrame:PointToWorldSpace(Vector3.new(x*part.Size.X,y*part.Size.Y,z*part.Size.Z)*.5))
     low=Vector3.new(math.min(low.X,q.X),math.min(low.Y,q.Y),math.min(low.Z,q.Z))
     high=Vector3.new(math.max(high.X,q.X),math.max(high.Y,q.Y),math.max(high.Z,q.Z))
     count=count+1
    end end end
   end
  end
  v.boundsLow=count>0 and low or -root.Size*.5
  v.boundsHigh=count>0 and high or root.Size*.5
 end
 local low,high=v.boundsLow,v.boundsHigh
 local view=cam.ViewportSize
 local x1,y1,x2,y2=math.huge,math.huge,-math.huge,-math.huge
 for x=0,1 do for y=0,1 do for z=0,1 do
  local p=cam:WorldToViewportPoint(root.CFrame:PointToWorldSpace(Vector3.new(x==0 and low.X or high.X,y==0 and low.Y or high.Y,z==0 and low.Z or high.Z)))
  if p.Z>.1 then
   x1=math.min(x1,p.X); y1=math.min(y1,p.Y); x2=math.max(x2,p.X); y2=math.max(y2,p.Y)
  end
 end end end
 if x1==math.huge or x2<0 or y2<0 or x1>view.X or y1>view.Y then return end
 x1=math.clamp(x1,0,view.X); y1=math.clamp(y1,0,view.Y)
 x2=math.clamp(x2,0,view.X); y2=math.clamp(y2,0,view.Y)
 if x2-x1<1 or y2-y1<1 then return end
 return x1,y1,x2-x1,y2-y1
end
local radar=make('Frame',{Visible=false,Position=UDim2.new(1,-160,0,30),Size=UDim2.fromOffset(140,140),BackgroundColor3=Color3.fromRGB(15,25,15),BackgroundTransparency=.2,ClipsDescendants=true},overlay)
make('UICorner',{CornerRadius=UDim.new(1,0)},radar)
make('TextLabel',{Text='+',TextColor3=color,BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},radar)
local effect=make('ColorCorrectionEffect',{Name='DonezeteColor',Enabled=false},Lighting)
local cameras={}
local integrationActive=false
local performanceBackup={}
local lastManual=0
local stickMagnitude=0
local touchLook={}
on(Input.InputBegan,function(i,processed) if not processed and i.UserInputType==Enum.UserInputType.Touch then touchLook[i]=true end end)
on(Input.InputChanged,function(i)
 if i.UserInputType==Enum.UserInputType.MouseMovement and i.Delta.Magnitude>1 then lastManual=os.clock() end
 if touchLook[i] and i.Delta.Magnitude>1 then lastManual=os.clock() end
 if i.KeyCode==Enum.KeyCode.Thumbstick2 then stickMagnitude=i.Position.Magnitude; if stickMagnitude>.12 then lastManual=os.clock() end end
end)
on(Input.InputEnded,function(i) touchLook[i]=nil end)
local function lineBetween(frame,a,b,width)
 local d=b-a; frame.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
 frame.Size=UDim2.fromOffset(d.Magnitude,width); frame.Rotation=math.deg(math.atan2(d.Y,d.X))
end
local function destroyVisual(p)
 local v=visuals[p]
 if v then v.root:Destroy(); v.hl:Destroy(); if v.dot then v.dot:Destroy() end; visuals[p]=nil end
end
on(Players.PlayerRemoving,destroyVisual)
local lastHooks={}
local function hook(name,value)
 if integration[name] and lastHooks[name]~=value then
  local ok,err=pcall(integration[name],value)
  if not ok then warn('Donezete '..name..': '..tostring(err)) end
  lastHooks[name]=value
 end
end
local function updatePerformance()
 if cfg.performance then
  for _,o in ipairs(Lighting:GetChildren()) do
   if o:IsA('PostEffect') and o~=effect and performanceBackup[o]==nil then performanceBackup[o]=o.Enabled; o.Enabled=false end
  end
 else
  for o,state in pairs(performanceBackup) do if o.Parent then o.Enabled=state end end
  performanceBackup={}
 end
end
on(gui.Destroying,function()
 dead=true; Run:UnbindFromRenderStep('DonezeteRender')
 for _,conn in ipairs(cons) do conn:Disconnect() end
 effect:Destroy()
 for cam,fov in pairs(cameras) do if cam.Parent then cam.FieldOfView=fov end end
 for obj,state in pairs(performanceBackup) do if obj.Parent then obj.Enabled=state end end
 if integrationActive and integration.Restore then pcall(integration.Restore) end
end)
local locked=nil
local blocked=false
local heldTime=0
local lastMode='off'
-- BEGIN AIM LIMITS
local function inAimRange(config,distance,error,onScreen)
 return onScreen and distance>=.001 and distance<=config.distance and error<=(config.fovEnabled and config.fov or 90)
end
-- END AIM LIMITS
local function candidate(cam,p)
 local ch,hum=eligible(p); if not ch then return end
 local part=targetPart(ch); if not part then return end
 local distance=(part.Position-cam.CFrame.Position).Magnitude
 if distance<.001 or distance>cfg.distance then return end
 local point,screen=cam:WorldToViewportPoint(part.Position)
 local error=(Vector2.new(point.X,point.Y)-cam.ViewportSize*.5).Magnitude
 if not inAimRange(cfg,distance,error,screen) or (cfg.wall and not visible(cam,ch,part)) then return end
 return part,error,distance,hum
end
-- BEGIN AIM MATH
local function aimAlpha(config,axis,dt,heldTime,error,distance)
 if config.pullLevel==5 or (not config.rage and config.smooth==0) then return 1 end
 local rates={10,20,40,75}
 local rate=rates[config.pullLevel]*(config.speed/14)
 if config.rage then
  rate=rate*1.8 -- Rage skips smoothing modifiers, but keeps manual-camera priority.
 else
  local smooth=(config.smooth+axis)/200
  rate=rate*(1.6-1.25*smooth)
  if config.accel then rate=rate*math.min(1,.5+heldTime/.18) end
  if config.decel then rate=rate*math.max(.5,math.min(1,error/35)) end
  if config.dynamic then rate=rate/(1+.4*distance/math.max(1,config.distance)) end
  if not config.micro and error<config.deadzone+1 then return 0 end
 end
 return 1-math.exp(-rate*math.max(0,dt))
end
-- END AIM MATH
local elapsed=0
local maintenance=0
Run:BindToRenderStep('DonezeteRender',Enum.RenderPriority.Camera.Value+1,function(dt)
 if dead then return end
 local cam=workspace.CurrentCamera; if not cam then return end
 if cfg.fovOverride then
  if not cameras[cam] then cameras[cam]=cam.FieldOfView end
  cam.FieldOfView=cfg.cameraFov
 else
  for savedCamera,fov in pairs(cameras) do if savedCamera.Parent then savedCamera.FieldOfView=fov end end
  cameras={}
 end
 local view=cam.ViewportSize
 panel.Size=UDim2.fromOffset(cfg.compact and 620 or 780,cfg.compact and 370 or 490)
 scale.Scale=math.min(1,(view.X-24)/panel.Size.X.Offset,(view.Y-30)/panel.Size.Y.Offset)
 panel.BackgroundTransparency=1-cfg.opacity
 color=palette[cfg.color]
 logo.Image=cfg.logo; signature.Visible=cfg.logo==''
 effect.Saturation=cfg.saturation/100-1; effect.Brightness=cfg.brightness; effect.Contrast=cfg.contrast
 effect.TintColor=({Color3.new(1,1,1),Color3.fromRGB(220,235,255),Color3.fromRGB(255,235,215),Color3.fromRGB(225,255,225)})[cfg.filter]
 effect.Enabled=cfg.visualEnabled
 if cfg.visualEnabled then
 integrationActive=true
 hook('SetGamma',cfg.gamma); hook('SetSharpness',cfg.sharpness); hook('SetCameraEffects',cfg.effects)
 hook('SetStretch',({'original','4:3','5:4','16:10'})[cfg.stretch])
 elseif integrationActive then
  if integration.Restore then pcall(integration.Restore) end
  integrationActive=false; lastHooks={}
 end
 floating.Visible=true
 -- Center hit area stays active, including over the panel, as requested.
 local own=me.Character and me.Character:FindFirstChildOfClass('Humanoid')
 local active=(cfg.aim or cfg.rage) and not panel.Visible and own and own.Health>0
 local mode=cfg.rage and 'rage' or (cfg.aim and 'smooth' or 'off')
 if mode~=lastMode then blocked=false; locked=nil; heldTime=0; lastMode=mode end
 local best,part,error,distance
 if active and not blocked then
  if locked then
   local h=locked.Character and locked.Character:FindFirstChildOfClass('Humanoid')
   if (not h or h.Health<=0) and not cfg.switch then blocked=true end
  end
  if not blocked and cfg.tracking and locked then
   part,error,distance=candidate(cam,locked); if part then best=locked end
  end
  if not blocked and not best then
   local score=math.huge
   for _,p in ipairs(Players:GetPlayers()) do
    local pp,ee,dd=candidate(cam,p)
    if pp then local s=cfg.nearest and dd or ee; if s<score then score=s; best=p; part=pp; error=ee; distance=dd end end
   end
  end
 end
 if best~=locked then heldTime=0 end
 locked=best
 local manual=os.clock()-lastManual<(cfg.legit and .18 or .10) or stickMagnitude>.12
 if active and part and not manual and error>cfg.deadzone then
  heldTime=heldTime+dt
  local position=part.Position+(cfg.prediction and part.AssemblyLinearVelocity*cfg.lead or Vector3.zero)
  local delta=position-cam.CFrame.Position
  local localDirection=cam.CFrame:VectorToObjectSpace(delta.Magnitude>.001 and delta.Unit or cam.CFrame.LookVector)
  local yaw=math.atan2(-localDirection.X,-localDirection.Z)
  local pitch=math.asin(math.clamp(localDirection.Y,-1,1))
  local function alpha(axis)
   return aimAlpha(cfg,axis,dt,heldTime,error,distance)
  end
  cam.CFrame=cam.CFrame*CFrame.Angles(0,yaw*alpha(cfg.horizontal),0)*CFrame.Angles(pitch*alpha(cfg.vertical),0,0)
 else heldTime=0 end
 elapsed=elapsed+dt
 if elapsed<(cfg.performance and 1/15 or 1/60) then return end
 local espDt=elapsed; elapsed=0
 maintenance=maintenance+espDt
 if maintenance>=.25 then updatePerformance(); maintenance=0 end
 local now=os.clock()
 local playerESP=not cfg.presentation and (cfg.box or cfg.skeleton or cfg.name or cfg.health or cfg.distanceESP or cfg.weapon or cfg.head or cfg.line or cfg.teamESP or cfg.armor or cfg.ammo or cfg.radar or cfg.outline)
 overlay.Visible=not cfg.presentation; radar.Visible=cfg.radar
 footer.Text=blocked and 'ALVO ELIMINADO / REATIVE A MIRA' or (mode=='off' and 'MIRA OFF  /  ESP '..(playerESP and 'ON' or 'OFF') or string.upper(mode)..'  /  NIVEL '..cfg.pullLevel..'  /  '..(manual and 'CAMERA LIVRE' or 'PRONTO'))
 if not playerESP then
  for p in pairs(visuals) do destroyVisual(p) end
 end
 for _,p in ipairs(playerESP and Players:GetPlayers() or {}) do
  local ch,hum=eligible(p)
  local v=visuals[p]
  if not playerESP and v then destroyVisual(p); v=nil end
  if playerESP and ch and not v then
   v=newVisual(); visuals[p]=v; v.bones={}
   v.head=make('Frame',{Size=UDim2.fromOffset(6,6),AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0},v.root)
   make('UICorner',{CornerRadius=UDim.new(1,0)},v.head)
   v.dot=make('Frame',{Size=UDim2.fromOffset(4,4),AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0},radar)
  end
  if v then
   v.root.Visible=false; v.hl.Enabled=false; v.dot.Visible=false
   local root=ch and ch:FindFirstChild('HumanoidRootPart')
   if root and playerESP then
    local distance=(root.Position-cam.CFrame.Position).Magnitude
    if distance<=cfg.espDistance then
     if cfg.visibility and (v.sightCharacter~=ch or now>=(v.sightAt or 0)) then
      v.sight=visible(cam,ch,ch:FindFirstChild('Head') or root); v.sightAt=now+.1; v.sightCharacter=ch
     end
     local sight=not cfg.visibility or v.sight
     local fade=math.max(0,(distance/cfg.espDistance-.8)/.2)
     local transparency=cfg.transparency+(1-cfg.transparency)*fade
     local tint=cfg.visibility and not sight and Color3.fromRGB(255,110,90) or color
     v.hl.Adornee=ch; v.hl.Enabled=cfg.outline; v.hl.OutlineColor=tint; v.hl.OutlineTransparency=transparency
     local forward=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z)
     forward=forward.Magnitude>.001 and forward.Unit or Vector3.new(0,0,-1)
     local right=forward:Cross(Vector3.yAxis)
     local delta=root.Position-cam.CFrame.Position
     local radarPoint=Vector2.new(delta:Dot(right),-delta:Dot(forward))/cfg.espDistance*60
     if radarPoint.Magnitude>60 then radarPoint=radarPoint.Unit*60 end
     v.dot.Position=UDim2.fromOffset(70+radarPoint.X,70+radarPoint.Y)
     v.dot.Visible=cfg.radar; v.dot.BackgroundColor3=tint
     local x,y,w,h=bounds(cam,ch,v,now)
     if x then
      v.root.Visible=true
      v.box.Visible=cfg.box; v.box.Position=UDim2.fromOffset(x,y); v.box.Size=UDim2.fromOffset(w,h)
      local stroke=v.box:FindFirstChildOfClass('UIStroke'); stroke.Color=tint; stroke.Thickness=cfg.thickness; stroke.Transparency=transparency
      v.line.Visible=cfg.line; v.line.BackgroundColor3=tint; v.line.BackgroundTransparency=transparency
      lineBetween(v.line,Vector2.new(view.X/2,view.Y),Vector2.new(x+w/2,y+h),cfg.thickness)
      local ratio=math.clamp(hum.Health/math.max(1,hum.MaxHealth),0,1)
      if v.healthCharacter~=ch then v.displayHealth=ratio; v.healthCharacter=ch end
      v.displayHealth=v.displayHealth+(ratio-v.displayHealth)*(1-math.exp(-20*espDt))
      v.health.Visible=cfg.health; v.health.Position=UDim2.fromOffset(x-7,y); v.health.Size=UDim2.fromOffset(4,h)
      v.fill.Size=UDim2.fromScale(1,v.displayHealth); v.fill.BackgroundColor3=Color3.fromHSV(ratio/3,.85,1)
      v.health.BackgroundTransparency=transparency; v.fill.BackgroundTransparency=transparency
      local texts={}
      if cfg.health then table.insert(texts,math.ceil(hum.Health)..' HP') end
      if cfg.distanceESP then table.insert(texts,math.floor(distance)..' st') end
      local tool=ch:FindFirstChildOfClass('Tool')
      if cfg.weapon then table.insert(texts,tool and tool.Name or 'Sem arma') end
      if cfg.teamESP then table.insert(texts,p.Team and p.Team.Name or 'Sem equipe') end
      local armor=ch:GetAttribute('Armor')
      local maxArmor=ch:GetAttribute('MaxArmor')
      v.armor.Visible=cfg.armor and type(armor)=='number'
      v.armor.Position=UDim2.fromOffset(x,y+h+2); v.armor.Size=UDim2.fromOffset(w,3)
      if v.armor.Visible then
       v.armorFill.Size=UDim2.fromScale(math.clamp(armor/math.max(1,type(maxArmor)=='number' and maxArmor or 100),0,1),1)
       v.armor.BackgroundTransparency=transparency; v.armorFill.BackgroundTransparency=transparency
      end
      if cfg.armor then table.insert(texts,'Armor: '..tostring(armor or 'N/D')) end
      if cfg.ammo then table.insert(texts,'Ammo: '..tostring(tool and tool:GetAttribute('Ammo') or 'N/D')) end
      v.text.Text=cfg.privacy and 'Jogador' or p.DisplayName; v.text.Visible=cfg.name
      v.text.TextSize=cfg.textSize; v.text.TextTransparency=transparency
      v.text.Position=UDim2.fromOffset(math.clamp(x+w/2-100,0,math.max(0,view.X-200)),math.max(0,y-22)); v.text.Size=UDim2.fromOffset(200,20)
      v.details.Text=table.concat(texts,' | '); v.details.Visible=#texts>0
      v.details.TextSize=cfg.textSize; v.details.TextTransparency=transparency
      v.details.Position=UDim2.fromOffset(math.clamp(x+w/2-110,0,math.max(0,view.X-220)),math.min(view.Y-42,y+h+7)); v.details.Size=UDim2.fromOffset(220,40)
      local head=ch:FindFirstChild('Head'); v.head.Visible=false
      if head and cfg.head then local q,ok=cam:WorldToViewportPoint(head.Position); v.head.Visible=ok; v.head.Position=UDim2.fromOffset(q.X,q.Y); v.head.BackgroundColor3=tint; v.head.BackgroundTransparency=transparency end
      if cfg.skeleton and (v.character~=ch or now>=(v.bonesAt or 0)) then
       for _,bone in ipairs(v.bones) do bone.line:Destroy() end
       v.bones={}; v.character=ch; v.bonesAt=now+2
       for _,joint in ipairs(ch:GetDescendants()) do
        if joint:IsA('Motor6D') and joint.Part0 and joint.Part1 and joint.Part0.Parent==ch and joint.Part1.Parent==ch then
         table.insert(v.bones,{joint=joint,line=make('Frame',{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0},v.root)})
        end
       end
      end
      for _,bone in ipairs(v.bones) do
       local j=bone.joint; bone.line.Visible=false
       if cfg.skeleton and j.Parent and j.Part0 and j.Part1 then
        local aa,ao=cam:WorldToViewportPoint(j.Part0.Position); local bb,bo=cam:WorldToViewportPoint(j.Part1.Position)
        if ao and bo then bone.line.Visible=true; bone.line.BackgroundColor3=tint; bone.line.BackgroundTransparency=transparency; lineBetween(bone.line,Vector2.new(aa.X,aa.Y),Vector2.new(bb.X,bb.Y),cfg.thickness) end
       end
      end
     end
    end
   end
  end
 end
 local seen={}
 for _,spec in ipairs({{'FPSItem',cfg.item},{'FPSObjective',cfg.objective}}) do
  if spec[2] and not cfg.presentation then
   for _,obj in ipairs(Tags:GetTagged(spec[1])) do
    local pos=obj:IsA('BasePart') and obj.Position or (obj:IsA('Model') and obj:GetPivot().Position)
    if pos and obj:IsDescendantOf(workspace) and (pos-cam.CFrame.Position).Magnitude<=cfg.espDistance then
     seen[obj]=true
     local label=markers[obj]
     if not label then label=make('TextLabel',{Size=UDim2.fromOffset(160,20),AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,TextColor3=color,TextStrokeTransparency=.4},overlay); markers[obj]=label end
     local point,ok=cam:WorldToViewportPoint(pos); label.Visible=ok; label.Position=UDim2.fromOffset(point.X,point.Y); label.Text=obj.Name; label.TextSize=cfg.textSize; label.TextColor3=color; label.TextTransparency=cfg.transparency
    end
   end
  end
 end
 for obj,label in pairs(markers) do if not seen[obj] then label:Destroy(); markers[obj]=nil end end
end)
-- No automatic profile load: every new execution starts with all functions OFF.
