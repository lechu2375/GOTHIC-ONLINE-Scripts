addEventHandler("onKey",function(key)
{
    if(key==KEY_G)
    {
        playAni(heroId,"T_PLUNDER");

        local closestVobPuckupable = null
        local closestDist = 301
        local heroPos = getPlayerPosition(heroId)

        foreach(id,vobPickupable in vobPickupableList)
        {
            local vobPos = vobPickupable.getPosition()
            local distance = getDistance3d(heroPos.x,heroPos.y,heroPos.z,vobPos.x,vobPos.y,vobPos.z)

            if(distance<closestDist)
            {
                closestDist = distance
                closestVobPuckupable = vobPickupable
            }
        }

        if(closestVobPuckupable)
        {
            print("found vob!!")
            RequestPickup(closestVobPuckupable.id)
        }
        else
        {
            print("Not found vob.")
            RequestPickup(0)   
        }
            
        
    }
})


function RequestPickup(vobPickupableID)
{
    local packet = Packet();
    packet.writeUInt8(PacketId.vobPickupableRequest);
    packet.writeUInt8(vobPickupableID); //id vobPickupable
    packet.send(RELIABLE)
}


addEventHandler("onPacket",function(packet)
{
    local packetid = packet.readUInt8();

    switch(packetid)
    {
        case PacketId.vobPickupableUpdate:
        {
            local vobID = packet.readUInt8();
            
            local x =  packet.readFloat()
            local y = packet.readFloat()
            local z = packet.readFloat()
            local angle = packet.readUInt8()
            local visual = packet.readString()
            local toPickup = packet.readString()

            if(vobID in vobPickupableList)
                vobPickupableList[vobID].update(x,y,z,angle,visual,toPickup)
            else
                vobPickupable(x,y,z,angle,visual,toPickup)
            
            break;
        }
        case PacketId.vobPickupableRemove:
        {
            local vobID = packet.readUInt8();
            print("REMOVE VOBpickupable ID"+vobID)
            if(vobID in vobPickupableList)
                delete vobPickupableList[vobID]            
        }
    }



});