﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  ИмяПараметра - Строка
//  УстановленныеПараметры - Массив из Строка
//
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса, УстановленныеПараметры) Экспорт
	
	Если ИменаПараметровСеанса = Неопределено
	 Или ИменаПараметровСеанса.Найти("УстановленныеРасширения") <> Неопределено Тогда
		
		ПараметрыСеанса.УстановленныеРасширения = УстановленныеРасширения(Истина);
		УстановленныеПараметры.Добавить("УстановленныеРасширения");
	КонецЕсли;
	
	Если ИменаПараметровСеанса = Неопределено
	 Или ИменаПараметровСеанса.Найти("ПодключенныеРасширения") <> Неопределено Тогда
		
		Расширения = РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансАктивные);
		ПараметрыСеанса.ПодключенныеРасширения = КонтрольныеСуммыРасширений(Расширения, "БезопасныйРежим");
		УстановленныеПараметры.Добавить("ПодключенныеРасширения");
	КонецЕсли;
	
	Если ИменаПараметровСеанса <> Неопределено
	   И ИменаПараметровСеанса.Найти("ВерсияРасширений") <> Неопределено Тогда
		
		ПараметрыСеанса.ВерсияРасширений = ВерсияРасширений();
		УстановленныеПараметры.Добавить("ВерсияРасширений");
	КонецЕсли;
	
	Если ИменаПараметровСеанса = Неопределено
	   И ТекущийРежимЗапуска() <> Неопределено Тогда
	
		ЗарегистрироватьИспользованиеВерсииРасширений();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает отдельные контрольные суммы для основных расширений и
