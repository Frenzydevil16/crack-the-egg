Add-Type -AssemblyName System.Drawing
$code = @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;

public class WheelAssetExtractorV3 {
    public static void ExtractAll(string imgPath, string outWheelDir, string outPetDir) {
        using (Bitmap src = new Bitmap(imgPath)) {
            int W = src.Width;
            int H = src.Height;
            double cx = 387.0;
            double cy = 510.0;
            int rDisc = 320;
            int discSize = rDisc * 2; // 640x640

            // 1. Extract wheel_disc.png (640x640 centered at cx=387, cy=510)
            using (Bitmap discBmp = new Bitmap(discSize, discSize, PixelFormat.Format32bppArgb)) {
                for (int dy = 0; dy < discSize; dy++) {
                    int sy = (int)(cy - rDisc + dy);
                    for (int dx = 0; dx < discSize; dx++) {
                        int sx = (int)(cx - rDisc + dx);
                        double dist = Math.Sqrt((sx - cx) * (sx - cx) + (sy - cy) * (sy - cy));
                        if (dist <= 319.5 && sx >= 0 && sx < W && sy >= 0 && sy < H) {
                            Color c = src.GetPixel(sx, sy);
                            int alpha = 255;
                            if (dist > 317.5) {
                                alpha = (int)Math.Max(0, Math.Min(255, (319.5 - dist) / 2.0 * 255.0));
                            }
                            discBmp.SetPixel(dx, dy, Color.FromArgb(alpha, c.R, c.G, c.B));
                        } else {
                            discBmp.SetPixel(dx, dy, Color.FromArgb(0, 0, 0, 0));
                        }
                    }
                }
                discBmp.Save(outWheelDir + "\\wheel_disc.png", ImageFormat.Png);
            }
            Console.WriteLine("Saved wheel_disc.png (640x640)");

            // 2. Flood-fill exterior black background
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

            // 3. Extract wheel_frame_ui.png
            // Outer rim inner edge: r=319.0, Center paw medallion outer edge: r=82.5
            using (Bitmap frameBmp = new Bitmap(W, H, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < H; y++) {
                    for (int x = 0; x < W; x++) {
                        if (isExterior[x, y]) {
                            frameBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }
                        Color c = src.GetPixel(x, y);
                        double dist = Math.Sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));

                        // Top golden diamond pointer at 12 o'clock (x=348..426, tip at (387, 202))
                        bool isTopPointer = (y < 203 && x >= 348 && x <= 426 && (y <= (202.0 - Math.Abs(x - 387.0) * 1.32)));

                        if (!isTopPointer && dist > 82.0 && dist < 319.0) {
                            if (dist < 84.0) {
                                int a = (int)((84.0 - dist) / 2.0 * 255.0);
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            } else if (dist > 317.0) {
                                int a = (int)((dist - 317.0) / 2.0 * 255.0);
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
                            // Patch "1 Dreh verfügbar" text area (x=780..945, y=781..809) by copying the clean dark-navy background pixel at (946, y)
                            if (x >= 780 && x <= 945 && y >= 781 && y <= 809) {
                                Color bgRowCol = src.GetPixel(946, y);
                                frameBmp.SetPixel(x, y, Color.FromArgb(255, bgRowCol.R, bgRowCol.G, bgRowCol.B));
                            } else {
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            }
                        }
                    }
                }
                frameBmp.Save(outWheelDir + "\\wheel_frame_ui.png", ImageFormat.Png);
            }
            Console.WriteLine("Saved wheel_frame_ui.png");

            // 4. Extract 11 Pet Portraits from the 11 wheel wedges (animal head & body at r=240)
            string[] petIds = {
                "pet_dog", "pet_cat", "pet_mouse", "pet_bunny", "pet_fox",
                "pet_frog", "pet_panda", "pet_dragon", "pet_phoenix", "pet_unicorn", "pet_cosmic_companion"
            };
            double rPortraitDist = 238.0;
            int portraitSize = 136;
            int halfP = 68;
            for (int i = 0; i < 11; i++) {
                double angleDeg = -90.0 + i * (360.0 / 11.0);
                double angleRad = angleDeg * Math.PI / 180.0;
                double px = cx + Math.Cos(angleRad) * rPortraitDist;
                double py = cy + Math.Sin(angleRad) * rPortraitDist - 8.0;

                using (Bitmap pBmp = new Bitmap(portraitSize, portraitSize, PixelFormat.Format32bppArgb)) {
                    for (int dy = 0; dy < portraitSize; dy++) {
                        int sy = (int)(py - halfP + dy);
                        for (int dx = 0; dx < portraitSize; dx++) {
                            int sx = (int)(px - halfP + dx);
                            double d = Math.Sqrt((dx - halfP) * (dx - halfP) + (dy - halfP) * (dy - halfP));
                            if (d <= 64.0 && sx >= 0 && sx < W && sy >= 0 && sy < H) {
                                Color c = src.GetPixel(sx, sy);
                                if (d > 60.0) {
                                    int a = (int)Math.Max(0, Math.Min(255, (64.0 - d) / 4.0 * 255.0));
                                    pBmp.SetPixel(dx, dy, Color.FromArgb(a, 255, 210, 65));
                                } else {
                                    pBmp.SetPixel(dx, dy, Color.FromArgb(255, c.R, c.G, c.B));
                                }
                            } else {
                                pBmp.SetPixel(dx, dy, Color.FromArgb(0, 0, 0, 0));
                            }
                        }
                    }
                    pBmp.Save(outPetDir + "\\" + petIds[i] + ".png", ImageFormat.Png);
                }
            }
            Console.WriteLine("Saved all 11 pet portraits");
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
$imgPath = "C:/Users/kunde/.gemini/antigravity/brain/4baa3864-af36-4dbb-9097-602f9d2e1eec/.user_uploaded/media_1793376914150_32da2b27.jpg"
$outWheelDir = "c:\Users\kunde\Desktop\Crack the egg\assets\wheel"
$outPetDir = "c:\Users\kunde\Desktop\Crack the egg\assets\pets"
[WheelAssetExtractorV3]::ExtractAll($imgPath, $outWheelDir, $outPetDir)
