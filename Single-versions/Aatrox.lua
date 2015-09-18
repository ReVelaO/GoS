require ('Dlib')
require ('Inspired')

supportedHero = {["Aatrox"] = true}

class "Aatrox"

function Aatrox:__init()

	OnLoop(function(myHero) self:Loop(myHero) end)

	root = menu.addItem(SubMenu.new("DarkAIO - TOP Series : Aatrox"))
	Combo = root.addItem(SubMenu.new("Combo"))
		QU = Combo.addItem(MenuBool.new("Use Q",true))
		WU = Combo.addItem(MenuBool.new("Use W",true))
		WSettings = Combo.addItem(SubMenu.new("W Settings"))
		WLIFE = WSettings.addItem(SubMenu.new("W Life Settings"))
		WLO = WLIFE.addItem(MenuSlider.new("Use W at HP %", 55, 1, 100, 1))
		WDAMAGE = WSettings.addItem(SubMenu.new("W Damage Settings"))
		WDO = WDAMAGE.addItem(MenuSlider.new("Use W at HP %", 55, 1, 100, 1))
		EU = Combo.addItem(MenuBool.new("Use E",true))	
		RU = Combo.addItem(MenuBool.new("Use R",true))
		Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))
	
	Drawings = root.addItem(SubMenu.new("Drawings"))
	Enable = Drawings.addItem(MenuBool.new("Enable Drawings",true))
		DrawQ = Drawings.addItem(MenuBool.new("Draw Q Range",true))
		DrawE = Drawings.addItem(MenuBool.new("Draw E Range",true))
		DrawR = Drawings.addItem(MenuBool.new("Draw R Cast Range",true))
		DrawHD = Drawings.addItem(MenuSlider.new("Quality Circles (High Number More FPS)", 255, 1, 255, 1))

	Flee = root.addItem(SubMenu.new("Flee"))
	FG = Flee.addItem(MenuKeyBind.new("Flee", 71))

	Misc = root.addItem(SubMenu.new("Misc"))
		AI = Misc.addItem(MenuBool.new("Auto-Ignite",true))
	
end

function Aatrox:Loop(myHero)
	self:Valores()

if Enable.getValue() then
	self:Drawings()
end

if AI.getValue() then
	self:AutoIgnite()
	end

if FG.getValue() then
	self:Flee()
end

if Comb.getValue() then
	self:Combo()
end

end

function Aatrox:Valores()
	target = GetCurrentTarget()
	myHP = 100*GetCurrentHP(myHero)/GetMaxHP(myHero)
	WLife = GotBuff(myHero, "aatroxwlife") == 1
	WDamage = GotBuff(myHero, "aatroxwpower") == 1
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
end

function Aatrox:Drawings()
	if DrawQ.getValue() then 
		DrawCircle(GetOrigin(myHero),650,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawE.getValue() then 
		DrawCircle(GetOrigin(myHero),1075,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawR.getValue() then 
		DrawCircle(GetOrigin(myHero),550,1,DrawHD.getValue(),0xffFFFF00)
	end
end

function Aatrox:AutoIgnite()
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
		if Ignite then
        for _, k in pairs(GoS:GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GoS:GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Aatrox:UseQ()								--YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2000,600,650,250,false,true)		
	if QREADY and QPred.HitChance == 1 and GoS:ValidTarget(target, 650) and QU.getValue() then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Aatrox:UseW()
	if WREADY and WLife and (myHP > WLO.getValue()) and WU.getValue() then
		CastSpell(_W)
	elseif WREADY and WDamage and (myHP < WDO.getValue()) and WU.getValue() then
		CastSpell(_W)
	end
end

function Aatrox:UseE()
	local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1250,250,1075,35,false,false)
	if EREADY and EPred.HitChance == 1 and GoS:ValidTarget(target, 1075) and EU.getValue() then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	end
end

function Aatrox:UseR()
	if RREADY and GoS:ValidTarget(target, 550) and RU.getValue() then
		CastSpell(_R)
	end
end

function Aatrox:Flee()
	local Mouse = GetMousePos()
	MoveToXYZ(Mouse.x,Mouse.y,Mouse.z)
	if QREADY then
	CastSkillShot(_Q,Mouse.x,Mouse.y,Mouse.z)
	end
end

function Aatrox:Combo()
	if WREADY then
		self:UseW()
	end

	if QREADY then
		self:UseQ()
	end

	if EREADY then
		self:UseE()
	end
	
	if RREADY then
		self:UseR()
	end
end

if supportedHero[GetObjectName(myHero)] == true then
	if _G[GetObjectName(myHero)] then
  		_G[GetObjectName(myHero)]()
	end 
end
