﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
		Элементы.СпособСравненияВерсийФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСравненияФайлов");
	Элемент.Вставить("Настройка", "СпособСравненияВерсийФайлов");
	Элемент.Вставить("Значение", СпособСравненияВерсийФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, Истина);
	
	РезультатВыбора = КодВозвратаДиалога.ОК;
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти
