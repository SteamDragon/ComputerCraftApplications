function convertOfFE(fe)
	type="FE"
	convertedFE=fe;
    if math.floor(convertedFE/1000) > 0 
    then
        type= "kFE"
        convertedFE=fe/1000
    end

    if math.floor(convertedFE/1000) > 0 
    then
        type= "MFE"
        convertedFE=fe/1000000
    end
	return convertedFE,type
end

function removeEnding(stroka)
    return string.match(stroka, ".*%d")
end

function numberFormat(stroka)
    res, _ = string.gsub(removeEnding(stroka):gsub(',$', ''), ',', '')
    return tonumber(res)
end

local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
local cube = peripheral.find("ultimateEnergyCube")
local createTarget = peripheral.find("create_target")
rednet.open("back")
local debug = true

monitor.write(modem.getMethodsRemote("create_target_0"))
local w,h = monitor.getSize()
term.redirect(monitor)
monitor.clear()
monitor.setBackgroundColor(colors.black)
paintutils.drawFilledBox(1, 1, w, h, colors.black)
paintutils.drawFilledBox(1, 1, w, h, colors.gray)
paintutils.drawFilledBox(2,2,w-1,h-1,colors.lightGray)
monitor.setTextColor(colors.black)
while true
do
    paintutils.drawBox(1, 1, w, h, colors.black)
    monitor.setCursorPos(1+w/20,1)
    local currentEnergy = cube.getEnergy() * 0.4
    local convertedCurrentEnergy, currentType = convertOfFE(currentEnergy)
    local maxEnergy = cube.getMaxEnergy() * 0.4
    local convertedEnergyMax, typeMax = convertOfFE(maxEnergy)    
    local storagepercent = cube.getEnergyFilledPercentage()
    rednet.broadcast(string.format("FE: %.2f %s / %.2f %s", convertedCurrentEnergy, currentType, convertedEnergyMax, typeMax),"Energy")
    local currentSU = numberFormat(createTarget.getLine(1))
    local maxSU = numberFormat(createTarget.getLine(2))    
    suPercent = currentSU/maxSU
    rednet.broadcast(string.format("SU: %s / %s", currentSU, maxSU),"SU")

    rednet.broadcast(string.format("Lava: %s", createTarget.getLine(3)),"Lava")
    paintutils.drawBox(3, 4, w-2, 4, colors.gray)
    paintutils.drawBox(3, 4, 3+math.floor((w-3)*storagepercent), 4, colors.green)
    paintutils.drawBox(3, 8, w-2, 8, colors.gray)
	local suColor = colors.green;
	if((maxSU - currentSU) < maxSU * 0.1)
	then
		suColor = colors.red
	end 

	if((maxSU - currentSU) < maxSU * 0.25)
	then
		suColor = colors.yellow
	end 
    paintutils.drawBox(3, 8, 2+math.floor(w*suPercent), 8, suColor)    
	paintutils.drawBox(w-2, 4, w-1, 8, colors.lightGray)
	paintutils.drawBox(w-2, 4, w-1, 4, colors.lightGray)
	
    monitor.setBackgroundColor(colors.lightGray)
    monitor.setCursorPos(3, 3)
    monitor.write(string.format("FE:          %.2f %s / %.2f %s", convertedCurrentEnergy, currentType, convertedEnergyMax, typeMax))
    monitor.setCursorPos(3, 7)
    monitor.write(string.format("SU:          %s / %s", currentSU, maxSU))

if(debug)
then
    monitor.setCursorPos(3, 10)
    monitor.write(string.format("storagepercent:          %s", storagepercent))
    monitor.setCursorPos(3, 11)
    monitor.write(string.format("Current SU:          %s", createTarget.getLine(1)))
    monitor.setCursorPos(3, 12)
    monitor.write(string.format("Max SU:          %s", createTarget.getLine(2)))
    monitor.setCursorPos(3, 13)
    monitor.write(string.format("suPercent:          %s", suPercent))
    monitor.setCursorPos(3, 14)
    monitor.write(string.format("Lava:          %s", createTarget.getLine(3)))
end
end
