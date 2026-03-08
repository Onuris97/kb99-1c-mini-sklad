

Функция ПолучитьАктуальныеКурсыВалют() Экспорт
	
	Соединение = Новый HTTPСоединение("www.cbr.ru");
	
	// Формирование SOAP-запроса
	ТекущаяДатаXML = Формат(ТекущаяДата(), "ДФ=yyyy-MM-ddThh:mm:ss");
	ТекстЗапроса = 
		"<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|				xmlns:xsd=""http://www.w3.org/2001/XMLSchema""
		|				xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
		|	<soap:Body>
		|		<GetCursOnDateXML xmlns=""http://web.cbr.ru/"">
		|			<On_date>" + ТекущаяДатаXML + "</On_date>
		|		</GetCursOnDateXML>
		|	</soap:Body>
		|</soap:Envelope>";
	
	// Создание HTTP-запроса и установка заголовков
	Запрос = Новый HTTPЗапрос("/DailyInfoWebServ/DailyInfo.asmx");
	Запрос.Заголовки.Вставить("Content-Type", "text/xml; charset=utf-8");
	Запрос.Заголовки.Вставить("SOAPAction", "http://web.cbr.ru/GetCursOnDateXML");
	Запрос.УстановитьТелоИзСтроки(ТекстЗапроса);
	
	// Отправка запроса
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		РезультатXML = Ответ.ПолучитьТелоКакСтроку();
	Иначе
		Сообщить("Ошибка запроса: " + Ответ.КодСостояния);
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(РезультатXML);
	
	ДанныеXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Возврат ДанныеXDTO.Body.GetCursOnDateXMLResponse.GetCursOnDateXMLResult.ValuteData.ValuteCursOnDate;
	
КонецФункции


Функция ПолучитьСписокВалют() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Валюты.Ссылка КАК Ссылка,
		|	Валюты.Код КАК Код
		|ИЗ
		|	Справочник.Валюты КАК Валюты";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();	
	
КонецФункции
















