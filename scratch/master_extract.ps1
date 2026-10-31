Add-Type -AssemblyName System.Drawing
$code = @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class MasterWheelAndPetExtractor {
    public static void ExtractAll(string imgPath, string outWheelDir, string outPetDir) {
        using (Bitmap src = new Bitmap(imgPath)) {
            int W = src.Width;
            int H = src.Height;
            double cx = 387.0;
            double cy = 500.0; // Exact center of circular golden rim!
            int rDisc = 338;   // Disc goes 14px UNDER golden rim (inner rim is 324)
            int discSize = rDisc * 2; // 676x676

            // 1. Extract wheel_disc.png (676x676 centered at cx=387, cy=500)
            using (Bitmap discBmp = new Bitmap(discSize, discSize, PixelFormat.Format32bppArgb)) {
                for (int dy = 0; dy < discSize; dy++) {
                    int sy = (int)(cy - rDisc + dy);
                    for (int dx = 0; dx < discSize; dx++) {
                        int sx = (int)(cx - rDisc + dx);
                        double dist = Math.Sqrt((sx - cx) * (sx - cx) + (sy - cy) * (sy - cy));
                        if (dist <= 337.5 && sx >= 0 && sx < W && sy >= 0 && sy < H) {
                            Color c = src.GetPixel(sx, sy);
                            int alpha = 255;
                            if (dist > 335.5) {
                                alpha = (int)Math.Max(0, Math.Min(255, (337.5 - dist) / 2.0 * 255.0));
                            }
                            discBmp.SetPixel(dx, dy, Color.FromArgb(alpha, c.R, c.G, c.B));
                        } else {
                            discBmp.SetPixel(dx, dy, Color.FromArgb(0, 0, 0, 0));
                        }
                    }
                }
                discBmp.Save(outWheelDir + "\\wheel_disc.png", ImageFormat.Png);
            }
            Console.WriteLine("Saved seamless wheel_disc.png (676x676)");

            // 2. Flood-fill exterior black background (lum < 28)
            bool[,] isExterior = new bool[W, H];
            Queue<Point> q = new Queue<Point>();
            for (int x = 0; x < W; x++) {
                isExterior[x, 0] = true; q.Enqueue(new Point(x, 0));
                isExterior[x, H - 1] = true; q.Enqueue(new Point(x, H - 1));
            }
            for (int y = 1; y < H - 1; y++) {
                isExterior[0, y] = true; q.Enqueue(new Point(0, y));
                isExterior[W - 1, y] = true; q.Enqueue(new Point(W - 1, y));
            }
            int[] dxArr = { -1, 1, 0, 0 };
            int[] dyArr = { 0, 0, -1, 1 };
            while (q.Count > 0) {
                Point pt = q.Dequeue();
                for (int d = 0; d < 4; d++) {
                    int nx = pt.X + dxArr[d];
                    int ny = pt.Y + dyArr[d];
                    if (nx >= 0 && nx < W && ny >= 0 && ny < H && !isExterior[nx, ny]) {
                        Color c = src.GetPixel(nx, ny);
                        int lum = Math.Max(c.R, Math.Max(c.G, c.B));
                        if (lum < 28) {
                            isExterior[nx, ny] = true;
                            q.Enqueue(new Point(nx, ny));
                        }
                    }
                }
            }

            // 3. Extract wheel_frame_ui.png (1024x1024)
            // Golden rim inner cutout is at r = 324.0. Paw center cap is kept up to r = 84.0.
            // Top pointer is kept up to tip at (387, 198).
            using (Bitmap frameBmp = new Bitmap(W, H, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < H; y++) {
                    for (int x = 0; x < W; x++) {
                        if (isExterior[x, y]) {
                            frameBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }
                        Color c = src.GetPixel(x, y);
                        double dist = Math.Sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));

                        // Top pointer triangular shape
                        bool isTopPointer = (y <= 198 && Math.Abs(x - 387.0) <= 46.0 && (y <= (198.0 - Math.Abs(x - 387.0) * 1.35)));

                        // The rotating window is inside the golden rim (dist < 324.0), outside center paw cap (dist > 84.0), and outside top pointer
                        if (!isTopPointer && dist > 83.0 && dist < 324.0) {
                            if (dist < 85.0) {
                                int a = (int)((85.0 - dist) / 2.0 * 255.0);
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            } else if (dist > 322.0) {
                                int a = (int)((dist - 322.0) / 2.0 * 255.0);
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            } else {
                                frameBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            }
                        } else {
                            bool nearExt = false;
                            if (x > 0 && x < W - 1 && y > 0 && y < H - 1) {
                                if (isExterior[x - 1, y] || isExterior[x + 1, y] || isExterior[x, y - 1] || isExterior[x, y + 1]) {
                                    nearExt = true;
                                }
                            }
                            int a = 255;
                            if (nearExt) {
                                int lum = Math.Max(c.R, Math.Max(c.G, c.B));
                                a = Math.Min(255, lum * 3);
                            }
                            // Cleanly patch "1 Dreh verfügbar" text area (x=776..948, y=780..810) using navy color from right panel
                            if (x >= 776 && x <= 948 && y >= 780 && y <= 810) {
                                Color bgCol = src.GetPixel(948, y);
                                frameBmp.SetPixel(x, y, Color.FromArgb(255, bgCol.R, bgCol.G, bgCol.B));
                            } else {
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            }
                        }
                    }
                }
                frameBmp.Save(outWheelDir + "\\wheel_frame_ui.png", ImageFormat.Png);
            }
            Console.WriteLine("Saved seamless wheel_frame_ui.png");

            // 4. Extract High-Quality Upright Pet Portraits
            var petDefs = new[] {
                new { Id = "pet_dog", Cx = 387, Cy = 252, R = 72, BaseColor = Color.FromArgb(170, 185, 205) },
                new { Id = "pet_cat", Cx = 514, Cy = 286, R = 68, BaseColor = Color.FromArgb(75, 185, 25) },
                new { Id = "pet_mouse", Cx = 603, Cy = 396, R = 68, BaseColor = Color.FromArgb(0, 168, 255) },
                new { Id = "pet_bunny", Cx = 612, Cy = 538, R = 68, BaseColor = Color.FromArgb(220, 25, 175) },
                new { Id = "pet_fox", Cx = 536, Cy = 654, R = 66, BaseColor = Color.FromArgb(255, 110, 0) },
                new { Id = "pet_frog", Cx = 438, Cy = 724, R = 66, BaseColor = Color.FromArgb(25, 185, 60) },
                new { Id = "pet_panda", Cx = 328, Cy = 724, R = 66, BaseColor = Color.FromArgb(0, 165, 240) },
                new { Id = "pet_dragon", Cx = 226, Cy = 664, R = 68, BaseColor = Color.FromArgb(130, 25, 235) },
                new { Id = "pet_phoenix", Cx = 158, Cy = 542, R = 70, BaseColor = Color.FromArgb(255, 160, 0) },
                new { Id = "pet_unicorn", Cx = 166, Cy = 395, R = 68, BaseColor = Color.FromArgb(100, 75, 240) },
                new { Id = "pet_cosmic_companion", Cx = 260, Cy = 275, R = 68, BaseColor = Color.FromArgb(40, 10, 120) }
            };

            int cropSize = 160;
            int half = cropSize / 2;

            for (int i = 0; i < petDefs.Length; i++) {
                var p = petDefs[i];
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

                            Color c = Color.Black;
                            if (sx >= 0 && sx < src.Width && sy >= 0 && sy < src.Height) {
                                c = src.GetPixel(sx, sy);
                            }

                            // Clean anti-aliased golden medal rim
                            if (dist > maxR - 4.0) {
                                int a = (int)Math.Max(0, Math.Min(255, (maxR - dist) / 4.0 * 255.0));
                                bmp.SetPixel(x, y, Color.FromArgb(a, 255, 218, 65));
                            } else {
                                bmp.SetPixel(x, y, Color.FromArgb(255, c.R, c.G, c.B));
                            }
                        }
                    }
                    bmp.Save(outPetDir + "\\" + p.Id + ".png", ImageFormat.Png);
                    Console.WriteLine("Saved high-res portrait " + p.Id + ".png");
                }
            }
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$outWheelDir = "c:\Users\kunde\Desktop\Crack the egg\assets\wheel"
$outPetDir = "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
[MasterWheelAndPetExtractor]::ExtractAll($imgPath, $outWheelDir, $outPetDir)
