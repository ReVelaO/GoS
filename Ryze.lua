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
local Cargas = "ryzepassivestack"
local Pasiva = "ryzepassivecharged"

OnLoop(function(myHero)
                
        if IWalkConfig.Combo then
                   local target = GetTarget(1000, DAMAGE_MAGIC)
                        if ValidTarget(target, 1000) then
                		if (GotBuff(myHero, "ryzepassivestack") == 3) then
						if CanUseSpell(myHero, _W) == READY and Config.W then
						CastTargetSpell(unit, _W)
						end
                     	
						local Q = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),900,250,GetCastRange(myHero,_Q),55,false,true)		
                        			if CanUseSpell(myHero, _Q) == READY and Q.HitChance == 1 and Config.Q and (GotBuff(unit, "RyzeW") == 1) then
                        			CastSkillShot(_Q,Q.PredPos.x,Q.PredPos.y,Q.PredPos.z)						
						end

						if CanUseSpell(myHero, _E) == READY and Config.E then
						CastTargetSpell(unit, _E)
						end

						if CanUseSpell(myHero, _R) == READY and Config.R and (GotBuff(myHero, "ryzepassivecharged") == 1) and (GotBuff(unit, "RyzeW") == 1) then
						CastSpell(_R)
						end

				else if (GotBuff(myHero, "ryzepassivestack") == 4) then
						local Q = GetPredictionForPlayer(GetMyHeroPos(),unit,GetMoveSpeed(unit),900,250,GetCastRange(myHero,_Q),55,false,true)		
                        			if CanUseSpell(myHero, _Q) == READY and Q.HitChance == 1 and Config.Q then
                        			CastSkillShot(_Q,Q.PredPos.x,Q.PredPos.y,Q.PredPos.z)						
						end
						
						if CanUseSpell(myHero, _W) == READY and Config.W then
						CastTargetSpell(unit, _W)
						end
                     	
						if CanUseSpell(myHero, _E) == READY and Config.E then
						CastTargetSpell(unit, _E)
						end

						if CanUseSpell(myHero, _R) == READY and Config.R and (GotBuff(myHero, "ryzepassivecharged") == 1) and (GotBuff(unit, "RyzeW") == 1) then
						CastSpell(_R)
						end
				end
		end
	end
end)