// исправлений для установки параметра сеанса УстановленныеРасширения и
// дальнейшей проверки изменений.
// 
// Вызывается при запуске для установки параметра сеанса УстановленныеРасширения,
// который требуется для анализа наличия расширений и контроля динамического обновления,
// а также из формы установки расширений конфигурации в режиме 1С:Предприятия.
//
// Для сеанса запущенного без разделителей возвращается только состав неразделенных (общих)
// расширений, независимо от установленных разделителей.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * Основные    - Строка - контрольная сумма всех расширений, кроме исправительных расширений.
//   * Исправления - Строка - контрольная сумма всех исправительных расширений.
//
Функция УстановленныеРасширения(ПриЗапуске = Ложь) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Неразделенные = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		Неразделенные = Ложь;
	КонецЕсли;
	
	РасширенияБазыДанных = РасширенияКонфигурации.Получить();
	Если ПриЗапуске Тогда
		РасширенияПриЗапуске = Новый Соответствие;
		АктивныеРасширения = РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансАктивные);
		Для Каждого Расширение Из АктивныеРасширения Цикл
			РасширенияПриЗапуске.Вставить(КонтрольнаяСуммаРасширения(Расширение), Расширение);
		КонецЦикла;
		НеподключенныеРасширения = РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансОтключенные);
		Для Каждого Расширение Из НеподключенныеРасширения Цикл
			РасширенияПриЗапуске.Вставить(КонтрольнаяСуммаРасширения(Расширение), Расширение);
		КонецЦикла;
		ДобавленныеРасширения = Новый Соответствие;
		Расширения = Новый Массив;
		Для Каждого Расширение Из РасширенияБазыДанных Цикл
			КонтрольнаяСумма = КонтрольнаяСуммаРасширения(Расширение);
			РасширениеПриЗапуске = РасширенияПриЗапуске.Получить(КонтрольнаяСумма);
			Если РасширениеПриЗапуске <> Неопределено Тогда
				ДобавленныеРасширения.Вставить(КонтрольнаяСумма, Истина);
				Расширения.Добавить(РасширениеПриЗапуске);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ОписаниеРасширения Из РасширенияПриЗапуске Цикл
			Если ДобавленныеРасширения.Получить(ОписаниеРасширения.Ключ) = Неопределено Тогда
				Расширения.Добавить(ОписаниеРасширения.Значение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Расширения = РасширенияБазыДанных;
	КонецЕсли;
	
	Индекс = Расширения.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Расширение = Расширения.Получить(Индекс);
		Если Base64Строка(Расширение.ХешСумма) = "AAAAAAAAAAAAAAAAAAAAAAAAAAA=" Тогда
			Расширения.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	
	Основные    = Новый Массив;
	Исправления = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда 
		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");
	Иначе
		МодульОбновлениеКонфигурации = Неопределено;
	КонецЕсли;
	
	Для Каждого Расширение Из Расширения Цикл
		Если Неразделенные И Расширение.ОбластьДействия = ОбластьДействияРасширенияКонфигурации.РазделениеДанных Тогда
			Продолжить;
		КонецЕсли;
		Если МодульОбновлениеКонфигурации <> Неопределено И МодульОбновлениеКонфигурации.ЭтоИсправление(Расширение) Тогда 
			Исправления.Добавить(Расширение);
		Иначе
			Основные.Добавить(Расширение);
		КонецЕсли;
	КонецЦикла;

	УстановленныеРасширения = Новый Структура;
	УстановленныеРасширения.Вставить("Основные", КонтрольныеСуммыРасширений(Основные));
	УстановленныеРасширения.Вставить("Исправления", КонтрольныеСуммыРасширений(Исправления));
	УстановленныеРасширения.Вставить("ОсновныеСостояние", КонтрольныеСуммыРасширений(Основные, "Все"));
	УстановленныеРасширения.Вставить("ИсправленияСостояние", КонтрольныеСуммыРасширений(Исправления, "Все"));
	
	Если ПриЗапуске
	   И АктивныеРасширения.Количество() = 0
	   И НеподключенныеРасширения.Количество() = 0
	   И РасширенияБазыДанных.Количество() <> 0
	   И СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		
		УстановленныеРасширения.Вставить("РасширенияНедоступны");
	КонецЕсли;
	
	Если ПриЗапуске Тогда
		УстановитьНачальноеЗарегистрированноеСостояние(УстановленныеРасширения, УстановленныеРасширения);
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(УстановленныеРасширения);
	
КонецФункции

// Для функции ДлительныеОперации.ЗапуститьФоновоеЗаданиеСКонтекстомКлиента.
Процедура ВставитьЗарегистрированныйСоставУстановленныхРасширений(Параметры) Экспорт
	
	РасширенияИзмененыДинамически();
	
	УстановитьПривилегированныйРежим(Истина);
	УстановленныеРасширения = ПараметрыСеанса.УстановленныеРасширения;
	УстановитьПривилегированныйРежим(Ложь);
	
	Свойства = Новый Структура;
	Свойства.Вставить("ОсновныеСостояние",     УстановленныеРасширения.ОсновныеЗарегистрированноеСостояние);
	Свойства.Вставить("ИсправленияСостояние",  УстановленныеРасширения.ИсправленияЗарегистрированноеСостояние);
	
	Параметры.Вставить("ЗарегистрированныйСоставУстановленныхРасширений", Свойства);
	
КонецПроцедуры

// Для процедуры ДлительныеОперации.ВыполнитьСКонтекстомКлиента.
Процедура ВосстановитьЗарегистрированныйСоставУстановленныхРасширений(Параметры) Экспорт
	
	Если Параметры.Свойство("ЗарегистрированныйСоставУстановленныхРасширений") Тогда
		УстановитьНачальноеЗарегистрированноеСостояние(
			Параметры.ЗарегистрированныйСоставУстановленныхРасширений);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак изменения состава расширений после запуска сеанса.
// 
// Возвращаемое значение:
//  Булево
//
Функция РасширенияИзмененыДинамически() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УстановленныеРасширения = УстановленныеРасширения();
	
	БезИзменений = ПараметрыСеанса.УстановленныеРасширения.Свойство("РасширенияНедоступны")
		Или ПараметрыСеанса.УстановленныеРасширения.ОсновныеСостояние    = УстановленныеРасширения.ОсновныеСостояние
		  И ПараметрыСеанса.УстановленныеРасширения.ИсправленияСостояние = УстановленныеРасширения.ИсправленияСостояние;
	
	ЗарегистрироватьИзменениеУстановленныхРасширений(УстановленныеРасширения, БезИзменений);
	
	Возврат Не БезИзменений;
	
КонецФункции

// Возвращает информацию по измененным расширениям и исправлениям.
//
// Возвращаемое значение:
//  Структура:
//     * Расширения - Структура:
//          * Добавлено - Число
//          * Удалено   - Число
//     * Исправления - Структура:
//          * Добавлено - Число
//          * Удалено   - Число
//
Функция ДинамическиИзмененныеРасширения() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Расширения", Неопределено);
	Результат.Вставить("Исправления", Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	УстановленныеРасширения = УстановленныеРасширения();
	
	БезИзменений = ПараметрыСеанса.УстановленныеРасширения.Свойство("РасширенияНедоступны")
		Или ПараметрыСеанса.УстановленныеРасширения.ОсновныеСостояние    = УстановленныеРасширения.ОсновныеСостояние
		  И ПараметрыСеанса.УстановленныеРасширения.ИсправленияСостояние = УстановленныеРасширения.ИсправленияСостояние;
	
	ЗарегистрироватьИзменениеУстановленныхРасширений(УстановленныеРасширения, БезИзменений);
	
	Если БезИзменений Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ПараметрыСеанса.УстановленныеРасширения.ИсправленияСостояние <> УстановленныеРасширения.ИсправленияСостояние Тогда
		Изменения = ИзмененияВСоставеРасширений(ПараметрыСеанса.УстановленныеРасширения.Исправления, УстановленныеРасширения.Исправления);
		Результат.Исправления = Изменения;
	КонецЕсли;
	
	Если ПараметрыСеанса.УстановленныеРасширения.ОсновныеСостояние <> УстановленныеРасширения.ОсновныеСостояние Тогда
		Изменения = ИзмененияВСоставеРасширений(ПараметрыСеанса.УстановленныеРасширения.ОсновныеСостояние, УстановленныеРасширения.ОсновныеСостояние);
		Результат.Расширения = Изменения;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Добавляет сведения, что сеанс начал использование версии метаданных.
Процедура ЗарегистрироватьИспользованиеВерсииРасширений() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
			МодульУправлениеДоступомСлужебный.ПриРегистрацииИспользованияВерсииРасширенийВНеразделенномСеансе();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ВерсияРасширений = ПараметрыСеанса.ВерсияРасширений;
	
	Если Не ЗначениеЗаполнено(ВерсияРасширений) Тогда
		Возврат;
	КонецЕсли;
	
	ОкругленнаяДатаНачалаСеанса = ОкругленнаяДатаНачалаСеанса();
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВерсияРасширений", ВерсияРасширений);
	Запрос.УстановитьПараметр("ДатаПоследнегоИспользования", ОкругленнаяДатаНачалаСеанса);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	НЕ ВерсииРасширений.ПометкаУдаления
	|	И ВерсииРасширений.Ссылка = &ВерсияРасширений
	|	И ВерсииРасширений.ДатаПоследнегоИспользования < &ДатаПоследнегоИспользования";
	
	// Если в другом сеансе обновляется дата последнего использования текущей версии, тогда
	// нужно дождаться окончания обновления, чтобы избежать очереди исключительных блокировок.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", ВерсияРасширений);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		РезультатЗапроса = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВерсияРасширений);
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			Объект = СлужебныйЭлемент(ВерсияРасширений);
			
			Если Объект <> Неопределено
			   И Объект.ДатаПоследнегоИспользования < ОкругленнаяДатаНачалаСеанса Тогда
				
				Объект.ДатаПоследнегоИспользования = ОкругленнаяДатаНачалаСеанса;
				Объект.Записать();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	ОбновитьПоследнююВерсиюРасширений(ВерсияРасширений);
	
КонецПроцедуры

Функция ПоследняяВерсияРасширений() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.БазоваяФункциональность.ПоследняяВерсияРасширений";
	ХранимыеСвойства = СтандартныеПодсистемыСервер.ПараметрРаботыРасширения(ИмяПараметра, Истина);
	
	Если ХранимыеСвойства = Неопределено
	 Или ТипЗнч(ХранимыеСвойства) <> Тип("Структура")
	 Или Не ХранимыеСвойства.Свойство("ВерсияРасширений")
	 Или Не ХранимыеСвойства.Свойство("ДатаОбновления") Тогда
		
		ХранимыеСвойства = Новый Структура("ВерсияРасширений, ДатаОбновления", , '00010101');
	КонецЕсли;
	
	Возврат ХранимыеСвойства;
	
КонецФункции

// Удаляет устаревшие версии метаданных.
Процедура УдалитьУстаревшиеВерсииПараметров() Экспорт
	
	ДругаяВерсия = ДругаяВерсияРасширений();
	
	Если Не ЗначениеЗаполнено(ДругаяВерсия) Тогда
		ОтключитьРегламентноеЗаданиеЕслиТребуется();
		Возврат;
	КонецЕсли;
	
	ПроверяемыеПриложения = Новый Соответствие;
	ПроверяемыеПриложения.Вставить("1CV8", Истина);
	ПроверяемыеПриложения.Вставить("1CV8C", Истина);
	ПроверяемыеПриложения.Вставить("WebClient", Истина);
	ПроверяемыеПриложения.Вставить("COMConnection", Истина);
	ПроверяемыеПриложения.Вставить("WSConnection", Истина);
	ПроверяемыеПриложения.Вставить("BackgroundJob", Истина);
	ПроверяемыеПриложения.Вставить("SystemBackgroundJob", Истина);
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	НаименьшаяДатаНачалаСеанса = ПолучитьТекущийСеансИнформационнойБазы().НачалоСеанса;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если Сеанс.НачалоСеанса >= НаименьшаяДатаНачалаСеанса
		 Или ПроверяемыеПриложения.Получить(Сеанс.ИмяПриложения) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НаименьшаяДатаНачалаСеанса = Сеанс.НачалоСеанса;
	КонецЦикла;
	НаименьшаяДатаНачалаСеанса = ОкругленнаяДатаНачалаСеанса(НаименьшаяДатаНачалаСеанса);
	
	// Пометка устаревших версий расширений.
	Пока Истина Цикл
		ДругаяВерсия = ДругаяВерсияРасширений(НаименьшаяДатаНачалаСеанса);
		Если Не ЗначениеЗаполнено(ДругаяВерсия) Тогда
			Прервать;
		КонецЕсли;
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ДругаяВерсия);
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			Объект = СлужебныйЭлемент(ДругаяВерсия);
			
			Если Объект <> Неопределено
			   И Объект.ДатаПоследнегоИспользования < НаименьшаяДатаНачалаСеанса Тогда
				
				Объект.ПометкаУдаления = Истина;
				Объект.Записать();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	ОтключитьРегламентноеЗаданиеЕслиТребуется();
	
КонецПроцедуры

// Вызывается из формы Расширения.
Процедура ПриУдаленииВсехРасширений() Экспорт
	
	ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Истина);
	
