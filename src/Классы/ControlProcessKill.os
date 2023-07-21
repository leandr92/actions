﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("pid p", "",
		"PID процесса, который необходимо завершить (обязательный)")
		.ТСтрока();

КонецПроцедуры

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
    
	Параметры = ПолучитьСтруктуруПараметров(Команда);
    ЗавершаемыйПроцесс = Новый КонтролируемыйПроцесс();
	ЗавершаемыйПроцесс.ЗавершитьПроцессПоИдентификатору(Параметры.Идентификатор);
        
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Идентификатор", ЧтениеОпций.ЗначениеОпции("pid", Истина));

	Возврат ПараметрыКоманды;

КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции