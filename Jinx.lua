if myHero.charName ~= 'Jinx' then return end

local _PLAYER; _PLAYER = myHero
local SPELL_DELAY; SPELL_DELAY = function (delay) return delay + Game.Latency()*0.001 end
local SPELL_READY; SPELL_READY = function (slot) return _PLAYER:GetSpellData(slot).currentCd == 0 and _PLAYER:GetSpellData(slot).level > 0 and _PLAYER:GetSpellData(slot).mana < _PLAYER.mana end
local NEAR_TO; NEAR_TO = function(unit, to, range) return _G.SDK.Utilities:IsInRange(to, unit, range) end
local MINIMUM_RANGE; MINIMUM_RANGE = function (unit, to, min, max) return not _G.SDK.Utilities:IsInRange(to, unit, min) and _G.SDK.Utilities:IsInRange(to, unit, max) end
local GOT_BUFF; GOT_BUFF = function (name) return _G.SDK.BuffManager:HasBuff(name) end
local DRAW_COLOR; DRAW_COLOR = {LIGHT_GREEN = Draw.Color(255, 144, 238, 144), LIGHT_RED = Draw.Color(255, 238, 145, 148), LIGHT_BLUE = Draw.Color(255, 145, 161, 238)}
local DRAW_CIRCLE; DRAW_CIRCLE = function (origen, range, width, color) return Draw.Circle(origen.pos, range, width, color) end

Callback.Add('Load', function() Jinx() end)

class 'Jinx'

function Jinx:__init()
  self:GetMenu()
  self:GetSpellsData()
  Callback.Add('Tick', function() self:OnTick() end)
  Callback.Add('Draw', function() self:OnDraw() end)
end

function Jinx:GetMenu()
  self.Menu = MenuElement({type = MENU, id = 'menuId', name = 'Trix | Jinx'})

  self.Menu:MenuElement({type = MENU, id = 'combo', name = 'Combo'})
  self.Menu.combo:MenuElement({id = 'q', name = 'Switch Q', value = true})
  self.Menu.combo:MenuElement({id = 'w', name = 'Zap!', value = true})
  self.Menu.combo:MenuElement({id = 'r', name = 'Death Rocket', value = true})

  self.Menu:MenuElement({type = MENU, id = 'lasthit', name = 'LastHit'})
  self.Menu.lasthit:MenuElement({id = 'q', name = 'Try Minigun', value = true})

  self.Menu:MenuElement({type = MENU, id = 'draw', name = 'Drawings'})
  self.Menu.draw:MenuElement({id = 'aa', name = 'Draw AA', value = true})
  self.Menu.draw:MenuElement({id = 'w', name = 'Draw W', value = true})
  self.Menu.draw:MenuElement({id = 'e', name = 'Draw E', value = true})

  self.Menu:MenuElement({type = MENU, id = 'misc', name = 'Automated'})
  self.Menu.misc:MenuElement({id = 'autoe', name = "Auto E CC'd'", value = true})
end

function Jinx:GetSpellsData()
  self.W = {range = 1500, delay = SPELL_DELAY(0.6), speed = 3200, width = 60}
  self.E = {range = 900, delay = SPELL_DELAY(0.5), speed = 2500, width = 65}
  self.R = {range = 3000, delay = SPELL_DELAY(0.6), speed = 1700, width = 140}
end

function Jinx:GetAARange()
  local range = 0
  local const = 586
  if _PLAYER:GetSpellData(_Q).level == 0 then
    range = const
  end
  if GOT_BUFF('JinxQ') then
    local bonusRange = {75, 100, 125, 150, 175}
    local array = (bonusRange)[_PLAYER:GetSpellData(_Q).level]
    range = const + array
  else
    range = const
  end
  return range
end

function Jinx:GetFishRange()
  if _PLAYER:GetSpellData(_Q).level == 0 then
    return 586
  end
  local bonusRange = {75, 100, 125, 150, 175}
  local array = (bonusRange)[_PLAYER:GetSpellData(_Q).level]
  return 586 + array
end

