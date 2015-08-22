require ('Inspired')
require ('IAC')                
myIAC = IAC()
Config = scriptConfig("Ryze", "DarkRyze")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)
PrintChat("<font color=\"#a375ff\"><b>[DarkRyze v1.1.2 By DarkFight] </b></font> <font color=\"#FFFFFF\">Loaded and Ready to use.</font>")

--Reworked Combo, 5.16 Working.               
local Pasiva = "ryzepassivecharged"

OnLoop(function(myHero)
                
if IWalkConfig.Combo then
local target = GetTarget(1000, DAMAGE_MAGIC)
if ValidTarget(target, 1000) then
							
if CanUseSpell(myHero, _W) == READY and Config.W then
CastTargetSpell(target, _W)
end
                     	
local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)		
if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and Config.Q then
CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
end

if CanUseSpell(myHero, _E) == READY and Config.E then
CastTargetSpell(target, _E)
end

if CanUseSpell(myHero, _R) == READY and Config.R and (GotBuff(myHero, "ryzepassivecharged") > 0) then
CastSpell(_R)
end				
end
end
end)
