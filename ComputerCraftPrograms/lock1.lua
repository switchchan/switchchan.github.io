--Allowed floppy ID. This code only allows 1 floppy to be inserted, but you can easily modify it to have multiple allowed.
allowedID = 92
 
--Variable for which side the redstone will be at
redstoneSide = 'right'
 
--Variable for which side your disk drive will be on. You can also change it to networked positions
diskSide = 'bottom'
 
--Checks to see if it's the correct disk
local function isCorrect()
    diskID = disk.getID(diskSide)
    if diskID == allowedID then
        return true
    else
        return false
    end
end
 
--Function that just waits a given number of seconds
local function wait( dur )
    dur = type(dur) == 'number' and dur or 1
    local t = os.startTimer(dur)
    repeat
        local _, p = os.pullEventRaw('timer')
    until p == t
end
 
--Standby text
local function text()
    term.clear()
    term.setCursorPos(1,2)
    print("Insert Disk")
end
 
--waits until a disk is inserted and then runs isCorrect() in order to figure out what to do next
local function checkDisk()
    while true do
        text()
        local _, side = os.pullEvent('disk')
        if isCorrect() == true then
            rs.setOutput(redstoneSide, true)
            term.setCursorPos(1,2)
            term.clear()
            print("GRANTED")
            disk.eject(diskSide)
            wait(3)
                rs.setOutput(redstoneSide, false)
        else
            disk.eject(diskSide)
            term.clear()
            print("Denied.")
            wait(10)
        end
    end
end
 
checkDisk()