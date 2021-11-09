DROP TABLE IF EXISTS [dbo].[fetchReviewOfRecieptItems];
DROP TABLE IF EXISTS [dbo].[rewardsReceiptItemList];
DROP TABLE IF EXISTS [dbo].[receipts];
DROP TABLE IF EXISTS [dbo].[users];
DROP TABLE IF EXISTS [dbo].[brands];
DROP TABLE IF EXISTS [dbo].[stateMaster];
DROP TABLE IF EXISTS [dbo].[categoryMaster];
DROP TABLE IF EXISTS [dbo].[rewardStatusMaster];

CREATE TABLE stateMaster(
id varchar(2) PRIMARY KEY,
name varchar(50)
);

CREATE TABLE categoryMaster(
code varchar(20) PRIMARY KEY,
name varchar(50)
);

CREATE TABLE rewardStatusMaster(
code integer PRIMARY KEY,
name varchar(50)
);

CREATE TABLE users(
id varchar(24) PRIMARY KEY, 
stateId varchar(2),
isActive bit,
dateLastLogin date,
dateCreated date,
FOREIGN KEY (stateId) REFERENCES stateMaster(id)
);


CREATE TABLE brands(
barcode numeric(12,0) PRIMARY KEY,
name varchar(200),
brandCode varchar(50),
categoryCode varchar(20),
cpg varchar(20),
topBrand bit,
FOREIGN KEY  (categoryCode) REFERENCES categoryMaster(code)
);


CREATE TABLE receipts(
id varchar(24) PRIMARY KEY, 
userId varchar(24) NOT NULL,
purchaseDate date NOT NULL,
pointsEarned integer,
bonusPointsEarned integer,
bonusPointsEarnedReason varchar(100),
pointsAwardedDate date,
rewardsReceiptStatusId integer,
dateScanned date,
dateFinished date,
dateCreated date NOT NULL,
dateModified date,
FOREIGN KEY (userId) REFERENCES users(id),
FOREIGN KEY (rewardsReceiptStatusId) REFERENCES rewardStatusMaster(code)
);

CREATE TABLE rewardsReceiptItemList(
id integer NOT NULL IDENTITY(1,1),
receiptId varchar(24),
barcode numeric(12,0),
quantity integer NOT NULL,
finalUnitPrice numeric(6,2) NOT NULL,
isPointsAwarded bit NOT NULL,
pointsEarned numeric(10,2),
pointsNotAwardedReason varchar(200),
rewardsGroup varchar(200),
PRIMARY KEY (id, receiptId, barcode),
FOREIGN KEY  (receiptId) REFERENCES receipts(id) ON DELETE CASCADE,
FOREIGN KEY (barcode) REFERENCES brands(barcode)
);

CREATE TABLE fetchReviewOfRecieptItems(
id integer IDENTITY(1,1),
receiptId varchar(24),
receiptItemId integer,
barcode numeric(12,0),
doesNeedsFetchReview bit,
needsFetchReviewReason varchar(50),
userFlaggedType varchar(10),
userFlaggedValue varchar(50),
PRIMARY KEY (id, receiptId, receiptItemId, barcode),
FOREIGN KEY (receiptItemId,receiptId,barcode) REFERENCES rewardsReceiptItemList(id,receiptId, barcode)
ON DELETE CASCADE);


/**********Add dummy data for testing query correctness********/


INSERT INTO StateMaster Values ('NY', 'New York');
INSERT INTO StateMaster Values('NJ', 'New Jersey');
INSERT INTO StateMaster Values('NM', 'New Mexico');

INSERT INTO categoryMaster Values ( 'DAIRY', 'Dairy');
INSERT INTO categoryMaster Values ( 'BEVERAGES', 'Beverages');
INSERT INTO categoryMaster Values ( 'Health & Wellness', 'Health & Wellness');
INSERT INTO categoryMaster Values ('Condiments & Sauces', 'Condiments & Sauces')
INSERT INTO categoryMaster Values ('Breakfast & Cereal', 'Breakfast & Cereal')

INSERT INTO rewardStatusMaster Values (1, 'REJECTED');
INSERT INTO rewardStatusMaster Values (2, 'FLAGGED');
INSERT INTO rewardStatusMaster Values (3, 'FINISHED');

