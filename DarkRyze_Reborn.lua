--[[Codeado por un chileno ykpz.
Feel free to PM me (DarkFight)
Updated to New API.]]--
require ('Inspired')
supportedHero = {["Ryze"] = true}
class "Ryze"

function Ryze:__init()

OnTick(function(myHero) self:Script(myHero) end)
OnDraw(function(myHero) self:Dibujos(myHero) end)
OnProcessSpellComplete(function(Object, spell)
  if Object == GetMyHero() and spell and spell.name then
    if spell.name == "RyzeQ" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    elseif spell.name == "RyzeW" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    elseif spell.name == "RyzeE" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    end
  end
end)

dr = MenuConfig("DarkRyze: Reborn", "DarkTeam")
dr:Menu("Combo", "Combo")
dr.Combo:Info("info1", "Combo! (Space key)")

dr:Menu("lh", "LastHit")
dr.lh:Slider("ms", "Mana Manager", 85, 1, 100, 1)
dr.lh:Boolean("lhq", "Last Hit with Q", true)

dr:Menu("lc", "Laneclear")
dr.lc:Slider("ms1", "Mana Manager", 85, 1, 100, 1)
dr.lc:Boolean("lq", "Clear with Q", true)
dr.lc:Boolean("lw", "Clear with W", true)
dr.lc:Boolean("le", "Clear with E", true)
dr.lc:Boolean("lr", "Clear using R", false)

dr:Menu("jc", "Jungleclear")
dr.jc:Slider("ms2", "Mana Manager", 85, 1, 100, 1)
dr.jc:Boolean("jq", "Clear with Q", true)
dr.jc:Boolean("jw", "Clear with W", true)
dr.jc:Boolean("je", "Clear with E", true)
dr.jc:Boolean("jr", "Clear using R", false)

dr:Menu("KS", "Kill Steal")
dr.KS:Boolean("es1", "Enable Kill Steal", true)
dr.KS:Boolean("AQ", "Perfect Q", true)
dr.KS:Boolean("AW", "Perfect W", true)
dr.KS:Boolean("AE", "Perfect E", true)

dr:Menu("Drawings", "Drawings")
dr.Drawings:Boolean("es2", "Enable Drawings", true)
dr.Drawings:Boolean("Q", "Draw Overload [Q]", true)
dr.Drawings:Boolean("W", "Draw Rune Prison [W]", true)
dr.Drawings:Boolean("E", "Draw Spell Flux [E]", true)
dr.Drawings:Boolean("R", "Draw Desperate Power [R]", true)
dr.Drawings:Slider("dp", "Quality circles", 255, 1, 255, 1)

dr:Menu("Misc", "Misc")
dr.Misc:Boolean("es3", "Enable Miscs", true)
dr.Misc:Boolean("fuego", "Auto - Ignite", true)
dr.Misc:Boolean("poderes", "Auto - Level Spells", true)

end

function Ryze:Script(myHero)
	if dr.KS.es1:Value() then
		if dr.KS.AQ:Value() then
		self:AutoQ()
		end
		
		if dr.KS.AW:Value() then
		self:AutoW()
		end
		
		if dr.KS.AE:Value() then
		self:AutoE()
		end
	end
	
	if dr.Drawings.es2:Value() then
	self:Drawings()
	end
	
	if dr.Misc.es3:Value() then
		if dr.Misc.fuego:Value() then
		self:AutoIgnite()
		end
		if dr.Misc.poderes:Value() then
		self:spellz()
		end
	end
	
	if IOW:Mode() == "LastHit" then
	self:LastHit()
	end
	
	if IOW:Mode() == "LaneClear" then
	self:LimpiezaCtm()
	end
	
	if _G.IOW:Mode() == "Combo" then 
	self:Combo()
	end
end

function Ryze:Dibujos()
  if dr.Drawings.es2:Value() then
	self:Drawings()
	end
end

