Процедура ПриЗагрузкеБиблиотеки(Знач Путь, СтандартнаяОбработка, Отказ)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьМакет(ОбъединитьПути(Путь, "Перечисления.json"), "/Макеты/Перечисления");
	ДобавитьМакет(ОбъединитьПути(Путь, "ОписаниеФорматаChangeLog.md"), "/Макеты/ОписаниеФорматаChangeLog");
	ДобавитьМакет(ОбъединитьПути(Путь, "ОсобенностиChangeLog.md"), "/Макеты/ОсобенностиChangeLog");
	
КонецПроцедуры