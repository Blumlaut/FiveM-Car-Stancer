minStance = -0.3 -- 4° negative camber
maxStance = 0.3 -- 4° positive camber
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
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("", "",0,0,"shopui_title_clubhousemod", "shopui_title_clubhousemod")
--NativeUI.CreateSprite("shopui_title_clubhousemod", "shopui_title_clubhousemod",0,0,)
_menuPool:Add(mainMenu)

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


DecorRegister("ls_lowering", 3)
DecorRegister("ls_stanceFront", 3)
DecorRegister("ls_stanceBack", 3)
DecorRegister("ls_offsetFront", 3)
DecorRegister("ls_offsetBack", 3)



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
	veh = GetVehiclePedIsIn(PlayerPedId(), false)
	for i,Lowering in ipairs(loweringAll) do
		if tonumber(Lowering) == GetVehicleHandlingFloat(veh, "CHandlingData", "fSuspensionRaise") then
			currentIndexLowering = i
			Citizen.Trace(i)
			DecorSetInt(veh, "ls_lowering", i)
			currentItemIndexLowering = i
			selectedItemIndexLowering = i
		end
	end
	for i,camber in ipairs(stanceFront) do 
		if round(GetVehicleWheelXrot(GetVehiclePedIsIn( PlayerPedId(), false), 1),2) == tonumber(camber) then
			curRot[1] = tonumber(stanceFront[i])
			DecorSetInt(veh, "ls_stanceFront", i)
			curRot[0] = -tonumber(stanceFront[i])
			currentIndex = i
			currentItemIndexCamberFront = currentIndex
			selectedItemIndexCamberFront = currentIndex
		elseif round(GetVehicleWheelXrot(GetVehiclePedIsIn( PlayerPedId(), false), 3),2) == tonumber(camber) then
			curRot[3] = tonumber(stanceBack[i])
			DecorSetInt(veh, "ls_stanceBack", i)
			curRot[2] = -tonumber(stanceBack[i])
			currentIndexRear = i
			currentItemIndexCamberRear = currentIndexRear
			selectedItemIndexCamberRear = currentIndexRear
		end
	end
	for i,Offset in ipairs(offsetFront) do
		if round(GetVehicleWheelXOffset(GetVehiclePedIsIn( PlayerPedId(), false), 1),2) == tonumber(Offset) then
			curOffset[1] = tonumber(offsetFront[i])
			DecorSetInt(veh, "ls_offsetFront", i)
			curOffset[0] = -tonumber(offsetFront[i])
			currentIndex = i
			currentItemIndexOffsetFront = currentIndex
			selectedItemIndexOffsetFront = currentIndex
		elseif round(GetVehicleWheelXOffset(GetVehiclePedIsIn( PlayerPedId(), false), 3),2) == tonumber(Offset) then
			curOffset[3] = tonumber(offsetBack[i])
			DecorSetInt(veh, "ls_offsetBack", i)
			curOffset[2] = -tonumber(offsetBack[i])
			currentIndexRear = i
			currentItemIndexOffsetRear = currentIndexRear
			selectedItemIndexOffsetRear = currentIndexRear
		end
	end
end

function ApplyVehicleSetup(theveh,cf,cr,of,ore,lo)
	--Citizen.Trace("setting cf:"..cf..",cr:"..cr..",of:"..of..",ore:"..ore..",lo:"..lo)
	for i,Lowering in ipairs(loweringAll) do
		if i == lo then
			SetVehicleHandlingFloat( theveh, "CHandlingData", "fSuspensionRaise", tonumber(loweringAll[i]) )
		end
	end
	
	for i,Rotation in pairs(curRot) do
		if type(Rotation) == "number" and veh ~= 0 then
			SetVehicleWheelXrot( theveh, i, tonumber(Rotation) )
		end
	end

	for i,Offset in pairs(curOffset) do
		if type(Offset) == "number" and veh ~= 0 then
			SetVehicleWheelXOffset( theveh, i, tonumber(Offset) )
		end
	end
	for i,camber in ipairs(stanceFront) do 
		if cf == i then
			SetVehicleWheelXrot( theveh, 0, -tonumber(camber) )
			SetVehicleWheelXrot( theveh, 1, tonumber(camber) )
		elseif cr == i then
			SetVehicleWheelXrot( theveh, 2, -tonumber(camber) )
			SetVehicleWheelXrot( theveh, 3, tonumber(camber) )
		end
	end
	for i,Offset in ipairs(offsetFront) do
		if of == i then
			SetVehicleWheelXOffset( theveh, 0, -tonumber(Offset) )
			SetVehicleWheelXOffset( theveh, 1, tonumber(Offset) )
		elseif ore == i then
			SetVehicleWheelXOffset( theveh, 2, -tonumber(Offset) )
			SetVehicleWheelXOffset( theveh, 3, tonumber(Offset) )
		end
	end
	
