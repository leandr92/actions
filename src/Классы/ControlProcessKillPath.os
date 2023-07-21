﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("processpath p", "",
		"Каталог с json-файлам с информацией о запущенных процессах для закрытия (обязательный)")
		.ТСтрока();

КонецПроцедуры

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
    
	Лог = ПараметрыСистемы.Лог();

	Параметры = ПолучитьСтруктуруПараметров(Команда);

	Лог.Информация("Завершение процессов. Информация о процессах в каталоге <%1>", Параметры.Каталог);
	Файлы = НайтиФайлы(Параметры.Каталог, "*.json", Ложь);
	Количество = 0;
	Для Каждого Файл Из Файлы Цикл
		Попытка
			Структура = РаботаJSON.ПрочитатьФайлJSON(Файл.ПолноеИмя);
			Идентификатор = Структура.Идентификатор;
			СтрокаЗапуска = Структура.СтрокаЗапуска;
		Исключение
			Продолжить;
		КонецПопытки;		
		Процесс = НайтиПроцессПоИдентификатору(Идентификатор);
		Если ЗначениеЗаполнено(Процесс) Тогда			
			Процесс.Завершить();
			Лог.Информация("Процесс с PID ""%1"" завершен (%2)", Идентификатор, СтрокаЗапуска);
			Количество = Количество + 1;
		КонецЕсли;
		УдалитьФайлы(Файл.ПолноеИмя);
	КонецЦикла;
	Лог.Информация("Завершено %1 процесса(ов)", Количество);
        
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Каталог", ЧтениеОпций.ЗначениеОпции("processpath", Истина));

	Возврат ПараметрыКоманды;

КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции