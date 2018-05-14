require "Alpha"
require "HPred"

local TS = _G.SDK.TargetSelector
local MathAbs = math.abs
local MathAtan = math.atan
local MathHuge = math.huge
local PI = math.pi

local IsReady = function(islot)
	local data = myHero:GetSpellData(islot)
	return Game.CanUseSpell(islot) == READY and data.currentCd == 0 and data.level > 0 and myHero.mana >= data.mana
end

local GetData = function(islot)
	return myHero:GetSpellData(islot)
end

local GetDistance = function(xyz1,xyz2)
	local pos1 = Vector(xyz1.x, xyz1.y, xyz1.z)
	local pos2 = Vector(xyz2.x, xyz2.y, xyz2.z)
	return pos2:DistanceTo(pos1)
end

local Polar = function(vector2D)
	if MathAbs(vector2D.x - 0) <= 1e-9 then
		return vector2D.y > 0 and 90 or (vector2D.y < 0 and 270 or 0)
	end

	local theta = MathAtan(vector2D.y / vector2D.x) * (180 / PI)
	if vector2D.x < 0 then
		theta = theta + 180
	end
	if theta < 0 then
		theta = theta + 360
	end

	return theta
end

local AngleBetween = function(vector2D, toVector2D)
    local theta = Polar(vector2D) - Polar(toVector2D);
    if theta < 0 then
        theta = theta + 360;
	end

    if theta > 180 then
        theta = 360 - theta;
	end

    return theta;
end

local IsFacing = function(source, target)
	if source == nil or target == nil then
		return false
	end

	local _dir = Vector(source.dir)
	local diff = Vector(target.pos - source.pos)
	return AngleBetween(_dir, diff) < 90
end

local _EnemyHeroes
function GetEnemyHeroes()
  if _EnemyHeroes then return _EnemyHeroes end
  for i = 1, Game.HeroCount() do
    local unit = Game.Hero(i)
    if unit.isEnemy then
	  if _EnemyHeroes == nil then _EnemyHeroes = {} end
      table.insert(_EnemyHeroes, unit)
    end
  end
  return {}
end

local _OnVision = {}
function OnVision(unit)
	if _OnVision[unit.networkID] == nil then _OnVision[unit.networkID] = {state = unit.visible , tick = GetTickCount(), pos = unit.pos} end
	if _OnVision[unit.networkID].state == true and not unit.visible then _OnVision[unit.networkID].state = false _OnVision[unit.networkID].tick = GetTickCount() end
	if _OnVision[unit.networkID].state == false and unit.visible then _OnVision[unit.networkID].state = true _OnVision[unit.networkID].tick = GetTickCount() end
	return _OnVision[unit.networkID]
end
Callback.Add("Tick", function() OnVisionF() end)
local visionTick = GetTickCount()
function OnVisionF()
	if GetTickCount() - visionTick > 100 then
		for i,v in pairs(GetEnemyHeroes()) do
			OnVision(v)
		end
	end
end

local IsImmobileTarget = function(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

local _OnWaypoint = {}
local OnWaypoint = function(unit)
	if _OnWaypoint[unit.networkID] == nil then _OnWaypoint[unit.networkID] = {pos = unit.posTo , speed = unit.ms, time = Game.Timer()} end
	if _OnWaypoint[unit.networkID].pos ~= unit.posTo then
		_OnWaypoint[unit.networkID] = {startPos = unit.pos, pos = unit.posTo , speed = unit.ms, time = Game.Timer()}
			DelayAction(function()
				local time = (Game.Timer() - _OnWaypoint[unit.networkID].time)
				local speed = GetDistance(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				if speed > 1250 and time > 0 and unit.posTo == _OnWaypoint[unit.networkID].pos and GetDistance(unit.pos,_OnWaypoint[unit.networkID].pos) > 200 then
					_OnWaypoint[unit.networkID].speed = GetDistance(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				end
			end,0.05)
	end
	return _OnWaypoint[unit.networkID]
end

local GetPred = function(unit,speed,delay)
	local speed = speed or math.huge
	local delay = delay or 0.25
	local unitSpeed = unit.ms
	if OnWaypoint(unit).speed > unitSpeed then unitSpeed = OnWaypoint(unit).speed end
	if OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unitPos)/speed)))
		if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unit.pos)/speed)))
			if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
			return predPos
		elseif IsImmobileTarget(unit) then
			return unit.pos
		else
			return unit:GetPrediction(speed,delay)
		end
	end
