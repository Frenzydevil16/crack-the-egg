using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$petFiles = Get-ChildItem "c:\Users\kunde\Desktop\Crack the egg\assets\pets\pet_*.png"
foreach ($f in $petFiles) {
    if ($f.Name -match "meadow") { continue }
    $bmp = [Bitmap]::FromFile($f.FullName)
    # Check pixels around corners (e.g. 5, 5, 250, 5, etc.)
    $opaqueCorners = 0
    $corners = @(
        [Point]::new(5, 5), [Point]::new($bmp.Width - 6, 5),
        [Point]::new(5, $bmp.Height - 6), [Point]::new($bmp.Width - 6, $bmp.Height - 6)
    )
    foreach ($pt in $corners) {
        $c = $bmp.GetPixel($pt.X, $pt.Y)
        if ($c.A -gt 20) { $opaqueCorners++ }
    }
    Write-Host "$($f.Name): Size=$($bmp.Width)x$($bmp.Height), OpaqueCorners=$opaqueCorners"
    $bmp.Dispose()
}
