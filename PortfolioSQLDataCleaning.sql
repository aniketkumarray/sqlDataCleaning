--Data Cleaning using SQL Queries

Select *
From PortfolioProject..NashvilleHousing


-- keeping date element from the date time element
Select SaleDate , CONVERT(Date,SaleDate) AS Date
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


--Populate Propert Address Data


Select A.ParcelID, A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
From PortfolioProject..NashvilleHousing A
Join PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
--WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress =  ISNULL(A.PropertyAddress,B.PropertyAddress)
From PortfolioProject..NashvilleHousing A
Join PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--Breaking out address into Individual columns(address, city,state)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))  AS Address1
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing




SELECT OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
From PortfolioProject.dbo.NashvilleHousing

--Change Y and N to yes and No in SoldASVacant

Select DISTINCT SoldASVacant, Count(SoldASVacant)
From PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldASVacant
ORDER BY 2

Select SoldASVacant
 ,CASE WHEN SoldASVacant = 'Y' then 'Yes'
     WHEN SoldASVacant = 'N' then 'No'
	 ELSE SoldASVacant
	 end
	 From PortfolioProject.dbo.NashvilleHousing


	 UPDATE NashvilleHousing
	 SET SoldASVacant =CASE WHEN SoldASVacant = 'Y' then 'Yes'
     WHEN SoldASVacant = 'N' then 'No'
	 ELSE SoldASVacant
	 end
	 From PortfolioProject.dbo.NashvilleHousing


-- Remove Duplicates // not a standard pratise to delete data from main table

WITH RowNUMCTE AS(
SELECT *, 
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
PropertyAddress, SalePrice,SaleDate, LegalReference
Order By UniqueID
) Row_num

From PortfolioProject.dbo.NashvilleHousing
)

DELETE From RowNUMCTE

Where Row_num >1
--Order by PropertyAddress





--DElete unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

Select * from PortfolioProject.dbo.NashvilleHousing