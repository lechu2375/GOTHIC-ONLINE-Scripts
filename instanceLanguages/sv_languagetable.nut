    foreach(index, word in message) //dla każdego ciagu znaków (słowa)oddzielonego spacją
    {
        local currentLen = word.len()
        local goodPosition = 0 


        local changedWord = array(currentLen)//array na literki w pozmienianej kolejności, potem go skleimy w stringa bożego

        for(local i = 0;i<currentLen;i++)
        {

            local usedChars = array(currentLen) //array z pozycjami literek już użytych
            if(goodPosition>i) //pierwsze x będzie na poprawnej pozycji
            {
                changedWord[i] = word[i];    //uzupełniamy arraya z pomieszanymi literkami, tutaj na dobrych pozycjach
                usedChars[i] = true;   //tą literke już użyliśmy
                print("Na dobrej pozycji ma byc:"+word[i].tochar())
                continue;     
            }
            local randomChar = 0 //ktora literka tym razem
            
            do
            {
                //print("relosowanie bo "+word[randomChar].tochar()+" juz uzyty")
                randomChar = rand()%currentLen
            }while(usedChars[randomChar]==true)
            print(usedChars[randomChar],word[randomChar].tochar())
            print("rand "+randomChar+" len "+currentLen)

            changedWord[i] = word[randomChar];    //uzupełniamy arraya z pomieszanymi literkami, tutaj na dobrych pozycjach
            usedChars[randomChar] = true; 
        }

        local word = "" //skklejamy arraya z literkami
        foreach(_,char in changedWord)
            word+=char.tochar()

        mixedMessage+=word 
    }



///////////////////////

instanceLanguage <- {}


instanceLanguage.GetAbilityLevel <- function(pid) //zaimplementowac se branie z bazy danych albo inny chuj
{
    return 20;
}

instanceLanguage.GetMixedMessage <- function(message,abilityLevel)
{
    //local space = 32
 
    abilityLevel*=1.1
    if(!abilityLevel)
        abilityLevel = 10
        
    
    local mixedMessage = array(message.len())
    foreach(index, letter in message) 
    {
        
        if(letter==32)
        {
            mixedMessage[index] = 32
            continue            
        }

        if(letter==44 || letter==46)
        {
            if(abilityLevel>=50) 
                mixedMessage[index] = letter
            else 
                mixedMessage[index] = 32
            continue            
        }

        if(rand()%100<=abilityLevel)
            mixedMessage[index] = letter
        else
            mixedMessage[index] = rand() % (122 + 1 - 97) + 97
    }

    local msg = ""
    foreach(_,char in mixedMessage)
        msg+=char.tochar()
    print(msg)
    return mixedMessage



}
instanceLanguage.GetMixedMessage("Witajcie, jestesmy orkami. Przybywamy was najechac.",30)
instanceLanguage.GetMixedMessage("Witajcie, jestesmy orkami. Przybywamy was najechac.",50)
instanceLanguage.GetMixedMessage("Witajcie, jestesmy orkami. Przybywamy was najechac.",90)



