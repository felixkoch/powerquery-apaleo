let
    Quelle = reservations,
    #"Entfernte Spalten" = Table.RemoveColumns(Quelle,{"page", "bookingId", "status", "checkInTime", "checkOutTime", "property.id", "property.code", "property.name", "property.description", "ratePlan.id", "ratePlan.code", "ratePlan.name", "ratePlan.description", "unitGroup.id", "unitGroup.code", "unitGroup.name", "unitGroup.description", "unitGroup.type", "unit.id", "unit.name", "unit.description", "unit.unitGroupId", "totalGrossAmount.amount", "totalGrossAmount.currency", "arrival", "departure", "created", "modified", "adults", "channelCode", "primaryGuest.firstName", "primaryGuest.middleInitial", "primaryGuest.lastName", "primaryGuest.email", "primaryGuest.phone", "primaryGuest.address.addressLine1", "primaryGuest.address.postalCode", "primaryGuest.address.city", "primaryGuest.address.countryCode", "paymentAccount.accountNumber", "paymentAccount.accountHolder", "paymentAccount.expiryMonth", "paymentAccount.expiryYear", "paymentAccount.paymentMethod", "paymentAccount.payerEmail", "paymentAccount.isVirtual", "paymentAccount.isActive", "guaranteeType", "cancellationFee.id", "cancellationFee.code", "cancellationFee.name", "cancellationFee.description", "cancellationFee.dueDateTime", "cancellationFee.fee.amount", "cancellationFee.fee.currency", "noShowFee.id", "noShowFee.code", "noShowFee.name", "noShowFee.description", "noShowFee.fee.amount", "noShowFee.fee.currency", "balance.amount", "balance.currency", "allFoliosHaveInvoice", "hasCityTax"}),
    #"Erweiterte timeSlices" = Table.ExpandListColumn(#"Entfernte Spalten", "timeSlices"),
    #"Erweiterte timeSlices1" = Table.ExpandRecordColumn(#"Erweiterte timeSlices", "timeSlices", {"from", "to", "serviceDate", "ratePlan", "unitGroup", "unit", "baseAmount", "totalGrossAmount"}, {"from", "to", "serviceDate", "ratePlan", "unitGroup", "unit", "baseAmount", "totalGrossAmount"}),
    #"Erweiterte ratePlan" = Table.ExpandRecordColumn(#"Erweiterte timeSlices1", "ratePlan", {"id", "code", "name", "description", "isSubjectToCityTax"}, {"ratePlan.id", "ratePlan.code", "ratePlan.name", "ratePlan.description", "ratePlan.isSubjectToCityTax"}),
    #"Erweiterte unitGroup" = Table.ExpandRecordColumn(#"Erweiterte ratePlan", "unitGroup", {"id", "code", "name", "description", "type"}, {"unitGroup.id", "unitGroup.code", "unitGroup.name", "unitGroup.description", "unitGroup.type"}),
    #"Erweiterte unit" = Table.ExpandRecordColumn(#"Erweiterte unitGroup", "unit", {"id", "name", "description", "unitGroupId"}, {"unit.id", "unit.name", "unit.description", "unit.unitGroupId"}),
    #"Erweiterte baseAmount" = Table.ExpandRecordColumn(#"Erweiterte unit", "baseAmount", {"grossAmount", "netAmount", "vatType", "vatPercent", "currency"}, {"baseAmount.grossAmount", "baseAmount.netAmount", "baseAmount.vatType", "baseAmount.vatPercent", "baseAmount.currency"}),
    #"Erweiterte totalGrossAmount" = Table.ExpandRecordColumn(#"Erweiterte baseAmount", "totalGrossAmount", {"amount", "currency"}, {"totalGrossAmount.amount", "totalGrossAmount.currency"}),
    #"Umbenannte Spalten" = Table.RenameColumns(#"Erweiterte totalGrossAmount",{{"id", "reservationId"}})
in
    #"Umbenannte Spalten"