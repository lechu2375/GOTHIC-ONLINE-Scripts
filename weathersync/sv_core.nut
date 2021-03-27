
addEventHandler("onPlayerCommand",function(pid,cmd,params)
{
    switch (cmd)
    {
    case "weather":
        //if(!getStat(pid, "admin") || !getStat(pid, "gm") || !getStat(pid, "support"))
        //break;
        local args = sscanf("s",params);
        if(args){
            local text = args[0];
            if(text=="clear"){
                WeatherSync.currentWeather = WEATHER_CLEAR;
                ChangeWeather(WEATHER_CLEAR); 
                setTimerInterval(WeatherSync.weatherTimer, WeatherSync.weatherRandom);
            }
            else if(text=="rain"){
                WeatherSync.currentWeather = WEATHER_RAIN;
                ChangeWeather(WEATHER_RAIN);
                CreateWeatherTimer(WeatherSync.rainDur);
                setTimerInterval(WeatherSync.weatherTimer, WeatherSync.weatherRandom);
                /*po samym zmianie interwa³u chuja siê dzia³o
                    i usuwa³o szybko deszcz wiêc to takie obejœcie*/
            }
        }
        else
            sendMessageToPlayer(pid, 255, 255, 0,"/weather clear/rain")
        break;
    
         
    }
});

WeatherSync <- {
    rainChance = 5 //procentowa szansa na deszcz 
    currentWeather = WEATHER_CLEAR //startowa pogoda mo¿liwoœci: WEATHER_CLEAR, WEATHER_RAIN, WEATHER_SNOW(XD)
    rainDur = 600000//10 minut deszcz,musi byæ odpowiednio d³ugi ¿eby zaczê³o laæ
    weatherTimer = 0 //id timera
    weatherRandom = 60000 // 1 minuta - co ile losuje pogode
}


function ChangeWeather(wtype){

    
    packet <- Packet();
	packet.writeUInt16(RainPacket);
	packet.writeChar(wtype);
	packet.sendToAll(RELIABLE_ORDERED);

}
function CreateWeatherTimer(delay){
    if(WeatherSync.weatherTimer)
        killTimer(WeatherSync.weatherTimer);

    local delay = delay 
    if(!delay)
       delay = WeatherSync.weatherRandom


    WeatherSync.weatherTimer = setTimer(function()
    {
        local random = 100 * rand() / RAND_MAX;
        if(random>WeatherSync.rainChance){
            //print("clear")
            WeatherSync.currentWeather = WEATHER_CLEAR;
            setTimerInterval(WeatherSync.weatherTimer, WeatherSync.weatherRandom);
        }
            
        else{
            WeatherSync.currentWeather = WEATHER_RAIN;
            CreateWeatherTimer(WeatherSync.rainDur);
            setTimerInterval(WeatherSync.weatherTimer, WeatherSync.rainDur);
        }
            
        
        
        print(WeatherSync.currentWeather);
        ChangeWeather(WeatherSync.currentWeather);

        
    }, delay, 0);
}



addEventHandler("onInit", CreateWeatherTimer(3000));

function onPlayerJoin(pid)
{
    local id = setTimer(function()
    {
        packet <- Packet();
        packet.writeUInt16(RainPacket);
        packet.writeChar(WeatherSync.currentWeather);
        packet.send(pid,RELIABLE_ORDERED);
    }, 5000, 1); //coœ mi nie zmienia³o pogody po zrespieniu pierwszym wiêc timer taki o

}

addEventHandler("onPlayerJoin", onPlayerJoin);



