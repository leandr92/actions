﻿#Использовать ".."
#Использовать logos
#Использовать asserts
#Использовать 1commands

// Переменная тестирования
Перем юТест;
// Глобальный лог-файл
Перем Лог;
// Определяем какие тесты можно запускать в облаке, а какие на локальном компьютере.
Перем ЭтоЛокальноеТестирование;

// BSLLS:LatinAndCyrillicSymbolInWord-off

Процедура ПередЗапускомТеста() Экспорт

КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт

	юТест.УдалитьВременныеФайлы();

КонецПроцедуры

Процедура Инициализация()
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИмяКомпьютера = ВРег(СистемнаяИнформация.ИмяКомпьютера);
	ЭтоЛокальноеТестирование = ИмяКомпьютера = "SPC" ИЛИ ИмяКомпьютера = "MSI";
КонецПроцедуры

Процедура ЯВыполняюКомандуПродуктаCПередачейПараметров(Знач КомандаТестера, Знач ПараметрыКоманды,
		Знач ОжидаемыйКодВозврата = 0, ТекстВывода = "")
	
	Если Лог.Уровень() >= УровниЛога.Отладка Тогда
		юТест.ВключитьОтладкуВЛогахЗапускаемыхСкриптовOnescript();
	КонецЕсли;

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;	
	
	ПутьСтартера = ОбъединитьПути(КаталогИсходников(), "src", "actions.os");
	ФайлСтартера = Новый Файл(ПутьСтартера);
	Ожидаем.Что(ФайлСтартера.Существует(), "Ожидаем, что скрипт-стартер <actions.os> существует, а его нет. "
		+ ФайлСтартера.ПолноеИмя).Равно(Истина);
	
	КомандаДвижка = "oscript";
	Если ЭтоWindows Тогда
		КомандаДвижка = СтрШаблон("%1 %2", КомандаДвижка, "-encoding=utf-8");
	КонецЕсли;
	Если юТест.ИспользоватьСборСтатистикиСкриптовOnescript() Тогда
		КомандаДвижка = СтрШаблон("%1 %2", КомандаДвижка, ПараметрСтатистикиДляКомандыОСкрипт());
	КонецЕсли;

	СтрокаКоманды = СтрШаблон("%1 %2 %3 %4", КомандаДвижка, ПутьСтартера, КомандаТестера, ПараметрыКоманды);
	
	Команда = Новый Команда;
	
	Команда.УстановитьСтрокуЗапуска(СтрокаКоманды);
	Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	КодВозврата = Команда.Исполнить();
	ТекстВывода = Команда.ПолучитьВывод();
	
	Лог.Отладка(ТекстВывода);
	
	Если ОжидаемыйКодВозврата <> Неопределено И КодВозврата <> ОжидаемыйКодВозврата
		ИЛИ Лог.Уровень() <= УровниЛога.Отладка Тогда
		ВывестиТекст(ТекстВывода);
		Ожидаем.Что(КодВозврата, "Код возврата в ЯВыполняюКомандуПродуктаCПередачейПараметров")
		.Равно(ОжидаемыйКодВозврата);
	КонецЕсли;
КонецПроцедуры

Функция ПараметрСтатистикиДляКомандыОСкрипт()

	ОбъектКаталогаСтатистики = юТест.КаталогСбораСтатистикиСкриптовOnescript();
	Если Не ЗначениеЗаполнено(ОбъектКаталогаСтатистики) Тогда
		Возврат "";
	КонецЕсли;

	Ожидаем.Что(ОбъектКаталогаСтатистики.Существует(),
		"Каталог статистики должен существовать перед выполнения скрипта OneScript").Равно(Истина);

	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов;
	МенеджерВременныхФайлов.БазовыйКаталог = ОбъектКаталогаСтатистики.ПолноеИмя;
	ИмяФайлаСтатистики = МенеджерВременныхФайлов.НовоеИмяФайла("json");
	ПутьФайлаСтатистики = ОбъединитьПути(ОбъектКаталогаСтатистики.ПолноеИмя, ИмяФайлаСтатистики);

	Возврат СтрШаблон("-codestat=%1", ПутьФайлаСтатистики);