end

local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local CastSpell = function(spell,pos,range,delay)
local range = range or math.huge
local delay = delay or 250
local ticker = GetTickCount()

	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() and pos:ToScreen().onScreen then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			Control.SetCursorPos(pos)
				Control.KeyDown(spell)
				Control.KeyUp(spell)
				castSpell.casting = ticker + delay
				DelayAction(function()
					if castSpell.state == 1 then
						Control.SetCursorPos(castSpell.mouse)
						castSpell.state = 0
					end
				end,Game.Latency()/1000)
		end
		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

class "Anivia"

function Anivia:__init()
	self:Menu()
	self:Spells()
	
	self.QObject = { isValid = false, GameObject = nil }
	self.RObject = { isValid = false, Position = nil, isMaxed = false }
	self.LastSlot = nil
	
	Alpha.ObjectManager:OnMissileCreate(function(missile) 
		if missile.valid and missile.name == "FlashFrostSpell" and missile.data.missileData.owner == myHero.handle then
			self.QObject.isValid = true
			self.QObject.GameObject = missile.data
		end
	end)
	Alpha.ObjectManager:OnMissileDestroy(function(missile) 
		if missile.name == "FlashFrostSpell" and missile.data.missileData.owner == myHero.handle then
			self.QObject.isValid = false
			self.QObject.GameObject = nil
		end
	end)
	
	_G.Alpha.ObjectManager:OnParticleCreate(function(particle) 
		if particle.valid then
			if particle.name:lower():find("anivia") and particle.name:lower():find("aoe_green") then
				self.RObject.isValid = true
				self.RObject.Position = particle.pos
				self.LastSlot = _R
			end
			if particle.name:lower():find("anivia") and particle.name:lower():find("full") then
				self.R.Width = 400
				self.R.isMaxed = true
			end
		end
	end)

	_G.Alpha.ObjectManager:OnParticleDestroy(function(particle)
		if particle.name:lower():find("anivia") and particle.name:lower():find("aoe_green") then
			self.RObject.isValid = false
			self.RObject.Position = nil
			self.R.Width = 200
			self.R.isMaxed = false
		end
	end)
	
	_G.Alpha.ObjectManager:OnSpellCast(function(spell)
		if spell.owner == myHero.networkID then
			if spell.name:lower() == "flashfrostspell" then
				self.LastSlot = _Q
			end
		end
	end)
	
	Callback.Add("Tick", function() 
		self:OnTick()
	end)
	
	Callback.Add("Draw", function()
		self:OnDraw()
	end)
end

