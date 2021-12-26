const REQUEST_DESC = 2123;
vobTable <- {};
local offsetTable = {};

offsetTable["ITMI_GOLDCANDLEHOLDER.3DS"] <- 
{
    posOffset = { x = 0, y=0, z=0},//x lewo prawo ,y gora dó³, z przód ty³
    angleOffset = {x = 0 , y = 0, z = 0}
}
offsetTable["NC_LOB_LOG1.3DS"] <- 
{
    posOffset = { x = 0, y=0, z=30},
    angleOffset = {x = 0 , y = 0, z = 0} // yaw wokó³ osi gracz
}
offsetTable["OC_SACK_V03.3DS"] <- //worek
{
    posOffset = { x = 0, y=-10, z=40},
    angleOffset = {x = 0 , y = 0, z = 0} 
}
offsetTable["NW_CITY_CART_01.3DS"] <-  //wuzek
{
    posOffset = { x = 0, y=-40, z=-120},
    angleOffset = {x = 20 , y = 180, z = 0} 
}
offsetTable["OC_SAECKE_01.3DS"] <- //worki na wuzku
{
    posOffset = { x = 0, y=10, z=-190},
    angleOffset = {x = 0 , y = 90, z = 0} 
}
offsetTable["NW_HARBOUR_CRATE_01.3DS"] <- 
{
    posOffset = { x = 0, y=80, z=55},
    angleOffset = {x = 0 , y = 0, z = 0}  
}

function CreateVobFollower(vobVisual,playerID,vobID)
{
    if(vobID in vobTable)
        return false

    local vob =  Vob(vobVisual)
    vob.cdStatic = false;
    vob.cdDynamic = false;
    local currentPosition
    local currentRotation
    if(!playerID)
        playerID = heroId;
    
    currentPosition = getPlayerPosition(playerID); 
    currentRotation = getPlayerAngle(playerID);


        

    vob.setPosition(currentPosition.x,currentPosition.y,currentPosition.z);
    vob.setRotation(0, currentRotation, 0);
    vob.addToWorld();
    local index = vobTable.len()+1
    vobTable[index] <-  { pid = playerID, vob = vob} ;


    return index;

}
local function UpdateVobFollowerPos()
{
    local currentPosition //obecna pozycja gracza
    local pAngle //obecny obrót
    local angle // radiany
    local scale //skala (potem dodam wsparcie xd)
    local direction 
    local playerID
    local vob
    foreach(index, table in vobTable)
    {
        playerID = table.pid

        if(playerID==-1) 
        continue;

        vob = table.vob
        pAngle = getPlayerAngle(playerID)
        currentPosition = getPlayerPosition(playerID); 
        angle =  pAngle * PI / 180.0;
        direction = { x = sin(angle), z = cos(angle) };


        
        if(vob.visual in offsetTable)
        {
            currentPosition.x=currentPosition.x+direction.x*offsetTable[vob.visual].posOffset.z;
            currentPosition.y+=offsetTable[vob.visual].posOffset.y;
            currentPosition.z=currentPosition.z+direction.z*offsetTable[vob.visual].posOffset.z;
            vob.setRotation(offsetTable[vob.visual].angleOffset.x, pAngle+offsetTable[vob.visual].angleOffset.y, offsetTable[vob.visual].angleOffset.z);
        }
        else
        {
            currentPosition.x=currentPosition.x+direction.x;
            currentPosition.z=currentPosition.z+direction.z;
            vob.setRotation(0, pAngle, 0);
        }
        
        vob.setPosition(currentPosition.x,currentPosition.y,currentPosition.z);
        

    }
}

function ChangeVisualForVobFollower(vobID,visual)
{
    if(id in vobTable)
        vobTable[id].vob.visual = visual 
}

function ChangeParentForVobFollower(vobID,parent)
{
    if(id in vobTable)
        vobTable[id].pid = parent 
}

function RemoveVobFollowerWithID(id)
{
    if(id in vobTable)
    {
        vobTable[id].vob = null
        delete vobTable[id]
    }
}

function RemoveAllVobsFor(pid)
{
    foreach(index,table in vobTable)
    {
        if(table.pid == pid)
        {
            table.vob = null
            delete vobTable[index]
        }

    }
}

function RemoveVobWithVisualFor(pid,visual)
{
    foreach(index,table in vobTable)
    {
        if(table.pid == pid && table.vob.visual == visual)
        {
            table.vob.removeFromWorld()
            table.vob = null
            delete vobTable[index] //mog¹ byæ dwie kopie, na razie to nie ma sensu bo ten sam offset ale mo¿e w przysz³oœæi tego breaka mozna wyjebac
            
        }

    }
}
function RemoveVobParent(id) 
{
    if(id in vobTable)
    {
        vobTable[id].vob.floor();
        vobTable[id].pid = -1;
    }
}


addEventHandler("onCommand",function(cmd, params)
{
	if(cmd == "test" || (params =="odloz" || params =="podnies") ) // if player types "vob" command, then..
	{
        playAni(heroId,"T_PLUNDER")

	};
    if(cmd == "wozek") // if player types "vob" command, then..
	{
        CreateVobFollower("NW_CITY_CART_01.3DS",heroId);

	};
    if(cmd == "zostaw")
    {
        RemoveVobParent(1);
        RemoveVobParent(2);
        //RemoveAllVobsFor(heroId);
    }
    if(cmd == "skrzynia")
    {
        CreateVobFollower("NW_HARBOUR_CRATE_01.3DS",heroId);
    }


});







addEventHandler("onRender",UpdateVobFollowerPos)

local function initHandler() 
{     
	enableEvent_Render(true); // Enable "onRender" event.
}   

addEventHandler("onInit", initHandler);


