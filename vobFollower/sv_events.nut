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

local function testCmd(cmd,params)
{
    
}


addEventHandler("onCommand", testCmd);
