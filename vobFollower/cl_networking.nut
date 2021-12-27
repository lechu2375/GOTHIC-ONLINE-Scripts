local function packetHandler(packet)
{
    
	local id = packet.readUInt16();
    print("packet "+id)
    switch(id)
    {
        case PacketId.VobFollowerREMOVE:
        {
            local vobID = packet.readUInt8();
            RemoveVobFollowerWithID(vobID);
            
            break;
        }
        case PacketId.VobFollowerWHOLEUPDATE:
        {
            local vobID = packet.readUInt8();
            local parentID = packet.readUInt8();
            if(parentID==getMaxSlots()+1)
                parentID = -1
            local visual = packet.readString();
            if(vobID in vobTable)
            {
                ChangeParentForVobFollower(vobID,parentID);
                ChangeVisualForVobFollower(vobID,visual);
            }
            else
                CreateVobFollower(visual,parentID,vobID);

            
            break;
        }
        case PacketId.VobFollowerPARENTUPDATE:
        {
            //chatInputSetText("parent update")
            local vobID = packet.readUInt8();
            local parentID = packet.readUInt8();
            if(parentID==getMaxSlots()+1)
                parentID = -1


            ChangeParentForVobFollower(vobID,parentID);    
            
            break;
        }

    }

}

addEventHandler("onPacket", packetHandler);

