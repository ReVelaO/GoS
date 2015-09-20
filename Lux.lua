require ('Dlib')
require ('Inspired')

supportedHero = {["Lux"] = true}
class "Lux"

function Lux:__init()
	OnLoop(function(myHero) self:Loop(myHero) end)

	root = menu.addItem(SubMenu.new("DarkLux"))
	Combo = root.addItem(SubMenu.new("Combo"))
		QU = Combo.addItem(MenuBool.new("Use Q",true))
		EU = Combo.addItem(MenuBool.new("Use E",true))
		RU = Combo.addItem(MenuBool.new("Use Smart R",true))
		Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))

	ShieldS = root.addItem(SubMenu.new("Shield Settings"))
		WSM = ShieldS.addItem(MenuBool.new("Use W for save me",true))
		WSMS = ShieldS.addItem(MenuSlider.new("If HP % under", 55, 1, 100, 1))
		--WSM = ShieldS.addItem(MenuBool.new("Use W for save ally",true))
		--WSMSA = ShieldS.addItem(MenuSlider.new("If Ally HP % under)", 55, 1, 100, 1))
	
	Drawings = root.addItem(SubMenu.new("Drawings"))
		Enable = Drawings.addItem(MenuBool.new("Enable Drawings",true))
		DrawHD = Drawings.addItem(MenuSlider.new("Quality Circles (High Number More FPS)", 255, 1, 255, 1))
		SD = Drawings.addItem(SubMenu.new("Spell Drawings"))
		DrawQ = SD.addItem(MenuBool.new("Draw Q Range",true))
		DrawW = SD.addItem(MenuBool.new("Draw W Range",true))
		DrawE = SD.addItem(MenuBool.new("Draw E Range",true))
		DrawR = SD.addItem(MenuBool.new("Draw R Range",true))
		DD = Drawings.addItem(SubMenu.new("Damage Drawings"))
		DrawQD = DD.addItem(MenuBool.new("Draw Q Damage",true))
		DrawED = DD.addItem(MenuBool.new("Draw E Damage",true))
		DrawRD = DD.addItem(MenuBool.new("Draw R Damage",true))
		
		

	Misc = root.addItem(SubMenu.new("Misc"))
		AI = Misc.addItem(MenuBool.new("Auto-Ignite",true))
		--AI = Misc.addItem(MenuBool.new("Auto-Level Spells",true))

	end

function Lux:Loop(myHero)
	self:Valores()

	if WSM.getValue() then
		self:UseWSaveMe()
	end
	--if WSMSA.getValue() then
	--	self:UseWAlly()
	--end
	if Enable.getValue() then
		self:Drawings()
	end
	if AI.getValue() then
		self:AutoIgnite()
	end
	if Comb.getValue() then
		self:Combo()
	end
end

function Lux:Valores()
	target = GetCurrentTarget()
	targetHP = GetCurrentHP(target)
	--allyHP = GetCurrentHP(ally)/GetMaxHP(ally)
	myHP = GetCurrentHP(myHero)/GetMaxHP(myHero)
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
	QDamage = GoS:CalcDamage(myHero,target,0,60 + (60 * GetCastLevel(myHero,_Q)) + (GetBonusAP(myHero) *  0.75))
	EDamage = GoS:CalcDamage(myHero,target,0,60 + (60 * GetCastLevel(myHero,_E)) + (GetBonusAP(myHero) *  0.6))
	RDamage = GoS:CalcDamage(myHero,target,0,300 + (300 * GetCastLevel(myHero,_R)) + (GetBonusAP(myHero) *  0.75))
end

function Lux:Drawings()
	if DrawQ.getValue() then 
		DrawCircle(GetOrigin(myHero),1300,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawW.getValue() then 
		DrawCircle(GetOrigin(myHero),1075,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawE.getValue() then 
		DrawCircle(GetOrigin(myHero),1100,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawR.getValue() then 
		DrawCircle(GetOrigin(myHero),GetCastRange(myHero,_R),1,DrawHD.getValue(),0xffFFFF00)
	end
	if QREADY and DrawQD.getValue() then
	DrawDmgOverHpBar(target,targetHP,0,QDamage,0xffFFFF00)
	end
	if EREADY and DrawED.getValue() then
	DrawDmgOverHpBar(target,targetHP,0,EDamage,0xffFFFF00)
	end
	if RREADY and DrawRD.getValue() then
	DrawDmgOverHpBar(target,targetHP,0,RDamage,0xffFFFF00)
	end
end

function Lux:AutoIgnite()
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
		if Ignite then
        for _, k in pairs(GoS:GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GoS:GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Lux:UseQ(target)
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,250,1300,70,false,false)		
	if QREADY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

--function Lux:UseWAlly()
--	for _, ally in pairs(GoS:GetAllyHeroes()) do
--		local WAPred = GetPredictionForPlayer(GoS:myHeroPos(),ally,GetMoveSpeed(ally),1400,250,1075,100,false,false)	
--		if allyHP < (WSMSA.getValue()/100) and WREADY then 
--			CastSkillShot(_W,WAPred.PredPos.x,WAPred.PredPos.y,WAPred.PredPos.z)
--		end
--	end
--end

function Lux:UseWSaveMe()	
	local Mouse = GetMousePos()
	if myHP < (WSMS.getValue()/100) and WREADY then
		CastSkillShot(_W,Mouse.x,Mouse.y,Mouse.z)
	end
end

function Lux:UseE(target)
	local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1300,250,1100,275,false,false)		
	if EREADY and EPred.HitChance == 1 then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	end
end

function Lux:UseR(target)														--YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth
	local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),250,1000,GetCastRange(myHero,_R),190,false,false)		
	if RREADY and RPred.HitChance == 1 then
	HoldPosition()
	CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
	end
end

function Lux:Combo()
if GoS:ValidTarget(target, 1000) then
	if QREADY and QU.getValue() then
		self:UseQ(target)
	end
	if EREADY and EU.getValue() then
		self:UseE(target)
	end
	if RREADY and targetHP < RDamage and RU.getValue() then
		self:UseR(target)
	end
end
end

if supportedHero[GetObjectName(myHero)] == true then
	if _G[GetObjectName(myHero)] then
  		_G[GetObjectName(myHero)]()
	end 
end