function Anivia:Menu()
	local Icons = 
	{
		Pic = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/01/AniviaSquare.png",
		Q = "https://vignette.wikia.nocookie.net/leagueoflegends/images/4/49/Flash_Frost.png",
		W = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/28/Crystallize.png",
		E = "https://vignette.wikia.nocookie.net/leagueoflegends/images/e/ee/Frostbite.png",
		R = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/05/Glacial_Storm.png"
	}

	self.Menu = MenuElement({type = MENU, id = "main", name = "Anivia", leftIcon = Icons.Pic })
	
	self.Menu:MenuElement({ type = SPACE, name = "Rebirth of The Era", leftIcon = Icons.Pic })
	self.Menu:MenuElement({ type = SPACE })
	self.Menu:MenuElement({ type = MENU, id = "Combo", name = "Combo" })
	self.Menu.Combo:MenuElement({id = "UseQ", name = "Flash Frost", leftIcon = Icons.Q, value = true })
	self.Menu.Combo:MenuElement({ type = MENU, id = "ComboW", name = "Crystallize", leftIcon = Icons.W })
	self.Menu.Combo.ComboW:MenuElement({ id = "UseW", name = "Crystallize", leftIcon = Icons.W, value = true })
	self.Menu.Combo.ComboW:MenuElement({ id = "WMode", name = "Algorithm", leftIcon = Icons.W, drop = { "Push to Anivia", "Push Back", "Smart" }, value = 3 })
	self.Menu.Combo:MenuElement({ type = MENU, id = "ComboE", name = "Frostbite", leftIcon = Icons.E })
	self.Menu.Combo.ComboE:MenuElement({ id = "UseE", name = "Frostbite", leftIcon = Icons.E, value = true })
	self.Menu.Combo.ComboE:MenuElement({ id = "EMode", name = "Algorithm", leftIcon = Icons.E, drop = { "Always", "Fast", "Smart" }, value = 3 })
	self.Menu.Combo:MenuElement({id = "UseR", name = "Glacial Storm", leftIcon = Icons.R, value = true })
	self.Menu:MenuElement({ type = SPACE })
	self.Menu:MenuElement({ type = MENU, id = "Misc", name = "Misc" })
	self.Menu.Misc:MenuElement({id = "DrawQ", name = "Draw Flash Frost", leftIcon = Icons.Q, value = true })
	self.Menu.Misc:MenuElement({id = "DrawE", name = "Draw Frostbite", leftIcon = Icons.E, value = true })
	self.Menu.Misc:MenuElement({id = "DrawR", name = "Draw Glacial Storm", leftIcon = Icons.R, value = true })
	
	self.Menu:MenuElement({ type = SPACE })
	self.Menu:MenuElement({ type = SPACE, name = "Developer: Kiara789" })
	self.Menu:MenuElement({ type = SPACE, name = "League: 8.9" })
	self.Menu:MenuElement({ type = SPACE, name = "Update 2" })
end

function Anivia:Spells()
	self.Q = { Range = 1075, Delay = 250, Speed = 850, Width = 125, Width2 = 225 }
	self.W = { Range = 1000, Delay = 250, Width = self:GetWallLength() }
	self.E = { Range = 650, Delay = 250, Speed = 1600 }
	self.R = { Range = 750, Delay = 250, Speed = MathHuge, Width = 200, WidthMax = 400 }
end

function Anivia:GetWallLength()
	local data = myHero:GetSpellData(_W)
	
	if data.level == 0 then
		return 0
	end
	
	local lengths = { 400, 500, 600, 700, 800 }
	return lengths[data.level]
end

function Anivia:IsInQ2(unit)
	if unit == nil then
		return false
	end
	
	if self.QObject.isValid == false then
		return false
	end
	
	if GetDistance(self.QObject.GameObject.pos, unit.pos) <= self.Q.Width2 + 30 then
		return true
	end
end

function Anivia:GetEnemiesQ2()
	local t = {}
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.valid and not hero.dead and hero.isEnemy and hero.visible and hero.isTargetable and GetDistance(self.QObject.GameObject.pos, hero.pos) <= self.Q.Width2 then
			table.insert(t, hero)
		end
	end
	return nil
end

function Anivia:CastQ(target)
	if not self.Menu.Combo.UseQ:Value() then
		return
	end

	if not IsReady(_Q) or target == nil then
		return
	end
	
	if myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.isChanneling or myHero.activeSpell.isAutoAttack then
		return
	end
	
	if myHero:GetSpellData(_Q).toggleState == 1 then
		if IsFacing(target, myHero) then
			CastSpell(HK_Q, target.pos, self.Q.Range)
		end
	
		--local hitchance, castpos = HPred:GetHitchance(myHero.pos, target, self.Q.Range, self.Q.Delay, self.Q.Speed, self.Q.Width, false)
		local castpos = GetPred(target, self.Q.Speed, self.Q.Delay)
	
		--if hitchance and castpos and hitchance > 0 and GetDistance(target.pos, castpos) <= 400 then
		if castpos and GetDistance(castpos, myHero.pos) < self.Q.Range then
			if castpos:To2D().onScreen then
				CastSpell(HK_Q, castpos, self.Q.Range)
			else
				return
			end
		end
	elseif myHero:GetSpellData(_Q).toggleState == 2 then
		if self:IsInQ2(target) then
			Control.CastSpell(HK_Q)
		end
	end