function Ryze:Drawings()
	if dr.Drawings.Q:Value() then
	DrawCircle(myHeroPos(),900,1,dr.Drawings.dp:Value(),GoS.Pink)
	end
	if dr.Drawings.W:Value() then
	DrawCircle(myHeroPos(),600,1,dr.Drawings.dp:Value(),GoS.Pink)
	end
	if dr.Drawings.E:Value() then
	DrawCircle(myHeroPos(),600,1,dr.Drawings.dp:Value(),GoS.Pink)
	end
	if dr.Drawings.R:Value() then
	DrawCircle(myHeroPos(),200,1,dr.Drawings.dp:Value(),GoS.Pink)
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
        for _, k in pairs(GetEnemyHeroes()) do
            if CanUseSpell(GetMyHero(), Ignite) == READY and (20*GetLevel(GetMyHero())+50) > GetCurrentHP(k)+GetHPRegen(k)*2.5 and GetDistanceSqr(GetOrigin(k)) < 600*600 then
                CastTargetSpell(k, Ignite)
            end
        end
    end
end

function Ryze:AutoQ(aweonao1)
	for _, aweonao1 in pairs(GetEnemyHeroes()) do
		local PerfectQ = 60 * GetCastLevel(myHero, _Q) + 0.55*GetBonusAP(myHero) + 0.015*GetMaxMana(myHero) + 0.005*GetCastLevel(myHero,_Q)*GetMaxMana(myHero)
		local aweonao2 = GetCurrentHP(aweonao1)
		local ctm = CalcDamage(myHero, aweonao1, 0, PerfectQ)
		local Predazo1 = GetPredictionForPlayer(myHeroPos(),aweonao1,GetMoveSpeed(aweonao1),1700,250,900,50,true,true)
		if CanUseSpell(myHero, _Q) == READY and ((aweonao2 - 3) < ctm) and ValidTarget(aweonao1, 900) then
			CastSkillShot(_Q,Predazo1.PredPos.x,Predazo1.PredPos.y,Predazo1.PredPos.z)
		end
	end
end

function Ryze:AutoW(aweonao3)
	for _, aweonao3 in pairs(GetEnemyHeroes()) do
		local PerfectW = 80 * GetCastLevel(myHero, _W) + 0.4*GetBonusAP(myHero) + 0.025*GetMaxMana(myHero)
		local aweonao4 = GetCurrentHP(aweonao3)
		local ctm2 = CalcDamage(myHero, aweonao3, 0, PerfectW)
		if CanUseSpell(myHero, _W) == READY and ((aweonao4 - 3) < ctm2) and ValidTarget(aweonao3, 600) then
			CastTargetSpell(aweonao3, _W)
		end
	end
end

function Ryze:AutoE(aweonao5)
	for _, aweonao5 in pairs(GetEnemyHeroes()) do
		local PerfectE = 36 * GetCastLevel(myHero, _E) + 0.2*GetBonusAP(myHero) + 0.02*GetMaxMana(myHero)
		local aweonao6 = GetCurrentHP(aweonao5)
		local ctm3 = CalcDamage(myHero, aweonao5, 0, PerfectE)
		if CanUseSpell(myHero, _E) == READY and ((aweonao6 - 3) < ctm3) and ValidTarget(aweonao5, 600) then
			CastTargetSpell(aweonao5, _E)
		end
	end
end

function Ryze:UseQPred(target)
	local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1700,250,900,50,false,true)		
	if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Ryze:UseQRooted(target)
	local target = GetCurrentTarget()
	local posicion = GetOrigin(target)		
	if CanUseSpell(myHero, _Q) == READY then
	CastSkillShot(_Q,posicion.x,posicion.y,posicion.z)
	end
end

function Ryze:UseW(target)
	local target = GetCurrentTarget()
	CastTargetSpell(target, _W)
end

function Ryze:UseE(target)
	local target = GetCurrentTarget()
	CastTargetSpell(target, _E)
end

function Ryze:UseR()
	local Stacks = GotBuff(myHero, "ryzepassivestack")
	local Pasiva = GotBuff(myHero, "ryzepassivecharged")
	if Pasiva == 1 or Stacks >= 4 then
	CastSpell(_R)
	end
end

