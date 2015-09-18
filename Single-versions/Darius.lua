require ('Dlib')
require ('Inspired')

supportedHero = {["Darius"] = true}
class "Darius"

function Darius:__init()

	OnLoop(function(myHero) self:Loop(myHero) end)

	root = menu.addItem(SubMenu.new("DarkAIO - TOP Series : Darius"))
	Combo = root.addItem(SubMenu.new("Combo"))
		QU = Combo.addItem(MenuBool.new("Use Q",true))
		WU = Combo.addItem(MenuBool.new("Use W",true))
		EU = Combo.addItem(MenuBool.new("Use E",true))
		RU = Combo.addItem(MenuBool.new("Use R",true))
		Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))
	
	Drawings = root.addItem(SubMenu.new("Drawings"))
		Enable = Drawings.addItem(MenuBool.new("Enable Drawings",true))
		DrawQ = Drawings.addItem(MenuBool.new("Draw Q Range",true))
		DrawW = Drawings.addItem(MenuBool.new("Draw W Range",true))
		DrawE = Drawings.addItem(MenuBool.new("Draw E Range",true))
		DrawR = Drawings.addItem(MenuBool.new("Draw R Range",true))
		DrawRD = Drawings.addItem(MenuBool.new("Draw R Damage",true))
		DrawHD = Drawings.addItem(MenuSlider.new("Quality Circles (High Number More FPS)", 255, 1, 255, 1))

	Misc = root.addItem(SubMenu.new("Misc"))
		AI = Misc.addItem(MenuBool.new("Auto-Ignite",true))
	
end



function Darius:Loop(myHero)
	self:Valores()

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

function Darius:Valores()
	target = GetCurrentTarget()
	targetHP = GetCurrentHP(target)
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
	RDamage = 100 + (100 * GetCastLevel(myHero,_R)) + (GetBonusDmg(myHero) *  0.75)
	stacks = 0
	StacksDamage = 19 + (19 * stacks ) + (GetBonusDmg(myHero) *  0.15)
end

function Darius:Drawings()
	if DrawQ.getValue() then 
		DrawCircle(GetOrigin(myHero),425,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawW.getValue() then 
		DrawCircle(GetOrigin(myHero),300,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawE.getValue() then 
		DrawCircle(GetOrigin(myHero),575,1,DrawHD.getValue(),0xffFFFF00)
	end
	if DrawR.getValue() then 
		DrawCircle(GetOrigin(myHero),475,1,DrawHD.getValue(),0xffFFFF00)
	end
	if RREADY and DrawRD.getValue() then
	DrawDmgOverHpBar(target,targetHP,(RDamage + StacksDamage),0,0xffFFFF00)
	end
end

function Darius:AutoIgnite()
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
		if Ignite then
        for _, k in pairs(GoS:GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GoS:GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Darius:UseQ()
	local Mouse = GetMousePos()
	MoveToXYZ(Mouse.x,Mouse.y,Mouse.z)
	if QREADY and GoS:ValidTarget(target, 425) and QU.getValue() then
		CastSpell(_Q)
	end
end

function Darius:UseW()
	if WREADY and GoS:ValidTarget(target, 174) and WU.getValue() then
		CastSpell(_W)
		AttackUnit(target)
	end
end

function Darius:UseE()						--YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth
	local EPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,300,575,80,false,true)		
	if EREADY and EPred.HitChance == 1 and EU.getValue() then
	CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
	AttackUnit(target)
	end
end

function Darius:UseR(target)
	OnUpdateBuff(function(Object,BuffName,Stacks)
	for i,ES in pairs(GoS:GetEnemyHeroes()) do
		if not GetBuffCount(ES,"dariushemo") == nil and GoS:ValidTarget(ES,1000) then
			stacks = GetBuffCount(ES,"dariushemo")
			end
		end
	end)
	if RREADY and (RDamage + StacksDamage) > targetHP and GoS:ValidTarget(target, 475) and RU.getValue() then
		CastTargetSpell(target, _R)
	end
end

function Darius:Combo()
if GoS:ValidTarget(target, 575) then
		if QREADY then
			self:UseQ()

		elseif not QREADY and EREADY then
			self:UseE()
			
		elseif not EREADY and WREADY then
			self:UseW()
		
		elseif not WREADY and RREADY then
			self:UseR(target)
		end	
	end
end

if supportedHero[GetObjectName(myHero)] == true then
	if _G[GetObjectName(myHero)] then
  		_G[GetObjectName(myHero)]()
	end 
end
