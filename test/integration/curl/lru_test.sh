-- Заполняем кэш
-- Московский Кремль - 55.752004, 37.617734
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.752004&longitude=37.617734'

-- Казаньский кремль - 55.798546, 49.105965
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.798546&longitude=49.105965'

-- Новгородский кремль - 58.521912, 31.274541
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=58.521912&longitude=31.274541'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=58.521912&longitude=31.274541'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=58.521912&longitude=31.274541'


-- Нагоняем статистику
-- [КЭШ] Московский Кремль - 55.752004, 37.617734
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.752004&longitude=37.617734'

-- [КЭШ] Казаньский кремль - 55.798546, 49.105965
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.798546&longitude=49.105965'

-- [КЭШ] Московский Кремль - 55.752004, 37.617734
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.752004&longitude=37.617734'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.752004&longitude=37.617734'

-- [КЭШ] Казаньский кремль - 55.798546, 49.105965
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=55.798546&longitude=49.105965'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=55.798546&longitude=49.105965'

-- Вытесняем Новгородский кремль
-- Петергоф - 59.883909, 29.905751
curl -X 'GET' -si 'http://localhost:8081/weather/current?latitude=59.883909&longitude=29.905751'
curl -X 'GET' -si 'http://localhost:8081/weather/hourly?latitude=59.883909&longitude=29.905751'
curl -X 'GET' -si 'http://localhost:8081/weather/minutely_15?latitude=59.883909&longitude=29.905751'
