--cleaning Data in SQL Queries 

Select * 
from master.dbo.[NashvillaHousing ]

--Standardize Date Format

Select SalesDate2, CONVERT(Date,SaleDate)
from master.dbo.[NashvillaHousing ]


Update [NashvillaHousing ]
Set SaleDate = CONVERT(Date,SaleDate)


Alter Table NashvillaHousing
Add SalesDate2 Date;

Update [NashvillaHousing ]
Set SalesDate2 = CONVERT(Date,SaleDate)


-------------------------------------------------



--Populate Property Address data

Select *
from master.dbo.[NashvillaHousing ]
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from master.dbo.[NashvillaHousing ] a
Join master.dbo.[NashvillaHousing ] b
      on a.ParcelID = b.ParcelID
	  And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from master.dbo.[NashvillaHousing ] a
Join master.dbo.[NashvillaHousing ] b
      on a.ParcelID = b.ParcelID
	  And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




------------------------------------------------------------------------






--Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
from master.dbo.[NashvillaHousing ]
--where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as address 
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as address 
 
from master.dbo.[NashvillaHousing ]



Alter Table NashvillaHousing
Add PropertySplitAddress Nvarchar(225);
Update [NashvillaHousing ]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)



Alter Table NashvillaHousing
Add PropertySplitCity Nvarchar(225);

Update [NashvillaHousing ]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 


Select * 
from master.dbo.[NashvillaHousing ]



Select 
PARSENAME(Replace(OwnerAddress, ',','.'),3)
,PARSENAME(Replace(OwnerAddress, ',','.'),2)
,PARSENAME(Replace(OwnerAddress, ',','.'),1)
from master.dbo.[NashvillaHousing ]


Alter Table NashvillaHousing
Add OwnerSplitAddress Nvarchar(225);

Update [NashvillaHousing ]
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)



Alter Table NashvillaHousing
Add OwnerSplitCity Nvarchar(225);

Update [NashvillaHousing ]
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'),2)



Alter Table NashvillaHousing
Add OwnerSplitState Nvarchar(225);

Update [NashvillaHousing ]
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),1) 






----------------------------------------------------------------------

--Change Y and N to Yes and NO in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from master.dbo.[NashvillaHousing ]
Group by SoldAsVacant
order by 2
 

 Select SoldAsVacant
 , Case When SoldAsVacant ='Y' THEN 'Yes'
        When SoldAsVacant ='N' THEN 'No'
		Else SoldAsVacant
		END
From master.dbo.[NashvillaHousing ]

Update [NashvillaHousing ]
SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END








----------------------------------------------------------------------------------

--Remove Duplicates


WITH RowNumCTE AS (
Select *,
    ROW_NUMBER() over (
	Partition BY ParcelID,
	            PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
				UniqueID 
				   ) row_num

from master.dbo.[NashvillaHousing ]
--order by ParcelID
)

--DELETE
select*
From RowNumCTE
where row_num > 1
order by PropertyAddress



----------------------------------------------------------------

--Delete Unused Columns




Select*
from master.dbo.[NashvillaHousing ]

ALTER TABLE master.dbo.[NashvillaHousing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE master.dbo.[NashvillaHousing ]
DROP COLUMN SaleDate