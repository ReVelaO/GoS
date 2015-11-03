--[[Codeado por un chileno ykpz.
Feel free to PM me (DarkFight)
Updated to New API.
Version: 1.0.0.6, Clean code.
]]--
require ('Inspired')
supportedHero = {["Ryze"] = true}
class "Ryze"
function Ryze:__init()
OnTick(function(myHero) self:OnLoad(myHero) end)
OnDraw(function(myHero) self:On_Draw(myHero) end)
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

dr = MenuConfig("[DarkTeam] Ryze", "DarkTeam")
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
function Ryze:OnLoad(myHero)
  self:CallCombo()
  self:CallLastHit()
  self:CallLaneclear()
  self:CallKS()
  self:CallMisc()
end
function Ryze:CallCombo()
  if IOW:Mode() == "Combo" then 
	self:Combo()
	end
end
function Ryze:CallLastHit()
  if IOW:Mode() == "LastHit" then
	self:LastHit()
	end
end
function Ryze:CallLaneclear()
  if IOW:Mode() == "LaneClear" then
	self:LimpiezaCtm()
	end
end
function Ryze:CallKS()
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
end
function Ryze:CallMisc()
  if dr.Misc.es3:Value() then
		if dr.Misc.fuego:Value() then
		self:AutoIgnite()
		end
		if dr.Misc.poderes:Value() then
		self:OnLevel()
		end
	end
end
function Ryze:On_Draw()
  if dr.Drawings.es2:Value() then
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
end
function Ryze:OnLevel()
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
		if Ready(_Q) and ((aweonao2 - 3) < ctm) and ValidTarget(aweonao1, 900) then
			CastSkillShot(_Q,Predazo1.PredPos.x,Predazo1.PredPos.y,Predazo1.PredPos.z)
		end
	end
end
function Ryze:AutoW(aweonao3)
	for _, aweonao3 in pairs(GetEnemyHeroes()) do
		local PerfectW = 80 * GetCastLevel(myHero, _W) + 0.4*GetBonusAP(myHero) + 0.025*GetMaxMana(myHero)
		local aweonao4 = GetCurrentHP(aweonao3)
		local ctm2 = CalcDamage(myHero, aweonao3, 0, PerfectW)
		if Ready(_W) and ((aweonao4 - 3) < ctm2) and ValidTarget(aweonao3, 600) then
			CastTargetSpell(aweonao3, _W)
		end
	end
end
function Ryze:AutoE(aweonao5)
	for _, aweonao5 in pairs(GetEnemyHeroes()) do
		local PerfectE = 36 * GetCastLevel(myHero, _E) + 0.2*GetBonusAP(myHero) + 0.02*GetMaxMana(myHero)
		local aweonao6 = GetCurrentHP(aweonao5)
		local ctm3 = CalcDamage(myHero, aweonao5, 0, PerfectE)
		if Ready(_E) and ((aweonao6 - 3) < ctm3) and ValidTarget(aweonao5, 600) then
			CastTargetSpell(aweonao5, _E)
		end
	end
end
function Ryze:UseQPred(target)
	local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1700,250,900,50,false,true)		
	if Ready(_Q) and QPred.HitChance == 1 then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end
function Ryze:UseQRooted(target)
	local target = GetCurrentTarget()
	local posicion = GetOrigin(target)		
	if Ready(_Q) then
	CastSkillShot(_Q,posicion.x,posicion.y,posicion.z)
	end
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
				if Ready(_Q) then
				self:UseQPred(target)
				end
				if Ready(_W) then
				CastTargetSpell(target, _W)
				end
				if Ready(_E) then
				CastTargetSpell(target, _E)
				end
				if Ready(_R) then
				self:UseR()
				end
		end
		if Stacks == 3 then
				if Ready(_Q) then
				self:UseQPred(target)
				end
				if Ready(_E) then
				CastTargetSpell(target, _E)
				end
				if Ready(_W) then
				CastTargetSpell(target, _W)
				end
				if Ready(_R) then
				self:UseR()
				end
		end
		if Stacks == 4 then
				if Ready(_W) then
				CastTargetSpell(target, _W)
				end
				if Ready(_Q) then
				self:UseQRooted(target)
				end
				if Ready(_E) then
				CastTargetSpell(target, _E)
				end
				if Ready(_R) then
				self:UseR()
				end
		end
		if Pasiva == 1 then
				if Ready(_W) then 
				CastTargetSpell(target, _W)
				end
				if Ready(_Q) then
				self:UseQRooted(target)
				end
				if Ready(_E) then
				CastTargetSpell(target, _E)
				end
				if Ready(_R) then
				self:UseR()
				end
			end
	end
end
function Ryze:LastHit()
  for i,minion in pairs(minionManager.objects) do    
    if ValidTarget(minion, 900) then
    local PosM = GetOrigin(minion)
    local SpellDamage = 60 * GetCastLevel(myHero, _Q) + 0.55*GetBonusAP(myHero) + 0.015*GetMaxMana(myHero) + 0.005*GetCastLevel(myHero,_Q)*GetMaxMana(myHero)
		local Calcs = CalcDamage(myHero, minion, 0, SpellDamage)
      if Ready(_Q) and dr.lh.lhq:Value() and GetPercentMP(myHero) >= dr.lh.ms:Value() and (GetCurrentHP(minion) - 25) <= Calcs then
        CastSkillShot(_Q,PosM.x,PosM.y,PosM.z)
      end
		end
	end
end
function Ryze:LimpiezaCtm()     
        for i,minion in pairs(minionManager.objects) do    
            if ValidTarget(minion, 600) and GetPercentMP(myHero) >= dr.lc.ms1:Value() then
							local PMinion = GetOrigin(minion)
							if Ready(_W) and dr.lc.lw:Value() then
							CastTargetSpell(minion, _W)
							end				
							if Ready(_Q) and dr.lc.lq:Value() then
							CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
							end												
							if Ready(_E) and dr.lc.le:Value() then
							CastTargetSpell(minion, _E) 
							end							           
							if Ready(_R) and dr.lc.lr:Value() then
							CastSpell(_R)			 
							end						
						end 
				end						
				for i,jungle in pairs(minionManager.objects) do    
             if ValidTarget(jungle, 600) and GetPercentMP(myHero) >= dr.jc.ms2:Value() then
							local PJungle = GetOrigin(jungle)
							if Ready(_W) and dr.jc.jw:Value() then
							CastTargetSpell(jungle, _W)
							end					
							if Ready(_Q) and dr.jc.jq:Value() then
							CastSkillShot(_Q,PJungle.x,PJungle.y,PJungle.z)
							end							
							if Ready(_E) and dr.jc.je:Value() then
							CastTargetSpell(jungle, _E)
							end 		           
							if Ready(_R) and dr.jc.jr:Value() then
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
