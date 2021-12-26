local function joinHandle(pid)
{
    foreach(index,_ in vobTable)
    {
        UpdateVobFollower(index, VobFollowerAction.WHOLEUPDATE,pid)
    }
}

addEventHandler("onPlayerJoin", joinHandle);

local function disconnectHandle(pid)
{
    foreach(index,table in vobTable)
    {
       if(table.pid == pid)
        UpdateVobFollower(index, VobFollowerAction.REMOVE,-1)
    }
}
addEventHandler("onPlayerDisconnect", joinHandle);
local vobID;
local function testCmd(pid,cmd,params)
{
    if(cmd=="test")
    {
        
        if(params=="podnies")
        {
            
            print("Timer start")
            local id = setTimer(function()
            {
                print("TIIIMER")
                vobID = CreateVobFollower("OC_SACK_V03.3DS",pid);
                applyPlayerOverlay(pid, Mds.id("HUMANS_CARRYBARREL.MDS"))
            },3000,1)


            
        }
        if(params=="odloz")
        {
            SetVobFollowerParent(vobID,-1);
            removePlayerOverlay(pid, Mds.id("HUMANS_CARRYBARREL.MDS"))
            
        }        
    }
}


addEventHandler("onPlayerCommand", testCmd);
