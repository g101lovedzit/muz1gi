--[[
-- THIS SCRIPT HAS BEEN CODED BY RAFA (discord.gg/MilkUp)
-- DON'T BE A STUPID SKIDDIE THAT STEAL PEOPLE CODE AND PUT ON A SHIT PAID (or "watch ad to get key") SCRIPT
-- hi Project WD please don't steal my code again thx

-- For Preston:
-- Sorry for any incovenience I don't make any malicous script like mail/bank stealers, trade scam and this shit, just auto-farm and QoL scripts, feel free to use this repo to fix any vulnerability on your game
--]]

-- Join us at 
-- discord.gg/MilkUp

-- source by Milkup
-- edit by muz1gi


--[[ 
-- • Potato FPS
-- • Improve Bank Index with "Auto buy storage upgrades" (+ withdraw needed diamonds from bank)
--]]


-- Important Variables
local SCRIPT_NAME = "Muz1gi"
local SCRIPT_VERSION = "v0.1" -- Hey rafa remember to change it before updating lmao

-- Detect if the script has executed by AutoExec
local AutoExecuted = false
if not game:IsLoaded() then AutoExecuted = true end

repeat task.wait() until game.PlaceId ~= nil
if not game:IsLoaded() then game.Loaded:Wait() end

--//-------------- SERVICES ----------------//*
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local InputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local ContentProvider = game:GetService("ContentProvider")

--//*--------- Potato FPS -----------//*
local lighting = game.Lighting
local terrain = game.Workspace.Terrain
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
terrain.WaterTransparency = 0
lighting.GlobalShadows = false
lighting.FogStart = 0
lighting.FogEnd = 0
lighting.Brightness = 0
settings().Rendering.QualityLevel = "Level01"

