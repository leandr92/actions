#Использовать fs

// ПрочитатьТекстФайла
//	Возвращает содержимое файла, читая его в правильной кодировке
// Параметры:
//   ПутьКФайлу - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Строка - Содержимое файла
//
Функция ПрочитатьТекстФайла(ПутьКФайлу) Экспорт
	
	Кодировка = ОпределитьКодировку(ПутьКФайлу);
	Текст = Новый ЧтениеТекста();
	Текст.Открыть(ПутьКФайлу, Кодировка);
	
	СодержимоеФайла = Текст.Прочитать();
	
	Текст.Закрыть();
	
	Возврат СодержимоеФайла;
	
КонецФункции // ПрочитатьТекстФайла

// ЗаписатьТекстФайла
//	Определяет кодировку файла и записывает содержимое в файл
//
// Параметры:
//	ПутьКФайлу 		- Строка - Полный путь к файлу
//	СодержимоеФайла	- Строка - Текст для записи
Процедура ЗаписатьТекстФайла(ПутьКФайлу, СодержимоеФайла) Экспорт
	
	Кодировка = ОпределитьКодировку(ПутьКФайлу);
	ЗаписьТекста = Новый ЗаписьТекста(ПутьКФайлу, Кодировка, , , Символы.ПС);
	
	ЗаписьТекста.Записать(СодержимоеФайла);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры // ЗаписатьТекстФайла

// ОпределитьКодировку
//	Читает первые 3 байта файла и ищет маркер BOM кодировки UTF-8
// Параметры:
//   ПутьКФайлу - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Перечисление - Кодировка файла
//
Функция ОпределитьКодировку(ПутьКФайлу) Экспорт
	
	МаркерUTFBOM = СтрРазделить("239 187 191", " ");
	ЧтениеДанных = Новый ЧтениеДанных(ПутьКФайлу);
	Буфер = Новый БуферДвоичныхДанных(МаркерUTFBOM.Количество());
	
	ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Буфер, , МаркерUTFBOM.Количество());
	Cч = 0;
	ЕстьBOM = Истина;
	
	Для Каждого Байт Из Буфер Цикл
		Если МаркерUTFBOM[Cч] <> Строка(Байт) Тогда
			ЕстьBOM = Ложь;
			Прервать;
		КонецЕсли;
		Cч = Cч + 1;
	КонецЦикла;
	
	ЧтениеДанных.Закрыть();
	
	Возврат ?(ЕстьBOM, КодировкаТекста.UTF8, КодировкаТекста.UTF8NoBOM);
	
КонецФункции // ОпределитьКодировку

// Получить абсолютный путь к файлу или каталогу
//
// Параметры:
//   ПутьКФайлу - Строка - Полный путь к файлу
//
// Возвращаемое значение:
// 	Строка - абсолютный путь к файлу или каталогу.
//
Функция АбсолютныйПуть(Знач ПутьКФайлу) Экспорт
	
	Файл = Новый Файл(УбратьКавычкиВокругПути(ПутьКФайлу));
	Возврат Файл.ПолноеИмя;
	
КонецФункции


// Проверяет существование файла
//
// Параметры:
//   ПутьКФайлу - Строка - Полный путь к файлу
//
// Возвращаемое значение:
// 	Булево - признак существования файла.
//
Функция ФайлСуществует(Знач ПутьКФайлу) Экспорт
	
	Файл = Новый Файл(УбратьКавычкиВокругПути(ПутьКФайлу));
	Возврат Файл.Существует() И НЕ Файл.ЭтоКаталог();
	
КонецФункции

// Проверяет существование каталога
//
// Параметры:
//   Путь - Строка - Полный путь к каталогу
//
// Возвращаемое значение:
// 	Булево - признак существования каталога.
//
Функция КаталогСуществует(Знач Путь) Экспорт
	
	Файл = Новый Файл(УбратьКавычкиВокругПути(Путь));
	Возврат Файл.Существует() И Файл.ЭтоКаталог();
	
КонецФункции

Функция ОбернутьПутьВКавычки(Знач Путь) Экспорт
	
	Результат = Путь;
	Если Прав(Результат, 1) = "\" ИЛИ Прав(Результат, 1) = "/" Тогда
		Результат = Лев(Результат, СтрДлина(Результат) - 1);
	КонецЕсли;
	
	Результат = """" + Результат + """";
	
	Возврат Результат;
	
КонецФункции

Функция УбратьКавычкиВокругПути(Знач Путь) Экспорт
	// NOTICE: https://github.com/xDrivenDevelopment/precommit1c
	// Apache 2.0
	ОбработанныйПуть = Путь;
	
	Если Лев(ОбработанныйПуть, 1) = """" Тогда
		ОбработанныйПуть = Прав(ОбработанныйПуть, СтрДлина(ОбработанныйПуть) - 1);
	КонецЕсли;
	Если Прав(ОбработанныйПуть, 1) = """" Тогда
		ОбработанныйПуть = Лев(ОбработанныйПуть, СтрДлина(ОбработанныйПуть) - 1);
	КонецЕсли;
	
	Возврат ОбработанныйПуть;
	
КонецФункции

// Дополнить разделителем пути
//
// Параметры:
//   Путь - Строка - путь файла или каталога
//
//  Возвращаемое значение:
//   Строка - путь с разделителем пути в конце строки, если его там не было, иначе сам путь
//
Функция ДополнитьРазделителемПути(Знач Путь) Экспорт
	
	Если Прав(Путь, 1) <> ПолучитьРазделительПути() Тогда
		Возврат Путь + ПолучитьРазделительПути();
	КонецЕсли;
	
	Возврат Путь;
	
