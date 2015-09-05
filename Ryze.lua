require('DLib')
require('IAC')

local root = menu.addItem(SubMenu.new("DarkRyze"))
local Combo = root.addItem(SubMenu.new("Combo"))
	local QU = Combo.addItem(MenuBool.new("Use Q",true))
	local WU = Combo.addItem(MenuBool.new("Use W",true))
	local EU = Combo.addItem(MenuBool.new("Use E",true))
	local RU = Combo.addItem(MenuBool.new("Use R",true))
	local RRU = Combo.addItem(MenuBool.new("Use R if rooted",true))
	local Comb = Combo.addItem(MenuKeyBind.new("Combo", 32))
	
local Farm = root.addItem(SubMenu.new("Farm"))
	local LaneClear = Farm.addItem(SubMenu.new("Lane Clear"))
	local useQ = LaneClear.addItem(MenuBool.new("Use Q",true))
	local useW = LaneClear.addItem(MenuBool.new("Use W",true))
	local useE = LaneClear.addItem(MenuBool.new("Use E",true))
	local useR = LaneClear.addItem(MenuBool.new("Use R",true))
	local LClear = LaneClear.addItem(MenuKeyBind.new("Lane Clear", 86))
	
DelayAction(function () -- Do u know who made it... (ILS)
        for _, imenu in pairs(menuTable) do
                local submenu = menu.addItem(SubMenu.new(imenu.name))
                for _,subImenu in pairs(imenu) do
                        if subImenu.type == SCRIPT_PARAM_ONOFF then
                                local ChangeMenu = submenu.addItem(MenuBool.new(subImenu.t, subImenu.value))
                                OnLoop(function(myHero) subImenu.value = ChangeMenu.getValue() end)
                        elseif subImenu.type == SCRIPT_PARAM_KEYDOWN then
                                local ChangeMenu = submenu.addItem(MenuKeyBind.new(subImenu.t, subImenu.key))
                                OnLoop(function(myHero) subImenu.key = ChangeMenu.getValue(true) end)
                        elseif subImenu.type == SCRIPT_PARAM_INFO then
                                submenu.addItem(MenuSeparator.new(subImenu.t))
                        end
                end
        end
        _G.DrawMenu = function ( ... )  end
end, 1000)
	
--Updated 5.17.               
local Pasiva = "ryzepassivecharged"

OnLoop(function(myHero)
if Comb.getValue() then 
	DoCombo()
	end

if LClear.getValue() then
	LaneClear()
	end	
end)


function DoCombo()
if Comb.getValue() then 
	local myHeroPos = GetOrigin(myHero)
	local target = GetCurrentTarget()
	if ValidTarget(target, 900) then					
		if CanUseSpell(myHero, _W) == READY and WU.getValue() then
			CastTargetSpell(target, _W)
			end                     	
		
		local QPred = GetPredictionForPlayer(GetMyHeroPos(),target,GetMoveSpeed(target),900,250,GetCastRange(myHero,_Q),55,false,true)		
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and QU.getValue() then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)						
			end

		if CanUseSpell(myHero, _E) == READY and EU.getValue() then
			CastTargetSpell(target, _E)
			end

		if CanUseSpell(myHero, _R) == READY and RU.getValue() and (GotBuff(myHero, "ryzepassivecharged") > 0) then
			CastSpell(_R)
		elseif CanUseSpell(myHero, _R) == READY and RRU.getValue() and (GotBuff(myHero, "ryzepassivecharged") > 0) and (GotBuff(target , "RyzeW") == 1) then
			CastSpell(_R)
			end
		end
	end
end

function LaneClear()
if LClear.getValue() then      
                for i,minion in pairs(GetAllMinions(MINION_ENEMY)) do    
                        if IsInDistance(minion, 600) then
                        local PMinion = GetOrigin(minion)
						if CanUseSpell(myHero, _W) == READY and useW.getValue() then
						CastTargetSpell(minion, _W)
						end
						
						if CanUseSpell(myHero, _Q) == READY  and useQ.getValue() then
						CastSkillShot(_Q,PMinion.x,PMinion.y,PMinion.z)
						end		
						
						if CanUseSpell(myHero, _E) == READY and useE.getValue() then
						CastTargetSpell(minion, _E)
						end 		
             
						if CanUseSpell(myHero, _R) == READY and useR.getValue() and (GotBuff(myHero, "ryzepassivecharged") > 0) then
						CastSpell(_R)			 
						end
          end
       end
    end    
end

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