КонецПроцедуры

// Включает/Отключает регламентное задание УдалениеУстаревшихПараметровРаботыВерсийРасширений.
Процедура ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Включить) Экспорт
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеПредопределенногоРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.УдалениеУстаревшихПараметровРаботыВерсийРасширений, Включить);
	
КонецПроцедуры

// Для общих форм Расширения, УстановленныеИсправления.
//
// Возвращаемое значение:
//  РасширениеКонфигурации
//  Неопределено
//
Функция НайтиРасширение(ИдентификаторРасширения) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(ИдентификаторРасширения));
	Расширения = РасширенияКонфигурации.Получить(Отбор);
	
	Расширение = Неопределено;
	
	Если Расширения.Количество() = 1 Тогда
		Расширение = Расширения[0];
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции

// Для общих форм Расширения, УстановленныеИсправления.
// 
// Параметры:
//  Расширение - РасширениеКонфигурации
//
Процедура ОтключитьПредупрежденияБезопасности(Расширение) Экспорт
	
	Расширение.ЗащитаОтОпасныхДействий = ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений();
	
КонецПроцедуры

// Для общих форм Расширения, УстановленныеИсправления.
Процедура ОтключитьИспользованиеОсновныхРолейДляВсехПользователей(Расширение) Экспорт
	
	Расширение.ИспользоватьОсновныеРолиДляВсехПользователей = Ложь;
	
