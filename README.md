# Nashville Housing Data Cleaning and Transformation

## Overview

This project focuses on cleaning and transforming the NashvilleHousing dataset within the PortfolioProject database. The script performs several data cleaning tasks to standardize formats, handle missing data, and prepare the dataset for further analysis. The key tasks include standardizing date formats, populating missing property addresses, breaking down addresses into individual columns, handling address components, converting values, removing duplicates, and deleting unused columns.

## Tasks

### Standardize Date Format

- **Objective:** Convert the `SaleDate` column to the Date data type.
- **Implementation:** If conversion issues arise, a new column `SaleDateConverted` is created, and the conversion is attempted again.

### Populate Property Address Data

- **Objective:** Fill missing property addresses based on records with the same `ParcelID` but different `UniqueID`.
- **Implementation:** Update records with null property addresses using available data from matching records.

### Break Out Addresses into Individual Columns

- **Objective:** Separate the `PropertyAddress` column into `Address` and `City` components.
- **Implementation:** Create new columns `PropertySplitAddress` and `PropertySplitCity` to store the separated data.

### Handle Owner Address Components

- **Objective:** Separate the `OwnerAddress` into `Address`, `City`, and `State` components.
- **Implementation:** Create new columns `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState` for the respective components.

### Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" Field

- **Objective:** Convert 'Y' and 'N' values in the `SoldAsVacant` field to 'Yes' and 'No'.
- **Implementation:** Update the values to enhance readability.

### Remove Duplicates

- **Objective:** Identify and retain unique records based on a combination of `ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, and `LegalReference`.
- **Implementation:** Remove duplicate records to ensure data integrity.

### Delete Unused Columns

- **Objective:** Remove columns that are no longer needed for analysis.
- **Implementation:** Delete columns such as `OwnerAddress`, `TaxDistrict`, `PropertyAddress`, and `SaleDate`.

## Acknowledgments

This project is part of a YouTube tutorial series led by Alex the Analyst. The techniques and skills applied in this project were learned through his guidance. For a more detailed understanding of the project and SQL skills, refer to the tutorial series on Alex the Analyst's [YouTube channel](https://www.youtube.com/channel/UCtOfUcp88zp8klG6Bwr8U_g).

## Getting Started

1. **Clone or Download:**
   Clone or download this repository to your local machine.

2. **Install Dependencies:**
   Ensure you have the necessary libraries and tools installed to run the script. Install them as needed.

3. **Run the Script:**
   Execute the script to perform the data cleaning and transformation tasks outlined above.

4. **Review the Results:**
   Check the transformed dataset to verify the changes and improvements.


