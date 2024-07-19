-- 1. View the Initial Dataset
-- Select all columns from the initial dataset
Select *
From PortfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- 2. Standardize Date Format

-- 2.1 Add a new column SaleDateConverted of Date data type
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date;

-- 2.2 Update SaleDateConverted with the standardized SaleDate values
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

-- Alternative way to add and populate SaleDateConverted column in a single step
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted AS CONVERT(Date, SaleDate);

 --------------------------------------------------------------------------------------------------------------------------

-- 3. Populate Missing Property Addresses

-- 3.1 Select records with missing PropertyAddress
Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
ORDER BY ParcelID;

-- 3.2 Update missing PropertyAddress using matching records
UPDATE a
SET PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL AND a.[UniqueID] <> b.[UniqueID];

--------------------------------------------------------------------------------------------------------------------------

-- 4. Break Out Address into Individual Columns

-- 4.1 Select PropertyAddress
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing;
--Where PropertyAddress is null
--order by ParcelID;

-- 4.2 Separate Address into Address and City
SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing;

-- 4.3 Update the new columns with separated values
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- 4.4 View the updated dataset
Select *
From PortfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- 5. Handle Owner Address Components

-- 5.1 Select OwnerAddress
Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing;

-- 5.2 Separate OwnerAddress into Address, City, and State
SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as OwnerSplitState,
    PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as OwnerSplitCity,
    PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as OwnerSplitAddress
FROM PortfolioProject.dbo.NashvilleHousing;

-- 5.3 Update the new columns with separated values
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

-- 5.4 View the updated dataset
Select *
From PortfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- 6. Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" field

-- 6.1 Show distinct SoldAsVacant values and their counts
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2;

-- 6.2 Update SoldAsVacant values
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

-- 6.3 View the updated dataset
Select *
From PortfolioProject.dbo.NashvilleHousing;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Remove Duplicates

-- 7.1 Identify duplicates using RowNumCTE
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY
                UniqueID
        ) row_num
    FROM PortfolioProject.dbo.NashvilleHousing
    --order by ParcelID
)

-- 7.2 Select duplicate records
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

-- 7.3 View the updated dataset without duplicates
Select *
From PortfolioProject.dbo.NashvilleHousing;

---------------------------------------------------------------------------------------------------------

-- 8. Delete Unused Columns

-- 8.1 View the dataset before deletion
Select *
From PortfolioProject.dbo.NashvilleHousing;

-- 8.2 Delete unused columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

-- 8.3 View the final dataset
Select *
From PortfolioProject.dbo.NashvilleHousing;
