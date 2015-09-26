-- Codeado por un chileno ykpz.
-- Feel free to PM me (DarkFight)

supportedHero = {["Ryze"] = true}

class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

Kappa = Menu("DarkRyze : Reworked", "Ryze")
Kappa:SubMenu("Combo", "Combo")
Kappa.Combo:List("list1", "Combo options", 1, {"[WQER]", "[QWER]", "[QEWR]", "[WQRE]"})

Kappa:SubMenu("lc", "Laneclear")
Kappa.lc:Boolean("lq", "Clear with Q", true)
Kappa.lc:Boolean("lw", "Clear with W", true)
Kappa.lc:Boolean("le", "Clear with E", true)
Kappa.lc:Boolean("lr", "Clear using R", false)

Kappa:SubMenu("jc", "Jungleclear")
Kappa.jc:Boolean("jq", "Clear with Q", true)
Kappa.jc:Boolean("jw", "Clear with W", true)
Kappa.jc:Boolean("je", "Clear with E", true)
Kappa.jc:Boolean("jr", "Clear using R", false)

Kappa:SubMenu("KS", "Kill Steal (KS)")
Kappa.KS:Boolean("es1", "Enable KS", true)
Kappa.KS:Boolean("AQ", "Perfect Q", true)
Kappa.KS:Boolean("AW", "Perfect W", true)
Kappa.KS:Boolean("AE", "Perfect E", true)

Kappa:SubMenu("Drawings", "Drawings")
Kappa.Drawings:Boolean("es2", "Enable Drawings", true)
Kappa.Drawings:Boolean("Q", "Draw Overload [Q]", true)
Kappa.Drawings:Boolean("W", "Draw Rune Prison [W]", true)
Kappa.Drawings:Boolean("E", "Draw Spell Flux [E]", true)
Kappa.Drawings:Boolean("R", "Draw Desperate Power [R]", true)
Kappa.Drawings:Slider("dp", "Quality circles", 255, 1, 255, 1)


Kappa:SubMenu("Misc", "Misc")
Kappa.Misc:Boolean("es3", "Enable Miscs", true)
Kappa.Misc:Boolean("fuego", "Auto - Ignite", true)
Kappa.Misc:Boolean("poderes", "Auto - Level Spells", true)

end

function Ryze:Loop(myHero)
self:Valores()

	if Kappa.KS.es1:Value() then
		if Kappa.KS.AQ:Value() then
		self:AutoQ()
		end
		
		if Kappa.KS.AW:Value() then
		self:AutoW()
		end
		
		if Kappa.KS.AE:Value() then
		self:AutoE()
		end
	end
	
	if Kappa.Drawings.es2:Value() then
	self:Drawings()
	end
	
	if Kappa.Misc.es3:Value() then
		if Kappa.Misc.fuego:Value() then
		self:AutoIgnite()
		end
		if Kappa.Misc.poderes:Value() then
		self:spellz()
		end
	end
	
	if IOW:Mode() == "LaneClear" then
	self:LimpiezaCtm()
	end
	
	if _G.IOW:Mode() == "Combo" and Kappa.Combo.list1:Value() == 1 then 
	self:WQER()
	end
	
	if _G.IOW:Mode() == "Combo" and Kappa.Combo.list1:Value() == 2 then
	self:QWER()
	end
	
	if _G.IOW:Mode() == "Combo" and Kappa.Combo.list1:Value() == 3 then
	self:QEWR()
	end
	
	if _G.IOW:Mode() == "Combo" and Kappa.Combo.list1:Value() == 4 then
	self:WQRE()
	end
end

function Ryze:Valores()
	aweonao = IOW:GetTarget()
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
	PerfectQ = 60 * GetCastLevel(myHero, _Q) + 0.55*GetBonusAP(myHero) + 0.015*GetMaxMana(myHero) + 0.005*GetCastLevel(myHero,_Q)*GetMaxMana(myHero)
	PerfectW = 80 * GetCastLevel(myHero, _W) + 0.4*GetBonusAP(myHero) + 0.025*GetMaxMana(myHero)
	PerfectE = 36 * GetCastLevel(myHero, _E) + 0.2*GetBonusAP(myHero) + 0.02*GetMaxMana(myHero)
end

function Ryze:Drawings()
	if Kappa.Drawings.Q:Value() then
	DrawCircle(GetOrigin(myHero),900,1,Kappa.Drawings.dp:Value(),0xffE0FFFF)
	end
	if Kappa.Drawings.W:Value() then
	DrawCircle(GetOrigin(myHero),600,1,Kappa.Drawings.dp:Value(),0xffE0FFFF)
	end
	if Kappa.Drawings.E:Value() then
	DrawCircle(GetOrigin(myHero),600,1,Kappa.Drawings.dp:Value(),0xffE0FFFF)
	end
	if Kappa.Drawings.R:Value() then
	DrawCircle(GetOrigin(myHero),200,1,Kappa.Drawings.dp:Value(),0xffE0FFFF)
	end

end

function Ryze:spellz()
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

