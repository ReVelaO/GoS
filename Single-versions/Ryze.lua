require ('Dlib')
require ('Inspired')

supportedHero = {["Ryze"] = true}

class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

	root = menu.addItem(SubMenu.new("DarkAIO - TOP Series : Ryze"))
	Combo = root.addItem(SubMenu.new("Combo"))
		CO = Combo.addItem(MenuStringList.new("Combo Options", {"WQER ", "QWER "}))
		Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))
	
	LaneClear = root.addItem(SubMenu.new("Lane Clear"))
		QL = LaneClear.addItem(MenuBool.new("Use Q",true))
		WL = LaneClear.addItem(MenuBool.new("Use W",true))
		EL = LaneClear.addItem(MenuBool.new("Use E",true))
		RL = LaneClear.addItem(MenuBool.new("Use R",false))
		LC = LaneClear.addItem(MenuKeyBind.new("Lane Clear", 86))

	JungleClear = root.addItem(SubMenu.new("Jungle Clear"))
		QJ = JungleClear.addItem(MenuBool.new("Use Q",true))
		WJ = JungleClear.addItem(MenuBool.new("Use W",true))
		EJ = JungleClear.addItem(MenuBool.new("Use E",true))
		RJ = JungleClear.addItem(MenuBool.new("Use R",false))
		JC = JungleClear.addItem(MenuKeyBind.new("Jungle Clear", 86))

	Misc = root.addItem(SubMenu.new("Misc"))
		AI = Misc.addItem(MenuBool.new("Auto - Ignite",true))
		ALS = Misc.addItem(MenuBool.new("Auto - Level Spells",true))

	Drawings = root.addItem(SubMenu.new("Drawings"))
		Enable = Drawings.addItem(MenuBool.new("Enable Drawings",true))
		DrawQ = Drawings.addItem(MenuBool.new("Draw Q Range",true))
		DrawWE = Drawings.addItem(MenuBool.new("Draw W + E Range",true))
		DrawHD = Drawings.addItem(MenuSlider.new("Quality Circles (High Number More FPS)", 255, 1, 255, 1))
	
end

function Ryze:Loop(myHero)
	self:Valores()

	if Enable.getValue() then
		self:Drawings()
	end
	if ALS.getValue() then
		self:AutoLevelS()
	end
	if AI.getValue() then
		self:AutoIgnite()
	end	
	if Comb.getValue() and CO.getValue() == 1 then	
		self:WQER()
	end
	if Comb.getValue() and CO.getValue() == 2 then	
		self:QWER()
	end
	if LC.getValue() or JC.getValue() then
	self:LaneAndJungle()
	end
end

function Ryze:Valores()
	rooted = (GotBuff(target, "RyzeW") == 1)
	gotpasive = (GotBuff(myHero, "ryzepassivecharged") > 0)
	target = GetCurrentTarget()
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
end

function Ryze:Drawings()
if DrawQ.getValue() then
	DrawCircle(GetOrigin(myHero),895,1,DrawHD.getValue(),0xff7B68EE)
	end
if DrawWE.getValue() then
	DrawCircle(GetOrigin(myHero),600,1,DrawHD.getValue(),0xff7B68EE)
	end
end

function Ryze:AutoLevelS()
	if ALS.getValue() then
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
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1700,250,900,50,false,true)		
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
if LC.getValue() then      
                for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if WREADY and WL.getValue() then
						CastTargetSpell(minion, _W)
						end
						
						if QREADY and QL.getValue() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if EREADY and EL.getValue() then
						CastTargetSpell(minion, _E)
						end 		
             
						if RREADY and RL.getValue() then
						CastSpell(_R)			 
						end
					end
		end
    end    
if JC.getValue() then     
                for i,minion in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do    
                        if GoS:IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if WREADY and WJ.getValue() then
						CastTargetSpell(minion, _W)
						end
						
						if QREADY and QJ.getValue() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if EREADY and EJ.getValue() then
						CastTargetSpell(minion, _E)
						end 		
             
						if RREADY and RJ.getValue() then
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
