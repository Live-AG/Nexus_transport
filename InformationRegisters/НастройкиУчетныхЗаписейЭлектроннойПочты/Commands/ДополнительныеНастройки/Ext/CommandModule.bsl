﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияЗаполнения = Новый Структура("УчетнаяЗаписьЭлектроннойПочты", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.ФормаЗаписи",
		Новый Структура("Ключ,ЗначенияЗаполнения", КлючЗаписи(ПараметрКоманды), ЗначенияЗаполнения),
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КлючЗаписи(УчетнаяЗаписьЭлектроннойПочты)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты
		|ИЗ
		|	РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты КАК НастройкиУчетныхЗаписейЭлектроннойПочты
		|ГДЕ
		|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты = &УчетнаяЗаписьЭлектроннойПочты
		|");
	
	Запрос.УстановитьПараметр("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеКлючаЗаписи = Новый Структура("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗаписьЭлектроннойПочты);
	Возврат РегистрыСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.СоздатьКлючЗаписи(ДанныеКлючаЗаписи);
	
КонецФункции

#КонецОбласти
