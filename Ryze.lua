supportedHero = {["Ryze"] = true}
class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

MainMenu = Menu("DarkRyze", "Ryze")
MainMenu:SubMenu("Combo", "Combo")
MainMenu.Combo:Boolean("Q", "Use Q", true)
MainMenu.Combo:Boolean("W", "Use W", true)
MainMenu.Combo:Boolean("E", "Use E", true)
MainMenu.Combo:Boolean("R", "Use R", true)
MainMenu.Combo:Boolean("RR", "Use R if rooted", true)
	
end
--Updated 5.17.


function Ryze:Loop(myHero)
	self:Req()
	self:DoCombo()
end

function Ryze:Req()
	rooted = (GotBuff(target, "RyzeW") == 1)
	gotpasive = (GotBuff(myHero, "ryzepassivecharged") > 0)
	QREADY = CanUseSpell(myHero, _Q) == READY
	WREADY = CanUseSpell(myHero, _W) == READY
	EREADY = CanUseSpell(myHero, _E) == READY
	RREADY = CanUseSpell(myHero, _R) == READY
end

function Ryze:DoCombo()
if IOW:Mode() == "Combo" and GotBuff(myHero, "ryzepassivestacks") >= 2 then 
	local target = IOW:GetTarget()
			
	if GoS:ValidTarget(target, 900) then					
		if WREADY and MainMenu.Combo.W:Value() then
			CastTargetSpell(target, _W)
			end                     	
		
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)
		local ChampEnemy = GetOrigin(target)		
		if QREADY and rooted and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)						
		elseif QREADY and QPred.HitChance == 1 and not rooted and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end

		if EREADY and MainMenu.Combo.E:Value() then
			CastTargetSpell(target, _E)
			end

		if RREADY and MainMenu.Combo.R:Value() and gotpasive then
			CastSpell(_R)
		elseif RREADY and MainMenu.Combo.RR:Value() and gotpasive and rooted then
			CastSpell(_R)
			end
		end
	end

if IOW:Mode() == "Combo" and GotBuff(myHero, "ryzepassivestacks") <= 1 then 
	local target = IOW:GetTarget()
			
	if GoS:ValidTarget(target, 900) then							                     			
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)
		local ChampEnemy = GetOrigin(target)		
		if QREADY and rooted and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)						
		elseif QREADY and QPred.HitChance == 1 and not rooted and MainMenu.Combo.Q:Value() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end

		if WREADY and MainMenu.Combo.W:Value() then
			CastTargetSpell(target, _W)
			end
		
		if EREADY and MainMenu.Combo.E:Value() then
			CastTargetSpell(target, _E)
			end

		if RREADY and MainMenu.Combo.R:Value() then
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