КонецФункции

// Возвращает стандартное имя файла настроек.
//
//  Возвращаемое значение:
//   Строка - имя файла с настройками
Функция ИмяФайлаНастроек() Экспорт
	
	Возврат "settings.json";
	
КонецФункции // ИмяФайлаНастроек()

Функция НайтиКаталогТекущегоПроекта(Знач Путь) Экспорт
    Результат = "";
    Если ПустаяСтрока(Путь) Тогда
        Попытка
            Команда = Новый Команда;
            Команда.УстановитьСтрокуЗапуска("git rev-parse --show-toplevel");
            Команда.УстановитьПравильныйКодВозврата(0);
            Команда.Исполнить();
            Результат = СокрЛП(Команда.ПолучитьВывод());
        Исключение
            // некуда выдавать ошибку, логи еще не доступны
            Результат = "..";
        КонецПопытки;
    Иначе
        Результат = Путь;
    КонецЕсли;

    Если ПараметрыСистемы.ЭтоWindows Тогда
        Результат = СтрЗаменить(Результат, "/", "\");
    Иначе
        Результат = СтрЗаменить(Результат, "\", "/");
    КонецЕсли;

    Возврат Результат;

КонецФункции // НайтиКаталогТекущегоПроекта()

Функция ХэшФайлов(ИмяФайла, Маска = "*") Экспорт

	Хеширование = Новый ХешированиеДанных(ХешФункция["MD5"]);

	Если ФайловыеОперации.ФайлСуществует(ИмяФайла) Тогда
		Хеширование.ДобавитьФайл(ИмяФайла); 
	Иначе
		Файлы = НайтиФайлы(ИмяФайла, Маска, Истина);
		Для Каждого мФайл Из Файлы Цикл
			Если мФайл.ЭтоФайл() Тогда
				Хеширование.ДобавитьФайл(мФайл.ПолноеИмя);
			Иначе
				Хеширование.Добавить(мФайл.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Хеш = Строка(Хеширование.ХешСумма);	
	Возврат НРег(СтрЗаменить(Хеш, " ", ""));

КонецФункции

// Гарантирует наличие пустого каталога с указанным именем
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
Процедура ОбеспечитьПустойКаталог(Знач Путь) Экспорт

    ОбеспечитьКаталог(Путь);
    УдалитьФайлы(Путь, ПолучитьМаскуВсеФайлы());

КонецПроцедуры // ОбеспечитьПустойКаталог()

// Гарантирует наличие каталога с указанным именем
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
Процедура ОбеспечитьКаталог(Знач Путь) Экспорт

    Объект = Новый Файл(Путь);
    Если Не Объект.Существует() Тогда
        СоздатьКаталог(Путь);
    Иначе
		Если НЕ Объект.ЭтоКаталог() Тогда
        	ВызватьИсключение "Не удается создать каталог " + Путь + ". По данному пути уже существует файл.";
		КонецЕсли;
    КонецЕсли;

КонецПроцедуры // ОбеспечитьКаталог()

Процедура ОбеспечитьСуществованиеКаталоговДляПутей(Знач ПроверятьРодителя, Знач НаборПутей, Знач СообщениеОшибки)
	ЕстьОшибка = Ложь;
	Для Каждого Путь Из НаборПутей Цикл		
		Файл = Новый Файл(Путь);
		Если ПроверятьРодителя Тогда
			НужныйПуть = Файл.Путь;
			Если ПустаяСтрока(НужныйПуть) Тогда
				Возврат;
			КонецЕсли;
		Иначе
			НужныйПуть = Файл.ПолноеИмя;
		КонецЕсли;		
		ОбъектКаталог = Новый Файл(НужныйПуть);

		ФС.ОбеспечитьКаталог(ОбъектКаталог.ПолноеИмя);

		Если Не ОбъектКаталог.Существует() Тогда
			ЕстьОшибка = Истина;
			СообщениеОшибки = СтрШаблон("%1	%2", СообщениеОшибки, ОбъектКаталог.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;

	Если ЕстьОшибка Тогда
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;

КонецПроцедуры

Процедура ОбеспечитьСуществованиеКаталогов(Знач НаборПутей, Знач СообщениеОшибки) Экспорт
	ОбеспечитьСуществованиеКаталоговДляПутей(Ложь, НаборПутей, СообщениеОшибки);
КонецПроцедуры

Процедура ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(Знач НаборПутей, Знач СообщениеОшибки) Экспорт
	ОбеспечитьСуществованиеКаталоговДляПутей(Истина, НаборПутей, СообщениеОшибки);
КонецПроцедуры

// Удалить последний разделитель пути
//
// Параметры:
//   Путь - Строка - путь файла или каталога
//
//  Возвращаемое значение:
//   Строка - путь без разделителя пути в конце строки, если он там был, иначе сам путь
//
Функция УдалитьПоследнийРазделительПути(Знач Путь) Экспорт
	
	Путь = СокрП(Путь);
	Если НЕ ПустаяСтрока(Путь) Тогда
		Если Прав(Путь, 1) = "\" ИЛИ Прав(Путь, 1) = "/" Тогда
			Возврат Лев(Путь, СтрДлина(Путь) - 1);	
		КонецЕсли;
	КонецЕсли;
	
	Возврат Путь;
	
КонецФункции
