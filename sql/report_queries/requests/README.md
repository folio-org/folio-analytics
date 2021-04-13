# Requests Report


## Report Details

Brief description: Provides a list of patron requests within a specified date range, and by request type. Data fields also included are patron group, patron status, delivery method (pick-up vs. delivery), owning location, pick-up location. 

NOTE: This report includes patron personal information, which is not GDPR-compliant.

| date\_range | request\_id | request\_date | request\_type | request\_status | pickup\_service\_point\_display\_name | pickup\_service\_point\_name | pickup\_library\_name | fulfilment\_preference | call\_number | barcode | material\_type\_name | permanent\_location\_name | effective\_location\_name | shelving\_title | user\_group | user\_last\_name | user\_first\_name | user\_middle\_name | user\_email |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2000-01-01 to 2022-01-01 | 2e96310e-ba10-47bb-a743-def1dd9d28e2 | 4/6/21 5:05 | Recall | Open - Not yet filled | Circulation Desk -- Hallway | Circ Desk 1 | Datalogisk Institut | Hold Shelf | some-callnumber | 6.97685E+11 | book |  | Main Library |  | staff | Admin | acq-staff |  |  |
| 2000-01-01 to 2022-01-01 | fa4148f7-42e4-43f6-ab15-2eeb2d00867f | 4/6/21 3:59 | Page | Open - Not yet filled | Circulation Desk -- Back Entrance | Circ Desk 2 | Datalogisk Institut | Hold Shelf | K1 .M44 | A14837334314 | text |  | Main Library |  | staff | Admin | acq-admin |  |  |


## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular date range, item permanent location, and/or request status.