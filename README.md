# Power Query apaleo

Starter files to use the apaleo API directly from Excel and Power BI using Power Query / M.

## Goals
[x] Use PowerQuery to download *all* reservations into Excel or Power BI (Pagination)  
[x] Automatic data refresh in Power BI Service  
[ ] Rebuild all KPI from GM Report in Power BI  
[ ] Example Power BI Report

## How to use
1. Get ClientID und Secret by installing this connected app: https://app.apaleo.com/apps/connected-apps/create?clientCode=TAPAPALEO&clientName=tap-apaleo&secret=tap-apaleo%20is%20a%20Singer%20tap%20for%20apaleo.&clientScopes=%5B%22maintenances.read%22,%22rateplans.read-corporate%22,%22reservations.read%22,%22setup.read%22%5D&piiMode=Retrieve
2. **Excel:** Start with an empty file. Data -> Get Data -> Launch Power Query Editor. On the left side under Queries click right: New query -> Other sources -> Empty query. Right click on the newly created "Query1". Rename it to "reservations". Right click again, select "Advanced editor". Copy and paste content of `reservations.m`. Replace "CHANGE_ME" with values of step one. Click "Done". Click on "Close & Apply" to close the Power Query editor.  
**Power BI:** Start with an empty file. Click on "Transform data" to start the Power Query editor. On the left side under Queries click right: New query -> Empty query. Right click on the newly created "Query1". Rename it to "reservations". Right click again, select "Advanced editor". Copy and paste content of `reservations.m`. Replace "CHANGE_ME" with values of step one. Click "Done". Click on "Close & Apply" to close the Power Query editor.
3. Bonus Step: Open Power Query editor again. Add a new query "timeSlices". Copy and paste content of `timeSlices.m`.

## Caution
Please keep in mind: If you have 50,000+ reservations in your account a data refresh will make 50 request for 1,000 reservations to the apaleo API. If you have more data in your account, consider reducing the amount of reservations retrieved by adjusting `STARTDATE` or consider using an ETL pipeline (https://github.com/felixkoch/apaleo-pipeline).

## Consulting / Hosting / Open for work
I'm a freelance Full Stack Developer & Data Analyst from near Hamburg. I can help you with creating meaningful reports in Power BI. Please get in touch:

Felix Koch  
felix@tagungshotels.info  
+49 4266 999 999 9  
[Make an appointment](https://meetings.hubspot.com/felix137)  
[https://felixkoch.de](https://felixkoch.de)  
[Imprint](https://tagungshotels.info/impressum)