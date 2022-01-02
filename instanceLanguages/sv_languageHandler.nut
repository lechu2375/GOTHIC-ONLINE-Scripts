instanceLanguage <- {}


instanceLanguage.GetAbilityLevel <- function(pid) //zaimplementowac se branie z bazy danych albo inny chuj
{
    return 20;
}

instanceLanguage.GetMixedMessage <- function(message,abilityLevel)
{
    //local space = 32
 
    abilityLevel*=1.1

        
    
    local mixedMessage = array(message.len())
    local bonus = 0
    local upper = false
    foreach(index, letter in message) 
    {

        if(letter==46)
        {
            upper = true
        }

        if(letter==32)
        {
            mixedMessage[index] = 32
            continue            
        }

        if(letter==44 || letter==46 || letter==63)
        {
            if(abilityLevel>=50) 
                mixedMessage[index] = letter
            else 
                mixedMessage[index] = 32
            continue            
        }

        if((rand()%100)<=abilityLevel)
        {
            if(upper)
            {
                upper = false
                mixedMessage[index] = letter+255
            }
            else
                mixedMessage[index] = letter

            bonus=0            
        }
        else
        {
            if(bonus && (rand()%100)<=abilityLevel )
            {
                if(upper)
                {
                    mixedMessage[index] = letter+255
                    upper = false                   
                }
                else
                    mixedMessage[index] = letter

                bonus = 0;
                continue;
            }
            bonus=1;
            if(upper)
            {
                mixedMessage[index] = rand() % (122 + 1 - 97) + 97 +255 
                upper = false
            }
            else
                mixedMessage[index] = rand() % (122 + 1 - 97) + 97
            
        }

    }

    local msg = ""
    foreach(i,char in mixedMessage)
    {

        if(char>255)
        {
            char-=255
            
            msg+=char.tochar().toupper()             
        }
        if(i==0)
        msg+=char.tochar().toupper()  
        else
        msg+=char.tochar()       
    }

    return msg
}

instanceLanguage.GetMixedMessage("Greetings, im the Orc. Im here to conquer your race.",50)

/*
function IsOrc(pid)
{
    local instance = getPlayerInstance(pid)
    if(instance.find("ORC"))
        return true
    else
        return false
}


//Obs³uga czatów IC itp kto chce.
addEventHandler("onPlayerMessage", function(senderID,message)
{

    if(IsOrc(senderID))
    {

    }
});

*/