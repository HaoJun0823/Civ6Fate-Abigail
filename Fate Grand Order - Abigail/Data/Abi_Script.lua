-- Abi_Script
-- Author: HaoJun0823
-- DateCreated: 3/27/2021 1:14:36 PM
--------------------------------------------------------------
print("Abigail Script Activated!");

function Abigail()
	print("Abigail:Do Turn Start Event.");
	local turn = Game.GetCurrentGameTurn();
	if turn % 7 ~= 0 then
	print("Abigail:Not This Turn.");
	--myRandom();
	else
		local mul = (turn / 49) + 1;
		print("Abigail:This Turn!");
		checkPlayer(mul);
	end
end


function trait1(mul,playerId) --金币信仰
	
	local player = Players[playerId];
	
	local gold = player:GetTreasury():GetGoldBalance();
	local faith = player:GetReligion():GetFaithBalance();
	
	local gold_result = gold + (gold * (mul * 0.25));
	local faith_result = faith + (faith * (mul * 0.25));
	
	player:GetTreasury():ChangeGoldBalance(gold_result);
	player:GetReligion():ChangeFaithBalance(faith_result);
	print("Abigail:Trait1 Done.");	

end

function trait2(mul,playerId) --文化科研

	local player = Players[playerId];
	local playerTechs = player:GetTechs();
	local playerCulture = player:GetCulture();

	if (playerTechs:GetResearchingTech() ~= -1) then
		--playerTechs:ChangeCurrentResearchProgress(playerTechs:GetResearchCost(playerTechs:GetResearchingTech()) - playerTechs:GetResearchProgress());
		playerTechs:ChangeCurrentResearchProgress(playerTechs:GetResearchProgress() + (playerTechs:GetResearchCost(playerTechs:GetResearchingTech()) * mul * 0.1));
	end	
	
	if (playerCulture:GetProgressingCivic() ~= -1) then
		--playerCulture:ChangeCurrentCulturalProgress(playerCulture:GetCultureCost(playerCulture:GetProgressingCivic()) - playerCulture:GetCulturalProgress());
		playerCulture:ChangeCurrentCulturalProgress(playerCulture:GetCulturalProgress() + (playerCulture:GetCultureCost(playerCulture:GetProgressingCivic()) * mul * 0.1));
	end		
	print("Abigail:Trait2 Done.");	

end

function trait3(mul,playerId) --伟人点数

	local player = Players[playerId];

	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_GENERAL'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ADMIRAL'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ENGINEER'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_PROPHET'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_SCIENTIST'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_WRITER'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_ARTIST'].Index, mul * 10);
	player:GetGreatPeoplePoints():ChangePointsTotal(GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MUSICIAN'].Index, mul * 10);
	print("Abigail:Trait3 Done.");	

end

function trait4(mul,playerId) --加影响力和时代得分

	local player = Players[playerId];

	player:GetInfluence():ChangeTokensToGive(mul);
	Game.GetEras():ChangePlayerEraScore(playerId, mul*3);
	print("Abigail:Trait4 Done.");	
	
end

function trait5(mul,playerId) --战斗单位经验值

	local player = Players[playerId];
	for i,pUnit in player:GetUnits():Members() do
		pUnit:GetExperience():ChangeExperience(mul*10);
		UnitManager.ChangeMovesRemaining(pUnit, mul*2);
	end
	print("Abigail:Trait5 Done.");	
	
end

function trait6(mul,playerId) --战略资源

	local player = Players[playerId];	
	player:GetGovernors():ChangeGovernorPoints(mul);
	player:GetDiplomacy():ChangeFavor(mul*30);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_IRON"].Index, mul*5);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_ALUMINUM"].Index, mul*5);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_COAL"].Index, mul*5);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_HORSES"].Index, mul*5);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_NITER"].Index, mul*5);
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_OIL"].Index, mul*5);	
	--player:GetResources():ChangeResourceAmount(GameInfo.Resources["RESOURCE_URANIUM"].Index, mul*5);		
	print("Abigail:Trait6 Done.");	

end

function trait7(mul,playerId) --城市人口 目前只有锤子了

	local player = Players[playerId];

	for i, pCity in player:GetCities():Members() do
		--pCity:ChangePopulation(pCity:GetPopulation()+mul);
		local buildQueue = pCity:GetBuildQueue();
		if (buildQueue ~= nil) then
			buildQueue:AddProgress(mul*20);
		end
	end
	print("Abigail:Trait7 Done.");	
	
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
	print("Abigail:Random Result Seed:"..result);	
	return math.floor(math.abs((result % 7) + 1));

end

function myTrait(playerId,mul)

	local result = myRandom();
	print("Abigail:Random Result:"..result);	
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
		if Game.GetLocalPlayer() == playerId and pPlayer:IsMajor() and pPlayer:IsAlive() and playerConfig:GetLeaderTypeName() == "LEADER_ABIGAIL" then
			myTrait(playerId,mul);
		end
	end

end

function getSpeed()

return GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier;

end


Events.TurnBegin.Add( Abigail );