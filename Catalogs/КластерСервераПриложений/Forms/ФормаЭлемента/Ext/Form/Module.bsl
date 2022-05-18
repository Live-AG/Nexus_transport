﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ТипПодключения = "RAS";
	Иначе
	Попытка
		ТаблицаСводнойИнформации = Справочники.КластерСервераПриложений.ПолучитьМакетОписанияКластера(Объект.Ссылка);
	Исключение
		// TODO:
	КонецПопытки;	
				
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображениеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьБазы_Отладка(Команда)
	
	СвойстваИнформационныхБаз = ПолучитьСвойстваИнформационныхБаз();

КонецПроцедуры

&НаСервере
Функция ПолучитьСвойстваИнформационныхБаз()

	//ПараметрыАдминистрированияКластера = ПолучитьПараметрыАдминистрированияКластера();
	//Возврат АдминистрированиеКластера.СвойстваИнформационныхБаз(Объект.ИдентификаторКластера, ПараметрыАдминистрированияКластера);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтображениеЭлементов()

	Если Объект.ТипПодключения = "RAS" Тогда
		Элементы.ГруппаАдресИПорт.ТекущаяСтраница = Элементы.СтраницаПодключениеRAS;
	ИначеЕсли Объект.ТипПодключения = "COM" Тогда	
		Элементы.ГруппаАдресИПорт.ТекущаяСтраница = Элементы.СтраницаПодключениеCOM;	
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	ОбновитьОтображениеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИдентификатор(Команда)
	
	УстановитьИдентификатор(Параметры);	

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИдентификатор(Параметры)
	
	Отказ = Ложь;
	
	Если  Объект.ТипПодключения = 0 Тогда
		Если Не ЗначениеЗаполнено(Объект.АдресСервераАдминистрирования) Тогда
			Сообщить("Не заполнен адрес сервера", СтатусСообщения.Важное);
			Отказ = Истина;		
		КонецЕсли;  
		
		Если Не ЗначениеЗаполнено(Объект.ПортСервераАдминистрирования) Тогда
			Сообщить("Не заполнен порт сервера", СтатусСообщения.Важное);
			Отказ = Истина;		
		КонецЕсли;
	ИначеЕсли Объект.ТипПодключения = 1 Тогда
		Если Не ЗначениеЗаполнено(Объект.АдресАгентаСервера) Тогда
			Сообщить("Не заполнен адрес сервера", СтатусСообщения.Важное);
			Отказ = Истина;		
		КонецЕсли;  
		
		Если Не ЗначениеЗаполнено(Объект.ПортАгентаСервера) Тогда
			Сообщить("Не заполнен порт сервера", СтатусСообщения.Важное);
			Отказ = Истина;		
		КонецЕсли;
	КонецЕсли;

	Если Не Отказ Тогда
		Объект.ИдентификаторКластера = ПолучитьИдентификаторНаСервере();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторКластера) Тогда
		ПоказатьПредупреждение(, "Успешное подключение");
	Иначе
		ПоказатьПредупреждение(, "Не удалось подключиться");
	КонецЕсли;
	 	
КонецПроцедуры

&НаСервере
Функция ПолучитьИдентификаторНаСервере()
	
	Возврат Справочники.КластерСервераПриложений.ПолучитьИдентификаторКластера(Объект);
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.ИдентификаторКластера) Тогда
		УстановитьИдентификатор(Параметры);		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСводнойИнформацииОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОбработки = Неопределено;
	Если Расшифровка.Свойство("ПараметрыБазы", ПараметрыОбработки) Тогда
		//ОбработатьРегистрациюИнформационнойБазы(ПараметрыОбработки);
		ДополнительныеПараметры = Новый Структура; 
		ДополнительныеПараметры.Вставить("ПараметрыБазы", ПараметрыОбработки);
		ДополнительныеПараметры.Вставить("Кластер", Объект.Ссылка);
		
		ОткрытьФорму("Справочник.ИнформационныеБазы.ФормаОбъекта", Новый Структура("ДополнительныеПараметры", ДополнительныеПараметры));
	КонецЕсли;
	
КонецПроцедуры



