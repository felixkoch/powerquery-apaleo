let
    CLIENTID = "CHANGE_ME",
    SECRET = "CHANGE_ME",
    STARTDATE="2020-01-01", //YYYY-MM-DD
    
    AccessToken = Json.Document(Web.Contents("https://identity.apaleo.com/connect/token", 
    [
        Headers=[#"Content-Type"="application/x-www-form-urlencoded;charset=UTF-8", Authorization="Basic " & Binary.ToText(Text.ToBinary(CLIENTID& ":" & SECRET),0)],
        Content=Text.ToBinary("grant_type=client_credentials")
        
    ]))[access_token],
    total = Json.Document(Web.Contents("https://api.apaleo.com/booking/v1/reservations?pageNumber=1&pageSize=10", 
    [
        Headers=[ Authorization="Bearer " & AccessToken],
        Query=[dateFilter="Creation",from=STARTDATE&"T00:00:00Z"]
    ]))[count],
    pageSize = 1000,
    pages = Number.RoundUp(total/pageSize),
    liste = List.Numbers(1, pages),
    #"In Tabelle konvertiert" = Table.FromList(liste, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Geänderter Typ" = Table.TransformColumnTypes(#"In Tabelle konvertiert",{{"Column1", type text}}),
    #"Umbenannte Spalten" = Table.RenameColumns(#"Geänderter Typ",{{"Column1", "page"}}),
    #"Hinzugefügte benutzerdefinierte Spalte" = Table.AddColumn(#"Umbenannte Spalten", "Benutzerdefiniert", each Json.Document(Web.Contents("https://api.apaleo.com/booking/v1/reservations?expand=timeSlices&pageSize=1000", 
    [
        Headers=[ Authorization="Bearer " & AccessToken],
        Query=[pageNumber=[page], dateFilter="Creation",from=STARTDATE&"T00:00:00Z"]
    ]))),
    #"Erweiterte Benutzerdefiniert" = Table.ExpandRecordColumn(#"Hinzugefügte benutzerdefinierte Spalte", "Benutzerdefiniert", {"reservations"}, {"reservations"}),
    #"Erweiterte reservations" = Table.ExpandListColumn(#"Erweiterte Benutzerdefiniert", "reservations"),
    #"Erweiterte reservations1" = Table.ExpandRecordColumn(#"Erweiterte reservations", "reservations", {"id", "bookingId", "status", "checkInTime", "checkOutTime", "property", "ratePlan", "unitGroup", "unit", "totalGrossAmount", "arrival", "departure", "created", "modified", "adults", "channelCode", "primaryGuest", "paymentAccount", "guaranteeType", "cancellationFee", "noShowFee", "balance", "timeSlices", "allFoliosHaveInvoice", "hasCityTax"}, {"id", "bookingId", "status", "checkInTime", "checkOutTime", "property", "ratePlan", "unitGroup", "unit", "totalGrossAmount", "arrival", "departure", "created", "modified", "adults", "channelCode", "primaryGuest", "paymentAccount", "guaranteeType", "cancellationFee", "noShowFee", "balance", "timeSlices", "allFoliosHaveInvoice", "hasCityTax"}),
    #"Erweiterte property" = Table.ExpandRecordColumn(#"Erweiterte reservations1", "property", {"id", "code", "name", "description"}, {"property.id", "property.code", "property.name", "property.description"}),
    #"Erweiterte ratePlan" = Table.ExpandRecordColumn(#"Erweiterte property", "ratePlan", {"id", "code", "name", "description"}, {"ratePlan.id", "ratePlan.code", "ratePlan.name", "ratePlan.description"}),
    #"Erweiterte unitGroup" = Table.ExpandRecordColumn(#"Erweiterte ratePlan", "unitGroup", {"id", "code", "name", "description", "type"}, {"unitGroup.id", "unitGroup.code", "unitGroup.name", "unitGroup.description", "unitGroup.type"}),
    #"Erweiterte unit" = Table.ExpandRecordColumn(#"Erweiterte unitGroup", "unit", {"id", "name", "description", "unitGroupId"}, {"unit.id", "unit.name", "unit.description", "unit.unitGroupId"}),
    #"Erweiterte totalGrossAmount" = Table.ExpandRecordColumn(#"Erweiterte unit", "totalGrossAmount", {"amount", "currency"}, {"totalGrossAmount.amount", "totalGrossAmount.currency"}),
    #"Erweiterte primaryGuest" = Table.ExpandRecordColumn(#"Erweiterte totalGrossAmount", "primaryGuest", {"firstName", "middleInitial", "lastName", "email", "phone", "address"}, {"primaryGuest.firstName", "primaryGuest.middleInitial", "primaryGuest.lastName", "primaryGuest.email", "primaryGuest.phone", "primaryGuest.address"}),
    #"Erweiterte paymentAccount" = Table.ExpandRecordColumn(#"Erweiterte primaryGuest", "paymentAccount", {"accountNumber", "accountHolder", "expiryMonth", "expiryYear", "paymentMethod", "payerEmail", "isVirtual", "isActive"}, {"paymentAccount.accountNumber", "paymentAccount.accountHolder", "paymentAccount.expiryMonth", "paymentAccount.expiryYear", "paymentAccount.paymentMethod", "paymentAccount.payerEmail", "paymentAccount.isVirtual", "paymentAccount.isActive"}),
    #"Erweiterte cancellationFee" = Table.ExpandRecordColumn(#"Erweiterte paymentAccount", "cancellationFee", {"id", "code", "name", "description", "dueDateTime", "fee"}, {"cancellationFee.id", "cancellationFee.code", "cancellationFee.name", "cancellationFee.description", "cancellationFee.dueDateTime", "cancellationFee.fee"}),
    #"Erweiterte cancellationFee.fee" = Table.ExpandRecordColumn(#"Erweiterte cancellationFee", "cancellationFee.fee", {"amount", "currency"}, {"cancellationFee.fee.amount", "cancellationFee.fee.currency"}),
    #"Erweiterte noShowFee" = Table.ExpandRecordColumn(#"Erweiterte cancellationFee.fee", "noShowFee", {"id", "code", "name", "description", "fee"}, {"noShowFee.id", "noShowFee.code", "noShowFee.name", "noShowFee.description", "noShowFee.fee"}),
    #"Erweiterte noShowFee.fee" = Table.ExpandRecordColumn(#"Erweiterte noShowFee", "noShowFee.fee", {"amount", "currency"}, {"noShowFee.fee.amount", "noShowFee.fee.currency"}),
    #"Erweiterte balance" = Table.ExpandRecordColumn(#"Erweiterte noShowFee.fee", "balance", {"amount", "currency"}, {"balance.amount", "balance.currency"}),
    #"Erweiterte primaryGuest.address" = Table.ExpandRecordColumn(#"Erweiterte balance", "primaryGuest.address", {"addressLine1", "postalCode", "city", "countryCode"}, {"primaryGuest.address.addressLine1", "primaryGuest.address.postalCode", "primaryGuest.address.city", "primaryGuest.address.countryCode"})
in
    #"Erweiterte primaryGuest.address"