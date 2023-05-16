﻿#Использовать tempfiles
#Использовать logos

//	Возвращает идентификатор лога приложения
//
// Возвращаемое значение:
//   Строка   - Значение идентификатора лога приложения
//
Функция ИмяЛогаСистемы() Экспорт

	Возврат "oscript.app." + ИмяПродукта();

КонецФункции // ИмяЛогаСистемы

//	Возвращает текущую версию продукта
//
// Возвращаемое значение:
//   Строка   - Значение текущей версии продукта
//
Функция ВерсияПродукта() Экспорт

	Версия = "0.0.1";
	Возврат Версия;

КонецФункции // ВерсияПродукта()

// Возвращает имя продукта
//
//  Возвращаемое значение:
//   Строка - имя продукта
//
Функция ИмяПродукта() Экспорт

	Возврат "cicd";
	
КонецФункции

Функция ИмяФайлаНастроек() Экспорт
	Возврат ".env";
КонецФункции

Функция ПолучитьПараметр(Параметры, Имя, ЗначениеПоУмолчанию = "") Экспорт
	
	ЗначениеПараметра = ЗначениеПоУмолчанию;
	
	Если Параметры.Свойство(Имя) Тогда
		ЗначениеПараметра = Параметры[Имя];
	КонецЕсли;
	
	Возврат ЗначениеПараметра;

КонецФункции // ПолучитьПараметр()

Процедура РегистрацияГлобальныхПараметровКоманд(Парсер) Экспорт

	Описание = СтрШаблон("Путь к файлу настроек CI/CD в формате json. По умолчанию имя файла ""%1""  (необязательно)",
		ИмяФайлаНастроек());
	Парсер.ДобавитьИменованныйПараметр("-settings", 
		Описание,
		Истина);

	Парсер.ДобавитьИменованныйПараметр("-logfile", 
		"Вывод отладочных файлов в указанный лог-файл (необязательно)",
		Истина);

КонецПроцедуры

