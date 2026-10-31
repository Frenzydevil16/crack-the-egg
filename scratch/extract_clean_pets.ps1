Add-Type -AssemblyName System.Drawing
$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class CleanPetExtractor {
    public static void Extract(string imgPath, string outDir) {
        using (Bitmap src = new Bitmap(imgPath)) {
            double cx = 387.0;
            double cy = 500.0;

            var petDefs = new[] {
                new { Id = "pet_dog", Cx = 387, Cy = 252, R = 76, BaseColor = Color.FromArgb(170, 185, 205) },
                new { Id = "pet_cat", Cx = 514, Cy = 286, R = 72, BaseColor = Color.FromArgb(75, 185, 25) },
                new { Id = "pet_mouse", Cx = 603, Cy = 396, R = 72, BaseColor = Color.FromArgb(0, 168, 255) },
                new { Id = "pet_bunny", Cx = 612, Cy = 538, R = 72, BaseColor = Color.FromArgb(220, 25, 175) },
                new { Id = "pet_fox", Cx = 536, Cy = 654, R = 72, BaseColor = Color.FromArgb(255, 110, 0) },
                new { Id = "pet_frog", Cx = 438, Cy = 724, R = 70, BaseColor = Color.FromArgb(25, 185, 60) },
                new { Id = "pet_panda", Cx = 328, Cy = 724, R = 70, BaseColor = Color.FromArgb(0, 165, 240) },
                new { Id = "pet_dragon", Cx = 226, Cy = 664, R = 72, BaseColor = Color.FromArgb(130, 25, 235) },
                new { Id = "pet_phoenix", Cx = 158, Cy = 542, R = 74, BaseColor = Color.FromArgb(255, 160, 0) },
                new { Id = "pet_unicorn", Cx = 166, Cy = 395, R = 72, BaseColor = Color.FromArgb(100, 75, 240) },
                new { Id = "pet_cosmic_companion", Cx = 260, Cy = 275, R = 72, BaseColor = Color.FromArgb(40, 10, 120) }
            };

            int cropSize = 190;
            int half = cropSize / 2;

            for (int i = 0; i < petDefs.Length; i++) {
                var p = petDefs[i];
                double segCenterAngle = -90.0 + i * (360.0 / 11.0);
                double minAngle = segCenterAngle - (360.0 / 22.0) + 1.5;
                double maxAngle = segCenterAngle + (360.0 / 22.0) - 1.5;

                using (Bitmap bmp = new Bitmap(cropSize, cropSize, PixelFormat.Format32bppArgb)) {
                    double maxR = p.R;
                    int srcX = p.Cx - half;
                    int srcY = p.Cy - half;

                    for (int y = 0; y < cropSize; y++) {
                        int sy = srcY + y;
                        int ly = y - half;
                        for (int x = 0; x < cropSize; x++) {
                            int sx = srcX + x;
                            int lx = x - half;
                            double dist = Math.Sqrt(lx * lx + ly * ly);

                            if (dist > maxR) {
                                bmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                continue;
                            }

                            // Calculate angle from wheel center (cx, cy)
                            double angleFromWheelCenter = Math.Atan2(sy - cy, sx - cx) * 180.0 / Math.PI;
                            // Normalize angle relative to segCenterAngle
                            double diff = angleFromWheelCenter - segCenterAngle;
                            while (diff < -180.0) diff += 360.0;
                            while (diff > 180.0) diff -= 360.0;

                            Color c;
                            if (sx >= 0 && sx < src.Width && sy >= 0 && sy < src.Height) {
                                // If inside the animal's wedge:
                                if (Math.Abs(diff) <= 15.5) {
                                    c = src.GetPixel(sx, sy);
                                } else {
                                    // Adjacent wedge bleed: replace with the pet's own vibrant background color + gentle radial shading
                                    double radialFactor = Math.Max(0.5, 1.0 - (dist / maxR) * 0.4);
                                    c = Color.FromArgb(
                                        (int)(p.BaseColor.R * radialFactor),
                                        (int)(p.BaseColor.G * radialFactor),
                                        (int)(p.BaseColor.B * radialFactor)
                                    );
                                }
                            } else {
                                c = p.BaseColor;
                            }

                            // Outer gold ring
                            if (dist > maxR - 5.0) {
                                int a = (int)Math.Max(0, Math.Min(255, (maxR - dist) / 5.0 * 255.0));
                                bmp.SetPixel(x, y, Color.FromArgb(a, 255, 218, 65));
                            } else {
                                bmp.SetPixel(x, y, Color.FromArgb(255, c.R, c.G, c.B));
                            }
                        }
                    }
                    bmp.Save(outDir + "\\" + p.Id + ".png", ImageFormat.Png);
                    Console.WriteLine("Saved clean " + p.Id + ".png");
                }
            }
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$outDir = "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
[CleanPetExtractor]::Extract($imgPath, $outDir)
