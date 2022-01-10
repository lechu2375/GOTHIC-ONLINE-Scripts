vobPickupablePlayer <- array(getMaxSlots(),false);
addEventHandler("onPacket",function(pid,packet)
{
    local packetid = packet.readUInt8();
    if(packetid==PacketId.vobPickupableRequest)
    {
        local vobPickupableID = packet.readUInt8();

        

        if(vobPickupablePlayer[pid]) //jak ma coœ w rêkach juz aka vobFollower
        {

            
            local playerPos = getPlayerPosition(pid)
            local vobFollowerId = vobPickupablePlayer[pid]
            local vobFollowerInfo = vobTable[vobFollowerId]



            local singlePickupVob = vobPickupable(playerPos.x,playerPos.y,playerPos.z,0,vobFollowerInfo.visual,vobFollowerInfo.visual)
            singlePickupVob.singlePickup = true



            UpdateVobFollower(vobFollowerId, VobFollowerAction.REMOVE,-1); //usuwamy to co ma w rêkach

            vobPickupablePlayer[pid] = false

            local ids = setTimer(function()
            {
                removePlayerOverlay(pid, Mds.id("HUMANS_CARRYBARREL.MDS"));
            },1000,1) 

            
        }
        else if(vobPickupableID in vobPickupableList) //jak mozna cos podniesc
        {

            local vobTable = vobPickupableList[vobPickupableID]
            local vobPosition = vobTable.position
            local playerPos = getPlayerPosition(pid)

                if(getDistance3d(playerPos.x,playerPos.y,playerPos.z,vobPosition.x,vobPosition.y,vobPosition.z)<=400)
                {
                    
                    vobPickupablePlayer[pid] = CreateVobFollower(vobTable.toPickup,pid)


                        if(vobTable.singlePickup)
                            vobPickupableRemove(vobTable.id)

                    local ids = setTimer(function()
                    {
                        applyPlayerOverlay(pid, Mds.id("HUMANS_CARRYBARREL.MDS"))
                    },1000,1)                
                }

        }
    }
});