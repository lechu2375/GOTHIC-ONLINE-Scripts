


WeatherSync <- {
    currentWeather = WEATHER_CLEAR
    jebniecietimer = 1 //tutaj 0 je�li kto� chce pioruny mie�
}

addEventHandler("onPacket", function(packet)
{
	local id = packet.readUInt16();
    if (id == RainPacket)
	{
		local weather = packet.readChar();
        print(weather);
        if(WeatherSync.currentWeather==WEATHER_RAIN && weather==WEATHER_RAIN){
            Chat.print(0, 255, 0,"Deszcz nasila si�.");
        }
        else if(WeatherSync.currentWeather==WEATHER_RAIN && weather==WEATHER_CLEAR){
            Chat.print(0, 255, 0,"Deszcz ustaje.");
            killTimer(WeatherSync.jebniecietimer); 
            WeatherSync.jebniecietimer = false;//jak ma jebn�� to sobie odpuszczamy i nie jebnie bo ustaje deszcz
        }
        else if(WeatherSync.currentWeather==WEATHER_CLEAR && weather==WEATHER_RAIN){
            Chat.print(0, 255, 0,"Zaczyna kropi�.");
        }
		Sky.setWeather(weather);
        WeatherSync.currentWeather = weather;
	}


});




local jebniecie = Sound("thunder.WAV") // _work\data\SOUND\SFX wrzucic se
jebniecie.volume = 0.4;

/*Ten timer co 3 sekundy sprawdza czy pogoda silnika nie r�ni si� od tej skryptowej
w razie gdyby silnik postanowi� sam zmieni� pogod�, dodatkowo jak leje to mo�e jebn�� piorun */
local id = setTimer(function() 
{
	if(Sky.getWeather()!=WeatherSync.currentWeather){
        Sky.setWeather(WeatherSync.currentWeather);
    }
        

    if(WeatherSync.currentWeather==WEATHER_RAIN && !WeatherSync.jebniecietimer){ //jak nie ma jebn�� za ile� sekund to jebnie za ile�
            local random = 30000 * rand() / RAND_MAX + 120000;
            Chat.print(0, 255, 0,random);
            WeatherSync.jebniecietimer = setTimer(function()
            {
                jebniecie.play();
                WeatherSync.jebniecietimer = false;
                    
            }, random, 1);
        }
    
        
}, 3000, 0);