КонецПроцедуры

// Для общих форм Расширения, УстановленныеИсправления.
Процедура УдалитьРасширения(ИдентификаторыРасширений, ТекстОшибки) Экспорт
	
	УдаляемыеРасширения = Новый Массив;
	
	ТекстОшибки = "";
	Попытка
		УдаляемоеРасширение = "";
		Для Каждого ИдентификаторРасширения Из ИдентификаторыРасширений Цикл
			Расширение = НайтиРасширение(ИдентификаторРасширения);
			Если Расширение <> Неопределено Тогда
				ОписаниеРасширения = Новый Структура;
				ОписаниеРасширения.Вставить("Удалено", Ложь);
				ОписаниеРасширения.Вставить("Расширение", Расширение);
				ОписаниеРасширения.Вставить("ДанныеРасширения", Расширение.ПолучитьДанные());
				УдаляемыеРасширения.Добавить(ОписаниеРасширения);
			КонецЕсли;
		КонецЦикла;
		Индекс = УдаляемыеРасширения.Количество() - 1;
		Пока Индекс >= 0 Цикл
			ОписаниеРасширения = УдаляемыеРасширения[Индекс];
			ОтключитьПредупрежденияБезопасности(ОписаниеРасширения.Расширение);
			ОтключитьИспользованиеОсновныхРолейДляВсехПользователей(ОписаниеРасширения.Расширение);
			УдаляемоеРасширение = ОписаниеРасширения.Расширение.Синоним;
			УдаляемоеРасширение = ?(УдаляемоеРасширение = "", ОписаниеРасширения.Расширение.Имя, УдаляемоеРасширение);
			ОписаниеРасширения.Расширение.Удалить();
			УдаляемоеРасширение = "";
			ОписаниеРасширения.Удалено = Истина;
			Индекс = Индекс - 1;
		КонецЦикла;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось удалить расширение ""%1"" по причине:
			           |%2'"),
			УдаляемоеРасширение,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		Попытка
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
			   И РасширенияКонфигурации.Получить().Количество() = 0 Тогда
				
				Справочники.ВерсииРасширений.ПриУдаленииВсехРасширений();
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'После удаления, при обработке случая удаления всех расширений, произошла ошибка:
				           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		Попытка
			РегистрыСведений.ПараметрыРаботыВерсийРасширений.ОбновитьПараметрыРаботыРасширений();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'После удаления, при подготовке оставшихся расширений к работе, произошла ошибка:
				           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ИнформацияОбОшибкеВосстановления = Неопределено;
		ВосстановлениеВыполнялось = Ложь;
		Попытка
			Для Каждого ОписаниеРасширения Из УдаляемыеРасширения Цикл
				Если Не ОписаниеРасширения.Удалено Тогда
					Продолжить;
				КонецЕсли;
				ОписаниеРасширения.Расширение.Записать(ОписаниеРасширения.ДанныеРасширения);
				ВосстановлениеВыполнялось = Истина;
			КонецЦикла;
		Исключение
			ИнформацияОбОшибкеВосстановления = ИнформацияОбОшибке();
			ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При попытке восстановить удаленные расширения произошла еще одна ошибка:
					           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибкеВосстановления));
		КонецПопытки;
		Если ВосстановлениеВыполнялось
		   И ИнформацияОбОшибкеВосстановления = Неопределено Тогда
			
			ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС
				+ НСтр("ru = 'Удаленные расширения были восстановлены.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Для общих форм Расширения, УстановленныеИсправления.
//
// Возвращаемое значение:
//  Массив из УникальныйИдентификатор
//
Функция ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(ИдентификаторыРасширений) Экспорт
	
	Запросы = Новый Массив;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Если Не МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности() Тогда
		Возврат Запросы;
	КонецЕсли;
	
	Разрешения = Новый Массив;
	
	Для Каждого ИдентификаторРасширения Из ИдентификаторыРасширений Цикл
		ТекущееРасширение = НайтиРасширение(ИдентификаторРасширения);
		Разрешения.Добавить(МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
			ТекущееРасширение.Имя, Base64Строка(ТекущееРасширение.ХешСумма)));
	КонецЦикла;
	
	Запросы.Добавить(МодульРаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов(
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПараметрыРаботыВерсийРасширений"),
		Разрешения));
		
	Возврат Запросы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает контрольные суммы указанных расширений.
//
// Параметры:
//  Расширения - Массив - получить контрольные суммы указанных расширений.
//  УчитыватьСостояниеРасширений - Булево - учитывать признаки Активно и БезопасныйРежим.
//
// Возвращаемое значение:
//  Строка - строки вида "<Имя расширения> (<Версия расширения>) <Контрольная сумма>".
//
Функция КонтрольныеСуммыРасширений(Расширения, СвойстваПодключения = "")
	
	Список = Новый СписокЗначений;
	
	Для Каждого Расширение Из Расширения Цикл
		Список.Добавить(КонтрольнаяСуммаРасширения(Расширение, СвойстваПодключения));
	КонецЦикла;
	
	Если Список.Количество() <> 0 Тогда
		КонтрольнаяСумма = "#" + Метаданные.Имя + " (" + Метаданные.Версия + ")";
		Список.Добавить(КонтрольнаяСумма);
	КонецЕсли;
	
	КонтрольныеСуммы = "";
	Для Каждого Элемент Из Список Цикл
		КонтрольныеСуммы = КонтрольныеСуммы + Символы.ПС + Элемент.Значение;
	КонецЦикла;
	
	Возврат СокрЛ(КонтрольныеСуммы);
	
КонецФункции

// Для функций КонтрольныеСуммыРасширений и УстановленныеРасширения.
Функция КонтрольнаяСуммаРасширения(Расширение, СвойстваПодключения = "")
	
	КонтрольнаяСумма = Расширение.Имя + " (" + Расширение.Версия + ") " + Base64Строка(Расширение.ХешСумма);
	
	Если ЗначениеЗаполнено(СвойстваПодключения) Тогда
		КонтрольнаяСумма = КонтрольнаяСумма + " БезопасныйРежим:" + Расширение.БезопасныйРежим;
	КонецЕсли;
	
	Если СвойстваПодключения = "Все" Тогда
		КонтрольнаяСумма = КонтрольнаяСумма
			+ " ПередаватьВПодчиненныеУзлыРИБ:" + Расширение.ИспользуетсяВРаспределеннойИнформационнойБазе
			+ " Активно:" + Расширение.Активно;
	КонецЕсли;
	
	Возврат КонтрольнаяСумма;
	