INSERT INTO users Values ('5a43c08fe4b014fd6b6a0612', 'NY', 1, '2021-10-10', '2021-01-01');
INSERT INTO users Values ('5e27526d0bdb6a138c32b556', 'NJ', 1, '2021-10-10', '2021-10-06');
INSERT INTO users Values ('5f2068904928021530f8fc34', 'NJ', 1, '2021-10-10', '2021-11-07');
INSERT INTO users Values ('5fa32b4d898c7a11a6bcebce', 'NY', 1, '2021-10-10', '2021-08-08');
INSERT INTO users Values ('5fa41775898c7a11a6bcef3e', 'NM', 1, '2021-10-10', '2021-07-09');

INSERT INTO brands Values (511111704140, 'DIETCHRIS2', 'Diet Chris Cola', 'BEVERAGES', 'Cogs1' ,0);
INSERT INTO brands Values (511111919803, 'PREGO', 'Prego', 'Condiments & Sauces',' Cogs2',1);
INSERT INTO brands Values (511111906124, 'BASIC 4', 'Basic 4™','Breakfast & Cereal', 'Cpgs2', 0);
INSERT INTO brands Values (511111905967, 'Mountain High', 'Mountain High™', 'DAIRY', 'Cpgs1', 1);
INSERT INTO brands Values (511111906070, 'WHEATIES', ' Wheaties™','Breakfast & Cereal','Cogs3',0);
INSERT INTO brands Values (028400642255, 'FLINTSTONES MULTIVITAMIN GUMMY', ' Flintstones™ MULTIVITAMIN GUMMY', 'Health & Wellness', 'Cogs4', 0);

INSERT INTO receipts Values ('5ff1e1eb0a720f0523000575', '5a43c08fe4b014fd6b6a0612',
'2021-01-10', 500,500,' Receipt number 2 completed, bonus point schedule DEFAULT (5cefdcacf3693e0b50e83a36)','2021-01-10',3,'2021-01-10','2021-01-10', '2021-01-10','2021-01-10');
INSERT INTO receipts Values ('5ff1e1bb0a720f052300056b', '5e27526d0bdb6a138c32b556',
'2021-10-10', 150,150,' Receipt number 5 completed, bonus point schedule DEFAULT (5cefdcacf3693e0b50e83a36)','2021-10-10',3,'2021-10-10','2021-10-10','2021-10-10','2021-10-11');
INSERT INTO receipts Values ('5ff1e1cd0a720f052300056f', '5f2068904928021530f8fc34','2021-11-01', 5,5,'All-receipts receipt bonus','2021-11-01', 3,'2021-11-01','2021-11-01','2021-11-01','2021-11-02');
INSERT INTO receipts Values ('5f9c74f70a7214ad07000037', '5fa32b4d898c7a11a6bcebce',
'2021-10-23', 5,5,' All-receipts receipt bonus','2021-10-23',1,'2021-10-23', '2021-10-23','2021-10-23','2021-10-25');
INSERT INTO receipts Values ('5ff1e1d20a7214ada1000561', '5fa41775898c7a11a6bcef3e',
'2021-10-05', 750,7500,'All-receipts receipt bonus','2021-10-05',3,'2021-10-05',
'2021-10-05','2021-10-05','2021-10-07');

INSERT INTO rewardsReceiptItemList values ('5f9c74f70a7214ad07000037',511111704140,
5, 26, 0, 0, 'User Flagged', NULL);
INSERT INTO rewardsReceiptItemList values ('5ff1e1bb0a720f052300056b', 511111704140,1,1.00,0,0, NULL, NULL);
INSERT INTO rewardsReceiptItemList values ('5ff1e1bb0a720f052300056b',
028400642255, 1, 10, 0, 0, 'Action not allowed for user and CPG', ' DORITOS SPICY SWEET CHILI SINGLE SERVE');
INSERT INTO rewardsReceiptItemList values ('5ff1e1cd0a720f052300056f ', 511111919803,
1, 2.23, 0, 0, NULL, NULL);
INSERT INTO rewardsReceiptItemList values ('5ff1e1d20a7214ada1000561',
511111919803, 3, 2.25, 0, 0, 'Action not allowed for user and CPG', 'OLD EL PASO BEANS & PEPPERS');
INSERT INTO rewardsReceiptItemList values ('5ff1e1d20a7214ada1000561',
511111704140, 1, 1, 0, 0, 'Action not allowed for user and CPG', 'OLD EL PASO BEANS & PEPPERS');


