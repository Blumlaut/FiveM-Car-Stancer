minStance = -0.1 -- 4° negative camber
maxStance = 0.1 -- 4° positive camber
minOffset = 0.6
maxOffset = 1.1
maxLowering = -0.1

stanceFront = {}
stanceBack = {}
loweringAll = {}
offsetFront = {}
offsetBack = {}
curRot = {}
curOffset = {}

LoadedVehicles = {}
veh = 0

local currentItemIndexCamberFront = 1
local selectedItemIndexCamberFront = 1
local currentItemIndexCamberRear = 1
local selectedItemIndexCamberRear = 1

local currentItemIndexOffsetFront = 1
local selectedItemIndexOffsetFront = 1
local currentItemIndexOffsetRear = 1
local selectedItemIndexOffsetRear = 1

local currentItemIndexLowering = 1
local selectedItemIndexLowering = 1



function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

for i=minStance+0.0,maxStance+0.0, 0.01 do
	i = round(i,3)
	table.insert(stanceFront,tostring(i))
	table.insert(stanceBack,tostring(i))
end

for i=maxLowering+0.0, 0.0, 0.01 do
	i = round(i,3)
	table.insert(loweringAll, tostring(i))
end

for i=minOffset+0.0,maxOffset+0.0, 0.01 do
	i = round(i,3)
	table.insert(offsetFront,tostring(i))
	table.insert(offsetBack,tostring(i))
end

function GetCurrentVehicleSetup()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	for i,Lowering in ipairs(loweringAll) do
		if tonumber(Lowering) == GetVehicleHandlingFloat(veh, "CHandlingData", "fSuspensionRaise") then
			currentIndexLowering = i
			DecorSetFloat(veh, "ls_lowering", i)
			currentItemIndexLowering = i
			selectedItemIndexLowering = i
		end
	end
	for i,camber in ipairs(stanceFront) do 
		if round(GetVehicleWheelXrot(GetVehiclePedIsIn( PlayerPedId(), false), 1),2) == tonumber(camber) then
			curRot[1] = tonumber(stanceFront[i])
			DecorSetFloat(veh, "ls_stanceFront", tonumber(stanceFront[i]))
			curRot[0] = -tonumber(stanceFront[i])
			currentIndex = i
			currentItemIndexCamberFront = currentIndex
			selectedItemIndexCamberFront = currentIndex
		elseif round(GetVehicleWheelXrot(GetVehiclePedIsIn( PlayerPedId(), false), 3),2) == tonumber(camber) then
			curRot[3] = tonumber(stanceBack[i])
			DecorSetFloat(veh, "ls_stanceBack", tonumber(stanceBack[i]))
			curRot[2] = -tonumber(stanceBack[i])
			currentIndexRear = i
			currentItemIndexCamberRear = currentIndexRear
			selectedItemIndexCamberRear = currentIndexRear
		end
	end
	for i,Offset in ipairs(offsetFront) do
		if round(GetVehicleWheelXOffset(GetVehiclePedIsIn( PlayerPedId(), false), 1),2) == tonumber(Offset) then
			curOffset[1] = tonumber(offsetFront[i])
			DecorSetFloat(veh, "ls_offsetFront", tonumber(offsetFront[i]))
			curOffset[0] = -tonumber(offsetFront[i])
			currentIndex = i
			currentItemIndexOffsetFront = currentIndex
			selectedItemIndexOffsetFront = currentIndex
		elseif round(GetVehicleWheelXOffset(GetVehiclePedIsIn( PlayerPedId(), false), 3),2) == tonumber(Offset) then
			curOffset[3] = tonumber(offsetBack[i])
			DecorSetFloat(veh, "ls_offsetBack", tonumber(offsetBack[i]))
			curOffset[2] = -tonumber(offsetBack[i])
			currentIndexRear = i
			currentItemIndexOffsetRear = currentIndexRear
			selectedItemIndexOffsetRear = currentIndexRear
		end
	end
end


