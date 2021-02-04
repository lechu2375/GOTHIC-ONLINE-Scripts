const UPDATE_DRAWS = 2121;
const REMOVE_DRAW = 2122;
local DRAW_TABLE = [];

addEventHandler("onPacket", function(packet)
{
	local id = packet.readUInt16();
    Chat.print(255, 255, 0,id);
	if (id == UPDATE_DRAWS)
	{
        local x = packet.readInt32();
        local y = packet.readInt32();
        local z = packet.readInt32();
        local text = packet.readString();


        local draw = Draw3d(x,y,z);
        draw.distance = 1000;
        draw.insertText(text);
        draw.visible = true;
        DRAW_TABLE.append(draw);




	}
    if (id == REMOVE_DRAW)
	{
        Chat.print(255, 255, 0,"mhm");
        local x = packet.readInt32();
        local text = packet.readString();
        foreach (id, draw in DRAW_TABLE) {
            local dtext = draw.getText()[1];
            local dpos = draw.getWorldPosition();
            Chat.print(255, 0, 0,"s"+dtext);
            if(dtext==text && dpos.x==x){
                draw.visible = false;
                
            }
        }
	}
});


function DrawHuj(cmd,params)
{
    Chat.print(255, 255, 0,cmd);
	if (cmd == "getdraws"){
        local localPlayerPos = getPlayerPosition(heroId);
        foreach (id, draw in DRAW_TABLE) {
            local posTable = draw.getWorldPosition();
            Chat.print(255, 255, 0,"ID Drawu:"+id+"Dystans od gracza:"+getDistance3d(posTable.x,posTable.y,posTable.z,localPlayerPos.x,localPlayerPos.y,localPlayerPos.z));
            Chat.print(255, 255, 0,"Tekst:"+draw.getText()[1]);
        }
	}
    

	
}

addEventHandler("onCommand", DrawHuj);



