## Tworzenie nowego vob followera 
> CreateVobFollower(string vobVisual, int playerID)
## Zmiana parenta vobFollowera 
> SetVobFollowerParent(int vobID, int parent) 
- w przypadku -1 vob zostaje w "powietrzu"
## Aktualizacja informacji o vobFollowerze 
> UpdateVobFollower(int id, enum VobFollowerAction,int pid) 

## enum VobFollowerAction
- REMOVE Usuwa vobFollowera
- PARENTUPDATE Zmienia parenta
- WHOLEUPDATE Aktualizuje wszystko, od parenta po gracza, można użyć do wysłania listy vobFollowerów po wejściu na serwis 

