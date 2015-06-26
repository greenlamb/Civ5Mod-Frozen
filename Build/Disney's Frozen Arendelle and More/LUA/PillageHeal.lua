-- Code modified from bouncymischa: http://forums.civfanatics.com/showthread.php?t=527700


function CheckPillageHealButtonValidity(pPlayer, pUnit)
	local iCurrentCulture = pPlayer:GetJONSCulture();
	local pImprovement = pUnit:GetPlot():GetImprovementType();

	if (iCurrentCulture > 50) and (pImprovement == GameInfo.Improvements.IMPROVEMENT_FARM.ID) then
		return true;
	end
	return false;
end

local PillageHealMissionButton = {
  Name = "PillageHealMissionButton",
  Title = "Finish Each Other's Sandwiches",
  OrderPriority = 200,
  IconAtlas = "CIV_COLOR_ATLAS_FROZEN",
  PortraitIndex = 8,
  
  ToolTip = function(action, unit)
		local sTooltip;
		local pPlayer = Players[Game:GetActivePlayer()];
		local bIsValid = CheckPillageHealButtonValidity(pPlayer, unit);
		if bIsValid then
			sTooltip = "Hans will pillage farms to regain health and +10 food in the nearest city."
		else
			sTooltip = "Can only be used when you have more than 50 culture, on a farm, and have at least 1 city."
		end
		return sTooltip
  end, -- or a TXT_KEY_ or a function
  
  Condition = function(action, unit)
		if unit:GetMoves() <= 0 then
			return false
		end
		if (unit:GetUnitType() == GameInfoTypes["UNIT_HERO_HANS"]) then
			return true
		else
			return false
		end
  end, -- or nil or a boolean, default is true
  Disabled = function(action, unit)
  		local pPlayer = Players[Game:GetActivePlayer()];
		local bIsValid = CheckPillageHealButtonValidity(pPlayer, unit);
		if bIsValid then
			return false
		end
		return true;
  end, -- or nil or a boolean, default is false

  Action = function(action, unit, eClick)
	if eClick == Mouse.eRClick then
		return
	end
    local pPlayer = Players[Game:GetActivePlayer()];


	local iDistance = 99999
	local pTargetCity = nil
	for pCity in pPlayer:Cities() do
		if iDistance > Map.PlotDistance(unit:GetX(), unit:GetY(), pCity:GetX(), pCity:GetY()) then
			pTargetCity = pCity
			iDistance = Map.PlotDistance(unit:GetX(), unit:GetY(), pCity:GetX(), pCity:GetY())
		end
	end
	
	if pTargetCity == nil then
		return
	end

	if pPlayer:IsHuman() then
		pPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, "Hans finished someone else's sandwich." ,"Hans pillaged a farm, and added food to "..pTargetCity:GetName().."!", -1, -1);
	end

	pTargetCity:ChangeFood(10);
	unit:GetPlot():SetImprovementPillaged(true);
	unit:ChangeDamage(-999,pPlayer);

	pPlayer:ChangeJONSCulture(-50);
  end,
}

LuaEvents.UnitPanelActionAddin(PillageHealMissionButton)