end

function ApplyLocalSetup(cf,cr,of,ore,lo)
	for i,Lowering in ipairs(loweringAll) do
		if i == lo then
			currentIndexLowering = i
			currentItemIndexLowering = i
			selectedItemIndexLowering = i
			DecorSetInt(veh, "ls_lowering", i)
		end
	end
	
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
	for i,camber in ipairs(stanceFront) do 
		if cf == i then
			curRot[1] = tonumber(stanceFront[i])
			DecorSetInt(veh, "ls_stanceFront", tonumber(stanceFront[i]))
			curRot[0] = -tonumber(stanceFront[i])
			currentIndex = i
			currentItemIndexCamberFront = currentIndex
			selectedItemIndexCamberFront = currentIndex
		elseif cr == i then
			curRot[3] = tonumber(stanceBack[i])
			DecorSetInt(veh, "ls_stanceBack", tonumber(stanceBack[i]))
			curRot[2] = -tonumber(stanceBack[i])
			currentIndexRear = i
			currentItemIndexCamberRear = currentIndexRear
			selectedItemIndexCamberRear = currentIndexRear
		end
	end
	for i,Offset in ipairs(offsetFront) do
		if of == i then
			curOffset[1] = tonumber(offsetFront[i])
			DecorSetInt(veh, "ls_offsetFront", tonumber(offsetFront[i]))
			curOffset[0] = -tonumber(offsetFront[i])
			currentIndex = i
			currentItemIndexOffsetFront = currentIndex
			selectedItemIndexOffsetFront = currentIndex
		elseif ore == i then
			curOffset[3] = tonumber(offsetBack[i])
			DecorSetInt(veh, "ls_offsetBack", tonumber(offsetBack[i]))
			curOffset[2] = -tonumber(offsetBack[i])
			currentIndexRear = i
			currentItemIndexOffsetRear = currentIndexRear
			selectedItemIndexOffsetRear = currentIndexRear
		end
	end
end
	
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local handle, theVeh = FindFirstVehicle()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			Wait(0)
			if theVeh ~= 0 and DoesEntityExist(theVeh) and DecorGetInt(theVeh, "ls_stanceFront") and DecorGetInt(theVeh, "ls_stanceFront") ~= 0 and theVeh ~= GetVehiclePedIsIn(PlayerPedId(), false) then
				ApplyVehicleSetup(theVeh,DecorGetInt(theVeh, "ls_stanceFront"),DecorGetInt(theVeh, "ls_stanceBack"),DecorGetInt(theVeh, "ls_offsetFront"),DecorGetInt(theVeh, "ls_offsetBack"),DecorGetInt(theVeh, "ls_lowering"))
			end
			finished, theVeh = FindNextVehicle(handle) -- first param returns true while entities are found
			Wait(0)
			if theVeh ~= 0 and DoesEntityExist(theVeh) and DecorGetInt(theVeh, "ls_stanceFront") and DecorGetInt(theVeh, "ls_stanceFront") ~= 0 and theVeh ~= GetVehiclePedIsIn(PlayerPedId(), false) then
				ApplyVehicleSetup(theVeh,DecorGetInt(theVeh, "ls_stanceFront"),DecorGetInt(theVeh, "ls_stanceBack"),DecorGetInt(theVeh, "ls_offsetFront"),DecorGetInt(theVeh, "ls_offsetBack"),DecorGetInt(theVeh, "ls_lowering"))
			end
		until not finished
		EndFindVehicle(handle)
		
		
	end
end)
	

