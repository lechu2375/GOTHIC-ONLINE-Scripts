vobPickupableList <- {}
class vobPickupable extends Vob
{
    infoDraw = null
    id = null
    available = null 
    toPickup = null
    constructor(x,y,z,angle,visual,toPickupVisual)
	{
        base.constructor(visual)
		cdDynamic = false
        cdStatic = false

        setPosition(x,y,z)
        setRotation(0,angle,0)

        addToWorld()
        floor()

        infoDraw = Draw3d(x,y,z)
        infoDraw.visible = true
        infoDraw.distance = 300
        infoDraw.insertText("Wciœnij G by podnieœæ")

        toPickup = toPickupVisual

        id = vobPickupableList.len()+1
        vobPickupableList[id] <- this

	}
    function update(x,y,z,angle,vobVisual,toPickupVisual)
    {
        local position = getPosition()
        if(x)
            position.x=x
        if(y)
            position.x=y
        if(z)
            position.x=z

        setPosition(position.x,position.y,position.z)
        
        if(angle)
            setRotation(0,angle,0)  
        if(vobVisual)
            visual = vobVisual
        if(toPickupVisual)
            toPickup = toPickupVisual            
    }


}


