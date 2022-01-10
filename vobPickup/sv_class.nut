vobPickupableList <- {}
class vobPickupable 
{
    
    id = null
    available = null 
    toPickup = null
    visual = null
    angle = null
    position = null
    singlePickup = null
    function Update(pid)
    {
        
        local packet = Packet();
        packet.writeUInt8(PacketId.vobPickupableUpdate);
        packet.writeUInt8(id);
        packet.writeFloat(position.x)
        packet.writeFloat(position.y)
        packet.writeFloat(position.z)
        packet.writeUInt8(angle)
        packet.writeString(visual)
        packet.writeString(toPickup)
        if(pid==-1)
            packet.sendToAll(RELIABLE)  
        else
            packet.send(pid,RELIABLE)        
    }

    constructor(xPos,yPos,zPos,vobAngle,vis,toPickupVisual)
	{
        available = true
        position = { x = xPos, y = yPos, z = zPos}

        singlePickup = false
        angle = vobAngle
        visual = vis
        toPickup = toPickupVisual

        id = vobPickupableList.len()+1
        vobPickupableList[id] <- this

        Update(-1);
	}
    

}


function vobPickupableRemove(id)
{


    local packet = Packet();
    packet.writeUInt8(PacketId.vobPickupableRemove);
    packet.writeUInt8(id);
    packet.sendToAll(RELIABLE)
    if(id in vobPickupableList)
    delete vobPickupableList[id]

}

addEventHandler("onInit",function()
{
    vobPickupable(1310, -90, 332,180,"NW_MISC_BOARDS_01A.3DS","NC_LOB_LOG1.3DS")
    vobPickupable(768, -83, 1148,0,"NW_MISC_BOARDS_01C.3DS","NC_LOB_LOG1.3DS")
    vobPickupable(752, -81, -986,0,"NW_HARBOUR_CRATEPILE_01.3DS","NW_HARBOUR_CRATE_01.3DS")



})

addEventHandler("onPlayerDisconnect",function(pid)
{
    if(vobPickupablePlayer[pid])
    {
        UpdateVobFollower(vobPickupablePlayer[pid], VobFollowerAction.REMOVE,-1);
        vobPickupablePlayer[pid] = false
    }



})

addEventHandler("onPlayerJoin",function(pid)
{
    foreach(id,vobPickupable in vobPickupableList)
    {
        vobPickupable.Update(pid);
    }
})



addEventHandler("onPlayerChangeWeaponMode",function(playerid, oldWeaponMode, newWeaponMode)
{

    if(newWeaponMode!=WEAPONMODE_NONE && vobPickupablePlayer[playerid])
    {
        setPlayerWeaponMode(playerid,WEAPONMODE_NONE)      
    }


})
 