local function packetHandler(packet)
{
	local id = packet.ReadUInt16();
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
            local visual = packet.readString();
            if(vobID in vobTable)
            {
                ChangeParentForVobFollower(vobID,parentID);
                ChangeVisualForVobFollower(vobID,visual);
            }
            else
                CreateVobFollower(visual,parentID,vobID);
        }
        case PacketId.VobFollowerPARENTUPDATE:
        {
            local vobID = packet.readUInt8();
            local parentID = packet.readUInt8();
            ChangeParentForVobFollower(vobID,parentID);    
        }
    }

}

addEventHandler("onPacket", packetHandler);