function Jinx:GetRocketDamage(unit)
  if _PLAYER:GetSpellData(_R).level == 0 then
    return 0
  end
  if unit.pos:DistanceTo() < 1350 then
    local arrayMin = ({25, 35, 45})[_PLAYER:GetSpellData(_R).level]
    local arrayMinB = ({25, 30, 35})[_PLAYER:GetSpellData(_R).level]
    local bonusAdMin = 0.15 * _PLAYER.totalDamage
    return arrayMin + arrayMinB/100*(unit.maxHealth - unit.health) + bonusAdMin
  end
  local arrayMin = ({25, 35, 45})[_PLAYER:GetSpellData(_R).level]
  local arrayMax = ({250, 350, 450})[_PLAYER:GetSpellData(_R).level]
  local bonusAdMax = 1.5 * _PLAYER.totalDamage
  return arrayMax + arrayMin/100*(unit.maxHealth - unit.health) + bonusAdMax
end

function Jinx:OnDraw()
  if myHero.dead then return end
  if self.Menu.draw.aa:Value() then
    DRAW_CIRCLE(_PLAYER, self:GetAARange(), 2, DRAW_COLOR.LIGHT_GREEN)
  end
  if self.Menu.draw.w:Value() and SPELL_READY(_W) then
    DRAW_CIRCLE(_PLAYER, self.W.range, 2, DRAW_COLOR.LIGHT_RED)
  end
  if self.Menu.draw.e:Value() and SPELL_READY(_E) then
    DRAW_CIRCLE(_PLAYER, self.E.range, 2, DRAW_COLOR.LIGHT_RED)
  end
end

function Jinx:OnTick()
  if self.Menu.misc.autoe:Value() then
    self:AutoE()
  end
  if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
    self:Combo()
  end
  if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
    self:LastHit()
  end
end

function Jinx:Combo()
  local _TARGET = _G.SDK.TargetSelector:GetTarget(800, DAMAGE_TYPE_PHYSICAL)
  if _TARGET ~= nil and not _G.SDK.Utilities:HasUndyingBuff(_TARGET, false) then
    if SPELL_READY(_Q) and self.Menu.combo.q:Value() then
      if NEAR_TO(_TARGET, _PLAYER, 586) and GOT_BUFF('JinxQ') then
        _G.Control.CastSpell(HK_Q)
      elseif MINIMUM_RANGE(_TARGET, _PLAYER, 586, 761) and not GOT_BUFF('JinxQ') then
        _G.Control.CastSpell(HK_Q)
      end
    end
    if SPELL_READY(_W) and self.Menu.combo.w:Value() then
      _G.SDK.Orbwalker:OnPostAttack(function()
        if not _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then return end
        if _TARGET:GetCollision(self.W.width, self.W.speed, self.W.delay) == 0 then
          local castPos = _TARGET:GetPrediction(self.W.speed, self.W.delay)
          if castPos and MINIMUM_RANGE(_TARGET, _PLAYER, 586, self.W.range) and GOT_BUFF('JinxQ') then
            _G.Control.CastSpell(HK_W, castPos)
          end
        end
      end)
    end
    if SPELL_READY(_R) and self.Menu.combo.r:Value() then
      local castPos = _TARGET:GetPrediction(self.R.speed, self.R.delay)
      local rdmg = _G.SDK.Damage:CalculateDamage(_PLAYER, _TARGET, DAMAGE_TYPE_PHYSICAL, self:GetRocketDamage(_TARGET), true)
      if castPos and MINIMUM_RANGE(_TARGET, _PLAYER, 586, 2000) and _TARGET.health < rdmg then
        _G.Control.CastSpell(HK_R, castPos)
      end
    end
  end
end

function Jinx:LastHit()
  if not GOT_BUFF('JinxQ') then return end
  if self.Menu.lasthit.q:Value() then
    _G.Control.CastSpell(HK_Q)
  end
end

function Jinx:AutoE()
  for i, hero in ipairs(_G.SDK.ObjectManager:GetEnemyHeroes(900)) do
    if hero ~= nil then
      for i = 0, hero.buffCount do
        local b = hero:GetBuff(i)
        if b.count > 0 and b.type == 5 or b.type == 8 or b.type == 10 or b.type == 21 or b.type == 22 or b.type == 24 or b.type == 29 then
          if SPELL_READY(_E) then
            local pPos = hero:GetPrediction(self.E.speed, self.E.delay)
            if pPos and NEAR_TO(hero, _PLAYER, self.E.range) then
              _G.Control.CastSpell(HK_E, pPos)
            end
          end
        end
      end
    end
  end
end