Функция ДанныеПодключения(ЗначенияПараметров) Экспорт

	СтрокаПодключения = СокрЛП(ЗначенияПараметров["-ibconnection"]);

	СтруктураПодключения = Новый Структура;
	СтруктураПодключения.Вставить("СтрокаПодключения", СтрокаПодключения);
	Если СтрНачинаетсяС(ВРег(СтрокаПодключения), "/S") Тогда
		СтрокаПодключения = Сред(СтрокаПодключения, 3);
		Сервер1С 	= Лев(СтрокаПодключения, Найти(СтрокаПодключения, "\") - 1);
		ИмяИБ		= Прав(СтрокаПодключения, СтрДлина(СтрокаПодключения) - Найти(СтрокаПодключения, "\"));
		СтруктураПодключения.Вставить("Сервер1С", Сервер1С);
		СтруктураПодключения.Вставить("ИмяИБ", ИмяИБ);
	ИначеЕсли СтрНачинаетсяС(ВРег(СтрокаПодключения), "/F") Тогда
		КаталогИБ = Сред(СтрокаПодключения, 3);
		СтруктураПодключения.Вставить("КаталогИБ", КаталогИБ);
	Иначе
		ВызватьИсключение "Параметр -ibconnection должен начинаться либо с ключем /S либо /F (серверная или файловая ИБ)";
	КонецЕсли;
	СтруктураПодключения.Вставить("Пользователь", ЗначенияПараметров["-ib-user"]);
	СтруктураПодключения.Вставить("Пароль", ЗначенияПараметров["-ib-pwd"]);
	СтруктураПодключения.Вставить("КодЯзыка", ЗначенияПараметров["-language"]);
	СтруктураПодключения.Вставить("КодЯзыкаСеанса", ЗначенияПараметров["-locale"]);	
	СтруктураПодключения.Вставить("ВерсияПлатформы", ЗначенияПараметров["-v8version"]);

	Рез = Новый Структура;
	Для каждого КлючЗначение Из СтруктураПодключения Цикл
		Значение = КлючЗначение.Значение;
		Если Значение = Неопределено Тогда
			Значение = "";
		КонецЕсли;
		Рез.Вставить(КлючЗначение.Ключ, Значение);
	КонецЦикла;

	Возврат Новый ФиксированнаяСтруктура(Рез);

КонецФункции // ДанныеПодключения(ЗначенияПараметров)

// Функция подготавливает конфигуратор 1С для выполнения в режиме командной строки.
//   
// Параметры:
//   Параметры - Структура - строка подключения к базе 1С.
//
// Возвращаемое значение:
//		УправлениеКонфигуратором - подготовленный конфигуратор.
//
Функция НастроитьКонфигуратор(Параметры) Экспорт

	Конфигуратор = Новый УправлениеКонфигуратором;

	КаталогСборки = КаталогВременныхФайлов();

	Конфигуратор.КаталогСборки(КаталогСборки);
	ДанныеПодключения = Параметры["ДанныеПодключения"];

	Если ЗначениеЗаполнено(ДанныеПодключения.СтрокаПодключения) Тогда
		Конфигуратор.УстановитьКонтекст(ДанныеПодключения.СтрокаПодключения,
			ДанныеПодключения.Пользователь,
			ДанныеПодключения.Пароль);
	КонецЕсли;

	Если ЗначениеЗаполнено(ДанныеПодключения.ВерсияПлатформы) Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ДанныеПодключения.ВерсияПлатформы);
	КонецЕсли;

	Возврат Конфигуратор;

КонецФункции // НастроитьКонфигуратор()

Процедура РегистрацияОбщихПараметровV8(ОписаниеКоманды, Парсер, МассивПараметров) Экспорт

	ИмяКоманды = "-ibconnection";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Строка подключения к ИБ (/FfilePath или /SserverPath) (обязательно)
			|	Например, для файловых баз -ibconnection /FC:\base1 или -ibconnection /Fbase1
			|	Или для серверных баз -ibconnection /Sservername\basename");
	КонецЕсли;

	ИмяКоманды = "-ib-user";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Пользователь ИБ");	
	КонецЕсли;

	ИмяКоманды = "-ib-pwd";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Пароль пользователя ИБ");
	КонецЕсли;

	ИмяКоманды = "-v8version";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Версия платформы 1С (необязательно). Примеры:
			|	8.3
			|	8.3.22
			|	8.3.22.3456");
	КонецЕсли;

	ИмяКоманды = "-uccode";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Ключ разрешения запуска (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-ordinaryapp";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Запуск толстого клиента (1 = толстый, 0 = тонкий клиент, -1 = без указания клиента). 
			|	По умолчанию используется значение 0 (тонкий клиент). 
			|	Значение -1 может применяться в случаях, когда нужно прочитать лог работы 1С в режиме Предприятие в управляемом интерфейсе.");
	КонецЕсли;

	ИмяКоманды = "-nocacheuse";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Признак - не использовать кэш платформы для ускорения операций с базой,
			|а также не надо добавлять базу в список баз 1C пользователя (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-language";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды, 
		"Код языка запуска платформы (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-locale";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды, 
		"Код локализации сеанса платформы (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-cluster-user";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Администратор кластера (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-cluster-pwd";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Пароль администратора кластера (необязательно)");		
	КонецЕсли;
	
	ИмяКоманды = "-addinlist";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Имя, под которым база добавляется в список.
			|Если этот параметр не указан, база добавлена в список не будет (необязательно)");		
	КонецЕсли;

	ИмяКоманды = "-template";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Путь к шаблону для создания информационной базы (*.cf; *.dt).
			|Если шаблон не указан, то будет создана пустая ИБ (необязательно)");		
	КонецЕсли;

	ИмяКоманды = "-db-srvr";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Адрес сервера СУБД");
	КонецЕсли;

	ИмяКоманды = "-sql-offs";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,		
			"Смещение дат на сервере MS SQL (0; 2000 <по умолчанию>)");
	КонецЕсли;
		
	ИмяКоманды = "-createdb";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, ИмяКоманды,
			"Создавать базу данных в случае отсутствия");
	КонецЕсли;
		
	ИмяКоманды = "-allowschjob";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, ИмяКоманды,
			"Разрешить регламентные задания");
	КонецЕсли;

	ИмяКоманды = "-allowlicdstr";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, ИмяКоманды,
			"Разрешить выдачу лицензий сервером 1С");
	КонецЕсли;
		
	ИмяКоманды = "-dbms";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Тип сервера СУБД (MSSQLServer <по умолчанию>; PostgreSQL; IBMDB2; OracleDatabase)");
	КонецЕсли;

	ИмяКоманды = "-db-user";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,
			"Пользователь информационной базы (необязательно)");
	КонецЕсли;

	ИмяКоманды = "-db-pwd";
	Если МассивПараметров.Найти(ИмяКоманды) <> Неопределено Тогда
		Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИмяКоманды,			
			"Пароль пользователя информационной базы (необязательно)");
	КонецЕсли;

КонецПроцедуры