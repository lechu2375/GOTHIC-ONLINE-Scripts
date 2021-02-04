local DRAW_TABLE = [];


const UPDATE_DRAWS = 2121;
const REMOVE_DRAW = 2122;
addEventHandler("onPlayerCommand",function(pid,cmd,params)
{
    switch (cmd)
    {
    case "newdraw":
        //sendMessageToAll(255, 255, 255, "niby smiga SV");
        local args = sscanf("s",params);
        if(args){
        local vec = getPlayerPosition(pid);
        local text = args[0];

        local toSave = {
        x = vec.x,
        y = vec.y,
        z = vec.z,
        text = text,
        visible = true
        };
        
        DRAW_TABLE.append(toSave);

        packet <- Packet();
        packet.writeUInt16(UPDATE_DRAWS);
        packet.writeInt32(vec.x);
        packet.writeInt32(vec.y);
        packet.writeInt32(vec.z);
        packet.writeString(text);
		packet.sendToAll(RELIABLE_ORDERED);



        SaveDraws();


        }break;
    
        case "removedraw":
                //if(!getStat(pid, "admin") && !getStat(pid, "gm") && !getStat(pid, "support"))
                local localPlayerPos = getPlayerPosition(pid);
                //sendMessageToAll(255, 255, 255,"zda");
                foreach (id, draw in DRAW_TABLE) {
                    
                    local distance = getDistance3d(draw.x,draw.y,draw.z,localPlayerPos.x,localPlayerPos.y,localPlayerPos.z)
                    if(distance>50)
                        continue;
                        //sendMessageToAll(255, 255, 255,"Wybrano drawa nr:"+id+"Odleglosc boza:"+distance);
                        //sendMessageToAll(255, 255, 255,"Zawartosc:"+draw.text);
                            packet <- Packet();
                            packet.writeUInt16(REMOVE_DRAW);
                            packet.writeInt32(draw.x);
                            packet.writeString(draw.text);
                            draw.visible = false;

                            packet.sendToAll(RELIABLE_ORDERED);
                            
                    break;
                }
                SaveDraws();
        break;        
    }
});

function LoadDrawsFromFiles()
{


    for(local i=0;i<255;i+=1){
        local path = "draws/draws"+i;

        
        local readFile = File(path);
        if(readFile.exists()){
            print("File Exists");
            readFile.open("r+"); 


            local xPos = readFile.readLine();
            local yPos = readFile.readLine();
            local zPos = readFile.readLine();
            local textDraw = readFile.readLine();
            local shouldRead = readFile.readLine();
            if(shouldRead=="y"){
                local toSave = {
                x = xPos.tofloat(),
                y = yPos.tofloat(),
                z = zPos.tofloat(),
                text = textDraw,
                visible = true
                };
                DRAW_TABLE.append(toSave);                
            }

            readFile.close();
        }
        else{
            //print("Nie ma takiego drawu"+i);
            break;
        }



    }
    


}

function SaveDraws()
{
    foreach (id, draw in DRAW_TABLE) {   
        local path = "draws/draws"+id    
            local myFile = File(path);
            myFile.open("w+");
            myFile.writeLine(draw.x);
            myFile.writeLine(draw.y);
            myFile.writeLine(draw.z);
            myFile.writeLine(draw.text);

            if(draw.visible)
            myFile.writeLine("y");
            else
            myFile.writeLine("n");

            myFile.close();
    }
}

function DrawLoad(pid)
{
    foreach (num, table in DRAW_TABLE) {
        if(!table.visible)
            continue;
        packet <- Packet();
        packet.writeUInt16(UPDATE_DRAWS);
        packet.writeInt32(table.x);
        packet.writeInt32(table.y);
        packet.writeInt32(table.z);
        packet.writeString(table.text);
        
        packet.send(pid, RELIABLE_ORDERED);
    }
}

addEventHandler("onPlayerJoin", DrawLoad);
addEventHandler("onInit", LoadDrawsFromFiles);



//if(!getStat(pid, "admin") && !getStat(pid, "gm") && !getStat(pid, "support"))