КонецФункции

// Возвращает текущую версию расширений.
// Для поиска версии используется описание подключенных расширений.
//
Функция ВерсияРасширений()
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ОписаниеРасширений = ПараметрыСеанса.ПодключенныеРасширения;
	Если Не ЗначениеЗаполнено(ОписаниеРасширений) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииРасширений.Ссылка КАК Ссылка,
	|	ВерсииРасширений.ОписаниеМетаданных КАК ОписаниеРасширений
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	НЕ ВерсииРасширений.ПометкаУдаления";
	
	// Если в другом сеансе создается новая версия, тогда нужно дождаться
	// окончания создания, чтобы избежать очереди исключительных блокировок.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", ПризнакДобавленияНовойВерсии());
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ВерсияНайдена(Выборка, ОписаниеРасширений) Тогда
		ВерсияРасширений = Выборка.Ссылка;
	Иначе
		// Создание новой версии расширений.
		ОкругленнаяДатаНачалаСеанса = ОкругленнаяДатаНачалаСеанса();
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ПризнакДобавленияНовойВерсии());
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			// Повторная проверка, что версия еще не создана,
			// что маловероятно, но возможно между транзакциями.
			РезультатЗапроса = Запрос.Выполнить();
			Выборка = РезультатЗапроса.Выбрать();
			Если ВерсияНайдена(Выборка, ОписаниеРасширений) Тогда
				ВерсияРасширений = Выборка.Ссылка;
			Иначе
				Выборка = РезультатЗапроса.Выбрать();
				Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
					ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Истина);
				КонецЕсли;
				Объект = СлужебныйЭлемент();
				Объект.ОписаниеМетаданных = ОписаниеРасширений;
				Объект.ДатаПоследнегоИспользования = ОкругленнаяДатаНачалаСеанса;
				Объект.Записать();
				ВерсияРасширений = Объект.Ссылка;
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат ВерсияРасширений;
	
КонецФункции

// Для функции ВерсияРасширений.
Функция ВерсияНайдена(Выборка, ОписаниеРасширений)
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ОписаниеРасширений = ОписаниеРасширений Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Для функции ВерсияРасширений.
Функция ПризнакДобавленияНовойВерсии()
	
	Возврат Справочники.ВерсииРасширений.ПолучитьСсылку(
		Новый УникальныйИдентификатор("61ce6265-abb2-11ea-87d6-b06ebfbf08c7"));
	
КонецФункции

// Для функции ВерсияРасширений и процедур УдалитьУстаревшиеВерсииПараметров,
// ЗарегистрироватьИспользованиеВерсииРасширений.
//
Функция ОкругленнаяДатаНачалаСеанса(НачалоСеанса = '00010101')
	
	Если ЗначениеЗаполнено(НачалоСеанса) Тогда
		Возврат НачалоЧаса(НачалоСеанса);
	КонецЕсли;
	
	Возврат НачалоЧаса(ПолучитьТекущийСеансИнформационнойБазы().НачалоСеанса);
	
КонецФункции

