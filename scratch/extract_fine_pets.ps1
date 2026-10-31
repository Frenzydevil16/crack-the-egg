Add-Type -AssemblyName System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$src = [System.Drawing.Bitmap]::new($imgPath)

# Fine-tuned center (cx, cy) and radius for each animal
$pets = @(
    @{ id="pet_dog"; cx=387; cy=256; r=74 },
    @{ id="pet_cat"; cx=513; cy=288; r=68 },
    @{ id="pet_mouse"; cx=602; cy=396; r=68 },
    @{ id="pet_bunny"; cx=610; cy=540; r=68 },
    @{ id="pet_fox"; cx=534; cy=654; r=68 },
    @{ id="pet_frog"; cx=436; cy=724; r=66 },
    @{ id="pet_panda"; cx=330; cy=724; r=66 },
    @{ id="pet_dragon"; cx=226; cy=664; r=68 },
    @{ id="pet_phoenix"; cx=158; cy=542; r=70 },
    @{ id="pet_unicorn"; cx=166; cy=395; r=68 },
    @{ id="pet_cosmic_companion"; cx=260; cy=275; r=68 }
)

$outDir = "c:\Users\kunde\Desktop\Crack the egg\scratch\pet_fine"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$cropSize = 160
$half = [int]($cropSize / 2)

foreach ($p in $pets) {
    $bmp = [System.Drawing.Bitmap]::new($cropSize, $cropSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $maxR = [double]$p.r
    $srcX = $p.cx - $half
    $srcY = $p.cy - $half

    for ($y = 0; $y -lt $cropSize; $y++) {
        $sy = $srcY + $y
        $ly = $y - $half
        for ($x = 0; $x -lt $cropSize; $x++) {
            $sx = $srcX + $x
            $lx = $x - $half
            $dist = [Math]::Sqrt($lx * $lx + $ly * $ly)
            if ($dist -le $maxR -and $sx -ge 0 -and $sx -lt $src.Width -and $sy -ge 0 -and $sy -lt $src.Height) {
                $c = $src.GetPixel($sx, $sy)
                if ($dist -gt ($maxR - 4.0)) {
                    $a = [int](($maxR - $dist) / 4.0 * 255.0)
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, 255, 218, 70))
                } else {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
                }
            } else {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
    $bmp.Save("$outDir\$($p.id).png", [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Saved $($p.id).png"
}
$src.Dispose()
