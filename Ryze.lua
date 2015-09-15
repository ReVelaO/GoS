supportedHero = {["Ryze"] = true}
class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

MainMenu = Menu("DarkRyze", "Ryze")
MainMenu:SubMenu("Combo", "Combo")
MainMenu.Combo:List("combos", "Combo Options", 1, {"WQER", "QWER"})
	
MainMenu:SubMenu("LaneClear", "Lane Clear")
MainMenu.LaneClear:Boolean("Q", "Use Q", true)
MainMenu.LaneClear:Boolean("W", "Use W", true)
MainMenu.LaneClear:Boolean("E", "Use E", true)
MainMenu.LaneClear:Boolean("R", "Use R", false)

MainMenu:SubMenu("JungleClear", "Jungle Clear")
MainMenu.JungleClear:Boolean("Q", "Use Q", true)
MainMenu.JungleClear:Boolean("W", "Use W", true)
MainMenu.JungleClear:Boolean("E", "Use E", true)
MainMenu.JungleClear:Boolean("R", "Use R", false)

MainMenu:SubMenu("Misc", "Misc")
MainMenu.Misc:Boolean("AutoLevelS", "Auto-Level Spells", true)
MainMenu.Misc:Boolean("AutoIgnite", "Auto-Ignite", true)
	
MainMenu:SubMenu("Drawings", "Drawings")
MainMenu.Drawings:Boolean("ED", "Enable Drawings", true)
MainMenu.Drawings:Boolean("DQ", "Draw Q Range", true)
MainMenu.Drawings:Boolean("DWE", "Draw W + E Range", true)
MainMenu.Drawings:Slider("DrawHD", "Quality Circles", 255, 1, 255, 1)
	
end
--Updated 5.17.

function Ryze:Loop(myHero)
	self:Req()

if MainMenu.Drawings.ED:Value() then
	self:Drawings()
end

if MainMenu.Misc.AutoLevelS:Value() then
	self:AutoLevelS()
end

if MainMenu.Misc.AutoIgnite:Value() then
	self:AutoIgnite()
end
	
if _G.IOW:Mode() == "Combo" and MainMenu.Combo.combos:Value() == 1 then	
	self:WQER()
end

if _G.IOW:Mode() == "Combo" and MainMenu.Combo.combos:Value() == 2 then	
	self:QWER()
	end

if IOW:Mode() == "LaneClear" then
	self:LaneAndJungle()
end
end

function Ryze:Req()
	rooted = (GotBuff(target, "RyzeW") == 1)
	gotpasive = (GotBuff(myHero, "ryzepassivecharged") > 0)
	stacks = GotBuff(myHero, "ryzepassivestacks")
	target = IOW:GetTarget()
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
end

function Ryze:Drawings()
if MainMenu.Drawings.DQ:Value() then
	DrawCircle(GetOrigin(myHero),895,3,MainMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
if MainMenu.Drawings.DWE:Value() then
	DrawCircle(GetOrigin(myHero),600,3,MainMenu.Drawings.DrawHD:Value(),0xff7B68EE)
	end
end

function Ryze:AutoLevelS()
if MainMenu.Misc.AutoLevelS:Value() then
if GetLevel(myHero) == 1 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 2 then
	LevelSpell(_W)
elseif GetLevel(myHero) == 3 then
	LevelSpell(_E)
elseif GetLevel(myHero) == 4 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 5 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 6 then
	LevelSpell(_R)
elseif GetLevel(myHero) == 7 then
	LevelSpell(_Q)
elseif GetLevel(myHero) == 8 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) == 10 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 11 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 12 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 13 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 14 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 16 then
        LevelSpell(_R)
elseif GetLevel(myHero) == 17 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
end
end

function Ryze:AutoIgnite()
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
		if Ignite then
        for _, k in pairs(GoS:GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GoS:GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Ryze:UseQPred(target)
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)		
	if QREADY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Ryze:UseQRooted(target)
	local ChampEnemy = GetOrigin(target)		
	if QREADY then
	CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)
	end
end

function Ryze:UseW(target)
	if WREADY then
	CastTargetSpell(target, _W)
	end
end

function Ryze:UseE(target)
	if EREADY then
	CastTargetSpell(target, _E)
	end
end

function Ryze:UseR()
	CastSpell(_R)
end

function Ryze:WQER()			
	if GoS:ValidTarget(target, 900) then		
			if WREADY then
                self:UseW(target)
            elseif not WREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and QREADY then
                self:UseQRooted(target)
            elseif not QREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and WREADY then
                self:UseW(target)
        end
	end
end

function Ryze:QWER()			
	if GoS:ValidTarget(target, 900) then		
			if QREADY then
                self:UseQPred(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and QREADY then
                self:UseQPred(target)        
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and QREADY then
                self:UseQPred(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and QREADY then
                self:UseQPred(target)
            elseif not QREADY and WREADY then
                self:UseW(target)
            elseif not WREADY and EREADY then
                self:UseE(target)
            elseif not EREADY and RREADY then
                self:UseR()
            elseif not RREADY and QREADY then
                self:UseQPred(target)
				end
		end
end

function Ryze:LaneAndJungle()
if IOW:Mode() == "LaneClear" then      
                for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if WREADY and MainMenu.LaneClear.W:Value() then
						CastTargetSpell(minion, _W)
						end
						
						if QREADY  and MainMenu.LaneClear.Q:Value() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if EREADY and MainMenu.LaneClear.E:Value() then
						CastTargetSpell(minion, _E)
						end 		
             
						if RREADY and MainMenu.LaneClear.R:Value() then
						CastSpell(_R)			 
						end
					end
		end
    end    
if IOW:Mode() == "LaneClear" then     
                for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if WREADY and MainMenu.JungleClear.W:Value() then
						CastTargetSpell(minion, _W)
						end
						
						if QREADY and MainMenu.JungleClear.Q:Value() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if EREADY and MainMenu.JungleClear.E:Value() then
						CastTargetSpell(minion, _E)
						end 		
             
						if RREADY and MainMenu.JungleClear.R:Value() then
						CastSpell(_R)			 
						end
          		end
       		end
		end
end



if supportedHero[GetObjectName(myHero)] == true then
if _G[GetObjectName(myHero)] then
  _G[GetObjectName(myHero)]()
end 
end
