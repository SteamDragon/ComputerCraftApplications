rednet.open("back")
term.clear()
while true
do
local senderId, message, protocol = rednet.receive("Energy")
term.setCursorPos(1, 1)
term.write(message)
senderId, message, protocol = rednet.receive("SU")
term.setCursorPos(1, 2)
term.write(message)
senderId, message, protocol = rednet.receive("Lava")
term.setCursorPos(1, 3)
term.write(message)
sleep(50)
term.clear()
end
