


WeatherSync <- {
    currentWeather = WEATHER_CLEAR
    jebniecietimer = 1 //tutaj 0 jeœli ktoœ chce pioruny mieæ
}

addEventHandler("onPacket", function(packet)
{
	local id = packet.readUInt16();
    if (id == RainPacket)
	{
		local weather = packet.readChar();
        print(weather);
        if(WeatherSync.currentWeather==WEATHER_RAIN && weather==WEATHER_RAIN){
            Chat.print(0, 255, 0,"Deszcz nasila siê.");
        }
        else if(WeatherSync.currentWeather==WEATHER_RAIN && weather==WEATHER_CLEAR){
            Chat.print(0, 255, 0,"Deszcz ustaje.");
            killTimer(WeatherSync.jebniecietimer); 
            WeatherSync.jebniecietimer = false;//jak ma jebn¹æ to sobie odpuszczamy i nie jebnie bo ustaje deszcz
        }
        else if(WeatherSync.currentWeather==WEATHER_CLEAR && weather==WEATHER_RAIN){
            Chat.print(0, 255, 0,"Zaczyna kropiæ.");
        }
		Sky.setWeather(weather);
        WeatherSync.currentWeather = weather;
	}


});




local jebniecie = Sound("thunder.WAV") // _work\data\SOUND\SFX wrzucic se
jebniecie.volume = 0.4;

/*Ten timer co 3 sekundy sprawdza czy pogoda silnika nie ró¿ni siê od tej skryptowej
w razie gdyby silnik postanowi³ sam zmieniæ pogodê, dodatkowo jak leje to mo¿e jebn¹æ piorun */
local id = setTimer(function() 
{
	if(Sky.getWeather()!=WeatherSync.currentWeather){
        Sky.setWeather(WeatherSync.currentWeather);
    }
        

    if(WeatherSync.currentWeather==WEATHER_RAIN && !WeatherSync.jebniecietimer){ //jak nie ma jebn¹æ za ileœ sekund to jebnie za ileœ
            local random = 30000 * rand() / RAND_MAX + 120000;
            Chat.print(0, 255, 0,random);
            WeatherSync.jebniecietimer = setTimer(function()
            {
                jebniecie.play();
                WeatherSync.jebniecietimer = false;
                    
            }, random, 1);
        }
    
        
}, 3000, 0);

