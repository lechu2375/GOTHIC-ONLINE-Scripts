## Creating new vobFollower, returns id of vobFollower. 
> CreateVobFollower(string vobVisual, int playerID)
## Change parent for vobFollower
> SetVobFollowerParent(int vobID, int parent) 
- w przypadku -1 vob zostaje w "powietrzu"
## Update infotmation about vobFollower.
> UpdateVobFollower(int id, enum VobFollowerAction,int pid) 

## enum VobFollowerAction
- REMOVE Usuwa vobFollowera
- PARENTUPDATE Zmienia parenta
- WHOLEUPDATE Aktualizuje wszystko, od parenta po gracza, można użyć do wysłania listy vobFollowerów po wejściu na serwis 

