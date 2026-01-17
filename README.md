F&O Trading Data Warehouse Design Assignment
**Overview**
The objective of this design is to efficiently store data and have correct data without redundancy. It can analyze high volume of data . The source data set contains NSE – Future and Options Data which consists of trading data only for multiple future and options. To avoid duplication the schema is designed in 3NF form .
I have made designed 3 tables out of the available raw data present . 
o	Instruments 
o	Contracts 
o	Trades

1.	Instuments Table : 
This table stores high level instruments value/data 
Symbol (eg : Nifty , BankNifty ) Instrument Type (eg : Futidx,Optidk) , Exchange Name (eg : NSE for current dataset )
Idea : Separating instruments helps to avoid repeating symbol and instrument type and also supports future  multi-exchange ingestion

2.	Contracts Table : 
This table stores unique feature of F & O contracts :
Instrument , Expiry Date , Strike Price 
A contract cab be uniquely identified by expiry and strike as these values don’t change daily and need not be in trades table 

3.	Trades Table : 
This table stores daily market activity 
Open, High, Low, Close, Settle Price , etc.
This is the highest-volume table and contains time-series data used for all analytical queries. 
Keeping this as a separate fact table improves performance and supports efficient aggregation queries.

**Technologies Used**
Snowflake (data warehouse)
SQL (analytics and data modeling)
Kaggle (dataset source)
GitHub (version control and submission)