// Для функции ВерсияРасширений и процедур УдалитьУстаревшиеВерсииПараметров,
// ЗарегистрироватьИспользованиеВерсииРасширений.
//
Функция СлужебныйЭлемент(Ссылка = Неопределено)
	
	Если Ссылка = Неопределено Тогда
		ЭлементСправочника = СоздатьЭлемент();
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(ВерсииРасширений.Код), 0) КАК МаксимальныйНомер
		|ИЗ
		|	Справочник.ВерсииРасширений КАК ВерсииРасширений";
		Выборка = Запрос.Выполнить().Выбрать();
		ЭлементСправочника.Код = ?(Выборка.Следующий(), Выборка.МаксимальныйНомер, 0) + 1;
	Иначе
		ЭлементСправочника = Ссылка.ПолучитьОбъект();
		Если ЭлементСправочника = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ЭлементСправочника.ДополнительныеСвойства.Вставить("НеВыполнятьКонтрольУдаляемых");
	ЭлементСправочника.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	ЭлементСправочника.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	ЭлементСправочника.ОбменДанными.Загрузка = Истина;
	
	Возврат ЭлементСправочника;
	
КонецФункции

// Для процедуры УдалитьУстаревшиеВерсииПараметров.
Функция ДругаяВерсияРасширений(НаименьшаяДатаНачалаСеанса = '39991231')
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	Запрос.УстановитьПараметр("НаименьшаяДатаНачалаСеанса", НаименьшаяДатаНачалаСеанса);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВерсииРасширений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	ВерсииРасширений.Ссылка <> &ВерсияРасширений
	|	И ВерсииРасширений.ДатаПоследнегоИспользования < &НаименьшаяДатаНачалаСеанса
	|	И НЕ ВерсииРасширений.ПометкаУдаления";
	
	// Если справочник ВерсииРасширений изменяется в другом сеансе,
	// тогда нужно дождаться окончания изменений.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Для процедуры УдалитьУстаревшиеВерсииПараметров.
Процедура ОтключитьРегламентноеЗаданиеЕслиТребуется()

	// Отключение регламентного задания, если осталась только одна версия расширений.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ВерсииРасширений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВерсииРасширений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВерсииРасширений КАК ВерсииРасширений
	|ГДЕ
	|	НЕ ВерсииРасширений.ПометкаУдаления";
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() = 0
		 Или Выборка.Количество() = 1
		   И Выборка.Следующий()
		   И Выборка.Ссылка = ПараметрыСеанса.ВерсияРасширений Тогда
			
			ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Ложь);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для процедуры ЗарегистрироватьИспользованиеВерсииРасширений.
Процедура ОбновитьПоследнююВерсиюРасширений(ВерсияРасширений)
	
	Если КонфигурацияБазыДанныхИзмененаДинамически()
	 Или РасширенияИзмененыДинамически() Тогда
		Возврат;
	КонецЕсли;
	
	ХранимыеСвойства = ПоследняяВерсияРасширений();
	
	Если ХранимыеСвойства.ВерсияРасширений = ВерсияРасширений Тогда
		Возврат;
	КонецЕсли;
	
	ХранимыеСвойства.ВерсияРасширений = ВерсияРасширений;
	ХранимыеСвойства.ДатаОбновления   = ТекущаяДатаСеанса();
	
	ИмяПараметра = "СтандартныеПодсистемы.БазоваяФункциональность.ПоследняяВерсияРасширений";
	СтандартныеПодсистемыСервер.УстановитьПараметрРаботыРасширения(ИмяПараметра, ХранимыеСвойства, Истина);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ЗапланироватьОбновлениеПараметровОграниченияДоступа(
			"ОбновитьПоследнююВерсиюРасширений");
	КонецЕсли;
	
КонецПроцедуры