end

function Anivia:CastW(target)
	if not self.Menu.Combo.ComboW.UseW:Value() then
		return
	end

	if not IsReady(_W) or target == nil  or (IsReady(_Q) and self.QObject.isValid) then
		return
	end
	
	if myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.isChanneling or myHero.activeSpell.isAutoAttack then
		return
	end
	
	local pHP = (myHero.health/myHero.maxHealth) * 100
	local pHPt = (target.health/target.maxHealth) * 100
	
	local dir = Vector(target.pos - myHero.pos)
	local offset = 0
	
	if self.Menu.Combo.ComboW.WMode:Value() == 1 then
		offset = 200
	elseif self.Menu.Combo.ComboW.WMode:Value() == 2 then
		offset = 200 * (-1)
	elseif self.Menu.Combo.ComboW.WMode:Value() == 3 then
		if pHP > pHPt and not (GetDistance(target.pathing.endPos, myHero.pos) <= target.range) then
			offset = 200
		else 
			offset = 200 * (-1)
		end
	end
	
	local endPos = dir:Normalized() * offset
	local finalPos = (target.pos + target.dir) + endPos
	local angle = AngleBetween(myHero.dir, target.pos - myHero.pos)
	
	if GetDistance(myHero.pos, target.pos) <= self.W.Range and GetDistance(myHero.pos, target.pos) >= 450 and not (angle > 170 and angle <= 180) then
		CastSpell(HK_W, finalPos, self.W.Range)
	end
end

function Anivia:IsChilled(target)
	if target == nil then
		return false
	end

	for i = 0, target.buffCount do
		local b = target:GetBuff(i)
		if b and b.name == "chilled" and b.count > 0 and b.duration > 0 then
			return true
		end
	end
	return false
end

function Anivia:IsSmartChilled(target)
	if target == nil then
		return false
	end
	
	for i = 0, target.buffCount do
		local b = target:GetBuff(i)
		local _time = GetDistance(target.pos, myHero.pos) / (self.E.Speed + self.E.Delay)
		if b and b.name == "chilled" and b.count > 0 and b.duration > _time then
			return true
		end
	end
	return false
end

function Anivia:CastE(target)
	if not self.Menu.Combo.ComboE.UseE:Value() then
		return
	end

	if not IsReady(_E) or target == nil then
		return
	end
	
	if myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.isChanneling or myHero.activeSpell.isAutoAttack then
		return
	end
	
	if GetDistance(target.pos, myHero.pos) <= self.E.Range then
		if self.Menu.Combo.ComboE.EMode:Value() == 1 then
			Control.CastSpell(HK_E, target)
		elseif self.Menu.Combo.ComboE.EMode:Value() == 2 then
			if GetData(_Q).level == 0 and GetData(_R).level == 0 and GetData(_E).level > 0 then
				Control.CastSpell(HK_E, target)
			end
			if GetData(_Q).level > 0 and GetData(_R).level == 0 and GetData(_E).level > 0 then
				if self:IsChilled(target) then
					Control.CastSpell(HK_E, target)
				elseif self:IsChilled(target) == false and (myHero:GetSpellData(_Q).currentCd >= 1.5 and IsReady(_Q) == false and self.QObject.isValid == false) then
					Control.CastSpell(HK_E, target)
				end
			end
			if GetData(_Q).level > 0 and GetData(_R).level > 0 and GetData(_E).level > 0 then
				if self:IsChilled(target) and (self.LastSlot == _Q or (self.LastSlot == _R and self.R.isMaxed)) then
					Control.CastSpell(HK_E, target)
				elseif self:IsChilled(target) == false and (myHero:GetSpellData(_Q).currentCd >= 1.5 and IsReady(_Q) == false) and self.QObject.isValid == false and myHero:GetSpellData(_R).currentCd >= 2 then
					Control.CastSpell(HK_E, target)
				end
			end
		elseif self.Menu.Combo.ComboE.EMode:Value() == 3 then
			if GetData(_Q).level == 0 and GetData(_R).level == 0 and GetData(_E).level > 0 then
				Control.CastSpell(HK_E, target)
			end
			if GetData(_Q).level > 0 and GetData(_R).level == 0 and GetData(_E).level > 0 then
				if self:IsSmartChilled(target) then
					Control.CastSpell(HK_E, target)
				elseif self:IsSmartChilled(target) == false and (myHero:GetSpellData(_Q).currentCd >= 1.5 and IsReady(_Q) == false and self.QObject.isValid == false) then
					Control.CastSpell(HK_E, target)
				end
			end
			if GetData(_Q).level > 0 and GetData(_R).level > 0 and GetData(_E).level > 0 then
				if self:IsSmartChilled(target) and (self.LastSlot == _Q or (self.LastSlot == _R and self.R.isMaxed)) then
					Control.CastSpell(HK_E, target)
				elseif self:IsSmartChilled(target) == false and (myHero:GetSpellData(_Q).currentCd >= 1.5 and IsReady(_Q) == false) and self.QObject.isValid == false and myHero:GetSpellData(_R).currentCd >= 2 then
					Control.CastSpell(HK_E, target)
				end
			end
		end
	end