INSERT INTO fetchReviewOfRecieptItems values(
'5f9c74f70a7214ad07000037', 1, 511111704140, 0, NULL, NULL, 26);
INSERT INTO fetchReviewOfRecieptItems values(
'5ff1e1bb0a720f052300056b', 2, 511111704140, NULL, NULL, NULL, NULL);
INSERT INTO fetchReviewOfRecieptItems values(
'5ff1e1bb0a720f052300056b', 3, 028400642255, 1, 'USER_FLAGGED', 'Price', 10);
INSERT INTO fetchReviewOfRecieptItems values(
'5ff1e1cd0a720f052300056f', 4, 511111919803, 0, NULL, NULL, 28);
INSERT INTO fetchReviewOfRecieptItems values(
'5ff1e1d20a7214ada1000561', 5, 511111919803, 1, 'USER_FLAGGED','Price', 2.56);
INSERT INTO fetchReviewOfRecieptItems values(
'5ff1e1d20a7214ada1000561', 6,
511111704140, NULL, NULL, NULL, NULL);


/*** SQL Query ***/

/*** 1.	What are the top 5 brands by receipts scanned for most recent month? ***/
/*** Assuming TOP 5 Brands means Brands with Most Sales ***/
SELECT TOP 5 brnd_itms_sold.name brand, COUNT(*) tot_itm_sold  FROM 
(SELECT brnd.barcode, brnd.name, rct_itm_lst.receiptId, rct_itm_lst.id
FROM receipts rct
JOIN rewardsReceiptItemList rct_itm_lst 
ON rct.id = rct_itm_lst.receiptId
JOIN brands brnd ON brnd.barcode = rct_itm_lst.barcode
WHERE MONTH(dateScanned) 
IN(SELECT MONTH(MAX(dateScanned)) FROM receipts)) brnd_itms_sold
GROUP BY brnd_itms_sold.barcode, brnd_itms_sold.name
ORDER BY tot_itm_sold DESC
/**If  item not found to be considered, query will change with LEFT JOIN rewardsReceiptItemList **/

/*** 2.	How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month? ***/
/***Pseudo code in absence of SQL Server***/
-- CREATE FUNCTION ufn_topBrandsByMonth (@month int)  
-- RETURNS TABLE  
-- AS  
-- RETURN   
-- (  
--   SELECT TOP 5 brnd_itms_sold.name, COUNT(*) tot_itm_sold_rank  FROM 
--     (SELECT brnd.barcode, brnd.name, 
--             rct_itm_lst.receiptId, rct_itm_lst.id
--         FROM receipts rct
--         JOIN rewardsReceiptItemList rct_itm_lst 
--         ON rct.id = rct_itm_lst.receiptId
--         JOIN brands brnd ON brnd.barcode = rct_itm_lst.barcode
--         WHERE MONTH(dateScanned) = @month) brnd_itms_sold
--         GROUP BY brnd_itms_sold.barcode, brnd_itms_sold.name
--         ORDER BY tot_itm_sold_rank DESC
-- );  

-- DECLARE @mon INT;
-- SELECT @mon = MONTH(MAX(dateScanned)) FROM receipts;

-- SELECT * INTO #topBrandLatestMonth FROM ufn_topBrandsByMonth(@mon);
-- SELECT * INTO #topBrandPreviousMonth FROM ufn_topBrandsByMonth(@mon-1);

-- SELECT topBrandLatestMonth.brand brandLatestMonth
--               , topBrandLatestMonth.tot_itm_sold_rank topBrandRankLatestMonth
--               , topBrandPreviousMonth.brand brandPreviousMonth
--               , topBrandPreviousMonth.tot_itm_sold_rank topBrandRankPrevMonth
--    FROM #topBrandLatestMonth topBrandLatestMonth
--    FULL OUTER JOIN #topBrandPreviousMonth topBrandPreviousMonth
--    ON topBrandLatestMonth.brand = topBrandPreviousMonth.brand
   
-- DROP table #topBrandLatestMonth
-- DROP table #topBrandPreviousMonth


/***Tested code***/

DECLARE @month INT;
SELECT @month = MONTH(MAX(dateScanned)) FROM receipts;

 SELECT TOP 5 brnd_itms_sold.name brand, COUNT(*) tot_itm_sold_rank 
 INTO #topBrandLatestMonth  FROM 
    (SELECT brnd.barcode, brnd.name, 
            rct_itm_lst.receiptId, rct_itm_lst.id
        FROM receipts rct
        JOIN rewardsReceiptItemList rct_itm_lst ON rct.id = rct_itm_lst.receiptId
        JOIN brands brnd ON brnd.barcode = rct_itm_lst.barcode
        WHERE MONTH(dateScanned) = @month) brnd_itms_sold
        GROUP BY brnd_itms_sold.barcode, brnd_itms_sold.name
        ORDER BY tot_itm_sold_rank DESC
        
 SELECT TOP 5 brnd_itms_sold.name brand, COUNT(*) tot_itm_sold_rank 
 INTO #topBrandPreviousMonth  FROM 
    (SELECT brnd.barcode, brnd.name, 
            rct_itm_lst.receiptId, rct_itm_lst.id
        FROM receipts rct
        JOIN rewardsReceiptItemList rct_itm_lst ON rct.id = rct_itm_lst.receiptId
        JOIN brands brnd ON brnd.barcode = rct_itm_lst.barcode
        WHERE MONTH(dateScanned) = @month-1) brnd_itms_sold
        GROUP BY brnd_itms_sold.barcode, brnd_itms_sold.name
        ORDER BY tot_itm_sold_rank DESC

