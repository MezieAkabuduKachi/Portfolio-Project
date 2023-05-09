-- Data Cleaning in SQL

SELECT*
FROM `nashville housing data for data cleaning (reuploaded)`;

-- Populate Property Address

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ifnull(A.PropertyAddress, B.PropertyAddress) 
FROM `nashville housing data for data cleaning` A
JOIN `nashville housing data for data cleaning` B 
ON A.ParcelID = B.ParcelID
AND A.UniqueID <> B.UniqueID
WHERE A.PropertyAddress is NULL ;

UPDATE `nashville housing data for data cleaning` A 
JOIN (
  SELECT ParcelID, MAX(UniqueID) AS MaxUniqueID, PropertyAddress
  FROM `nashville housing data for data cleaning`
  GROUP BY ParcelID, PropertyAddress
) B ON A.ParcelID = B.ParcelID AND A.UniqueID = B.MaxUniqueID
SET A.PropertyAddress = IFNULL(A.PropertyAddress, B.PropertyAddress)
WHERE A.PropertyAddress IS NULL;

-- Seperating Address into individual column (Address, City)

SELECT PropertyAddress
FROM `nashville housing data for data cleaning`;

SELECT 
SUBSTRING(PropertyAddress, 1, LOCATE(",", PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, LOCATE(",", PropertyAddress)+1, LENGTH(PropertyAddress)) as City 
FROM `nashville housing data for data cleaning` ;

ALTER TABLE `nashville housing data for data cleaning`
ADD PropertySplitAddress varchar(200) ;

UPDATE `nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(",", PropertyAddress)-1) ;


ALTER TABLE `nashville housing data for data cleaning`
ADD PropertySplitCity varchar(200) ;

UPDATE `nashville housing data for data cleaning`
SET PropertySplitCity =SUBSTRING(PropertyAddress, LOCATE(",", PropertyAddress)+1, LENGTH(PropertyAddress)) ;

SELECT*
FROM `nashville housing data for data cleaning` ;

-- Remove Duplicates

WITH RowNumCTE AS (
SELECT*,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
               SaleDate,
               LegalReference
               ORDER BY 
                 UniqueID
			   ) row_num

FROM `nashville housing data for data cleaning` 
-- ORDER BY ParceID;
)
DELETE RowNumCTE
FROM RowNumCTE  
JOIN (SELECT Row_Num FROM RowNumCTE WHERE Row_Num > 1) AS subquery 
ON RowNumCTE.id = subquery.id;
-- ORDER BY PropertyAddress ;

-- Delete Unused Columns

SELECT*
FROM `nashville housing data for data cleaning` ;

ALTER TABLE portfolioproject.`nashville housing data for data cleaning` 
DROP COLUMN SaleDate









