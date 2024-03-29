/*
Tworzenie nowego vob followera = CreateVobFollower(string vobVisual, int playerID) zwraca id z tabeli
Zmiana parenta vobFollowera = SetVobFollowerParent(int vobID, int parent) w przypadku -1 vob zostaje w "powietrzu"
Aktualizacja informacji o vobFollowerze = UpdateVobFollower(int id, enum VobFollowerAction,int pid) 
*/
vobTable <- {};

enum VobFollowerAction
{
    REMOVE,
    PARENTUPDATE,
    WHOLEUPDATE
}

function CreateVobFollower(vobVisual,playerID)
{
    local index = vobTable.len()+1
    vobTable[index] <-  { pid = playerID,visual = vobVisual};
    //print("Created vobFollower with id"+index)
    UpdateVobFollower(index, VobFollowerAction.WHOLEUPDATE,-1)
    return index;
}


function SetVobFollowerParent(vobID,parent) //-1 zostaje w powietrzu
{
    vobTable[vobID].pid = parent
    UpdateVobFollower(vobID, VobFollowerAction.PARENTUPDATE,-1)
}

function UpdateVobFollower(id, action,pid) //pid -1 = leci na broadcast, reszta dla konkretnego ludzika
{

    switch(action)
    {
        case VobFollowerAction.WHOLEUPDATE:
        {
            local vobTable = vobTable[id];
            local packet = Packet();
            packet.writeUInt8(PacketId.VobFollowerWHOLEUPDATE);
            packet.writeUInt8(id); //id vobfollowera

            if(vobTable.pid==-1)
                packet.writeUInt8(getMaxSlots()+1);
            else
                packet.writeUInt8(vobTable.pid); //id gracza rodzina parenta kurwa
                packet.writeString(vobTable.visual); //model okuratny i sprawiedliwy
            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid,RELIABLE)

            break;
        }
        case VobFollowerAction.PARENTUPDATE:
        {
            local vobTable = vobTable[id];
            local packet = Packet();
            packet.writeUInt8(PacketId.VobFollowerPARENTUPDATE);
            packet.writeUInt8(id)

            if(vobTable.pid==-1)
                packet.writeUInt8(getMaxSlots()+1);
            else
                packet.writeUInt8(vobTable.pid); //id gracza rodzina parenta kurwa

            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid,RELIABLE)

            break;            
        }
        case VobFollowerAction.REMOVE: //wysyłka id do usuniecia
        {



            local packet = Packet();
            packet.writeUInt8(PacketId.VobFollowerREMOVE);
            packet.writeUInt8(id); 

            if(pid==-1)
                packet.sendToAll(RELIABLE)
            else
                packet.send(pid,RELIABLE)

            if(id in vobTable)
                delete vobTable[id]

                
                
            
            break;
        }
    }
}