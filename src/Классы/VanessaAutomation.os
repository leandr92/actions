﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт

	Текст = СтрШаблон("%1 %2", "Проверка log-файлов после выполнения тестов Vanessa-Automation.",
		"Если найдется ошибка в файлах, программа завешится с ошибкой");
	Команда.ДобавитьКоманду("check-errors", Текст,
		Новый VanessaAutomationCheckErrors());		

	Команда.ДобавитьКоманду("dbgs-on",
		"Включение отладчика 1C dbgs.exe. Возвращает в консоль порт, который будет использоваться отладчиком",
		Новый VanessaAutomationDbgsOn());

	Команда.ДобавитьКоманду("dbgs-off",
		"Отключение отладчика 1C dbgs.exe",
		Новый VanessaAutomationDbgsOff());

	Команда.ДобавитьКоманду("run",
		"Запуск тестов Vanessa Automation",
		Новый VanessaAutomationRun());

	Команда.ДобавитьКоманду("tag-change",
		"Замена тега в папке с feature-файлами с одного на другой",
		Новый VanessaAutomationTagChange());

	Команда.ДобавитьКоманду("tag-count",
		"Возвращает количество тегов в каталоге с тестами",
		Новый VanessaAutomationTagCount());

	Текст = СтрШаблон("%1 %2 %3", "Добавление тега всем feature-файлами вида ""@Prefix_Number"".",
		"Prefix - название тега, а Numer по очереди от 1 до Max. Prefix и Max можно задать.",
		"Позволяет разбить feature-файлы на равное количество групп добавленными тегами");
	Команда.ДобавитьКоманду("tag-partition", Текст,
		Новый VanessaAutomationTagPartition());

КонецПроцедуры // ОписаниеКоманды()

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
    
    КомандаПриложения.ВывестиСправку();
    
КонецПроцедуры