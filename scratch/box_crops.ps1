using namespace System.Drawing
Add-Type -AssemblyName System.Drawing

$src = [Bitmap]::FromFile("C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg")

# For each of the 11 pets, let's determine:
# - Pet center & bounding box
# - Label tag bounding box
# - Wedge color
# Let's write a C# helper to analyze each pet
$code = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class PetAnalyzer {
    public static void Analyze(string srcPath, string outDir) {
        using (Bitmap src = new Bitmap(srcPath)) {
            // Check each pet in wheel
            // The 11 animals are:
            // 0: Dog
            // 1: Cat
            // 2: Mouse
            // 3: Bunny
            // 4: Fox
            // 5: Frog
            // 6: Panda
            // 7: Dragon
            // 8: Phoenix
            // 9: Unicorn
            // 10: Cosmic Companion
            
            // Let's create a clean 250x250 crop for each pet centered directly on the ANIMAL itself (avoiding label)
            var pets = new[] {
                new { Id = "pet_dog", Cx = 387, Cy = 250, LabelY = 325, W = 160, H = 150 },
                new { Id = "pet_cat", Cx = 515, Cy = 295, LabelY = 365, W = 150, H = 150 },
                new { Id = "pet_mouse", Cx = 612, Cy = 405, LabelY = 440, W = 145, H = 145 },
                new { Id = "pet_bunny", Cx = 615, Cy = 545, LabelY = 555, W = 145, H = 150 },
                new { Id = "pet_fox", Cx = 538, Cy = 665, LabelY = 720, W = 155, H = 145 },
                new { Id = "pet_frog", Cx = 438, Cy = 730, LabelY = 780, W = 145, H = 140 },
                new { Id = "pet_panda", Cx = 328, Cy = 730, LabelY = 780, W = 145, H = 140 },
                new { Id = "pet_dragon", Cx = 222, Cy = 665, LabelY = 720, W = 160, H = 150 },
                new { Id = "pet_phoenix", Cx = 155, Cy = 540, LabelY = 555, W = 165, H = 155 },
                new { Id = "pet_unicorn", Cx = 162, Cy = 400, LabelY = 440, W = 160, H = 150 },
                new { Id = "pet_cosmic_companion", Cx = 260, Cy = 280, LabelY = 350, W = 160, H = 150 }
            };

            foreach (var p in pets) {
                using (Bitmap bmp = new Bitmap(p.W, p.H, PixelFormat.Format32bppArgb)) {
                    using (Graphics g = Graphics.FromImage(bmp)) {
                        g.DrawImage(src, 
                            new Rectangle(0, 0, p.W, p.H), 
                            new Rectangle(p.Cx - p.W/2, p.Cy - p.H/2, p.W, p.H), 
                            GraphicsUnit.Pixel);
                    }
                    bmp.Save(outDir + "\\box_" + p.Id + ".png", ImageFormat.Png);
                }
            }
        }
    }
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
[PetAnalyzer]::Analyze(
    "C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg",
    "c:\Users\kunde\Desktop\Crack the egg\scratch"
)
Write-Host "Done generating box crops."
$src.Dispose()
