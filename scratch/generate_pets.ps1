Add-Type -AssemblyName System.Drawing

$petDir = "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
if (-not (Test-Path $petDir)) { New-Item -ItemType Directory -Force -Path $petDir | Out-Null }

$pets = @(
    @{ Id="pet_sproutling"; BgColor=[System.Drawing.Color]::FromArgb(120, 210, 100); DetailColor=[System.Drawing.Color]::FromArgb(40, 140, 40); Type="nature" },
    @{ Id="pet_honey_bee"; BgColor=[System.Drawing.Color]::FromArgb(255, 210, 50); DetailColor=[System.Drawing.Color]::FromArgb(60, 40, 20); Type="nature" },
    @{ Id="pet_mossy_turtle"; BgColor=[System.Drawing.Color]::FromArgb(85, 175, 120); DetailColor=[System.Drawing.Color]::FromArgb(120, 80, 50); Type="nature" },
    @{ Id="pet_flora_pixie"; BgColor=[System.Drawing.Color]::FromArgb(255, 160, 210); DetailColor=[System.Drawing.Color]::FromArgb(220, 60, 140); Type="nature" },
    @{ Id="pet_forest_stag"; BgColor=[System.Drawing.Color]::FromArgb(240, 250, 235); DetailColor=[System.Drawing.Color]::FromArgb(212, 175, 55); Type="nature" },

    @{ Id="pet_pebble_golem"; BgColor=[System.Drawing.Color]::FromArgb(160, 175, 195); DetailColor=[System.Drawing.Color]::FromArgb(90, 110, 130); Type="crystal" },
    @{ Id="pet_frost_wisp"; BgColor=[System.Drawing.Color]::FromArgb(140, 230, 255); DetailColor=[System.Drawing.Color]::FromArgb(40, 160, 230); Type="crystal" },
    @{ Id="pet_glimmer_bat"; BgColor=[System.Drawing.Color]::FromArgb(190, 140, 245); DetailColor=[System.Drawing.Color]::FromArgb(110, 60, 180); Type="crystal" },
    @{ Id="pet_shard_drake"; BgColor=[System.Drawing.Color]::FromArgb(80, 200, 245); DetailColor=[System.Drawing.Color]::FromArgb(30, 110, 200); Type="crystal" },
    @{ Id="pet_diamond_sovereign"; BgColor=[System.Drawing.Color]::FromArgb(225, 245, 255); DetailColor=[System.Drawing.Color]::FromArgb(60, 180, 240); Type="crystal" },

    @{ Id="pet_mini_comet"; BgColor=[System.Drawing.Color]::FromArgb(255, 230, 120); DetailColor=[System.Drawing.Color]::FromArgb(255, 140, 40); Type="cosmic" },
    @{ Id="pet_moon_bunny"; BgColor=[System.Drawing.Color]::FromArgb(235, 235, 250); DetailColor=[System.Drawing.Color]::FromArgb(140, 160, 230); Type="cosmic" },
    @{ Id="pet_star_ray"; BgColor=[System.Drawing.Color]::FromArgb(90, 130, 240); DetailColor=[System.Drawing.Color]::FromArgb(200, 220, 255); Type="cosmic" },
    @{ Id="pet_nebula_fox"; BgColor=[System.Drawing.Color]::FromArgb(200, 90, 230); DetailColor=[System.Drawing.Color]::FromArgb(255, 180, 255); Type="cosmic" },
    @{ Id="pet_singularity_dragon"; BgColor=[System.Drawing.Color]::FromArgb(45, 25, 80); DetailColor=[System.Drawing.Color]::FromArgb(240, 60, 200); Type="cosmic" }
)

foreach ($p in $pets) {
    $outPath = Join-Path $petDir "$($p.Id).png"
    $bmp = New-Object System.Drawing.Bitmap 256, 256
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Soft Shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(60, 0, 0, 0))
    $g.FillEllipse($shadowBrush, 48, 200, 160, 40)
    $shadowBrush.Dispose()

    # 2. Main Body Glow
    $glowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70, $p.DetailColor.R, $p.DetailColor.G, $p.DetailColor.B))
    $g.FillEllipse($glowBrush, 28, 48, 200, 160)
    $glowBrush.Dispose()

    # 3. Main Body
    $bodyBrush = New-Object System.Drawing.SolidBrush $p.BgColor
    $g.FillEllipse($bodyBrush, 36, 56, 184, 150)
    $bodyBrush.Dispose()

    # Outline
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 25, 25, 35), 7)
    $g.DrawEllipse($pen, 36, 56, 184, 150)
    $pen.Dispose()

    # 4. Details based on type
    $detBrush = New-Object System.Drawing.SolidBrush $p.DetailColor
    if ($p.Type -eq "nature") {
        # Leaf on top
        $g.FillEllipse($detBrush, 114, 26, 28, 40)
    } elseif ($p.Type -eq "crystal") {
        # Crystal Spike on top
        $pts = @(
            (New-Object System.Drawing.Point 128, 20),
            (New-Object System.Drawing.Point 148, 60),
            (New-Object System.Drawing.Point 108, 60)
        )
        $g.FillPolygon($detBrush, $pts)
    } else {
        # Cosmic Ring or Star Orbit
        $ringPen = New-Object System.Drawing.Pen $p.DetailColor, 6
        $g.DrawEllipse($ringPen, 20, 100, 216, 60)
        $ringPen.Dispose()
    }
    $detBrush.Dispose()

    # 5. Glossy Eyes & Cute Smile
    $eyeBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(25, 20, 30))
    $g.FillEllipse($eyeBrush, 82, 108, 24, 32)
    $g.FillEllipse($eyeBrush, 150, 108, 24, 32)
    $eyeBrush.Dispose()

    # Highlights
    $hlBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.FillEllipse($hlBrush, 86, 112, 10, 14)
    $g.FillEllipse($hlBrush, 154, 112, 10, 14)
    $g.FillEllipse($hlBrush, 58, 70, 35, 20) # Top gloss
    $hlBrush.Dispose()

    # Cheeks
    $blushBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(100, 255, 100, 130))
    $g.FillEllipse($blushBrush, 66, 132, 22, 12)
    $g.FillEllipse($blushBrush, 168, 132, 22, 12)
    $blushBrush.Dispose()

    $g.Dispose()
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Write-Host "Created all 15 Pet PNGs successfully in $petDir"