function GenerateMenu()
	mainMenu:Clear()
	
	local newitem = NativeUI.CreateSliderItem("Camber: Front Wheels", stanceFront, currentItemIndexCamberFront, false, true)
	mainMenu:AddItem(newitem)
	newitem.OnSliderChanged = function(sender, item, currentIndex)
		if currentIndex ~= currentItemIndexCamberFront then
			curRot[1] = tonumber(stanceFront[currentIndex])
			curRot[0] = -tonumber(stanceFront[currentIndex])
		end
		
		currentItemIndexCamberFront = currentIndex
		selectedItemIndexCamberFront = currentIndex
	end
	
	local newitem = NativeUI.CreateSliderItem("Camber: Rear Wheels", stanceBack, currentItemIndexCamberRear, false, true)
	mainMenu:AddItem(newitem)
	newitem.OnSliderChanged = function(sender, item, currentIndex)
		if currentIndex ~= currentItemIndexCamberRear then
			curRot[3] = tonumber(stanceBack[currentIndex])
			curRot[2] = -tonumber(stanceBack[currentIndex])
		end
		currentItemIndexCamberRear = currentIndex
		selectedItemIndexCamberRear = currentIndex
	end
	
	local newitem = NativeUI.CreateSliderItem("Offset: Front Wheels", offsetFront, currentItemIndexOffsetFront, false, true)
	mainMenu:AddItem(newitem)
	newitem.OnSliderChanged = function(sender, item, currentIndex)
		if currentIndex ~= currentItemIndexOffsetFront then
			curOffset[1] = tonumber(offsetFront[currentIndex])
			curOffset[0] = -tonumber(offsetFront[currentIndex])
		end

		currentItemIndexOffsetFront = currentIndex
		selectedItemIndexOffsetFront = currentIndex
	end
	
	local newitem = NativeUI.CreateSliderItem("Offset: Rear Wheels", offsetBack, currentItemIndexOffsetRear, false, true)
	mainMenu:AddItem(newitem)
	newitem.OnSliderChanged = function(sender, item, currentIndex)
		if currentIndex ~= currentItemIndexOffsetRear then
			curOffset[3] = tonumber(offsetBack[currentIndex])
			curOffset[2] = -tonumber(offsetBack[currentIndex])
			curOffset[5] = tonumber(offsetBack[currentIndex])
			curOffset[4] = -tonumber(offsetBack[currentIndex])
		end
		currentItemIndexOffsetRear = currentIndex
		selectedItemIndexOffsetRear = currentIndex
	end
	
	local newitem = NativeUI.CreateSliderItem("Suspension Lowering", loweringAll, currentItemIndexLowering, false, true)
	mainMenu:AddItem(newitem)
	newitem.OnSliderChanged = function(sender, item, currentIndex)
		if currentIndex ~= currentItemIndexLowering then
			SetVehicleHandlingFloat( GetVehiclePedIsIn( PlayerPedId(), false), "CHandlingData", "fSuspensionRaise", tonumber(loweringAll[currentIndex]) )
		end
		currentItemIndexLowering = currentIndex
		selectedItemIndexLowering = currentIndex
	end
	
	local thisItem = NativeUI.CreateItem("Load Current Vehicle Setup","")
	mainMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		GetCurrentVehicleSetup()
	end

	
	setups = _menuPool:AddSubMenu(mainMenu, "Setups","",true)
	--setups:SetBannerSprite("shopui_title_clubhousemod","shopui_title_clubhousemod")
	for i=1,15 do
		if GetResourceKvpString("lambdastance."..i..".name") then
			thisSetup = _menuPool:AddSubMenu(setups, "Setup #"..i.." - "..GetResourceKvpString("lambdastance."..i..".name"))
		else
			thisSetup = _menuPool:AddSubMenu(setups, "Setup #"..i)
		end
		local thisItem = NativeUI.CreateItem("Load Setup","")
		thisSetup:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
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
		end
		
		local thisItem = NativeUI.CreateItem("Save Setup","")
		thisSetup:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
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
		end
		
		local thisItem = NativeUI.CreateItem("Clear Setup","")
		thisSetup:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			DeleteResourceKvp("lambdastance."..i..".name")
			DeleteResourceKvp("lambdastance."..i..".frontCamber")
			DeleteResourceKvp("lambdastance."..i..".rearCamber")
			DeleteResourceKvp("lambdastance."..i..".frontOffset")
			DeleteResourceKvp("lambdastance."..i..".rearOffset")
			DeleteResourceKvp("lambdastance."..i..".lowering")
		end
	end
		
	local thisItem = NativeUI.CreateItem("Exit","")
	mainMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		mainMenu:Visible(not mainMenu:Visible())
	end
end
	

Citizen.CreateThread(function()
	chdata = {} -- our table where we will store our handling information


	while true do
		if veh ~= 0 and veh ~= GetVehiclePedIsIn(PlayerPedId(), false) then
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
			
		if IsControlJustReleased(0, 29) and GetVehiclePedIsIn( PlayerPedId(), false ) ~= 0 then -- Press B, also make sure we are in a vehicle otherwise the script will crash
			GetCurrentVehicleSetup()
			GenerateMenu()
			mainMenu:Visible(not mainMenu:Visible())
		end
		
		if veh ~= 0 and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and GetVehiclePedIsIn(PlayerPedId(), false) then
			_menuPool:ProcessMenus()
		end
		Citizen.Wait(0)
	end


end)