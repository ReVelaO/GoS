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
if _G.IOW:Mode() == "Combo" then	
	self:DoCombo()
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

function Ryze:UseQPred(target)
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)		
	if QREADY and QPred.HitChance == 1 and not rooted and MainMenu.Combo.Q:Value() then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
end

function Ryze:UseQRooted(target)
	local ChampEnemy = GetOrigin(target)		
	if QREADY and rooted and MainMenu.Combo.Q:Value() then
	CastSkillShot(_Q,ChampEnemy.x,ChampEnemy.y,ChampEnemy.z)
	end
end

function Ryze:UseW(target)
	if WREADY and MainMenu.Combo.E:Value() then
	CastTargetSpell(target, _W)
	end
end

function Ryze:UseE(target)
	if EREADY and MainMenu.Combo.W:Value() then
	CastTargetSpell(target, _E)
	end
end

function Ryze:UseR()
	CastSpell(_R)
end

function Ryze:DoCombo()
if stacks >= 2 then 			
	if GoS:ValidTarget(target, 900) then					
		if WREADY then
			self:UseW(target)
			end                     	
		if QREADY and rooted then
			self:UseQRooted(target)
		elseif QREADY and not rooted then
			self:UseQPred(target)						
			end
		if EREADY then
			self:UseE(target)
			end
		if RREADY and gotpasive then
			self:UseR()
		elseif RREADY and gotpasive and rooted then
			self:UseR()
			end
		end
	end

if stacks <= 1 then 			
	if GoS:ValidTarget(target, 900) then			
		if QREADY then
			self:UseQPred(target)								
		elseif QREADY and rooted then
			self:UseQRooted(target)						
			end
		if WREADY then
			self:UseW(target)
			end		
		if EREADY then
			self:UseE(target)
			end
		if RREADY then
			self:UseR()
			end
		end
	end
end

if supportedHero[GetObjectName(myHero)] == true then
if _G[GetObjectName(myHero)] then
  _G[GetObjectName(myHero)]()
end 
end