end

function Anivia:IsInStorm(target)
	if not self.RObject.isValid or target == nil then
		return false
	end
	
	return GetDistance(target.pos, self.RObject.Position) <= self.R.Width
end

function Anivia:GetHeroesInStorm()
	if not self.RObject.isValid then
		return nil
	end
	
	local t = {}
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.valid and not hero.dead and hero.isEnemy and hero.visible and GetDistance(self.RObject.Position, hero.pos) <= self.R.Width + 150 then
			table.insert(t, hero)
		end
		if i == Game.HeroCount() then
			return t
		end
	end
	return nil
end

function Anivia:GetMinionsInStorm()
	if not self.RObject.isValid then
		return nil
	end

	local t = {}
	for i = 0, Game.MinionCount() do
		local m = Game.Minion(i)
		if m and m.valid and not m.dead and m.isEnemy and m.visible and GetDistance(self.RObject.Position, m.pos) <= self.R.Width + 150 then
			table.insert(t, m)
		end
		if i == Game.MinionCount() then
			return t
		end
	end
	return nil
end

function Anivia:CastR(target)
	if not self.Menu.Combo.UseR:Value() then
		return
	end
	
	if not IsReady(_R) or target == nil then
		return
	end
	
	if myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.isChanneling or myHero.activeSpell.isAutoAttack then
		return
	end
	
	if GetDistance(target.pos, myHero.pos) <= self.R.Range then
		local data = myHero:GetSpellData(_R)
		
		if data.toggleState == 1 then
			CastSpell(HK_R, target.pos, self.R.Range, 0)
		elseif data.toggleState == 2 then
			if not self:IsInStorm(target) then
				Control.CastSpell(HK_R)
			end
		end
	end
end

function Anivia:Combo()
	if self:GetHeroesInStorm() ~= nil and #self:GetHeroesInStorm() == 0 and myHero:GetSpellData(_R).toggleState == 2 then
		Control.CastSpell(HK_R)
	end

	local target = TS:GetTarget(self.Q.Range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	
	if target ~= nil then
		if target.isImmortal then
			self:CastW()
			self:CastQ()
		else
			self:CastQ(target)
			self:CastE(target)
			self:CastR(target)
			self:CastW(target)
		end
	end
end

function Anivia:OnDraw()
	if IsReady(_Q) and self.Menu.Misc.DrawQ:Value() then
		Draw.Circle(myHero.pos, self.Q.Range, Draw.Color(255, 255, 255, 255))
	end
	if IsReady(_E) and self.Menu.Misc.DrawE:Value() then
		Draw.Circle(myHero.pos, self.E.Range, Draw.Color(255, 255, 255, 255))
	end
	if IsReady(_R) and self.Menu.Misc.DrawR:Value() then
		Draw.Circle(myHero.pos, self.R.Range, Draw.Color(255, 174, 237, 255))
	end
end

function Anivia:OnTick()
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
		self:Combo()
	end
end

Callback.Add("Load", function() Anivia() end)
