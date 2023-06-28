﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("file f", "",
		"Файл для добавления текста (обязательный)")
		.ТСтрока();

	Команда.Опция("text t", "",
		"Добавляемый текст. будет предпринята попытка прочитать из файла кодировку (не обязательный)")
		.ТСтрока();

	Команда.Опция("newline n", "",
		"Запись будет добавлена с новой строки")
		.ТБулево();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	Лог.Информация("Записываем в файл <%1> << %2", ПараметрыКоманды.ИмяФайла, ПараметрыКоманды.Текст);
	ФайловыеОперации.ДобавитьТекстКФайлу(ПараметрыКоманды.ИмяФайла, 
		ПараметрыКоманды.Текст, ПараметрыКоманды.НоваяСтрока);
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ИмяФайла", ЧтениеОпций.ЗначениеОпции("file", Истина));
	ПараметрыКоманды.Вставить("Текст", ЧтениеОпций.ЗначениеОпции("text"));
	ПараметрыКоманды.Вставить("НоваяСтрока", ЧтениеОпций.ЗначениеОпции("newline"));
	ПараметрыКоманды.Вставить("НоваяСтрока", ЗначениеЗаполнено(ПараметрыКоманды.НоваяСтрока));
	Если НЕ ЗначениеЗаполнено(ПараметрыКоманды.Текст) Тогда
		ПараметрыКоманды.Текст = "";
	КонецЕсли;
	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции