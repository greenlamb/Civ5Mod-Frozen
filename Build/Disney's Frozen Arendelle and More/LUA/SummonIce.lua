-- Code modified from bouncymischa: http://forums.civfanatics.com/showthread.php?t=527700


function CheckElsaSummonButtonValidity(pPlayer, pUnit)
	local iCurrentCulture = pPlayer:GetJONSCulture();
	if (iCurrentCulture > 50 and pUnit:GetPlot():IsWater()) then
		return true;
	end
	return false;
end

local ElsaSummonMissionButton = {
  Name = "ElsaSummonMissionButton",
  Title = "Summon Iceberg",
  OrderPriority = 200,
  IconAtlas = "CIV_COLOR_ATLAS_FROZEN",
  PortraitIndex = 0,
  
  ToolTip = function(action, unit)
		local sTooltip;
		local pPlayer = Players[Game:GetActivePlayer()];
		local bIsValid = CheckElsaSummonButtonValidity(pPlayer, unit);
		if bIsValid then
			sTooltip = "This summons icebergs on water/ocean tiles at a cost of 50 culture, which would allow land unit to move on top of it without embarking, while blocking ship movements. Icebergs can be disbanded or attacked by enemies."
		else
			sTooltip = "Can only be used when you have more than 50 culture and on water/ocean tiles."
		end
		return sTooltip
  end, -- or a TXT_KEY_ or a function
  
  Condition = function(action, unit)
		if unit:GetMoves() <= 0 then
			return false
		end
		if (unit:GetUnitType() == GameInfoTypes["UNIT_HERO_ELSA"]) then
			return true
		else
			return false
		end
  end, -- or nil or a boolean, default is true
  Disabled = function(action, unit)
  		local pPlayer = Players[Game:GetActivePlayer()];
		local bIsValid = CheckElsaSummonButtonValidity(pPlayer, unit);
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

	print("Summoning an iceberg.")

	if pPlayer:IsHuman() then
		pPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, "Iceberg created." ,"Elsa has created an iceberg!", -1, -1);
	end

--	unit:SetEmbarked(false);
--	unit:GetPlot():SetImprovementType(GameInfo.Improvements["IMPROVEMENT_ICEBERG"].ID);

	local iSummonUnitID = GameInfo.Units.UNIT_SUMMON_ICE.ID
	summon = pPlayer:InitUnit (iSummonUnitID, unit:GetX(), unit:GetY() );

	summon:PopMission();
	summon:PushMission(MissionTypes.MISSION_SLEEP, 0, 0, 0, 0, 1, MissionTypes.MISSION_SLEEP, summon:GetPlot(), summon);

	unit:ChangeMoves(-1 * GameDefines.MOVE_DENOMINATOR);
	pPlayer:ChangeJONSCulture(-50);
  end,
}

LuaEvents.UnitPanelActionAddin(ElsaSummonMissionButton)