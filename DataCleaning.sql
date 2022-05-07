

Select *
From dbo.Housing


Select SaleDateConverted, CONVERT(date,SaleDate)
From dbo.Housing


Update Housing
Set SaleDate = CONVERT(date,SaleDate)

Alter table housing
Add SaleDateConverted Date;

Update Housing
Set SaleDateConverted = CONVERT(date,SaleDate)

-----------------------------------------------------------------------

Select *
From dbo.Housing
--Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.Housing a
Join dbo.Housing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.Housing a
Join dbo.Housing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From dbo.Housing


Alter table housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


Alter table housing
Add PropertySplitCity Nvarchar(255);

Update Housing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From dbo.Housing


Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From dbo.Housing


Alter table housing
Add OwnerSplitAddress Nvarchar(255);

Update Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table housing
Add OwnerSplitCity Nvarchar(255);

Update Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table housing
Add OwnerSplitState Nvarchar(255);

Update Housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


---------------------------------------------------------------------

Select Distinct(SoldAsVacant),
Count(SoldAsVacant)
From dbo.Housing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From dbo.Housing;

Update Housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

-------------------------------------------------------------------------------------

With RowNumCTE As(
Select *,
      ROW_NUMBER() Over (
	  Partition By ParcelID,
				   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   Order By
					UniqueID
					) row_num
From dbo.Housing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



---------------------------------------------------------------------------------


Select *
From dbo.Housing

Alter table housing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table housing
Drop column SaleDate