function Ryze:AutoQ(aweonao1)
	for _, aweonao1 in pairs(GoS:GetEnemyHeroes()) do
		local aweonao2 = GetCurrentHP(aweonao1)
		local ctm = GoS:CalcDamage(myHero, aweonao1, 0, PerfectQ)
		local Predazo1 = GetPredictionForPlayer(GoS:myHeroPos(),aweonao1,GetMoveSpeed(aweonao1),1700,250,900,50,false,true)
		if QREADY and ((aweonao2 - 3) < ctm) and GoS:ValidTarget(aweonao1, 900) then
			CastSkillShot(_Q,Predazo1.PredPos.x,Predazo1.PredPos.y,Predazo1.PredPos.z)
		end
	end
end

function Ryze:AutoW(aweonao3)
	for _, aweonao3 in pairs(GoS:GetEnemyHeroes()) do
		local aweonao4 = GetCurrentHP(aweonao3)
		local ctm2 = GoS:CalcDamage(myHero, aweonao3, 0, PerfectW)
		if WREADY and ((aweonao4 - 3) < ctm2) and GoS:ValidTarget(aweonao3, 600) then
			CastTargetSpell(aweonao3, _W)
		end
	end
end

function Ryze:AutoE(aweonao5)
	for _, aweonao5 in pairs(GoS:GetEnemyHeroes()) do
		local aweonao6 = GetCurrentHP(aweonao5)
		local ctm3 = GoS:CalcDamage(myHero, aweonao5, 0, PerfectE)
		if EREADY and ((aweonao6 - 3) < ctm3) and GoS:ValidTarget(aweonao5, 600) then
			CastTargetSpell(aweonao5, _E)
		end
	end
end

function Ryze:UseQPred(aweonao)
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),aweonao,GetMoveSpeed(aweonao),1700,250,900,50,false,true)		
	if QREADY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Ryze:UseQRooted(aweonao)
	local posicion = GetOrigin(aweonao)		
	if QREADY then
	CastSkillShot(_Q,posicion.x,posicion.y,posicion.z)
	end
end

function Ryze:UseW(aweonao)
	if WREADY then
	CastTargetSpell(aweonao, _W)
	end
end

function Ryze:UseE(aweonao)
	if EREADY then
	CastTargetSpell(aweonao, _E)
	end
end

function Ryze:UseR()
	CastSpell(_R)
end

function Ryze:WQER()			
	if GoS:ValidTarget(aweonao, 600) then		
			if WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
				
        end
	end
end

function Ryze:QWER()			
	if GoS:ValidTarget(aweonao, 900) then		
			if QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and RREADY then
                self:UseR()
							
            end
	end
end

function Ryze:QEWR()			
	if GoS:ValidTarget(aweonao, 900) then		
			if QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and RREADY then
                self:UseR()
			elseif not RREADY and QREADY then
                self:UseQPred(aweonao)
            elseif not QREADY and EREADY then
                self:UseE(aweonao)
            elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and RREADY then
                self:UseR()
            end
	end
end

function Ryze:WQRE()			
	if GoS:ValidTarget(aweonao, 600) then		
			if WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and RREADY then
                self:UseR()
            elseif not RREADY and EREADY then
                self:UseE(aweonao)
			elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and RREADY then
                self:UseR()
            elseif not RREADY and EREADY then
                self:UseE(aweonao)
			elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and RREADY then
                self:UseR()
            elseif not RREADY and EREADY then
                self:UseE(aweonao)
			elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and RREADY then
                self:UseR()
            elseif not RREADY and EREADY then
                self:UseE(aweonao)
			elseif not EREADY and WREADY then
                self:UseW(aweonao)
            elseif not WREADY and QREADY then
                self:UseQRooted(aweonao)
            elseif not QREADY and RREADY then
                self:UseR()
            elseif not RREADY and EREADY then
                self:UseE(aweonao)
            end
	end
end


-- :')
function Ryze:LimpiezaCtm()     
                for i,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do    
                        if GoS:ValidTarget(minion, 600) then
							local PMinion = GetOrigin(minion)
							if WREADY and Kappa.lc.lw:Value() then
							CastTargetSpell(minion, _W)
							end
						
							if QREADY and Kappa.lc.lq:Value() then
							CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
							end							
						
							if EREADY and Kappa.lc.le:Value() then
							CastTargetSpell(minion, _E) 
							end							
             
							if RREADY and Kappa.lc.lr:Value() then
							CastSpell(_R)			 
							end
							
						end 
				end						
				for i,jungle in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do    
                        if GoS:ValidTarget(jungle, 600) then
							local PJungle = GetOrigin(jungle)
							if WREADY and Kappa.jc.jw:Value() then
							CastTargetSpell(jungle, _W)
							end
						
							if QREADY and Kappa.jc.jq:Value() then
							CastSkillShot(_Q,PJungle.x,PJungle.y,PJungle.z)
							end		
						
							if EREADY and Kappa.jc.je:Value() then
							CastTargetSpell(jungle, _E)
							end 		
             
							if RREADY and Kappa.jc.jr:Value() then
							CastSpell(_R)			 
							end
						end
				end
end

if supportedHero[GetObjectName(myHero)] == true then
	if _G[GetObjectName(myHero)] then
  		_G[GetObjectName(myHero)]()
	end 
end
