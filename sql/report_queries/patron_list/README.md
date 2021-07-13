# Patron List Report


## Report Details

Brief description: Provides a list of patrons along with related fields that can be used for additional work or to further filter the data: barcode, username, external\_system\_id, patron name fields, patron group, created date, expiration date, updated date, active status, user notes, user departments, custom fields, blocked status, block information, user addresses

NOTE: This report includes patron personal information, which is not GDPR-compliant.


|user\_id|barcode|username|external\_system\_id|user\_last\_name|user\_first\_name|user\_middle\_name|user\_preferred\_first\_name|user\_email|group\_name|created\_date|expiration\_date|updated\_date|active|user\_notes|depts\_list|custom\_field\_name|custom\_field\_value|blocked|block\_code|block\_description|block\_patron\_message|block\_type|block\_expiration\_date|block\_borrowing\_yn|block\_renewals\_yn|block\_requests\_yn|block\_created\_date|user\_all\_addresses|address\_line\_1|address\_line\_2|address\_city|address\_region|address\_country\_id|address\_postal\_code|address\_type\_name|address\_type\_description|is\_primary\_address|
|-------|-------|--------|------------------|--------------|---------------|----------------|-------------------------|----------|----------|------------|---------------|------------|------|----------|----------|-----------------|------------------|-------|----------|-----------------|--------------------|----------|---------------------|------------------|-----------------|-----------------|------------------|------------------|--------------|--------------|------------|--------------|------------------|-------------------|-----------------|------------------------|------------------|
|011dc219-6b7f-4d93-ae7f-f512ed651493|897083256223023|elmer||Huels|Lois|||monserrat@donnelly-skiles.ge|staff|2021-06-01 21:50:17.571-04|2019-09-01 20:00:00-04|2021-06-01 21:50:17.571-04|false|||||false||||||||||[{"addressLine1": "69175 Haley Skyway","addressTypeId": "93d3d88d-499b-45d0-9bc7-ac73c3a19880","city": "Marana","countryId": "US","postalCode": "02013-0332","primaryAddress": true,"region": "NH"}]|69175 Haley Skyway||Marana|NH|US|02013-0332|Home|Home Address|true|
|060d1627-445c-4da2-ab09-a4052b011b1a|1622599172162368504|checkin-all||Admin|checkin-all||||staff|2021-06-01 21:59:32.166-04||2021-06-01 21:59:32.166-04|true|<p>The patron left his laptop. It is in lost and found</p>||||false||||||||||[]||||||||||
|08522da4-668a-4450-a769-3abfae5678ad|548755241194417|johan||Braun|Aleen|||werner@wolff-hauck.lk|staff|2021-06-01 21:50:20.391-04|2020-03-29 20:00:00-04|2021-06-01 21:50:20.391-04|false|||||false||||||||||[{"addressLine1": "32796 Kuhn Drive Suite 950","addressTypeId": "1c4b225f-f669-4e9b-afcd-ebc0e273a34e","city": "Bowling Green","countryId": "US","postalCode": "52150-4432","primaryAddress": true,"region": "CT"}]||||||||||
|0a246f61-d85f-42b6-8dcc-48d25a46690b|855788620413307|maxine||Schamberger|Roxane|Suzanne||sasha@langworth-group.nm.us|staff|2021-06-01 21:50:20.783-04|2019-08-19 20:00:00-04|2021-06-01 21:50:20.783-04|false|||||false||||||||||[{"addressLine1": "86731 Conroy Walk #607","addressTypeId": "1c4b225f-f669-4e9b-afcd-ebc0e273a34e","city": "La Palma","countryId": "US","postalCode": "93045","primaryAddress": true,"region": "NH"}]||||||||||

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to show a particular address type, custom field, patron group, patron active status, or patron block status, or to limit patrons to those with created dates or updated dates greater than or equal to a particular date.