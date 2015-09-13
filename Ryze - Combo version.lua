supportedHero = {["Ryze"] = true}
class "Ryze"

function Ryze:__init()

OnLoop(function(myHero) self:Loop(myHero) end)

MainMenu = Menu("DarkRyze", "Ryze")
MainMenu:SubMenu("Combo", "Combo")
MainMenu.Combo:List("combos", "Combo Options", 1, {"WQER", "QWER"})
	
end
--Updated 5.17.


function Ryze:Loop(myHero)
	self:Req()
if _G.IOW:Mode() == "Combo" and MainMenu.Combo.combos:Value() == 1 then	
	self:WQER()
	end
if _G.IOW:Mode() == "Combo" and MainMenu.Combo.combos:Value() == 2 then	
	self:QWER()
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

if supportedHero[GetObjectName(myHero)] == true then
if _G[GetObjectName(myHero)] then
  _G[GetObjectName(myHero)]()
end 
end
