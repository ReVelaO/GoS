-- CHECK FOR RYZE HERO
if (myHero.charName ~= "Ryze") then
	return
end

-- SCRIPT NAME
local scriptName = "DarkRyze"

-- VARS IMAGES FOR MENUS
local Icons = { Ryze = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/2/28/RyzeSquare.png",
			   Q = "https://vignette1.wikia.nocookie.net/leagueoflegends/images/a/a7/Overload.png",
			   W = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/b/be/Rune_Prison.png",
			   E = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/8/81/Spell_Flux.png",
			   Ignite = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/f/f4/Ignite.png" }

-- MENU
local menu = MenuElement({type = MENU, id = "mymenu", name = scriptName, leftIcon = Icons.Ryze})

menu:MenuElement({type = MENU, name = "Combo Settings", id = "combo"})
menu.combo:MenuElement({name = "Overload [Q]", id = "useq", leftIcon = Icons.Q, value = true})
menu.combo:MenuElement({name = "Rune Prison [W]", id = "usew", leftIcon = Icons.W, value = true})
menu.combo:MenuElement({name = "Spell Flux [E]", id = "usee", leftIcon = Icons.E, value = true})
menu.combo:MenuElement({name = "Ignite", id = "ign", leftIcon = Icons.Ignite, value = true})

menu:MenuElement({type = MENU, name = "Laneclear Settings", id = "laneclear"})
menu.laneclear:MenuElement({name = "Overload [Q]", id = "lcuseq", leftIcon = Icons.Q, value = true})
menu.laneclear:MenuElement({name = "Spell Flux [E]", id = "lcusee", leftIcon = Icons.E, value = true})

menu:MenuElement({type = MENU, name = "Jungleclear Settings", id = "jungleclear"})
menu.jungleclear:MenuElement({name = "Overload [Q]", id = "useq", leftIcon = Icons.Q, value = true})
menu.jungleclear:MenuElement({name = "Rune Prison [W]", id = "usew", leftIcon = Icons.W, value = true})
menu.jungleclear:MenuElement({name = "Spell Flux [E]", id = "usee", leftIcon = Icons.E, value = true})

menu:MenuElement({type = MENU, name = "Drawings", id = "drawings"})
menu.drawings:MenuElement({name = "Draw Overload [Q]", id = "drawq", leftIcon = Icons.Q, value = false})
menu.drawings:MenuElement({name = "Draw W/E", id = "drawwe", value = false})

-- SPELLS WITH DATA
local Q = {range = 1000, speed = 1700, delay = 0.25 + Game.Latency() / 1000, width = 55}

-- FUNCTIONS

function doQ(unit)
	if (unit ~= nil) then
		if (_G.SDK.BuffManager:HasBuff(unit, "RyzeE")) then
			local pred = unit:GetPrediction(Q.speed, Q.delay)
			if (pred) then
				Control.CastSpell(HK_Q, pred)
			end
		end
	end
end

function CountEnemyMinionsInRange(unit, range)
	local c = 0
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if (minion.team ~= myHero.team and _G.SDK.Utilities:IsInRange(unit, minion.pos) and unit ~= minion) then
			c = c + 1
		end
	end
	return c
end

function EDamage()
	if (myHero:GetSpellData(_E).level == 0) then
		return 0
	end

	local baseE = { 50, 70, 100, 125, 150 }
	local Base = baseE[myHero:GetSpellData(_E).level]
	local BonusAP = 0.3 * myHero.ap
	local BonusMana = 0.009 * myHero.maxMana
	local dmg = Base + BonusAP + BonusMana

	return dmg
end

-- FUNCTIONs MODES
local Combo = function()
	local target = _G.SDK.TargetSelector:GetTarget(1000, _G.SDK.DAMAGE_TYPE_MAGICAL)

		if (target ~= nil) then
			if (menu.combo.useq:Value() and Game.CanUseSpell(_Q) == READY) then
				if (target:GetCollision(Q.width, Q.speed, Q.delay) == 0) then
					if (_G.SDK.BuffManager:HasBuff(target, "RyzeW")) then
						Control.CastSpell(HK_Q, target.pos)
					else
						local pred = target:GetPrediction(Q.speed, Q.delay)
						if (pred) then
							Control.CastSpell(HK_Q, pred)
						end
					end
				end
			end
			if (menu.combo.usee:Value() and Game.CanUseSpell(_E) == READY 
										and _G.SDK.Utilities:IsInRange(target, myHero, 615)) then
				Control.CastSpell(HK_E, target)
			end
			if (menu.combo.usew:Value() and Game.CanUseSpell(_W) == READY 
										and _G.SDK.Utilities:IsInRange(target, myHero, 615) 
										and myHero:GetSpellData(_Q).currentCd > 0 
										and myHero:GetSpellData(_E).currentCd > 0) then
				Control.CastSpell(HK_W, target)
			end
	end
end

local AutoIgnite = function()

	local Ignite = _G.SDK.Utilities:GetSlotFromName(myHero, "SummonerDot")
	
	if (Ignite == nil or menu.combo.ign:Value() == false) then return end
	
	for i, enemy in ipairs(_G.SDK.ObjectManager:GetEnemyHeroes(510)) do
		
		if (enemy ~= nil and enemy:IsValidTarget()) then
			
			local IgniteDmg = 50 + (20 * _G.SDK.Utilities:GetLevel(myHero))
			local fnlDmg = _G.SDK.Damage:CalculateDamage(myHero, enemy, DAMAGE_TYPE_TRUE, IgniteDmg, true)
			
			if (Game.CanUseSpell(Ignite) == READY and enemy.health <= fnlDmg) then
				Control.CastSpell(Ignite, enemy)
			end

		end
	end
end

local Laneclear = function()

	for i, minion in ipairs(_G.SDK.ObjectManager:GetEnemyMinions(1000)) do
		
		if (minion ~= nil) then
			-- Habilidad E
			if (Game.CanUseSpell(_E) == READY and menu.laneclear.lcusee:Value() and _G.SDK.Utilities:IsInRange(minion, myHero, 615)) then
				
				if (_G.SDK.BuffManager:HasBuff(minion, "RyzeE") and CountEnemyMinionsInRange(minion, 250) > 1) then
					Control.CastSpell(HK_E, minion)
				else

					local EDmg = _G.SDK.Damage:CalculateDamage(myHero, minion, DAMAGE_TYPE_MAGICAL, EDamage(), true)

					if (minion.health <= EDmg and CountEnemyMinionsInRange(minion, 250) > 1) then
						Control.CastSpell(HK_E, minion)
					end
				end

			end
			--Habilidad Q
			if (Game.CanUseSpell(_Q) == READY and menu.laneclear.lcuseq:Value() and _G.SDK.Utilities:IsInRange(minion, myHero, Q.range)) then
				doQ(minion)
			end
		end

	end
end

local Jungleclear = function()
	for i, monster in ipairs(_G.SDK.ObjectManager:GetMonstersInAutoAttackRange())do
		if (monster ~= nil) then
			if (menu.jungleclear.useq:Value() and Game.CanUseSpell(_Q) == READY) then
				doQ(monster)
			end
			if (menu.jungleclear.usee:Value() and Game.CanUseSpell(_E) == READY) then
				Control.CastSpell(HK_E, monster)
			end
			if (menu.jungleclear.usew:Value() and Game.CanUseSpell(_W) == READY 
										and myHero:GetSpellData(_Q).currentCd > 0 
										and myHero:GetSpellData(_E).currentCd > 0) then
				Control.CastSpell(HK_W, monster)
			end
		end
	end
end

local OnTick = function()

	if (myHero.dead) then return end

	AutoIgnite()

	if (_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]) then
		Combo()
	end

	if (_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR]) then
		Laneclear()
	end

	if (_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]) then
		Jungleclear()
	end
end

local OnDraw = function()

	if (myHero.dead) then return end

	if (Game.CanUseSpell(_Q) == READY and menu.drawings.drawq:Value()) then
		Draw.Circle(myHero.pos, Q.range, Draw.Color(180, 131, 131, 255))
	end

	if ((Game.CanUseSpell(_W) == READY or Game.CanUseSpell(_E) == READY) and menu.drawings.drawwe:Value()) then
		Draw.Circle(myHero.pos, 615, Draw.Color(180, 131, 131, 255))
	end
end

-- ONTICK FUNCTION
Callback.Add("Tick", function() OnTick() end)
Callback.Add("Draw", function() OnDraw() end)