КонецФункции

Процедура ВключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Отладка);
КонецПроцедуры

Процедура ВыключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Информация);
КонецПроцедуры

Процедура ВывестиТекст(Знач Строка)
	
	Лог.Отладка("");
	Лог.Отладка("  ----------------    ----------------    ----------------  ");
	Лог.Отладка(Строка);
	Лог.Отладка("  ----------------    ----------------    ----------------  ");
	Лог.Отладка("");
	
КонецПроцедуры

Функция КаталогТестовыхФикстур() Экспорт
	Возврат ОбъединитьПути(КаталогТестов(), "fixtures");
КонецФункции

Функция КаталогТестов() Экспорт
	Возврат ОбъединитьПути(КаталогИсходников(), "tests");
КонецФункции

Функция КаталогИсходников() Экспорт
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..");
КонецФункции

Функция ПолучитьТекстИзФайла(ИмяФайла)
	
	ФайлОбмена = Новый Файл(ИмяФайла);
	Данные = "";
	Если ФайлОбмена.Существует() Тогда
		Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		Данные = Текст.Прочитать();
		Текст.Закрыть();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Процедура Тест_Должен_Выполнить_Команду_checksum() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "checksum.txt");
	ПутьФайлаТестаВременный = юТест.ИмяВременногоФайла("txt");
	Текст = ПолучитьТекстИзФайла(ПутьФайлаТеста);
	Текст = СтрЗаменить(Текст, Символы.ПС, "");
	Текст = СтрЗаменить(Текст, Символ(10), "");
	Текст = СтрЗаменить(Текст, Символ(13), "");
	Файл = Новый ЗаписьТекста(ПутьФайлаТестаВременный, КодировкаТекста.UTF8, Символы.ПС, Истина, Символы.ПС);
	Файл.Записать(Текст);
	Файл.Закрыть();

	ЯВыполняюКомандуПродуктаCПередачейПараметров("checksum", "--file " + ПутьФайлаТестаВременный);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_obfuscation() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "code.os");
	ПутьФайлаТестаВременный = юТест.ИмяВременногоФайла("txt");
	мПараметры = "--in """ + ПутьФайлаТеста + """"
		+ " --out """ + ПутьФайлаТестаВременный + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("obfuscation", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_init() Экспорт

	ПутьФайлаТеста = юТест.ИмяВременногоФайла("md");
	мПараметры = "--file """ + ПутьФайлаТеста + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog init", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_txt() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("txt");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.txt");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "txt");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_htmlfull() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("txt");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.full.html");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "htmlfull");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_html() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("html");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.html");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "html");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_version() Экспорт

	ЯВыполняюКомандуПродуктаCПередачейПараметров("--version", "");
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_autodoc() Экспорт

	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("html");
	мПараметры = "--file """ + ПутьФайлаТестаРезультат + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("autodoc", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_string() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.string"" --string ""Hello world""";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_number() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.number"" --number 555";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_boolean() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.boolean"" --boolean true";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_get() Экспорт

	ПутьФайлаТеста = КаталогВременныхФайлов();
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp get", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_СозданиеФайловойБазы() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase create file", мПараметры);

КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_version");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_autodoc");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_checksum");
	//СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_obfuscation");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_changelog_init");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_changelog_txt");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_changelog_html");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_changelog_htmlfull");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_json_write_string");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_json_write_number");
	СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_json_write_boolean");
	Если ЭтоЛокальноеТестирование Тогда
		СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_ftp_get");
		//СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_ftp_put");
		//СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_ftp_delete");
		//СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_infobase_create_file");
		//СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_infobase_create_server");
		СписокТестов.Добавить("Тест_Должен_Выполнить_Команду_СозданиеФайловойБазы");
	КонецЕсли;
	
	Возврат СписокТестов;
	
КонецФункции

Инициализация();
Лог = Логирование.ПолучитьЛог("actions1c.tests");
//ВключитьПоказОтладки();

// BSLLS:LatinAndCyrillicSymbolInWord-on