SELECT topBrandLatestMonth.brand brandLatestMonth
              , topBrandLatestMonth.tot_itm_sold_rank topBrandRankLatestMonth
              , topBrandPreviousMonth.brand brandPreviousMonth
              , topBrandPreviousMonth.tot_itm_sold_rank topBrandRankPrevMonth
   FROM #topBrandLatestMonth topBrandLatestMonth
   FULL OUTER JOIN #topBrandPreviousMonth topBrandPreviousMonth
   ON topBrandLatestMonth.brand = topBrandPreviousMonth.brand
   
DROP table #topBrandLatestMonth
DROP table #topBrandPreviousMonth

/***3.	When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? ***/
/** There is no status Accepted in Dataset, using Finished instead***/

SELECT CASE WHEN rewardsReceiptStatusId=1 THEN 'Rejected' 
         ELSE 'Finished' END as rewardsReceiptStatus
       , AVG(totSpentPerRct.tot_spent) avgSpentPerStatus
       , RANK() OVER(ORDER BY AVG(totSpentPerRct.tot_spent) DESC) Rank
FROM receipts rct
JOIN
    (SELECT receiptId
          , SUM(finalUnitPrice) tot_spent
        FROM rewardsReceiptItemList  
      GROUP BY receiptId) totSpentPerRct
ON rct.id = totSpentPerRct.receiptId
WHERE rct.rewardsReceiptStatusId IN 
      (SELECT code 
   	 FROM rewardStatusMaster 
   	WHERE name IN('Finished','Rejected'))
 GROUP BY rct.rewardsReceiptStatusId

/*** 4.	When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? ***/
/** There is no status Accepted in Dataset, using Finished instead***/

SELECT CASE WHEN rewardsReceiptStatusId=1 THEN 'Rejected' 
        ELSE 'Finished' END as rewardsReceiptStatus
      ,SUM(itm_count.tot_itms) tot_itm_purchsd
      ,RANK() OVER(ORDER BY SUM(itm_count.tot_itms) DESC) Rank
FROM receipts rct
JOIN
    (SELECT receiptId
          , SUM(quantity) tot_itms
        FROM rewardsReceiptItemList  
      GROUP BY receiptId) itm_count
ON rct.id = itm_count.receiptId
WHERE rct.rewardsReceiptStatusId IN 
       (SELECT code 
   	 FROM rewardStatusMaster 
   	WHERE name IN('Finished','Rejected'))
GROUP BY rct.rewardsReceiptStatusId

/***5.	Which brand has the most spend among users who were created within the past 6 months?***/
SELECT brnd.name brand
             , sale_lst.brand_spending
             , RANK() OVER(ORDER BY sale_lst.brand_spending DESC) Rank
FROM Brands brnd
JOIN 
     (SElECT barcode
           , SUM(finalUnitPrice*quantity) brand_spending
       FROM rewardsReceiptItemList
       WHERE receiptId IN
                  (SELECT id FROM receipts
                     WHERE userId IN
                               (SELECT id FROM Users 
                                  WHERE dateCreated >= DATEADD(month, -6, getdate())))
       GROUP BY barcode) sale_lst 
ON brnd.barcode = sale_lst.barcode

/***6.	Which brand has the most transactions among users who were created within the past 6 months?***/
SELECT brnd.name
             , sale_lst.brand_trnsctn
             , DENSE_RANK() OVER(ORDER BY sale_lst.brand_trnsctn DESC) Rank
FROM Brands brnd
JOIN 
     (SELECT barcode
           , COUNT(*) brand_trnsctn
       FROM rewardsReceiptItemList
       WHERE receiptId IN
                  (SELECT id FROM receipts
                     WHERE userId IN
                               (SELECT id FROM Users 
                                  WHERE dateCreated >= DATEADD(month, -6, getdate())))
       GROUP BY barcode) sale_lst 
ON brnd.barcode = sale_lst.barcode

