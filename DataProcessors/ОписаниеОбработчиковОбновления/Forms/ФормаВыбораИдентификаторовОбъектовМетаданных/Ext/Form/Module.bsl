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
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СправочникИдентификаторыОбъектовМетаданных.Ссылка КАК Ссылка,
	|	СправочникИдентификаторыОбъектовМетаданных.ПометкаУдаления КАК ПометкаУдаления,
	|	СправочникИдентификаторыОбъектовМетаданных.Родитель КАК Родитель,
	|	СправочникИдентификаторыОбъектовМетаданных.Наименование КАК Наименование,
	|	СправочникИдентификаторыОбъектовМетаданных.ПорядокКоллекции КАК ПорядокКоллекции,
	|	СправочникИдентификаторыОбъектовМетаданных.Имя КАК Имя,
	|	СправочникИдентификаторыОбъектовМетаданных.Синоним КАК Синоним,
	|	СправочникИдентификаторыОбъектовМетаданных.ПолноеИмя КАК ПолноеИмя,
	|	СправочникИдентификаторыОбъектовМетаданных.ПолныйСиноним КАК ПолныйСиноним,
	|	СправочникИдентификаторыОбъектовМетаданных.БезДанных КАК БезДанных,
	|	СправочникИдентификаторыОбъектовМетаданных.ЗначениеПустойСсылки КАК ЗначениеПустойСсылки,
	|	СправочникИдентификаторыОбъектовМетаданных.КлючОбъектаМетаданных КАК КлючОбъектаМетаданных,
	|	СправочникИдентификаторыОбъектовМетаданных.НоваяСсылка КАК НоваяСсылка,
	|	СправочникИдентификаторыОбъектовМетаданных.Предопределенный КАК Предопределенный,
	|	СправочникИдентификаторыОбъектовМетаданных.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК СправочникИдентификаторыОбъектовМетаданных";
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "Справочник.ИдентификаторыОбъектовМетаданных";
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокИдентификаторов, СвойстваСписка); 
	
КонецПроцедуры

#КонецОбласти