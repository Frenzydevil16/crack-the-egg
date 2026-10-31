using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class UniversalPetExtractor {
    public static void ExtractAll(string srcPath, string outDir) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int W = src.Width;
            int H = src.Height;
            double cx = 387.0;
            double cy = 500.0;
            double segAngle = 2.0 * Math.PI / 11.0;

            string[] petIds = {
                "pet_dog", "pet_cat", "pet_mouse", "pet_bunny", "pet_fox",
                "pet_frog", "pet_panda", "pet_dragon", "pet_phoenix", "pet_unicorn",
                "pet_cosmic_companion"
            };

            for (int i = 0; i < 11; i++) {
                string pid = petIds[i];
                double centerAngle = i * segAngle;

                // Animal visual center radius ~ 245
                double rCenter = 245.0;
                int scx = (int)(cx + rCenter * Math.Sin(centerAngle));
                int scy = (int)(cy - rCenter * Math.Cos(centerAngle));

                int S = 200;
                int half = S / 2;

                using (Bitmap raw = new Bitmap(S, S, PixelFormat.Format32bppArgb)) {
                    bool[,] isBg = new bool[S, S];
                    Queue<Point> q = new Queue<Point>();

                    // 1. Initial pass: sample background color near top rim of this wedge (r ~ 310)
                    int bgSampleX = (int)(cx + 310.0 * Math.Sin(centerAngle));
                    int bgSampleY = (int)(cy - 310.0 * Math.Cos(centerAngle));
                    Color bgSample = (bgSampleX >= 0 && bgSampleX < W && bgSampleY >= 0 && bgSampleY < H)
                        ? src.GetPixel(bgSampleX, bgSampleY)
                        : Color.Magenta;

                    for (int y = 0; y < S; y++) {
                        int sy = scy - half + y;
                        for (int x = 0; x < S; x++) {
                            int sx = scx - half + x;
                            if (sx < 0 || sx >= W || sy < 0 || sy >= H) {
                                isBg[x, y] = true;
                                raw.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                continue;
                            }

                            double dx = sx - cx;
                            double dy = sy - cy;
                            double r = Math.Sqrt(dx * dx + dy * dy);
                            double angle = Math.Atan2(dx, -dy);
                            if (angle < 0) angle += 2.0 * Math.PI;

                            double diff = angle - centerAngle;
                            while (diff > Math.PI) diff -= 2.0 * Math.PI;
                            while (diff < -Math.PI) diff += 2.0 * Math.PI;

                            // Outside animal wedge slice: 100% background!
                            if (Math.Abs(diff) > (segAngle * 0.40)) {
                                isBg[x, y] = true;
                                raw.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                continue;
                            }

                            // Outside animal radial band: strictly between r = 180 and r = 318
                            if (r < 182.0 || r > 320.0) {
                                isBg[x, y] = true;
                                raw.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                continue;
                            }

                            Color c = src.GetPixel(sx, sy);
                            raw.SetPixel(x, y, c);

                            // Border pixels of the valid slice are seed points for background flood-fill
                            if (Math.Abs(diff) > (segAngle * 0.35) || r > 310.0 || r < 190.0) {
                                isBg[x, y] = true;
                                q.Enqueue(new Point(x, y));
                            }
                        }
                    }

                    // 2. Flood-fill background inwards from the outer rim & slice borders
                    int[] dxArr = { -1, 1, 0, 0 };
                    int[] dyArr = { 0, 0, -1, 1 };

                    while (q.Count > 0) {
                        Point pt = q.Dequeue();
                        Color cp = raw.GetPixel(pt.X, pt.Y);

                        for (int d = 0; d < 4; d++) {
                            int nx = pt.X + dxArr[d];
                            int ny = pt.Y + dyArr[d];
                            if (nx >= 0 && nx < S && ny >= 0 && ny < S && !isBg[nx, ny]) {
                                Color cn = raw.GetPixel(nx, ny);
                                if (cn.A == 0) continue;

                                // Check color similarity to bgSample or current background pixel
                                int distToBgSample = ColorDist(cn, bgSample);
                                int distToCp = ColorDist(cn, cp);

                                // If close to background hue, expand flood fill
                                if (distToBgSample < 85 || distToCp < 35) {
                                    isBg[nx, ny] = true;
                                    q.Enqueue(new Point(nx, ny));
                                }
                            }
                        }
                    }

                    // 3. Compose clean, centered 256x256 freestanding pet sprite
                    int outSize = 256;
                    using (Bitmap outBmp = new Bitmap(outSize, outSize, PixelFormat.Format32bppArgb)) {
                        // Find bounding box of foreground
                        int minX = S, maxX = 0, minY = S, maxY = 0;
                        for (int y = 0; y < S; y++) {
                            for (int x = 0; x < S; x++) {
                                if (!isBg[x, y]) {
                                    if (x < minX) minX = x;
                                    if (x > maxX) maxX = x;
                                    if (y < minY) minY = y;
                                    if (y > maxY) maxY = y;
                                }
                            }
                        }

                        if (maxX > minX && maxY > minY) {
                            int fw = maxX - minX + 1;
                            int fh = maxY - minY + 1;

                            using (Bitmap fg = new Bitmap(fw, fh, PixelFormat.Format32bppArgb)) {
                                for (int y = 0; y < fh; y++) {
                                    for (int x = 0; x < fw; x++) {
                                        int srcX = minX + x;
                                        int srcY = minY + y;
                                        if (!isBg[srcX, srcY]) {
                                            Color c = raw.GetPixel(srcX, srcY);
                                            // Soft edge alpha
                                            int bgCount = 0;
                                            for (int d = 0; d < 4; d++) {
                                                int nx = srcX + dxArr[d];
                                                int ny = srcY + dyArr[d];
                                                if (nx < 0 || nx >= S || ny < 0 || ny >= S || isBg[nx, ny]) bgCount++;
                                            }
                                            int a = (bgCount >= 2) ? 190 : 255;
                                            fg.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                                        } else {
                                            fg.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                        }
                                    }
                                }

                                using (Graphics g = Graphics.FromImage(outBmp)) {
                                    g.SmoothingMode = SmoothingMode.AntiAlias;
                                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                    float scale = Math.Min(220.0f / fw, 220.0f / fh);
                                    int dw = (int)(fw * scale);
                                    int dh = (int)(fh * scale);
                                    int dxPos = (outSize - dw) / 2;
                                    int dyPos = outSize - dh - 10; // Grounded near bottom!
                                    g.DrawImage(fg, new Rectangle(dxPos, dyPos, dw, dh));
                                }
                            }
                        }

                        outBmp.Save(outDir + "\\" + pid + ".png", ImageFormat.Png);
                        Console.WriteLine("Universal extracted clean " + pid + ".png");
                    }
                }
            }
        }
    }

    private static int ColorDist(Color c1, Color c2) {
        int dr = c1.R - c2.R;
        int dg = c1.G - c2.G;
        int db = c1.B - c2.B;
        return (int)Math.Sqrt(dr * dr + dg * dg + db * db);
    }
}
