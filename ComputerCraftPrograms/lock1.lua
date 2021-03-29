-- the list of allowed disks... it uses their ID, since in survival you will never have a disk with the same ID.
-- to add more, add the id on the left, followed by     = true,
local allowedDisksIds = {
  1 = true,
  2 = true,
  3 = true,
}
 
-- the side to check for disks
local diskSide = 'bottom'
-- the side the door, or the cable to the door is on
local rsSide = 'right'
 
-- this checks if it is an accepted disk 
local function isValid()
  -- we get the disk ID
  local diskId = disk.getDiskID and disk.getDiskID(diskSide) or disk.getID(diskSide) -- support for old versions of ComputerCraft
  -- we return the value from the allowed disks table (it will be true or nil/false)
  return allowedDisksIds[diskId]
end
 
-- wait for x amount of time, it is a termination safe sleep function
local function wait( dur )
  dur = type(dur) == 'number' and dur or 1
  local t = os.startTimer(dur)
  repeat
    local _, p = os.pullEventRaw('timer')
  until p == t
end
 
-- the main text while it is waiting for a disk
local function text()
  term.clear()
  term.setCursorPos(1,1)
  print("Please insert disk to enter...")
end
 
-- this is the main function
local function diskCheck()
  -- infinitely loop
  while true do
    -- draw the GUI
    text()
    -- wait here until a disk is inserted
    local _, side = os.pullEvent('disk')
    -- if the disk inserted is on the correct side, and it has a valid id
    if side == diskSide and isValid() then
      -- give entry
      rs.setOutput(rsSide, true)
      -- tell them they have entry
      term.setCursorPos(1,2)
      write("ACCESS GRANTED")
      -- eject their disk
      disk.eject(diskSide)
      -- wait 3 seconds
      wait(3)
      -- close the door
      rs.setOutput(rsSide, false)
    else
      -- if their card wasn't valid, or they inserted in a disk drive on another side, eject the disk
      disk.eject(side)
      -- wait for 10 seconds
      wait(10)
    end
  end
end
 
-- run the main function
diskCheck()