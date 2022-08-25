use Covid_project
select * from nhousing;

-- Standardize Date Format

Select saleDate, CONVERT(Date,SaleDate)
From nhousing;

Update nhousing
SET SaleDate = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From nhousing
Where PropertyAddress is null
order by ParcelID

Select *
From nhousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From nhousing a
JOIN nhousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From nhousing a
JOIN nhousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From nhousing
Where PropertyAddress is null
order by ParcelID

Select PropertyAddress
From nhousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From nhousing


ALTER TABLE nhousing
Add PropertySplitAddress Nvarchar(255);

Update nhousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE nhousing
Add PropertySplitCity Nvarchar(255);

Update nhousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select * From nhousing

Select OwnerAddress From nhousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From nhousing

ALTER TABLE nhousing
Add OwnerSplitAddress Nvarchar(255);

Update nhousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE nhousing
Add OwnerSplitCity Nvarchar(255);

Update nhousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE nhousing
Add OwnerSplitState Nvarchar(255);

Update nhousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select * From nhousing

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nhousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nhousing

Update nhousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nhousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select * From nhousing

-- Delete Unused Columns

ALTER TABLE nhousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

