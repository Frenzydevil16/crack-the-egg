using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

# Let's inspect raw_pet_dog.png
$dog = [Bitmap]::FromFile("c:\Users\kunde\Desktop\Crack the egg\scratch\raw_pet_dog.png")
Write-Host "Dog size: $($dog.Width) x $($dog.Height)"
# In dog crop: center was (387, 252)
# Dog wedge is sky blue (e.g., around corners: x=10, y=10)
$cornerColor = $dog.GetPixel(10, 10)
Write-Host "Dog corner color: R=$($cornerColor.R) G=$($cornerColor.G) B=$($cornerColor.B)"

# Check dog body colors: center (110, 110)
$centerColor = $dog.GetPixel(110, 110)
Write-Host "Dog center color: R=$($centerColor.R) G=$($centerColor.G) B=$($centerColor.B)"
$dog.Dispose()
