if (myHero.charName ~= "Ryze") then
	return
end

-- MENU
local menu = MenuElement({id = "mymenu", name = "DarkRyze", leftIcon = "https://vignette3.wikia.nocookie.net/leagueoflegends/images/2/28/RyzeSquare.png/revision/latest/scale-to-width-down/48?cb=20160630224634", type = MENU})

menu:MenuElement({type = MENU, name = "Combo", id = "combo"})
menu.combo:MenuElement({name = "Use Q", id = "useq", value = true})
menu.combo:MenuElement({name = "Use W", id = "usew", value = true})
menu.combo:MenuElement({name = "Use E", id = "usee", value = true})

-- SPELLS WITH DATA
local Q = {speed = 1000, delay = 250}

-- FUNCTIONS
function IsReady(spell)
	return Game.CanUseSpell(spell) == READY
end

function IsInRange(target, me, range)
	local rangoAlCuadrado = range * range
	local resultado = (target.x - me.x)^2 + (target.y - me.y)^2 + (target.z - me.z)^2
	if (resultado <= rangoAlCuadrado) then
		return true
	end	
	return false
end

local function OnTick()

	if (myHero.dead) then return end

	if (_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]) then

		local target = _G.SDK.TargetSelector:GetTarget(1000, _G.SDK.DAMAGE_TYPE_MAGICAL)
		if (target ~= nil and target:IsValidTarget()) then
			if (menu.combo.useq:Value() and IsReady(_Q)) then
				local pred = target:GetPrediction(Q.speed, Q.delay)
				if (pred) then
					Control.CastSpell(HW_Q, pred)
				end
			end
			if (menu.combo.usee:Value() and IsReady(_E) and IsInRange(target, myHero, 615)) then
				Control.CastSpell(HW_E, target)
			end
			if (menu.combo.usew:Value() and IsReady(_W) and IsInRange(target, myHero, 615) and not IsReady(_Q)) then
				Control.CastSpell(HW_W, target)
			end
		end

	end
end

-- ONTICK FUNCTION
Callback.Add("Tick", function()
	OnTick()
end)