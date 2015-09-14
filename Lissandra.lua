supportedHero = {["Lissandra"] = true}
class "Lissandra"

function Lissandra:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

DarkLissMenu = Menu("DarkLiss", "Lissandra")
DarkLissMenu:SubMenu("Combo", "Combo")
DarkLissMenu.Combo:Boolean("Q", "Use Q", true)
DarkLissMenu.Combo:Boolean("W", "Use W", true)
DarkLissMenu.Combo:Boolean("E", "Use E", true)
DarkLissMenu.Combo:List("EM", "E Modes", 1, {"To Target Position", "To Max Range", "No Reactive"})
DarkLissMenu.Combo:Boolean("R", "Use R", false)

DarkLissMenu:SubMenu("Drawings", "Drawings")
DarkLissMenu.Drawings:Boolean("ED", "Enable Drawings", true)
DarkLissMenu.Drawings:Boolean("Q", "Draw Q", true)
DarkLissMenu.Drawings:Boolean("W", "Draw W", true)
DarkLissMenu.Drawings:Boolean("E", "Draw E", true)
DarkLissMenu.Drawings:Boolean("R", "Draw R", true)
DarkLissMenu.Drawings:Slider("DrawHD", "Quality Circles", 255, 1, 255, 1)

DarkLissMenu:SubMenu("Flee", "Flee")
DarkLissMenu.Flee:Key("fle", "Flee (G)", string.byte("G"))

DarkLissMenu:SubMenu("Misc", "Misc")
DarkLissMenu.Misc:Boolean("AI", "Auto Ignite", true)

end

global_ticks = 0


function Lissandra:Loop(myHero)
	self:Req()

if DarkLissMenu.Drawings.ED:Value() then
	self:Drawings()
end

if DarkLissMenu.Misc.AI:Value() then
	self:AutoIgnite()
end

if DarkLissMenu.Flee.fle:Value() then
	self:Flee()
end

if _G.IOW:Mode() == "Combo" then
	self:Combo()
end

end

function Lissandra:Req()
	target = IOW:GetTarget()
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
end

function Lissandra:Drawings()
if DarkLissMenu.Drawings.Q:Value() then
	DrawCircle(GetOrigin(myHero),725,3,DarkLissMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
if DarkLissMenu.Drawings.W:Value() then
	DrawCircle(GetOrigin(myHero),450,3,DarkLissMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
if DarkLissMenu.Drawings.E:Value() then
	DrawCircle(GetOrigin(myHero),1050,3,DarkLissMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
if DarkLissMenu.Drawings.R:Value() then
	DrawCircle(GetOrigin(myHero),550,3,DarkLissMenu.Drawings.DrawHD:Value(),0xff87CEFA)
	end
end

function Lissandra:UseQ(target)
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2200,250,GetCastRange(myHero,_Q),75,false,true)		
	if QREADY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Lissandra:UseW()
	if WREADY and GoS:IsInDistance(target, 445) then
	CastSpell(_W)
	end
end

function Lissandra:UseEToPos(target)
	local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),850,250,GetCastRange(myHero,_E),125,false,true)		
	if EREADY and EPred.HitChance == 1 then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	end
end

function Lissandra:UseEMaxRange(target)
local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),850,250,GetCastRange(myHero,_E),125,false,true)
Ticker = GetTickCount()	

if (global_ticks + 2000) < Ticker then
   CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
   		global_ticks = Ticker
     		GoS:DelayAction(function()
       			CastSpell(_E)
     			end, 1500)
		end
end

function Lissandra:UseEOnly(target)
local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),850,250,GetCastRange(myHero,_E),125,false,true)
Ticker = GetTickCount()	

if (global_ticks + 2000) < Ticker then
   CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
   		global_ticks = Ticker
     		GoS:DelayAction(function()
       			CastSpell(_E)
     			end, 2000)
		end
end

function Lissandra:UseR(target)
	if RREADY then
	CastTargetSpell(target, _R)
	end
end

function Lissandra:Flee()
local mouse = GetMousePos()
MoveToXYZ(mouse.x,mouse.y,mouse.z)
Ticker = GetTickCount()	

if (global_ticks + 2000) < Ticker then
   CastSkillShot(_E,mouse.x,mouse.y,mouse.z)
   		global_ticks = Ticker
     		GoS:DelayAction(function()
       			CastSpell(_E)
     			end, 1500)
		end
end

function Lissandra:AutoIgnite()
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
		if Ignite then
        for _, k in pairs(GoS:GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Lissandra:Combo()
	if GoS:ValidTarget(target, 1050) then
		if QREADY and DarkLissMenu.Combo.Q:Value() then
			self:UseQ(target)
		end
		if WREADY and DarkLissMenu.Combo.W:Value() then
			self:UseW()
		end
		if EREADY and DarkLissMenu.Combo.E:Value() and DarkLissMenu.Combo.EM:Value() == 1 then
			self:UseEToPos(target)
		elseif EREADY and DarkLissMenu.Combo.E:Value() and DarkLissMenu.Combo.EM:Value() == 2 then
			self:UseEMaxRange(target)
		elseif EREADY and DarkLissMenu.Combo.E:Value() and DarkLissMenu.Combo.EM:Value() == 3 then
			self:UseEOnly(target)
		end
		if RREADY and DarkLissMenu.Combo.R:Value() then
			self:UseR(target)
		end
	end
end

if supportedHero[GetObjectName(myHero)] == true then
if _G[GetObjectName(myHero)] then
  _G[GetObjectName(myHero)]()
end 
end