// Для функции ДинамическиИзмененныеРасширения.
Функция ИзмененияВСоставеРасширений(ТекущийСостав, НовыйСостав)
	СоответствиеНовых = Новый Соответствие;
	Для Каждого Расширение Из СтрРазделить(НовыйСостав, Символы.ПС) Цикл
		Если СтрНачинаетсяС(Расширение, "#") Или Не ЗначениеЗаполнено(Расширение) Тогда
			Продолжить;
		КонецЕсли;
		ИмяИХеш = СтрРазделить(Расширение, " ");
		СоответствиеНовых.Вставить(ИмяИХеш[0], Расширение);
	КонецЦикла;
	
	СоответствиеТекущих = Новый Соответствие;
	Для Каждого Расширение Из СтрРазделить(ТекущийСостав, Символы.ПС) Цикл
		Если СтрНачинаетсяС(Расширение, "#") Или Не ЗначениеЗаполнено(Расширение) Тогда
			Продолжить;
		КонецЕсли;
		ИмяИХеш = СтрРазделить(Расширение, " ");
		СоответствиеТекущих.Вставить(ИмяИХеш[0], Расширение);
	КонецЦикла;
	
	Добавлено = 0;
	Изменено  = 0;
	СписокНовых = Новый Массив;
	Для Каждого НовоеРасширение Из СоответствиеНовых Цикл
		НайденныйЭлемент = СоответствиеТекущих[НовоеРасширение.Ключ];
		Если НайденныйЭлемент = Неопределено Тогда
			Добавлено = Добавлено + 1;
			СписокНовых.Добавить(НовоеРасширение.Ключ);
		ИначеЕсли НайденныйЭлемент <> НовоеРасширение.Значение Тогда
			Изменено = Изменено + 1;
			СоответствиеТекущих.Удалить(НовоеРасширение.Ключ);
		Иначе
			СоответствиеТекущих.Удалить(НовоеРасширение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Удалено = СоответствиеТекущих.Количество();
	
	Результат = Новый Структура;
	Результат.Вставить("Добавлено", Добавлено);
	Результат.Вставить("Изменено", Изменено);
	Результат.Вставить("Удалено", Удалено);
	Результат.Вставить("СписокНовых", СписокНовых);
	
	Возврат Результат;
КонецФункции

// Для функции УстановленныеРасширения и процедуры ВосстановитьЗарегистрированныйСоставУстановленныхРасширений.
Процедура УстановитьНачальноеЗарегистрированноеСостояние(Источник, Приемник = Неопределено)
	
	Если Приемник = Неопределено Тогда
		ОбновитьЗарегистрированноеСостояниеВПараметреСеанса(Источник);
	Иначе
		Приемник.Вставить("ОсновныеЗарегистрированноеСостояние",    Источник.ОсновныеСостояние);
		Приемник.Вставить("ИсправленияЗарегистрированноеСостояние", Источник.ИсправленияСостояние);
	КонецЕсли;
	
КонецПроцедуры

// Для функций РасширенияИзмененыДинамически и ДинамическиИзмененныеРасширения.
Процедура ЗарегистрироватьИзменениеУстановленныхРасширений(УстановленныеРасширения, БезИзменений)
	
	Если ПараметрыСеанса.УстановленныеРасширения.ОсновныеЗарегистрированноеСостояние
	                   = УстановленныеРасширения.ОсновныеСостояние
	   И ПараметрыСеанса.УстановленныеРасширения.ИсправленияЗарегистрированноеСостояние
	                   = УстановленныеРасширения.ИсправленияСостояние Тогда
		Возврат;
	КонецЕсли;
	
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '1. Было:
		           |- расширения:
		           |""%1""
		           |- исправления:
		           |""%2""
		           |2. Стало:
		           |- расширения:
		           |""%3""
		           |- исправления:
		           |""%4""
		           |3. Новый состав, как при запуске сеанса: %5'", КодОсновногоЯзыка),
		ПараметрыСеанса.УстановленныеРасширения.ОсновныеЗарегистрированноеСостояние,
		ПараметрыСеанса.УстановленныеРасширения.ИсправленияЗарегистрированноеСостояние,
		УстановленныеРасширения.ОсновныеСостояние,
		УстановленныеРасширения.ИсправленияСостояние,
		?(БезИзменений, НСтр("ru = 'Да'", КодОсновногоЯзыка), НСтр("ru = 'Нет'", КодОсновногоЯзыка)));
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Расширения конфигурации.Обнаружено изменение установленных расширений'",
		     ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,, Комментарий);
	
	ОбновитьЗарегистрированноеСостояниеВПараметреСеанса(УстановленныеРасширения);
	
КонецПроцедуры

// Для процедур ЗарегистрироватьИзменениеСоставаРасширений,
// УстановитьНачальноеЗарегистрированноеСостояние.
//
Процедура ОбновитьЗарегистрированноеСостояниеВПараметреСеанса(УстановленныеРасширения)
	
	Свойства = Новый Структура(ПараметрыСеанса.УстановленныеРасширения);
	Свойства.ОсновныеЗарегистрированноеСостояние    = УстановленныеРасширения.ОсновныеСостояние;
	Свойства.ИсправленияЗарегистрированноеСостояние = УстановленныеРасширения.ИсправленияСостояние;
	
	ПараметрыСеанса.УстановленныеРасширения = Новый ФиксированнаяСтруктура(Свойства);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли