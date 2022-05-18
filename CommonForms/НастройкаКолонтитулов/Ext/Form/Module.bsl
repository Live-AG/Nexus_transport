﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ШаблоныТекста;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОпределитьПоведениеВМобильномКлиенте();
	
	ЭтоИндивидуальныеНастройки = Параметры.Свойство("Настройки", Настройки);
	Если Не ЭтоИндивидуальныеНастройки Тогда 
		Элементы.ФормаОК.Заголовок = НСтр("ru = 'Сохранить'");
	КонецЕсли;
	Элементы.ФормаОтмена.Видимость = Не ЭтоИндивидуальныеНастройки;
	Элементы.ФормаУстановитьСтандартныеНастройки.Видимость = ЭтоИндивидуальныеНастройки;
	
	УстановитьСтандартныеНастройкиСервер();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ПримерСтраницы = 1;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ШаблоныТекста = Новый Структура;
	
	ШаблоныТекста.Вставить("Дата" , "[&Дата]");
	ШаблоныТекста.Вставить("Время" , "[&Время]");
	ШаблоныТекста.Вставить("НомерСтраницы" , "[&НомерСтраницы]");
	ШаблоныТекста.Вставить("СтраницВсего" , "[&СтраницВсего]");
	ШаблоныТекста.Вставить("Пользователь" , "[&Пользователь]");
	ШаблоныТекста.Вставить("НазваниеОтчета", "[&НазваниеОтчета]");
	
	ОбновитьОбразец();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстПриИзменении(Элемент)
	ОбновитьОбразец();
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьВерхнийКолонтитулСоСтраницыПриИзменении(Элемент)
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьНижнийКолонтитулСоСтраницыПриИзменении(Элемент)
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ПримерСтраницыПриИзменении(Элемент)
	
	ОбновитьОбразец();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьШаблон(Команда)
	
	Если ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы")
		И ТекущийЭлемент.Вид = ВидПоляФормы.ПолеВвода
		И СтрНайти(ТекущийЭлемент.Имя, "Текст") > 0 Тогда
		ВставитьТекст(ТекущийЭлемент, ШаблоныТекста[Команда.Имя]);	
		
		ОбновитьОбразец();
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШрифтВерхнегоКолонтитула(Команда)
	
	ДиалогВыбораШрифта = Новый ДиалогВыбораШрифта;
	#Если Не ВебКлиент Тогда
	ДиалогВыбораШрифта.Шрифт = ШрифтСверху;
	#КонецЕсли
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаШрифтаВерхнегоКолонтитулаЗавершение", ЭтотОбъект);
	
	ДиалогВыбораШрифта.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШрифтНижнегоКолонтитула(Команда)
	
	ДиалогВыбораШрифта = Новый ДиалогВыбораШрифта;
	#Если Не ВебКлиент Тогда
	ДиалогВыбораШрифта.Шрифт = ШрифтСнизу;
	#КонецЕсли
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаШрифтаНижнегоКолонтитулаЗавершение", ЭтотОбъект);
	
	ДиалогВыбораШрифта.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеВерхнегоКолонтитулаВерх(Команда)
	
	ВертикальноеПоложениеСверху = ВертикальноеПоложение.Верх;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаВерх.Пометка  = Истина;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаЦентр.Пометка = Ложь;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаНиз.Пометка   = Ложь;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеВерхнегоКолонтитулаЦентр(Команда)
	
	ВертикальноеПоложениеСверху = ВертикальноеПоложение.Центр;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаВерх.Пометка  = Ложь;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаЦентр.Пометка = Истина;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаНиз.Пометка   = Ложь;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеВерхнегоКолонтитулаНиз(Команда)
	
	ВертикальноеПоложениеСверху = ВертикальноеПоложение.Низ;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаВерх.Пометка  = Ложь;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаЦентр.Пометка = Ложь;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаНиз.Пометка   = Истина;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеНижнегоКолонтитулаВерх(Команда)
	
	ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Верх;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаВерх.Пометка  = Истина;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаЦентр.Пометка = Ложь;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаНиз.Пометка   = Ложь;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеНижнегоКолонтитулаЦентр(Команда)
	
	ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Центр;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаВерх.Пометка  = Ложь;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаЦентр.Пометка = Истина;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаНиз.Пометка   = Ложь;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ВертикальноеПоложениеНижнегоКолонтитулаНиз(Команда)
	
	ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Низ;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаВерх.Пометка  = Ложь;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаЦентр.Пометка = Ложь;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаНиз.Пометка   = Истина;
	
	ОбновитьОбразец();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ОбновитьНастройки();
	Закрыть(?(Не СтатусНастроек.Стандартные И Не СтатусНастроек.Пустые, Настройки, Неопределено));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	Настройки = Неопределено;
	УстановитьСтандартныеНастройкиСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	Если Не ЭтоМобильныйКлиент Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаТекстВерхнегоКолонтитула.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	Элементы.ГруппаТекстНижнегоКолонтитула.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	
	Элементы.ТекстСлеваСверху.ПодсказкаВвода = НСтр("ru = 'Слева сверху'");
	Элементы.ТекстВЦентреСверху.ПодсказкаВвода = НСтр("ru = 'В центре сверху'");
	Элементы.ТекстСправаСверху.ПодсказкаВвода = НСтр("ru = 'Справа сверху'");
	
	Элементы.ТекстСлеваСнизу.ПодсказкаВвода = НСтр("ru = 'Слева снизу'");
	Элементы.ТекстВЦентреСнизу.ПодсказкаВвода = НСтр("ru = 'В центре снизу'");
	Элементы.ТекстСправаСнизу.ПодсказкаВвода = НСтр("ru = 'Справа снизу'");
	
	Элементы.ТекстСлеваСверху.Высота = 1;
	Элементы.ТекстВЦентреСверху.Высота = 1;
	Элементы.ТекстСправаСверху.Высота = 1;
	
	Элементы.ТекстСлеваСнизу.Высота = 1;
	Элементы.ТекстВЦентреСнизу.Высота = 1;
	Элементы.ТекстСправаСнизу.Высота = 1;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВысотаСтрокиТекстаКолонтитула()
	Возврат 10;
КонецФункции

&НаКлиенте
Процедура ВставитьТекст(ТекущийЭлемент, Текст)
	ЭтотОбъект[ТекущийЭлемент.Имя] = ЭтотОбъект[ТекущийЭлемент.Имя] + Текст;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройки()
	ВерхнийКолонтитул = Новый Структура();
	ВерхнийКолонтитул.Вставить("ТекстСлева", ТекстСлеваСверху);
	ВерхнийКолонтитул.Вставить("ТекстВЦентре", ТекстВЦентреСверху);
	ВерхнийКолонтитул.Вставить("ТекстСправа", ТекстСправаСверху);
	ВерхнийКолонтитул.Вставить("Шрифт", ШрифтСверху);
	ВерхнийКолонтитул.Вставить("ВертикальноеПоложение", ВертикальноеПоложениеСверху);
	ВерхнийКолонтитул.Вставить("НачальнаяСтраница", НачальнаяСтраницаСверху);
	
	НижнийКолонтитул = Новый Структура();
	НижнийКолонтитул.Вставить("ТекстСлева", ТекстСлеваСнизу);
	НижнийКолонтитул.Вставить("ТекстВЦентре", ТекстВЦентреСнизу);
	НижнийКолонтитул.Вставить("ТекстСправа", ТекстСправаСнизу);
	НижнийКолонтитул.Вставить("Шрифт", ШрифтСнизу);
	НижнийКолонтитул.Вставить("ВертикальноеПоложение", ВертикальноеПоложениеСнизу);
	НижнийКолонтитул.Вставить("НачальнаяСтраница", НачальнаяСтраницаСнизу);
	
	Настройки = Новый Структура("ВерхнийКолонтитул, НижнийКолонтитул", ВерхнийКолонтитул, НижнийКолонтитул);
	СтатусНастроек = УправлениеКолонтитулами.СтатусНастроекКолонтитулов(Настройки);
	
	Если Не ЭтоИндивидуальныеНастройки Тогда 
		УправлениеКолонтитулами.СохранитьНастройкиКолонтитулов(Настройки);
	КонецЕсли;
КонецПроцедуры

// Устанавливает последние сохраненные общие настройки.
//
&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер()
	Если Настройки = Неопределено Тогда 
		Настройки = УправлениеКолонтитулами.НастройкиКолонтитулов();
	КонецЕсли;
	
	НачальнаяСтраницаСверху = Настройки.ВерхнийКолонтитул.НачальнаяСтраница;
	ТекстСлеваСверху = Настройки.ВерхнийКолонтитул.ТекстСлева;
	ТекстВЦентреСверху = Настройки.ВерхнийКолонтитул.ТекстВЦентре;
	ТекстСправаСверху = Настройки.ВерхнийКолонтитул.ТекстСправа;
	ШрифтСверху = Настройки.ВерхнийКолонтитул.Шрифт;
	ВертикальноеПоложениеСверху = Настройки.ВерхнийКолонтитул.ВертикальноеПоложение;
	
	НачальнаяСтраницаСнизу = Настройки.НижнийКолонтитул.НачальнаяСтраница;
	ТекстСлеваСнизу = Настройки.НижнийКолонтитул.ТекстСлева;
	ТекстВЦентреСнизу = Настройки.НижнийКолонтитул.ТекстВЦентре;
	ТекстСправаСнизу = Настройки.НижнийКолонтитул.ТекстСправа;
	ШрифтСнизу = Настройки.НижнийКолонтитул.Шрифт;
	ВертикальноеПоложениеСнизу = Настройки.НижнийКолонтитул.ВертикальноеПоложение;
	
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаВерх.Пометка = 
		ВертикальноеПоложениеСверху = ВертикальноеПоложение.Верх;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаЦентр.Пометка = 
		ВертикальноеПоложениеСверху = ВертикальноеПоложение.Центр;
	Элементы.ВертикальноеПоложениеВерхнегоКолонтитулаНиз.Пометка = 
		ВертикальноеПоложениеСверху = ВертикальноеПоложение.Низ;
		
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаВерх.Пометка = 
		ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Верх;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаЦентр.Пометка = 
		ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Центр;
	Элементы.ВертикальноеПоложениеНижнегоКолонтитулаНиз.Пометка = 
		ВертикальноеПоложениеСнизу = ВертикальноеПоложение.Низ;
	
	ПодготовитьОбразец();
КонецПроцедуры

&НаСервере
Процедура ПодготовитьОбразец()
	Образец.Область(1, 1).ВысотаСтроки  = 5;
	Образец.Область(1, 1).ШиринаКолонки = 1;
	
	ЭлементыСтиля = Метаданные.ЭлементыСтиля;
	ЦветОбразца = ЭлементыСтиля.ОбразецНастройкиКолонтитуловЦвет.Значение;
	ШрифтОбразца = ЭлементыСтиля.ОбразецНастройкиКолонтитуловШрифт.Значение;
	
	Образец.Область(2, 2, 4, 4).ЦветРамки = ЦветОбразца;
	Образец.Область(2, 2, 4, 4).РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Забивать;
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Образец.Область(2, 2).Обвести(Линия, Линия,, Линия);
	Образец.Область(2, 3).Обвести(, Линия,, Линия);
	Образец.Область(2, 4).Обвести(, Линия, Линия, Линия);
	
	Образец.Область(4, 2).Обвести(Линия, Линия,, Линия);
	Образец.Область(4, 3).Обвести(, Линия, , Линия);
	Образец.Область(4, 4).Обвести(, Линия, Линия, Линия);
	
	Образец.Область(2, 2).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Образец.Область(2, 3).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Образец.Область(2, 4).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	
	Образец.Область(4, 2).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Образец.Область(4, 3).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Образец.Область(4, 4).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	
	Образец.Область(2, 2).ШиринаКолонки = 40;
	Образец.Область(2, 3).ШиринаКолонки = 40;
	Образец.Область(2, 4).ШиринаКолонки = 40;
	
	Образец.Область(3, 2).Текст      = Символы.ПС + НСтр("ru = 'Образец отчета'") + Символы.ПС + " ";
	Образец.Область(3, 2).Шрифт      = ШрифтОбразца;
	Образец.Область(3, 2).ЦветТекста = ЦветОбразца;
	
	Образец.Область(3, 2).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	
	Образец.Область(3, 2, 3, 4).Объединить();
	Образец.Область(3, 2, 3, 4).Обвести(Линия, Линия, Линия, Линия);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОбразец()
	Образец.Область(2, 2, 2, 4).Шрифт = ШрифтСверху;
	Образец.Область(4, 2, 4, 4).Шрифт = ШрифтСнизу;
	
	Образец.Область(2, 2, 2, 4).ВертикальноеПоложение = ВертикальноеПоложениеСверху;
	Образец.Область(4, 2, 4, 4).ВертикальноеПоложение = ВертикальноеПоложениеСнизу;
	
	КоличествоСтрокСверху = Макс(
		2,
		КоличествоСтрокВТексте(ТекстСлеваСверху),
		КоличествоСтрокВТексте(ТекстВЦентреСверху),
		КоличествоСтрокВТексте(ТекстСправаСверху));
		
	КоличествоСтрокСнизу = Макс(
		2,
		КоличествоСтрокВТексте(ТекстСлеваСнизу),
		КоличествоСтрокВТексте(ТекстВЦентреСнизу),
		КоличествоСтрокВТексте(ТекстСправаСнизу));
		
	Образец.Область(2, 2).ВысотаСтроки = КоличествоСтрокСверху * ВысотаСтрокиТекстаКолонтитула();
	Образец.Область(4, 2).ВысотаСтроки = КоличествоСтрокСнизу * ВысотаСтрокиТекстаКолонтитула();
		
	Образец.Область(2, 2).Текст = ЗаполнитьШаблон(ТекстСлеваСверху, НачальнаяСтраницаСверху);
	Образец.Область(2, 3).Текст = ЗаполнитьШаблон(ТекстВЦентреСверху, НачальнаяСтраницаСверху);
	Образец.Область(2, 4).Текст = ЗаполнитьШаблон(ТекстСправаСверху, НачальнаяСтраницаСверху);
	
	Образец.Область(4, 2).Текст = ЗаполнитьШаблон(ТекстСлеваСнизу, НачальнаяСтраницаСнизу);
	Образец.Область(4, 3).Текст = ЗаполнитьШаблон(ТекстВЦентреСнизу, НачальнаяСтраницаСнизу);
	Образец.Область(4, 4).Текст = ЗаполнитьШаблон(ТекстСправаСнизу, НачальнаяСтраницаСнизу);
КонецПроцедуры

&НаКлиенте
Функция КоличествоСтрокВТексте(Текст)
	Возврат СтрРазделить(Текст, Символы.ПС).Количество();
КонецФункции

&НаКлиенте
Функция ЗаполнитьШаблон(Шаблон, НачальнаяСтраница)
	Если НачальнаяСтраница > ПримерСтраницы Тогда
		Результат = "";
	Иначе
		ДатаСегодня = ОбщегоНазначенияКлиент.ДатаСеанса();
		Результат = СтрЗаменить(Шаблон   , "[&Время]"         , Формат(ДатаСегодня, "ДЛФ=T"));
		Результат = СтрЗаменить(Результат, "[&Дата]"          , Формат(ДатаСегодня, "ДЛФ=D"));
		Результат = СтрЗаменить(Результат, "[&НазваниеОтчета]", НСтр("ru = 'Стандартный отчет'"));
		Результат = СтрЗаменить(Результат, "[&Пользователь]"  , Строка(ТекущийПользователь));
		Результат = СтрЗаменить(Результат, "[&НомерСтраницы]" , ПримерСтраницы);
		Результат = СтрЗаменить(Результат, "[&СтраницВсего]"  , "9");
	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура НастройкаШрифтаВерхнегоКолонтитулаЗавершение (ВыбранныйШрифт, Параметры) Экспорт
	Если ВыбранныйШрифт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШрифтСверху = ВыбранныйШрифт;
	ОбновитьОбразец();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаШрифтаНижнегоКолонтитулаЗавершение (ВыбранныйШрифт, Параметры) Экспорт
	Если ВыбранныйШрифт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШрифтСнизу = ВыбранныйШрифт;
	ОбновитьОбразец();
КонецПроцедуры

#КонецОбласти