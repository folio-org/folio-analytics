# Overdue Items Report

## Report Details

Brief description: This report lists items with overdue loans, including all item details, patron details, and loan details such as loan date, due date, and number of days overdue. 

The filters for this report are number of days overdue, patron group name (used to identify ILL and Borrow Direct overdue loans), and item location. 

This report generates data with the following format:

|patron\_group\_name|patron\_id|patron\_barcode|last\_name|first\_name|email|current\_item\_effective\_location\_name|current\_item\_permanent\_location\_name|current\_item\_temporary\_location\_name|call\_number|chronology|copy\_number|enumeration|item\_barcode|loan\_date|loan\_renewal\_count|loan\_due\_date|days\_overdue|
|-----------------|---------|--------------|---------|----------|-----|------------------------------------|------------------------------------|------------------------------------|-----------|----------|-----------|-----------|------------|---------|------------------|-------------|------------|
||47f7eaea-1a18-4058-907c-62b7d095c61b|344058867767195|Hilll|Justen|pete@schulist-raynor-and-beer.ar.us|Main Library|||||Copy 1||453987605438|2017-03-05 13:32:31-05|0|2017-03-19 14:32:31-04|1527.0|
||d0fc4228-2e42-49b2-a5b0-9df48897e8c0|109322966933845|Feil|Penelope|anastacio@hansen-dickens-and-mante.vu|Main Library|||||||697685458679|2017-03-03 10:41:54-05|1|2017-03-17 11:41:54-04|1529.0|
||9ad09b01-7429-455f-9f64-e3897027db61|724600319597122|McDermott|Foster|ansley@larson-williamson-and-williamson.eh|Main Library|||||||653285216743|2017-03-05 13:32:31-05|0|2017-03-19 14:32:31-04|1527.0|

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular number of days overdue, patron group, and item location. 

Note: when editing the number of days overdue, the number **should** be surrounded by single quotation marks (e.g., `'20'` for 20 days overdue).
