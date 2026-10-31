using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class PremiumMedalPetExtractor {
    public static void ExtractAll(string srcPath, string outDir) {
        using (Bitmap src = new Bitmap(srcPath)) {
            // Carefully calibrated centers and radii for all 11 pets:
            // Centered on the cute animal, avoiding 100% of labels and neighbor wedges!
            var petDefs = new[] {
                new { Id = "pet_dog", Cx = 387, Cy = 250, R = 64 },
                new { Id = "pet_cat", Cx = 515, Cy = 286, R = 58 },
                new { Id = "pet_mouse", Cx = 610, Cy = 388, R = 56 }, // Pure mouse, ZERO "Maus" label!
                new { Id = "pet_bunny", Cx = 614, Cy = 538, R = 58 }, // Pure bunny, ZERO label!
                new { Id = "pet_fox", Cx = 536, Cy = 648, R = 56 },   // Pure fox, ZERO "Fuchs" label, ZERO bunny/frog bleed!
                new { Id = "pet_frog", Cx = 438, Cy = 724, R = 55 },  // Pure frog, ZERO label!
                new { Id = "pet_panda", Cx = 328, Cy = 724, R = 56 }, // Pure panda, ZERO label!
                new { Id = "pet_dragon", Cx = 226, Cy = 652, R = 58 },// Pure dragon, ZERO label!
                new { Id = "pet_phoenix", Cx = 156, Cy = 536, R = 60 },// Pure phoenix, ZERO label!
                new { Id = "pet_unicorn", Cx = 164, Cy = 392, R = 58 },// Pure unicorn, ZERO label!
                new { Id = "pet_cosmic_companion", Cx = 260, Cy = 272, R = 58 } // Pure cosmic wolf, ZERO label!
            };

            int cropSize = 160;
            int half = cropSize / 2;

            foreach (var p in petDefs) {
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

                            if (dist > maxR + 3.0) {
                                bmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                continue;
                            }

                            // High-quality sample
                            Color c = Color.Black;
                            if (sx >= 0 && sx < src.Width && sy >= 0 && sy < src.Height) {
                                c = src.GetPixel(sx, sy);
                            }

                            // Outer edge antialiasing:
                            if (dist > maxR + 1.0) {
                                int alpha = (int)Math.Max(0, Math.Min(255, (maxR + 3.0 - dist) / 2.0 * 255.0));
                                bmp.SetPixel(x, y, Color.FromArgb(alpha, 255, 215, 60)); // Gold outer shine
                            } else if (dist > maxR - 3.5) {
                                // Rich gold medal frame
                                bmp.SetPixel(x, y, Color.FromArgb(255, 255, 220, 75));
                            } else if (dist > maxR - 5.0) {
                                // Inner gold shadow ring for 3D depth
                                bmp.SetPixel(x, y, Color.FromArgb(255, 185, 130, 20));
                            } else {
                                // Pure, authentic, crisp animal artwork from the original image!
                                bmp.SetPixel(x, y, Color.FromArgb(255, c.R, c.G, c.B));
                            }
                        }
                    }

                    bmp.Save(outDir + "\\" + p.Id + ".png", ImageFormat.Png);
                    Console.WriteLine("Saved premium medal " + p.Id + ".png");
                }
            }
        }
    }
}
