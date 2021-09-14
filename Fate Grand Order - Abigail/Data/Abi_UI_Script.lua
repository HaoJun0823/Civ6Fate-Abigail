-- Abi_UI_Script
-- Author: HaoJun0823
-- DateCreated: 6/25/2021 6:37:33 PM
--------------------------------------------------------------
include( "InstanceManager");
include("PopupDialog");
print("Abigail UI Script Activated!");

local m_kPopupDialog = PopupDialog:new( "AbiPopupDialog" )

function callbackPopup()
	m_kPopupDialog:Close();
	UIManager:DequeuePopup(ContextPtr);
end

function showDialog(text)
	local str = Locale.Lookup(text);
	m_kPopupDialog:Close();
	m_kPopupDialog:Reset();
	m_kPopupDialog:ShowOkDialog(str, function() callbackPopup(); end);
	m_kPopupDialog:Open();
	UIManager:QueuePopup( ContextPtr, PopupPriority.Utmost );
end

function Abigail()
	print("Abigail UI:Do Turn Start Event.");
	local turn = Game.GetCurrentGameTurn();
	if turn % 7 ~= 0 then
	print("Abigail UI:Not This Turn.");
	--myRandom();
	else
		local mul = (turn / 49) + 1;
		print("Abigail UI:This Turn!");
		checkPlayer(mul);
	end
end


function trait1(mul,playerId) --金币信仰
	
	showDialog("LOC_ABIGAIL_TRAIT_1");
	print("Abigail:Trait1 UI Done.");	

end

function trait2(mul,playerId) --文化科研

	showDialog("LOC_ABIGAIL_TRAIT_2");
	print("Abigail:Trait2 UI Done.");	

end

function trait3(mul,playerId) --伟人点数

	showDialog("LOC_ABIGAIL_TRAIT_3");
	print("Abigail:Trait3 UI Done.");	

end

function trait4(mul,playerId) --加影响力和时代得分

	showDialog("LOC_ABIGAIL_TRAIT_4");
	print("Abigail:Trait4 UI Done.");	
	
end

function trait5(mul,playerId) --战斗单位经验值

	showDialog("LOC_ABIGAIL_TRAIT_5");
	print("Abigail:Trait5 UI Done.");	
	
end

function trait6(mul,playerId) --战略资源

	showDialog("LOC_ABIGAIL_TRAIT_6");
	print("Abigail:Trait6 UI Done.");	

end

function trait7(mul,playerId) --城市人口 目前只有锤子了

	showDialog("LOC_ABIGAIL_TRAIT_7");
	print("Abigail:Trait7 UI Done.");	
	
end


function myRandom()

	local playerIDS = PlayerManager.GetAliveIDs();
	local turn = Game.GetCurrentGameTurn();
	local result = 0;
	
	for i, playerId in ipairs(playerIDS) do
		local pPlayer = Players[playerId];
		local playerConfig = PlayerConfigurations[playerId];		
		if pPlayer:IsMajor() and pPlayer:IsAlive() then
			for i, pCity in pPlayer:GetCities():Members() do
				if turn % 2 ~= 0 then
					result = result + pCity:GetGrowth():GetTurnsUntilGrowth();
					result = result - pCity:GetGrowth():GetHappiness();
					result = result + pCity:GetGrowth():GetFoodSurplus();
					result = result - pCity:GetGrowth():GetHousing();					
				else
					result = result - pCity:GetGrowth():GetTurnsUntilGrowth();
					result = result + pCity:GetGrowth():GetHappiness();
					result = result - pCity:GetGrowth():GetFoodSurplus();
					result = result + pCity:GetGrowth():GetHousing();					
				end
			end
		end
	end
	print("Abigail UI:Random Result Seed:"..result);	
	return math.floor(math.abs((result % 7) + 1));

end

function myTrait(playerId,mul)

	local result = myRandom();
	print("Abigail:Random UI Result:"..result);	
	if result == 1 then
		trait1(mul,playerId);
		return ;
	end

	if result == 2 then
		trait2(mul,playerId);
		return ;
	end
	
	if result == 3 then
		trait3(mul,playerId);
		return ;
	end
	
	if result == 4 then
		trait4(mul,playerId);
		return ;
	end
	
	if result == 5 then
		trait5(mul,playerId);
		return ;
	end
	
	if result == 6 then
		trait6(mul,playerId);
		return ;
	end
	
	if result == 7 then
		trait7(mul,playerId);
		return ;
	end

end


function checkPlayer(mul)

	local playerIDS = PlayerManager.GetAliveIDs();
	
	for i, playerId in ipairs(playerIDS) do
		local pPlayer = Players[playerId];
		local playerConfig = PlayerConfigurations[playerId];		
		if pPlayer:IsMajor() and pPlayer:IsAlive() and playerConfig:GetLeaderTypeName() == "LEADER_ABIGAIL" then
			myTrait(playerId,mul);
		end
	end

end

function init() -- I can write this to optimize the event.

	
  print("Initialization event loading.")

  local localPlayerID:number = Game.GetLocalPlayer();
  local playerConfig:table = PlayerConfigurations[localPlayerID]
  local leaderName = playerConfig:GetLeaderTypeName()
 
	-- 2019/02/16 Maybe need stop for all players.
	-- OLD CODE
 	--Events.LeaveGameComplete.Add(OnUIExitGame);
	--Events.PlayerDefeat.Add(OnPlayerDefeatStopMusic);
	--Events.TeamVictory.Add(OnTeamVictoryStopMusic);
	--LuaEvents.RestartGame.Add(OnUIExitGame);

  if leaderName == "LEADER_ABIGAIL"  then -- Consistent with the above variables
	-- There are local machine things.

	Events.TurnBegin.Add( Abigail );
	print(leaderName.." is local player, add UI event finished!")	
	else
	print(leaderName.." not local player, don't need add UI event!")
	
	--LuaEvents.DiplomacyActionView_ShowIngameUI.Add(DiplomacyActionView_ShowIngameUI_OtherPlayer);
	--LuaEvents.DiplomacyRibbon_OpenDiplomacyActionView.Add(OnOpenDiplomacyActionView_OtherPlayer);

  end

	


	--print("Abigail UI Event loaded.")
end

init()