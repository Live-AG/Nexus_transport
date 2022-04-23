﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПутьКФайлуПрограммы	= "C:\Program Files\1cv8\common\1cestart.exe";    
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Сервер1С",			"Сервер1С");	
	СтруктураРеквизитов.Вставить("ПортКластера",		"Сервер1С.ПортКластера");	
	СтруктураРеквизитов.Вставить("ИмяНаСервере1С",	"ИмяНаСервере1С");
	
	СтруктураРеквизитов = ПолучитьЗначениеРаквизита(ПараметрКоманды, СтруктураРеквизитов); 
	
	КомандаЗапуска = СтрШаблон("%1 DESIGNER /S""%2:%3\%4""", 
							ПутьКФайлуПрограммы, 
							СтруктураРеквизитов.Сервер1С,
							Формат(СтруктураРеквизитов.ПортКластера, "ЧГ=0"),
							СтруктураРеквизитов.ИмяНаСервере1С);
	
	ЗапуститьПриложение(КомандаЗапуска);        
	
КонецПроцедуры


&НаСервере
Функция ПолучитьЗначениеРаквизита(Объект, Знач СтруктураРеквизитов)
	
	ИмяТаблицы = ОбщегоНазначения.ИмяТаблицыПоСсылке(Объект);
	ТекстПолей = "";
	Для Каждого ЭлементСтруктурыРеквизитов Из СтруктураРеквизитов Цикл
		
		ТекстПолей = ТекстПолей + "," + Символы.ПС + 
					ЭлементСтруктурыРеквизитов.Значение + " КАК " + ЭлементСтруктурыРеквизитов.Ключ;
		
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				|	ДанныеОбъекта.Ссылка КАК Ссылка" + ТекстПолей + "
				|ИЗ                           	
				|	" + ИмяТаблицы + " КАК ДанныеОбъекта
				|ГДЕ
				|	ДанныеОбъекта.Ссылка = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Выборка);				
	
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;

КонецФункции // ПолучитьЗначениеРаквизита()