function Ryze:Combo()
	local target = GetCurrentTarget()
	local Stacks = GotBuff(myHero, "ryzepassivestack")
	local Pasiva = GotBuff(myHero, "ryzepassivecharged")
	if ValidTarget(target, 900) then
		if Stacks <= 2 and Pasiva == 0 then
				if CanUseSpell(myHero, _Q) == READY then
				self:UseQPred(target)
				end
				if CanUseSpell(myHero, _W) == READY then
				self:UseW(target)
				end
				if CanUseSpell(myHero, _E) == READY then
				self:UseE(target)
				end
				if CanUseSpell(myHero, _R) == READY then
				self:UseR()
				end
		end
		if Stacks == 3 then
				if CanUseSpell(myHero, _Q) == READY then
				self:UseQPred(target)
				end
				if CanUseSpell(myHero, _E) == READY then
				self:UseE(target)
				end
				if CanUseSpell(myHero, _W) == READY then
				self:UseW(target)
				end
				if CanUseSpell(myHero, _R) == READY then
				self:UseR()
				end
		end
		if Stacks == 4 then
				if CanUseSpell(myHero, _W) == READY then
				self:UseW(target)
				end
				if CanUseSpell(myHero, _Q) == READY then
				self:UseQRooted(target)
				end
				if CanUseSpell(myHero, _E) == READY then
				self:UseE(target)
				end
				if CanUseSpell(myHero, _R) == READY then
				self:UseR()
				end
		end
		if Pasiva == 1 then
				if CanUseSpell(myHero, _W) == READY then 
				self:UseW(target)
				end
				if CanUseSpell(myHero, _Q) == READY then
				self:UseQRooted(target)
				end
				if CanUseSpell(myHero, _E) == READY then
				self:UseE(target)
				end
				if CanUseSpell(myHero, _R) == READY then
				self:UseR()
				end
			end
	end
end

function Ryze:LastHit()
  for i,minion in pairs(minionManager.objects) do    
    if ValidTarget(minion, 900) then
    local Predazo1 = GetPredictionForPlayer(myHeroPos(),minion,GetMoveSpeed(minion),1700,250,900,50,true,true)
    local SpellDamage = 60 * GetCastLevel(myHero, _Q) + 0.55*GetBonusAP(myHero) + 0.015*GetMaxMana(myHero) + 0.005*GetCastLevel(myHero,_Q)*GetMaxMana(myHero)
    local Health = GetCurrentHP(minion)
    local Calcs = CalcDamage(myHero, minion, 0, SpellDamage)
      if CanUseSpell(myHero, _Q) == READY and dr.lh.lhq:Value() and GetPercentMP(myHero) >= dr.lh.ms:Value() and Health <= Calcs then
        CastSkillShot(_Q,Predazo1.PredPos.x,Predazo1.PredPos.y,Predazo1.PredPos.z)
      end
	end
   end
end

function Ryze:LimpiezaCtm()     
        for i,minion in pairs(minionManager.objects) do    
            if ValidTarget(minion, 600) and GetPercentMP(myHero) >= dr.lc.ms1:Value() then
							local PMinion = GetOrigin(minion)
							if CanUseSpell(myHero, _W) == READY and dr.lc.lw:Value() then
							CastTargetSpell(minion, _W)
							end				
							if CanUseSpell(myHero, _Q) == READY and dr.lc.lq:Value() then
							CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
							end												
							if CanUseSpell(myHero, _E) == READY and dr.lc.le:Value() then
							CastTargetSpell(minion, _E) 
							end							           
							if CanUseSpell(myHero, _R) == READY and dr.lc.lr:Value() then
							CastSpell(_R)			 
							end						
						end 
				end						
				for i,jungle in pairs(minionManager.objects) do    
             if ValidTarget(jungle, 600) and GetPercentMP(myHero) >= dr.jc.ms2:Value() then
							local PJungle = GetOrigin(jungle)
							if CanUseSpell(myHero, _W) == READY and dr.jc.jw:Value() then
							CastTargetSpell(jungle, _W)
							end					
							if CanUseSpell(myHero, _Q) == READY and dr.jc.jq:Value() then
							CastSkillShot(_Q,PJungle.x,PJungle.y,PJungle.z)
							end							
							if CanUseSpell(myHero, _E) == READY and dr.jc.je:Value() then
							CastTargetSpell(jungle, _E)
							end 		           
							if CanUseSpell(myHero, _R) == READY and dr.jc.jr:Value() then
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
