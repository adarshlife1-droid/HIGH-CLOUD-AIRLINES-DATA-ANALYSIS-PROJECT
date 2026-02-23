use high_cloud_airlines;

#A. Year

SELECT DISTINCT
  YEAR(Datefiled) AS Year
FROM high_cloud_flights;

#B. Month Number

SELECT DISTINCT
  MONTH(Datefiled) AS MonthNo
FROM high_cloud_flights ;

#C. Month Full Name

SELECT DISTINCT
  MONTHNAME(Datefiled) AS MonthFullName
FROM high_cloud_flights;

#D. Quarter (Q1–Q4)

SELECT DISTINCT
  CONCAT('Q', QUARTER(Datefiled)) AS Quarter
FROM high_cloud_flights;

#E. YearMonth (YYYY-MMM)

SELECT DISTINCT
  DATE_FORMAT(Datefiled, '%Y-%b') AS YearMonth
FROM high_cloud_flights;

#F. Weekday Number

SELECT DISTINCT
  WEEKDAY(Datefiled) + 1 AS WeekdayNo
FROM high_cloud_flights;

#G. Weekday Name

SELECT DISTINCT
  DAYNAME(Datefiled) AS WeekdayName
FROM high_cloud_flights;

#H. Financial Month (Apr–Mar)

SELECT
  Datefiled,
  CASE
    WHEN MONTH(Datefiled) >= 4 THEN CONCAT('FM', MONTH(Datefiled) - 3)
    ELSE CONCAT('FM', MONTH(Datefiled) + 9)
  END AS FinancialMonth
FROM high_cloud_flights;


#I. Financial Quarter
SELECT
  Datefiled,
  CASE
    WHEN MONTH(Datefiled) BETWEEN 4 AND 6 THEN 'FQ1'
    WHEN MONTH(Datefiled) BETWEEN 7 AND 9 THEN 'FQ2'
    WHEN MONTH(Datefiled) BETWEEN 10 AND 12 THEN 'FQ3'
    ELSE 'FQ4'
  END AS FinancialQuarter
FROM high_cloud_flights;

#A. Load Factor by Year
SELECT
  YEAR(Datefiled) AS Year,
  ROUND(
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2
  ) AS LoadFactorPercent
FROM high_cloud_flights
GROUP BY YEAR(Datefiled)
ORDER BY Year;


#B. Load Factor by Quarter

SELECT
  CONCAT('Q', QUARTER(Datefiled)) AS Quarter,
  ROUND(
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2
  ) AS LoadFactorPercent
FROM high_cloud_flights
GROUP BY CONCAT('Q', QUARTER(Datefiled))
ORDER BY Quarter;


#C. Load Factor by Month

SELECT
  MONTHNAME(Datefiled) AS Month,
  ROUND(
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2
  ) AS LoadFactorPercent
FROM high_cloud_flights
GROUP BY MONTH(Datefiled), MONTHNAME(Datefiled)
ORDER BY MONTH(Datefiled);


#3. LOAD FACTOR BY CARRIER NAME

SELECT
    `Carrier Name`,
    ROUND(
        AVG(`# Transported Passengers` * 1.0 / `# Available Seats`) * 100,
        2
    ) AS LoadFactorPercent
FROM high_cloud_flights
WHERE
    `# Available Seats` > 0
    AND `# Transported Passengers` > 0
    AND `%Service Class ID` IN ('L','F')
GROUP BY `Carrier Name`
ORDER BY LoadFactorPercent desc;

#4. TOP 10 CARRIERS BY PASSENGER PREFERENCE
SELECT
  `Carrier Name`,
  SUM(`# Transported Passengers`) AS TotalPassengers
FROM high_cloud_flights
GROUP BY `Carrier Name`
ORDER BY TotalPassengers DESC
LIMIT 10;


#5. TOP ROUTES (From–To City) BY NUMBER OF FLIGHTS


SELECT
  `From - To City`,
  COUNT(*) AS NumberOfFlights
FROM high_cloud_flights
GROUP BY `From - To City`
ORDER BY NumberOfFlights DESC
LIMIT 10;


#6. LOAD FACTOR: WEEKEND vs WEEKDAY

SELECT
  CASE
    WHEN DAYOFWEEK(`Datefiled`) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS DayType,
  ROUND(
    SUM(`# Transported Passengers`)
    /
    (SELECT SUM(`# Transported Passengers`) FROM high_cloud_flights)
    * 100,
    2
  ) AS PassengerSharePercent
FROM high_cloud_flights
GROUP BY
  CASE
    WHEN DAYOFWEEK(`Datefiled`) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END;


#7. FILTER: SOURCE → DESTINATION SEARCH
SELECT *
FROM high_cloud_flights
WHERE
  `Origin Country` = 'United States'
  AND `Origin State` = 'Alaska'
  AND `Origin City` = 'Nome, AK'
  AND `Destination Country` = 'United States'
  AND `Destination State` = 'Alaska'
  AND `Destination City` = 'Bethel, AK';

#NUMBER OF FLIGHTS BY DISTANCE GROUP

SELECT
    CASE `%Distance Group ID`
        WHEN 1 THEN 'Less Than 500 Miles'
        WHEN 2 THEN '500–999 Miles'
        WHEN 3 THEN '1000–1499 Miles'
        WHEN 4 THEN '1500–1999 Miles'
        WHEN 5 THEN '2000–2499 Miles'
        WHEN 6 THEN '2500–2999 Miles'
        WHEN 7 THEN '3000–3499 Miles'
        WHEN 8 THEN '3500–3999 Miles'
        WHEN 9 THEN '4000–4499 Miles'
        WHEN 10 THEN '4500–4999 Miles'
        WHEN 11 THEN '5000–5499 Miles'
        WHEN 12 THEN '5500–5999 Miles'
        WHEN 13 THEN '6000–6499 Miles'
        WHEN 14 THEN '6500–6999 Miles'
        WHEN 15 THEN '7000–7499 Miles'
        WHEN 16 THEN '7500–7999 Miles'
        WHEN 17 THEN '8000–8499 Miles'
        WHEN 18 THEN '8500–8999 Miles'
        WHEN 19 THEN '9000–9499 Miles'
        WHEN 20 THEN '9500–9999 Miles'
        ELSE 'Unknown'
    END AS DistanceInterval,
    COUNT(*) AS NumberOfFlights
FROM high_cloud_flights
GROUP BY `%Distance Group ID`
ORDER BY NumberOfFlights DESC;