function ApplyLocalSetup(cf,cr,of,ore,lo)
	for i,Lowering in ipairs(loweringAll) do
		if i == lo then
			currentIndexLowering = i
			currentItemIndexLowering = i
			selectedItemIndexLowering = i
			DecorSetFloat(veh, "ls_lowering", i)
		end
	end
	for i,camber in ipairs(stanceFront) do 
		if cf == i then
			curRot[1] = tonumber(stanceFront[i])
			DecorSetFloat(veh, "ls_stanceFront", tonumber(stanceFront[i]))
			curRot[0] = -tonumber(stanceFront[i])
			currentIndex = i
			currentItemIndexCamberFront = currentIndex
			selectedItemIndexCamberFront = currentIndex
		elseif cr == i then
			curRot[3] = tonumber(stanceBack[i])
			DecorSetFloat(veh, "ls_stanceBack", tonumber(stanceBack[i]))
			curRot[2] = -tonumber(stanceBack[i])
			currentIndexRear = i
			currentItemIndexCamberRear = currentIndexRear
			selectedItemIndexCamberRear = currentIndexRear
		end
	end
	for i,Offset in ipairs(offsetFront) do
		if of == i then
			curOffset[1] = tonumber(offsetFront[i])
			DecorSetFloat(veh, "ls_offsetFront", tonumber(offsetFront[i]))
			curOffset[0] = -tonumber(offsetFront[i])
			currentIndex = i
			currentItemIndexOffsetFront = currentIndex
			selectedItemIndexOffsetFront = currentIndex
		elseif ore == i then
			curOffset[3] = tonumber(offsetBack[i])
			DecorSetFloat(veh, "ls_offsetBack", tonumber(offsetBack[i]))
			curOffset[2] = -tonumber(offsetBack[i])
			currentIndexRear = i
			currentItemIndexOffsetRear = currentIndexRear
			selectedItemIndexOffsetRear = currentIndexRear
		end
	end
end
	