for i, v in pairs(game:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    end
end

for i, e in pairs(lighting:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end

--//*--------- GLOBAL VARIABLES -----------//*
local ScriptIsCurrentlyBusy = false
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local CurrentWorld = ""
local CurrentPosition = nil

local Settings_DisableRendering = true

local Webhook_Enabled = false
local Webhook_URL = ""
local Webhook_Daycare = true
local Webhook_Huge = true

LocalPlayer.CharacterAdded:Connect(function(char) 
	Character = char
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

if game.PlaceId == 6284583030 or game.PlaceId == 10321372166 or game.PlaceId == 7722306047 or game.PlaceId == 12610002282 then
	
	local banSuccess, banError = pcall(function() 
		local Blunder = require(game:GetService("ReplicatedStorage"):WaitForChild("X", 10):WaitForChild("Blunder", 10):WaitForChild("BlunderList", 10))
		if not Blunder or not Blunder.getAndClear then LocalPlayer:Kick("Error while bypassing the anti-cheat! (Didn't find blunder)") end
		
		local OldGet = Blunder.getAndClear
		setreadonly(Blunder, false)
		local function OutputData(Message)
		   print("-- PET SIM X BLUNDER --")
		   print(Message .. "\n")
		end
		
		Blunder.getAndClear = function(...)
		   local Packet = ...
			for i,v in next, Packet.list do
			   if v.message ~= "PING" then
				   OutputData(v.message)
				   table.remove(Packet.list, i)
			   end
		   end
		   return OldGet(Packet)
		end
		
		setreadonly(Blunder, true)
	end)

	if not banSuccess then
		LocalPlayer:Kick("Error while bypassing the anti-cheat! (".. banError ..")")
		return
	end
	
	local Library = require(game:GetService("ReplicatedStorage").Library)
	assert(Library, "Oopps! Library has not been loaded. Maybe try re-joining?") 
	while not Library.Loaded do task.wait() end
	
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	
	
	local bypassSuccess, bypassError = pcall(function()
		if not Library.Network then 
			LocalPlayer:Kick("Network not found, can't bypass!")
		end
		
		if not Library.Network.Invoke or not Library.Network.Fire then
			LocalPlayer:Kick("Network Invoke/Fire was not found! Failed to bypass!")
		end
		
		hookfunction(debug.getupvalue(Library.Network.Invoke, 1), function(...) return true end)
		-- Currently we don't need to hook Fire, since both Invoke/Fire have the same upvalue, this may change in future.
		-- hookfunction(debug.getupvalue(Library.Network.Fire, 1), function(...) return true end)
		
		local originalPlay = Library.Audio.Play
		Library.Audio.Play = function(...) 
			if checkcaller() then
				local audioId, parent, pitch, volume, maxDistance, group, looped, timePosition = unpack({ ... })
				if type(audioId) == "table" then
					audioId = audioId[Random.new():NextInteger(1, #audioId)]
				end
				if not parent then
					warn("Parent cannot be nil", debug.traceback())
					return nil
				end
				if audioId == 0 then return nil end
				
				if type(audioId) == "number" or not string.find(audioId, "rbxassetid://", 1, true) then
					audioId = "rbxassetid://" .. audioId
				end
				if pitch and type(pitch) == "table" then
					pitch = Random.new():NextNumber(unpack(pitch))
				end
				if volume and type(volume) == "table" then
					volume = Random.new():NextNumber(unpack(volume))
				end
				if group then
					local soundGroup = game.SoundService:FindFirstChild(group) or nil
				else
					soundGroup = nil
				end
				if timePosition == nil then
					timePosition = 0
				else
					timePosition = timePosition
				end
				local isGargabe = false
				if not pcall(function() local _ = parent.Parent end) then
					local newParent = parent
					pcall(function()
						newParent = CFrame.new(newParent)
					end)
					parent = Instance.new("Part")
					parent.Anchored = true
					parent.CanCollide = false
					parent.CFrame = newParent
					parent.Size = Vector3.new()
					parent.Transparency = 1
					parent.Parent = workspace:WaitForChild("__DEBRIS")
					isGargabe = true
				end
				local sound = Instance.new("Sound")
				sound.SoundId = audioId
				sound.Name = "sound-" .. audioId
				sound.Pitch = pitch and 1
				sound.Volume = volume and 0.5
				sound.SoundGroup = soundGroup
				sound.Looped = looped and false
				sound.MaxDistance = maxDistance and 100
				sound.TimePosition = timePosition
				sound.RollOffMode = Enum.RollOffMode.Linear
				sound.Parent = parent
				if not require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client")).Settings.SoundsEnabled then
					sound:SetAttribute("CachedVolume", sound.Volume)
					sound.Volume = 0
				end
				sound:Play()
				getfenv(originalPlay).AddToGarbageCollection(sound, isGargabe)
				return sound
			end
			
			return originalPlay(...)
		end
	
	end)
	
	if not bypassSuccess then
		print(bypassError)
		LocalPlayer:Kick("Error while bypassing network, try again or wait for an update!")
		return
	end
	
	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10):WaitForChild("Coins", 10)
	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10):WaitForChild("Pets", 10)
	wait()
	-- local orbsScript = getsenv(game.Players.LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Orbs", 10))
	-- local CollectOrb = orbsScript.Collect
	
	local GetRemoteFunction = debug.getupvalue(Library.Network.Invoke, 2)
		-- OrbList = debug.getupvalue(orbsScript.Collect, 1)
	local CoinsTable = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Coins", 10)).DestroyAllCoins, 1)
	local RenderedPets = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Pets", 10)).NetworkUpdate, 1)

	--// AUTO COMPLETE game
	local AllGameAreas = {}
	
	for name, area in pairs(Library.Directory.Areas) do
		local world = Library.Directory.Worlds[area.world]
		if world and world.worldOrder and world.worldOrder > 0 then
			if not area.hidden and not area.isVIP then
				local containsArea = false
				if world.spawns then
					for i,v in pairs(world.spawns) do
						if v.settings and v.settings.area and v.settings.area == name then 
							containsArea = true 
							break 
						end
					end
				end
				
				if area.gate or containsArea then
					table.insert(AllGameAreas, name)
				end
			end
		end
	end
	

	
	table.sort(AllGameAreas, function(a, b)
		local areaA = Library.Directory.Areas[a]
		local areaB = Library.Directory.Areas[b]

		local worldA = Library.Directory.Worlds[areaA.world]
		if a == "Ice Tech" then 
			worldA = Library.Directory.Worlds["Fantasy"]
		end
		
		local worldB = Library.Directory.Worlds[areaB.world]
		if b == "Ice Tech" then 
			worldB = Library.Directory.Worlds["Fantasy"]
		end

		if worldA.worldOrder ~= worldB.worldOrder then
			return worldA.worldOrder < worldB.worldOrder
		end
		
		local currencyA = Library.Directory.Currency[worldA.mainCurrency]
		local currencyB = Library.Directory.Currency[worldB.mainCurrency]
		if currencyA.order ~= currencyB.order then
			return currencyA.order < currencyB.order
		end
		
		if not areaA.gate or not areaB.gate then
			return areaA.id < areaB.id
		end
		
		return areaA.gate.cost < areaB.gate.cost
	end)
	

	function GetCurrentAndNextArea()
		local cArea, nArea = "", ""

		
		for i, v in ipairs(AllGameAreas) do 
			if cArea == "" and Library.WorldCmds.HasArea(v) then
				local nxtArea = AllGameAreas[i + 1]
				if nxtArea and not Library.WorldCmds.HasArea(nxtArea) then 
					cArea = v
					nArea = nxtArea
					break
				elseif not nxtArea then
					cArea = v
					nArea = "COMPLETED"
				end
			end
		end
		
		
		return cArea, nArea
	end

	
	function CheckIfCanAffordArea(areaName)
		local saveData = Library.Save.Get()
		local area = Library.Directory.Areas[areaName]
		
		if not saveData then 
			return false 
		end
		
		if not area then return false end
		
		if not area.gate then 
			return true 
		end -- Area is free =)
		
		local gateCurrency = area.gate.currency
		local currency = saveData[gateCurrency]
		if IsHardcore then
			if gateCurrency ~= "Diamonds" then
				currency = saveData.HardcoreCurrency[gateCurrency]
			end
		end
		
		if currency and currency >= area.gate.cost then
			return true
		end
		
		return false
	end
	
	-- TODO: Implement huge webhook notifier 
	function RewardsRedeemed(rewards)

		for v, rewardBox in pairs(rewards) do 
			local reward, quantity = unpack(rewardBox)
			if Webhook_Huge and reward == "Huge Pet" then 
				local petId = quantity
				local petData = Library.Directory.Pets[petId]
				if petData then
					SendWebhook()
				end
			end
			print(quantity, reward)
		end
		
	end
	
	Library.Network.Fired("Rewards Redeemed"):Connect(function(rewards)
		RewardsRedeemed(rewards)
	end)
	
	Library.Signal.Fired("Rewards Redeemed"):Connect(function(rewards)
		RewardsRedeemed(rewards)
	end)
	
	local fastPets = false
	local Original_HasPower = Library.Shared.HasPower
	Library.Shared.HasPower = function(pet, powerName) 
		if fastPets and powerName == "Agility" then 
			return true, 3
		end
		return Original_HasPower(pet, powerName)
	end
	
	local Original_GetPowerDir = Library.Shared.GetPowerDir
	Library.Shared.GetPowerDir = function(powerName, tier) 
		if fastPets and powerName == "Agility" then 
			return  {
				title = "Agility III", 
				desc = "Pet moves 50% faster", 
				value = 20
			}
		end
		return Original_GetPowerDir(powerName, tier)
	end

	getgenv().SecureMode = true
	getgenv().DisableArrayfieldAutoLoad = true
	
	local Rayfield = nil
	if isfile("UI/ArrayField.lua") then
		Rayfield = loadstring(readfile("UI/ArrayField.lua"))()
	else
		Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rafacasari/ArrayField/main/v2.lua"))()
	end
	
	-- local Rayfield = (isfile("UI/ArrayField.lua") and loadstring(readfile("UI/ArrayField.lua"))()) or loadstring(game:HttpGet("https://raw.githubusercontent.com/Rafacasari/ArrayField/main/v2.lua"))()
	assert(Rayfield, "Oopps! Rayfield has not been loaded. Maybe try re-joining?") 
	

	local Window = Rayfield:CreateWindow({
	   Name = "Pet Simulator Tier | by Muz1gi ",
	   LoadingTitle = SCRIPT_NAME .. " " .. SCRIPT_VERSION,
	   LoadingSubtitle = "by Muz1gi",
	   ConfigurationSaving = {
		  Enabled = true,
		  FolderName = "Rafa",
		  FileName = "PetSimulatorX_" .. tostring(LocalPlayer.UserId)
	   },
	   OldTabLayout = true
	})
	
	coroutine.wrap(function() 
		wait(0.5)
		if not isfile("Rafa/AcceptedTerms.txt") then 
			Window:Prompt({
				Title = 'Disclaimer',
				SubTitle = 'Misuse of this script may result in penalties!',
				Content = "I am not responsible for any harm caused by this tool, use at your own risk.",
				Actions = {
					
					Accept = {
						Name = "Ok",
						Callback = function()
							if not isfolder("Rafa") then makefolder("Rafa") end
							writefile("Rafa/AcceptedTerms.txt", "true")
						end,
						
					}
				}
			})
		end 
	
	end)()

	Library.ChatMsg.New(string.format("Hello, %s! You're running %s %s", LocalPlayer.DisplayName, SCRIPT_NAME, SCRIPT_VERSION), Color3.fromRGB(175, 70, 245))
	
	--local mainTab = Window:CreateTab("Main", "12434808810")
	
	
	-- task.spawn(function() 
		-- while true do 
			-- stats:Set({Title = "Hello, " .. LocalPlayer.DisplayName, Content = string.format("There are some useful information:\nServer age: %s\n", Library.Functions.TimeString(workspace.DistributedGameTime, true))})
			-- task.wait(1)
		-- end
	-- end)
	
	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10)

	local automationTab = Window:CreateTab("Automation", "13075622619", true)

	local bankIndexSection = automationTab:CreateSection("Auto up Tier", false, false, "13080063246")
	automationTab:CreateParagraph({ Title = "What is this?", Content = "Đại khái là tự lấy pet trong bank ra collect." }, bankIndexSection)
	
	local BankIndex_Debounce = false
	local BankIndex_InProgress = false
	local BankIndex_OwnerUsername = ""
	
	local Input = automationTab:CreateInput({
	   Name = "Chủ Bank",
	   Info = "Owner of the bank", -- Speaks for itself, Remove if none.
	   PlaceholderText = "Tên chủ bank",
	   Flag = "BankIndex_OwnerUsername",
	   SectionParent = bankIndexSection,
	   OnEnter = false, -- Will callback only if the user pressed ENTER while the box is focused.
	   RemoveTextAfterFocusLost = false,
	   Callback = function(Text)
			BankIndex_OwnerUsername = Text
	   end,
	})
	
	local bankIndexInfo = automationTab:CreateParagraph({
			Title = "Hiển Thị",
			Content = "Chưa bắt đầu cái gì"
		}, bankIndexSection)
	
	local startBankIndex = nil
	
	function BankMessage(message)
		if not startBankIndex then return end
		coroutine.wrap(function() 
			while true do
				wait()
				startBankIndex:Set(nil, message)
				break
			end
		end)()
	end
			
	function BankError(errorMessage)
		pcall(function() 
			bankIndexInfo:Set({
				Title = "Idling",
				Content = "Not doing anything yet..."
			})
		end)
		BankMessage(errorMessage)
		print("Error on Bank Index: " .. errorMessage)
		wait(3)
		BankMessage("")
	end

	startBankIndex = automationTab:CreateButton({
		Name = "Bắt đầu collect",
		CurrentValue = false,
		Interact = "",
		SectionParent = bankIndexSection,
		Callback = function(Value)

			if BankIndex_Debounce then return end
			
			if not BankIndex_InProgress then
				BankIndex_Debounce = true
				coroutine.wrap(function() 
					wait(0.3)
					BankIndex_Debounce = false
				end)()
			end
			
			-- Start bank functions
			if BankIndex_InProgress then 
				-- Cancel process
				BankIndex_Debounce = true
				BankIndex_InProgress = false
				BankMessage(nil, "")
				coroutine.wrap(function() 
					while true do
						wait()
						startBankIndex:Set("Đợi cất vô bank cái ba", nil)
						break
					end
				end)()
			else
				-- Start process
				local SaveData = Library.Save.Get()
				if not SaveData or not SaveData.Collection then 
					BankError("Failed to get data!")
					return
				end
				
				if Library.WorldCmds.Get() ~= "Spawn" then
					if not Library.WorldCmds.Load("Spawn") then return end
					wait(1)
				end

				HumanoidRootPart.CFrame = Library.WorldCmds.GetMap().Interactive.Bank.Pad.CFrame + Vector3.new(0, 3, 0) 
				HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + (HumanoidRootPart.CFrame.LookVector * 15)
				
				wait(0.5)
				
				local BankUID = nil

				BankMessage(nil, "Getting UserID")
				local success, result = pcall(function() return Players:GetUserIdFromNameAsync(BankIndex_OwnerUsername) end)
				if not success then 
					BankError("Không tìm thấy!")
					print(result)
					return
				end
				
				ownerId = result
				if not ownerId or not tonumber(ownerId) then
					BankError("Không thấy tên chủ bank")
					return
				end
				
				local myBanks = Library.Network.Invoke("Get My Banks")
				if not myBanks then 
					BankError("Bank is on cooldown!")
					return 
				end 
				
				for _, bank in pairs(myBanks) do 
					if bank.Owner == tonumber(ownerId) then 
						BankUID = bank.BUID
						break
					end
				end 
				

				if not BankUID then BankError("Bank was not found!") return end
				
				-- Get missing collection pets
				local allCollectablePets = Library.Shared.GetAllCollectablePets()
				local remainingPets = {}
				
				for i, pet in pairs(allCollectablePets) do 
					local petId = pet.petId
					local isGolden = pet.isGolden
					local isRainbow = pet.isRainbow
					local isDarkMatter = pet.isDarkMatter
					
					local petType = 1
					if isGolden then
						petType = 2
					elseif isRainbow then
						petType = 3
					elseif isDarkMatter then
						petType = 4
					end
								
					local isUnlocked = Library.Functions.SearchArray(SaveData.Collection, tostring(petId) .. "-" .. tostring(petType))
					if not isUnlocked then
						remainingPets[petId] = true
					end
				end
				
				
				local Bank = Library.Network.Invoke("Get Bank", BankUID) 
				if not Bank then BankError("Bank was not found!") return end

				local BankPets = Bank.Storage.Pets

				
				local petsAvailableOnBank = {}
				for _, pet in pairs(BankPets) do 
					local petId = pet.id
					local isGolden = pet.g
					local isRainbow = pet.r
					local isDarkMatter = pet.dm
					
					local petType = 1
					if isGolden then petType = 2
					elseif isRainbow then petType = 3
					elseif isDarkMatter then petType = 4 end
					
					local isUnlocked = Library.Functions.SearchArray(SaveData.Collection, tostring(petId) .. "-" .. tostring(petType))
					
					local petData = Library.Directory.Pets[petId]
					if petData and (petData.titanic or petData.huge or petData.rarity == "Exclusive" or petData.rarity == "Event") then petType = 5 end -- Huges/Exclusives/Event don't need to be indexed more than 1 time
					
					local petIdentifer = tostring(petId) .. "-" .. tostring(petType)
					-- Pet is not unlocked and not on our table, put they on list!
					if remainingPets[petId] and not petsAvailableOnBank[petIdentifer] and not isUnlocked then petsAvailableOnBank[petIdentifer] = pet end
				end


				local function UpdateInfo()
					local petsAvailableOnBankCount = 0
					for _, pet in pairs(petsAvailableOnBank) do
						if pet then 
							petsAvailableOnBankCount = petsAvailableOnBankCount + 1
						end
					end
					
					bankIndexInfo:SetContent(string.format("Đang có <b>%s</b> của %s Max colect\n", tostring(#SaveData.Collection), tostring(#allCollectablePets)) ..
									  string.format("Bank này có %s pets\n", tostring(#BankPets)) ..
									  string.format("Bank này còn <b>%s</b> trên %s để max colect", tostring(petsAvailableOnBankCount), tostring(#allCollectablePets - #SaveData.Collection)))
				
				end
				UpdateInfo()
				
				BankIndex_InProgress = true
				
				coroutine.wrap(function() 
					while true do
						wait()
						startBankIndex:Set("Stop Indexing", nil)
						break
					end
				end)()
				
				wait(1)
	
				coroutine.wrap(function()
					local petsToWithdraw = {}
					local failedToDeposit = false
					while BankIndex_InProgress do
					
						UpdateInfo()
						if not petsToWithdraw or #petsToWithdraw < 50 then
							for petIdentifer, pet in pairs(petsAvailableOnBank) do 
								if pet and pet.uid and #petsToWithdraw < 50 then
									table.insert(petsToWithdraw, pet.uid)
									petsAvailableOnBank[petIdentifer] = nil
								end
								
								if #petsToWithdraw >= 50 then break end
							end
						end
						
						UpdateInfo()
						if petsToWithdraw and #petsToWithdraw > 0 then
							bankIndexInfo:SetTitle(string.format("Đang lấy %s pets ra collect", tostring(#petsToWithdraw)))
							wait(0.5)
							
							local oldCollectionCount = 0 + #SaveData.Collection
							local expectedCollectionCount = oldCollectionCount + #petsToWithdraw
							
							local withdrawSuccess, withdrawMessage = Library.Network.Invoke("Bank Withdraw", BankUID, petsToWithdraw, 0)
							if withdrawSuccess then
								UpdateInfo()
								bankIndexInfo:SetTitle(string.format("Waiting for %s pets to index...", tostring(#petsToWithdraw)))
								wait(5)
								
								local cTick = tick()
								repeat UpdateInfo() wait() until #SaveData.Collection > oldCollectionCount or not BankIndex_InProgress or tick() - cTick > 15
								bankIndexInfo:SetTitle(string.format("Đang cất %s pets vào Bank", tostring(#petsToWithdraw)))
								
								UpdateInfo()
								local depositsAttempts = 0
								
								
								local function TryToDeposit()
									local depositSuccess, depositMessage = Library.Network.Invoke("Bank Deposit", BankUID, petsToWithdraw, 0)
									if not depositSuccess then 
										if depositsAttempts >= 5 then 
											failedToDeposit = true 
											return 
										end
										depositsAttempts = depositsAttempts + 1
										wait(5)
										TryToDeposit()
									end
								end
								
								TryToDeposit()
								
								if failedToDeposit then
									bankIndexInfo:SetTitle("Oopps... Aborting process!")
									bankIndexInfo:SetContent(string.format("Damn! <b>Failed to deposit</b> after <b>5</b> attempts, <font color=\"#FF0000\">process has been canceled</font>!\nFailed to deposit: %s pets!", tostring(#petsToWithdraw)))
									break
								else 
									-- CLEAR THE WITHDRAW TABLE
									petsToWithdraw = {}
								end
							else
								print(withdrawMessage)
							end
						else break end
						wait(10)
					end
					
					BankIndex_InProgress = false
					BankIndex_Debounce = false
					UpdateInfo()
					
					coroutine.wrap(function() 
						while true do
							wait()
							startBankIndex:Set("Start Indexing", nil)
							break
						end
					end)()
					
					if not failedToDeposit then 
						bankIndexInfo:Set({
							Title = "Idling",
							Content = "Not doing anything yet..."
						})
					end
					
					BankMessage(nil, "")
				end)()
			end
		end
	})
	
	local CompleteCollection_NormalEggs = true
	local CompleteCollection_GoldenEggs = true
	local CompleteCollection_MakeRainbows = false
	local CompleteCollection_MakeDarkMatter = false
	
	function GetNextMissingPet()
		local SaveData = Library.Save.Get()
		if not SaveData then return nil end
		
		local allCollectablePets = Library.Shared.GetAllCollectablePets()
		local remainingPets = {}

		for i, pet in pairs(allCollectablePets) do 
			local petId = pet.petId
			local petData = Library.Directory.Pets[petId]
			local isGolden = pet.isGolden
			local isRainbow = pet.isRainbow
			local isDarkMatter = pet.isDarkMatter
			
			local petType = 1
			if isGolden then
				petType = 2
			elseif isRainbow then
				petType = 3
			elseif isDarkMatter then
				petType = 4
			end
						
					
			local isUnlocked = Library.Functions.SearchArray(SaveData.Collection, tostring(petId) .. "-" .. tostring(petType))
			if petData and not (petData.titanic or petData.huge or petData.rarity == "Exclusive" or petData.rarity == "Event") and not isUnlocked then
				-- remainingPets[petId] = petType
				table.insert(remainingPets, {petId, petType})
			end
		end
		
		table.sort(remainingPets, function(a, b)
			local petDataA = Library.Directory.Pets[a[1]]
			local petDataB = Library.Directory.Pets[b[1]]
			
			local petTypeA = a[2]
			local petTypeB = b[2]
			
			if a == b then 
				return petTypeA < petTypeB
			end
			
			return a[1] < b[1]
		end)
		
		for i, v in ipairs(remainingPets) do return v end
	end
	
	function GetBestEggForPet(petId)
		local allEggs = Library.Directory.Eggs
		local eggsWithPet = {}
		for eggId, v in pairs(allEggs) do
			if v and v.drops and typeof(v.drops) == "table" then
				for _, drop in pairs(v.drops) do
					local petDropId = drop[1]
					if petDropId == tostring(petId) then
						table.insert(eggsWithPet, {eggId, drop[2]})
					end
				end
			end
		end
		
		table.sort(eggsWithPet, function(a, b) 
			local chanceA = eggsWithPet[a][2]
			local chanceB = eggsWithPet[b][2]
			
			return chanceA > chanceB
		end)
		
		for i, v in ipairs(eggsWithPet) do
			return v[1]
		end
		return nil
	end
	
	local completeCollectionSection = automationTab:CreateSection("Auto Pet Collection", false, true)
	local completeCollectionStatus = automationTab:CreateParagraph({Title = "Status", Content = "Waiting to start"}, completeCollectionSection)
	
	local completeCollectionNormalEggs = automationTab:CreateToggle({
		Name = "Normal Eggs",
		SectionParent = completeCollectionSection,
		CurrentValue = true,
		Flag = "CompleteCollection_NormalEggs",
		Callback = function(value) 
			CompleteCollection_NormalEggs = value
			
			coroutine.wrap(function()
				local currentPet, currentPetType = unpack(GetNextMissingPet())
				local currentEgg = GetBestEggForPet(currentPet)
				completeCollectionStatus:SetContent("Pet: " .. Library.Directory.Pets[currentPet].name .. "\nType: " .. currentPetType .. "\nEgg: " .. currentEgg)
				
				
				while task.wait(3) do
				
				end
			end)()
		end
	})
	
	
	local completeCollectionGolldenEggs = automationTab:CreateToggle({
		Name = "Golden Eggs",
		SectionParent = completeCollectionSection,
		CurrentValue = true,
		Flag = "CompleteCollection_GoldenEggs",
		Callback = function(value) 
			CompleteCollection_GoldenEggs = value
		end
	})

	local completeCollectionMakeRainbows = automationTab:CreateToggle({
		Name = "Make Rainbows",
		SectionParent = completeCollectionSection,
		CurrentValue = true,
		Flag = "CompleteCollection_MakeRainbows",
		Callback = function(value) 
			CompleteCollection_MakeRainbows = value
		end
	})
	
	local completeCollectionMakeDarkMatter = automationTab:CreateToggle({
		Name = "Make Dark Matter",
		SectionParent = completeCollectionSection,
		CurrentValue = true,
		Flag = "CompleteCollection_MakeDarkMatter",
		Callback = function(value) 
			CompleteCollection_MakeDarkMatter = value
		end
	})

	local settingsTab = Window:CreateTab("Settings", "13075268290", true)
	local windowSettings = settingsTab:CreateSection("General Options", false, false, "13080063021")
	
	settingsTab:CreateToggle({
		Name = "Màn hình trắng,giảm CPU máy các kiểu",
		CurrentValue = true,
		Flag = "Settings_DisableRendering",
		SectionParent = windowSettings,
		Callback = function(value) 
			Settings_DisableRendering = value
		end
	})

	Rayfield.LoadConfiguration()

	for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
		v:Disable()
	end

	InputService.WindowFocused:Connect(function()
		RunService:Set3dRenderingEnabled(true)
	end)

	InputService.WindowFocusReleased:Connect(function()
		if Settings_DisableRendering then
			RunService:Set3dRenderingEnabled(false)
		end
	end)
end
