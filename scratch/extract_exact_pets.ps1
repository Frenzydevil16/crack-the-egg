Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

# Let's inspect the bounding box / center of the animals on the wheel
# The wheel has 11 segments. Center of the wheel is (387, 500).
# Let's estimate the center of each animal:
# Hund: x=387, y=250
# Katze: x=515, y=285
# Maus: x=605, y=398
# Hase: x=612, y=538
# Fuchs: x=535, y=650
# Frosch: x=435, y=725
# Panda: x=330, y=725
# Drache: x=225, y=665
# Phönix: x=160, y=545
# Einhorn: x=165, y=395
# Kosmischer Begleiter: x=255, y=275

$pets = @(
    @{ id="pet_dog"; name="Hund"; cx=387; cy=252 },
    @{ id="pet_cat"; name="Katze"; cx=515; cy=285 },
    @{ id="pet_mouse"; name="Maus"; cx=605; cy=398 },
    @{ id="pet_bunny"; name="Hase"; cx=612; cy=538 },
    @{ id="pet_fox"; name="Fuchs"; cx=538; cy=652 },
    @{ id="pet_frog"; name="Frosch"; cx=435; cy=725 },
    @{ id="pet_panda"; name="Panda"; cx=330; cy=725 },
    @{ id="pet_dragon"; name="Drache"; cx=225; cy=665 },
    @{ id="pet_phoenix"; name="Phönix"; cx=158; cy=545 },
    @{ id="pet_unicorn"; name="Einhorn"; cx=165; cy=395 },
    @{ id="pet_cosmic_companion"; name="Kosmischer Begleiter"; cx=258; cy=275 }
)

$outDir = "c:\Users\kunde\Desktop\Crack the egg\scratch\pet_crops"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$cropSize = 190
$half = [int]($cropSize / 2)

foreach ($p in $pets) {
    $bmp = [System.Drawing.Bitmap]::new($cropSize, $cropSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $srcX = $p.cx - $half
    $srcY = $p.cy - $half

    for ($y = 0; $y -lt $cropSize; $y++) {
        $sy = $srcY + $y
        $ly = $y - $half
        for ($x = 0; $x -lt $cropSize; $x++) {
            $sx = $srcX + $x
            $lx = $x - $half
            $dist = [Math]::Sqrt($lx * $lx + $ly * $ly)
            if ($dist -le 92.0 -and $sx -ge 0 -and $sx -lt $src.Width -and $sy -ge 0 -and $sy -lt $src.Height) {
                $c = $src.GetPixel($sx, $sy)
                if ($dist -gt 87.0) {
                    $a = [int]((92.0 - $dist) / 5.0 * 255.0)
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, 255, 215, 60))
                } else {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
                }
            } else {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
    $g.Dispose()
    $bmp.Save("$outDir\$($p.id).png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Saved $($p.id).png at ($($p.cx), $($p.cy))"
}

$src.Dispose()
