﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.ДобавитьКоманду(Перечисления.ДействияСFTP.Получение,
		"Копирование файла с FTP-сервера",
		Новый FtpGet());
	
	Команда.ДобавитьКоманду(Перечисления.ДействияСFTP.Отправка,
		"Копирование файла на FTP-сервер",
		Новый FtpPut());
		
КонецПроцедуры // ОписаниеКоманды()