Citizen.CreateThread(function()
	chdata = {} -- our table where we will store our handling information

	WarMenu.CreateMenu('lambdastancer', 'uwu stance') -- gui creation stuff
	WarMenu.CreateSubMenu('lambdasetups', 'lambdastancer','uwu setups')
	WarMenu.SetTitleColor('lambdastancer', 0,0,0)
	WarMenu.SetTitleBackgroundColor('lambdastancer', 80,80,80)
	
	for i=1,15 do
		WarMenu.CreateSubMenu('setup'..i, 'lambdasetups','uwu specific setup')
	end
	


	while true do
		if veh ~= 0 and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and veh ~= GetVehiclePedIsIn(PlayerPedId(), false) then
			GetCurrentVehicleSetup()
			curRot = {}
			curOffset = {}
		end
		veh = GetVehiclePedIsIn(PlayerPedId(), false)
		
		for i,Rotation in pairs(curRot) do
			if type(Rotation) == "number" and veh ~= 0 then
				SetVehicleWheelXrot( GetVehiclePedIsIn( PlayerPedId(), false), i, tonumber(Rotation) )
			end
		end

		for i,Offset in pairs(curOffset) do
			if type(Offset) == "number" and veh ~= 0 then
				SetVehicleWheelXOffset( GetVehiclePedIsIn( PlayerPedId(), false), i, tonumber(Offset) )
			end
		end

		if WarMenu.IsMenuOpened('lambdastancer') then
			if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
				WarMenu.CloseMenu()
				return
			end
			if WarMenu.ComboBox('Camber: Front Wheels', stanceFront, currentItemIndexCamberFront, selectedItemIndexCamberFront, function(currentIndex, selectedIndex)
				if currentIndex ~= currentItemIndexCamberFront then
					curRot[1] = tonumber(stanceFront[currentIndex])
					curRot[0] = -tonumber(stanceFront[currentIndex])
				end
				
				currentItemIndexCamberFront = currentIndex
				selectedItemIndexCamberFront = currentIndex
				end) then


			elseif WarMenu.ComboBox('Camber: Rear Wheels', stanceBack, currentItemIndexCamberRear, selectedItemIndexCamberRear, function(currentIndexRear, selectedIndexRear)
				if currentIndexRear ~= currentItemIndexCamberRear then
					curRot[3] = tonumber(stanceBack[currentIndexRear])
					curRot[2] = -tonumber(stanceBack[currentIndexRear])
				end
				currentItemIndexCamberRear = currentIndexRear
				selectedItemIndexCamberRear = currentIndexRear
				end) then

			elseif WarMenu.ComboBox('Offset: Front Wheels', offsetFront, currentItemIndexOffsetFront, selectedItemIndexOffsetFront, function(currentIndex, selectedIndex)
					if currentIndex ~= currentItemIndexOffsetFront then
						curOffset[1] = tonumber(offsetFront[currentIndex])
						curOffset[0] = -tonumber(offsetFront[currentIndex])
					end

					currentItemIndexOffsetFront = currentIndex
					selectedItemIndexOffsetFront = currentIndex
					end) then


					elseif WarMenu.ComboBox('Offset: Rear Wheels', offsetBack, currentItemIndexOffsetRear, selectedItemIndexOffsetRear, function(currentIndexRear, selectedIndexRear)
						if currentIndexRear ~= currentItemIndexOffsetRear then
							curOffset[3] = tonumber(offsetBack[currentIndexRear])
							curOffset[2] = -tonumber(offsetBack[currentIndexRear])
							curOffset[5] = tonumber(offsetBack[currentIndexRear])
							curOffset[4] = -tonumber(offsetBack[currentIndexRear])
						end
						currentItemIndexOffsetRear = currentIndexRear
						selectedItemIndexOffsetRear = currentIndexRear
						end) then

			elseif WarMenu.ComboBox('Suspension Lowering', loweringAll, currentItemIndexLowering, selectedItemIndexLowering, function(currentIndexLowering, selectedIndexLowering)
				if currentIndexLowering ~= currentItemIndexLowering then
					SetVehicleHandlingFloat( GetVehiclePedIsIn( PlayerPedId(), false), "CHandlingData", "fSuspensionRaise", tonumber(loweringAll[currentIndexLowering]) )
				end
				currentItemIndexLowering = currentIndexLowering
				selectedItemIndexLowering = currentIndexLowering
				end) then

			elseif WarMenu.MenuButton('Stance Setups', 'lambdasetups') then
				
			elseif WarMenu.Button('Get Current Vehicle Setup') then
				GetCurrentVehicleSetup()
				
			elseif WarMenu.MenuButton('Exit', 'closeMenu') then
				WarMenu.CloseMenu()
			end
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('lambdasetups') then
			for i=1,15 do
				if not GetResourceKvpString("lambdastance."..i..".name") then
					if WarMenu.MenuButton("Setup "..i..": None Found", 'setup'..i) then
						
					end
				else
					WarMenu.MenuButton("Setup "..i..": "..GetResourceKvpString("lambdastance."..i..".name"), 'setup'..i)
				end
			end 
			WarMenu.Display()
			

			
		elseif IsControlJustReleased(0, 29) and GetVehiclePedIsIn( PlayerPedId(), false ) ~= 0 then -- Press B, also make sure we are in a vehicle otherwise the script will crash
			WarMenu.OpenMenu("lambdastancer") -- open the UI!
		end

		for i=1,15 do
			if WarMenu.IsMenuOpened('setup'..i) then
				
				if WarMenu.Button("Load Setup") then
					currentItemIndexCamberFront = GetResourceKvpInt("lambdastance."..i..".frontCamber")
						selectedItemIndexCamberFront = currentItemIndexCamberFront
					currentItemIndexCamberRear = GetResourceKvpInt("lambdastance."..i..".rearCamber")
						selectedItemIndexCamberRear = currentItemIndexCamberRear
					currentItemIndexOffsetFront = GetResourceKvpInt("lambdastance."..i..".frontOffset")
						selectedItemIndexOffsetFront = currentItemIndexOffsetFront
					currentItemIndexOffsetRear = GetResourceKvpInt("lambdastance."..i..".rearOffset")
						selectedItemIndexOffsetRear = currentItemIndexOffsetRear
					currentItemIndexLowering = GetResourceKvpInt("lambdastance."..i..".lowering")
						selectedItemIndexLowering = currentItemIndexLowering
						ApplyLocalSetup(currentItemIndexCamberFront,currentItemIndexCamberRear,currentItemIndexOffsetFront,currentItemIndexOffsetRear,currentItemIndexLowering)
					
				elseif WarMenu.Button("Save Setup") then
					
					AddTextEntry('FMMC_KEY_TIP1', "what shall thou setup be called")
					DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 255)
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
					local result = GetOnscreenKeyboardResult()
					if result == "" then return false end
					if result then
						SetResourceKvp("lambdastance."..i..".name",result)
						SetResourceKvpInt("lambdastance."..i..".frontCamber", currentItemIndexCamberFront)
						SetResourceKvpInt("lambdastance."..i..".rearCamber", currentItemIndexCamberRear)
						SetResourceKvpInt("lambdastance."..i..".frontOffset", currentItemIndexOffsetFront)
						SetResourceKvpInt("lambdastance."..i..".rearOffset", currentItemIndexOffsetRear)
						SetResourceKvpInt("lambdastance."..i..".lowering", currentItemIndexLowering)
					end
					
				elseif WarMenu.Button("Delete Setup") then
					DeleteResourceKvp("lambdastance."..i..".name")
					DeleteResourceKvp("lambdastance."..i..".frontCamber")
					DeleteResourceKvp("lambdastance."..i..".rearCamber")
					DeleteResourceKvp("lambdastance."..i..".frontOffset")
					DeleteResourceKvp("lambdastance."..i..".rearOffset")
					DeleteResourceKvp("lambdastance."..i..".lowering")
				end
				
				WarMenu.Display()
				break
			end
		end

		Citizen.Wait(0)
	end


end)