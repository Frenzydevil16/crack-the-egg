Add-Type -AssemblyName System.Drawing
$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class SeamlessWheelExtractor {
    public static void Generate(string imgPath, string outDir) {
        using (Bitmap src = new Bitmap(imgPath)) {
            int W = src.Width;
            int H = src.Height;
            double cx = 387.0;
            double cy = 500.0;
            int rDisc = 338;
            int discSize = rDisc * 2; // 676x676

            // 1. Wheel Disc (Full wheel with center paw rotating along)
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
                discBmp.Save(outDir + "\\wheel_disc_mitdrehen.png", ImageFormat.Png);
            }

            // 2. Wheel Frame (Circular hole from r=0 to r=324, NO center cap!)
            // Flood-fill exterior
            bool[,] isExterior = new bool[W, H];
            System.Collections.Generic.Queue<Point> q = new System.Collections.Generic.Queue<Point>();
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

            using (Bitmap frameBmp = new Bitmap(W, H, PixelFormat.Format32bppArgb)) {
                for (int y = 0; y < H; y++) {
                    for (int x = 0; x < W; x++) {
                        if (isExterior[x, y]) {
                            frameBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            continue;
                        }
                        Color c = src.GetPixel(x, y);
                        double dist = Math.Sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
                        bool isTopPointer = (y <= 198 && Math.Abs(x - 387.0) <= 46.0 && (y <= (198.0 - Math.Abs(x - 387.0) * 1.35)));

                        // The hole inside golden rim (dist < 324.0) is COMPLETELY transparent!
                        if (!isTopPointer && dist < 324.0) {
                            if (dist > 322.0) {
                                int a = (int)((dist - 322.0) / 2.0 * 255.0);
                                frameBmp.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                            } else {
                                frameBmp.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                            }
                        } else {
                            bool nearExt = false;
                            if (x > 0 && x < W - 1 && y > 0 && y < H - 1) {
                                if (isExterior[x-1, y] || isExterior[x+1, y] || isExterior[x, y-1] || isExterior[x, y+1]) {
                                    nearExt = true;
                                }
                            }
                            if (nearExt) {
                                frameBmp.SetPixel(x, y, Color.FromArgb(140, c.R, c.G, c.B));
                            } else {
                                frameBmp.SetPixel(x, y, Color.FromArgb(255, c.R, c.G, c.B));
                            }
                        }
                    }
                }

                // Patch the "1 Dreh verfügbar" text
                Color darkNavy = Color.FromArgb(255, 14, 11, 48);
                for (int py = 760; py <= 788; py++) {
                    for (int px = 770; px <= 940; px++) {
                        frameBmp.SetPixel(px, py, darkNavy);
                    }
                }

                frameBmp.Save(outDir + "\\wheel_frame_ui_mitdrehen.png", ImageFormat.Png);
            }
        }
    }
}
"@
Add-Type -TypeDefinition $code -ReferencedAssemblies System.Drawing
[SeamlessWheelExtractor]::Generate(
    "C:\Users\kunde\.gemini\antigravity\brain\4baa3864-af36-4dbb-9097-602f9d2e1eec\.user_uploaded\media_1793376914150_32da2b27.jpg",
    "c:\Users\kunde\Desktop\Crack the egg\scratch"
)
Write-Host "Done generating mitdrehen versions."
