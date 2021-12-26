/*
Tworzenie nowego vob followera = CreateVobFollower(string vobVisual, int playerID)
Zmiana parenta vobFollowera = SetVobFollowerParent(int vobID, int parent) w przypadku -1 vob zostaje w "powietrzu"
Aktualizacja informacji o vobFollowerze = UpdateVobFollower(int id, enum VobFollowerAction,int pid) 
*/
vobTable <- {};

function CreateVobFollower(vobVisual,playerID)
{


    if(!playerID)
        return false

    local index = vobTable.len()+1
    vobTable[index] <-  { pid = playerID,visual = vobVisual} ;
    return index;

}
enum VobFollowerAction
{
    REMOVE,
    PARENTUPDATE,
    WHOLEUPDATE
}

function SetVobFollowerParent(vobID,parent) //-1 zostaje w powietrzu
{
    vobTable[vobID].pid = parent
    UpdateVobFollower(vobID, VobFollowerAction.UpdateVobFollower,-1)
}

function UpdateVobFollower(id, VobFollowerAction,pid) //pid -1 = leci na broadcast, reszta dla konkretnego ludzika
{
    switch(action)
    {
        case VobFollowerAction.WHOLEUPDATE:
        {
            local vobTable = vobTable[id];
            local packet = Packet();
            packet.writeUInt16(PacketId.VobFollowerWHOLEUPDATE);
            packet.writeUInt8(id); //id vobfollowera
            packet.writeUInt8(vobTable.pid); //id gracza rodzina parenta kurwa
            packet.writeString(vobTable.visual); //model okuratny i sprawiedliwy
            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid)
            break;
        }
        case VobFollowerAction.PARENTUPDATE:
        {
            local vobTable = vobTable[id];
            local packet = Packet();
            packet.writeUInt16(PacketId.VobFollowerPARENTUPDATE);
            packet.writeUInt8(id)
            packet.writeUInt8(vobTable.pid);
            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid)
            break;            
        }
        case VobFollowerAction.REMOVE: //wysyłka id do usuniecia
        {

            local vobTable = vobTable[id];
            local packet = Packet();
            packet.writeUInt16(PacketId.VobFollowerREMOVE);
            packet.writeUInt8(id); 
            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid)

            delete vobTable[id]
            break;
        }
    }
}