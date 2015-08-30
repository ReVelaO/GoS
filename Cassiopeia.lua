require('Dlib')

local root = menu.addItem(SubMenu.new("DarkCassio"))
local Combo = root.addItem(SubMenu.new("Combo"))
	local QU = Combo.addItem(MenuBool.new("Use Q",true))
	local WU = Combo.addItem(MenuBool.new("Use W",true))
	local EU = Combo.addItem(MenuBool.new("Use E",true))
	local RU = Combo.addItem(MenuBool.new("Use R",true))
	local sl = Combo.addItem(MenuSlider.new("Min. Enemy for R", 1, 1, 5, 1))
	local Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))

do
  _G.objectManager = {}
  objectManager.maxObjects = 0
  objectManager.objects = {}
  objectManager.heroes = {}
  OnObjectLoop(function(object, myHero)
    objectManager.objects[GetNetworkID(object)] = object
  end)
  OnLoop(function(myHero)
    objectManager.maxObjects = 0
    for _, obj in pairs(objectManager.objects) do
      objectManager.maxObjects = objectManager.maxObjects + 1
      local type = GetObjectType(obj)
      if type == Obj_AI_Hero then
        objectManager.heroes[_] = obj
      else
        local objName = GetObjectBaseName(obj)
      end
    end
  end)
end
	
OnLoop(function(myHero)


if Comb.getValue() then 
	local myHeroPos = GetOrigin(myHero)
	local target = GetCurrentTarget()	
	if ValidTarget(target, 2000) then
		local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),850,75,GetCastRange(myHero,_Q),55,false,true)		
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and QU.getValue() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end                    	
				
		local WPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),850,125,GetCastRange(myHero,_W),55,false,true)		
		if CanUseSpell(myHero, _W) == READY and QPred.HitChance == 1 and WU.getValue() then
			CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)						
			end

		local poisoned = false
		for i=0, 63 do
			if GetBuffCount(target,i) > 0 and GetBuffName(target,i):lower():find("poison") then
				poisoned = true
			end
		end
		if CanUseSpell(myHero, _E) == READY and poisoned and EU.getValue() then
			CastTargetSpell(target, _E)
			end
		
		local RPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),math.huge,550,800,180,false,true)	-- Do u know Kappa	
		if CanUseSpell(myHero, _R) == READY and EnemiesAround(GetMyHeroPos(), 800) >= 1 and RPred.HitChance == 1 and RU.getValue() and sl.getValue(1) then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		elseif CanUseSpell(myHero, _R) == READY and EnemiesAround(GetMyHeroPos(), 800) >= 2 and RPred.HitChance == 1 and RU.getValue() and sl.getValue(2) then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		elseif CanUseSpell(myHero, _R) == READY and EnemiesAround(GetMyHeroPos(), 800) >= 3 and RPred.HitChance == 1 and RU.getValue() and sl.getValue(3) then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
		elseif CanUseSpell(myHero, _R) == READY and EnemiesAround(GetMyHeroPos(), 800) >= 4 and RPred.HitChance == 1 and RU.getValue() and sl.getValue(4) then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)	
		elseif CanUseSpell(myHero, _R) == READY and EnemiesAround(GetMyHeroPos(), 800) == 5 and RPred.HitChance == 1 and RU.getValue() and sl.getValue(5) then
			CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)				
			end 
		end
	end
end)

function CalcDamage(source, target, addmg, apdmg)
    local ADDmg = addmg or 0
    local APDmg = apdmg or 0
    local ArmorPen = math.floor(GetArmorPenFlat(source))
    local ArmorPenPercent = math.floor(GetArmorPenPercent(source)*100)/100
    local Armor = GetArmor(target)*ArmorPenPercent-ArmorPen
    local ArmorPercent = Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicPen = math.floor(GetMagicPenFlat(source))
    local MagicPenPercent = math.floor(GetMagicPenPercent(source)*100)/100
    local MagicArmor = GetMagicResist(target)*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100
    return (GotBuff(source,"exhausted")  > 0 and 0.4 or 1) * math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))
end

function GetEnemyHeroes()
  local result = {}
  for _, obj in pairs(objectManager.heroes) do
    if GetTeam(obj) ~= GetTeam(GetMyHero()) then
      table.insert(result, obj)
    end
  end
  return result
end

function ValidTarget(unit, range)
    range = range or 25000
    if unit == nil or GetOrigin(unit) == nil or not IsTargetable(unit) or IsDead(unit) or not IsVisible(unit) or GetTeam(unit) == GetTeam(GetMyHero()) or not IsInDistance(unit, range) then return false end
    return true
end

function IsInDistance(p1,r)
    return GetDistanceSqr(GetOrigin(p1)) < r*r
end

function GetDistanceSqr(p1,p2)
    p2 = p2 or GetMyHeroPos()
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

function GetMyHeroPos()
    return GetOrigin(GetMyHero()) 
end

function EnemiesAround(pos, range)
    local c = 0
    if pos == nil then return 0 end
    for k,v in pairs(GetEnemyHeroes()) do 
        if v and ValidTarget(v) and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
            c = c + 1
        end
    end
    return c
end
