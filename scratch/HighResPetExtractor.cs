using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class HighResPetExtractor {
    public class PetDef {
        public string Id;
        public int X, Y, W, H;
        // Background color characteristic to remove
        public Func<Color, bool> IsBg;
    }

    public static void ExtractAll(string srcPath, string outDir) {
        using (Bitmap src = new Bitmap(srcPath)) {
            var pets = new[] {
                new PetDef {
                    Id = "pet_dog", X = 315, Y = 190, W = 145, H = 130,
                    // Dog wedge is light blue/sky
                    IsBg = c => (c.B > 180 && c.B > c.R + 25 && c.B > c.G + 10) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_cat", X = 445, Y = 225, W = 140, H = 135,
                    // Cat wedge is bright lime green
                    IsBg = c => (c.G > 140 && c.G > c.R + 30 && c.G > c.B + 40) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_mouse", X = 540, Y = 340, W = 130, H = 125,
                    // Mouse wedge is cyan blue
                    IsBg = c => (c.B > 160 && c.B > c.R + 45) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_bunny", X = 555, Y = 475, W = 125, H = 135,
                    // Bunny wedge is magenta/pink
                    IsBg = c => (c.R > 160 && c.B > 130 && c.G < 100) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_fox", X = 480, Y = 595, W = 125, H = 120,
                    // Fox wedge is red-orange gradient (fox itself is bright orange with white chest)
                    IsBg = c => (c.R > 180 && c.G < 120 && c.B < 50 && (c.R - c.G > 90)) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_frog", X = 390, Y = 675, W = 100, H = 100,
                    // Frog wedge is yellow-green
                    IsBg = c => (c.G > 160 && c.G > c.B + 40 && c.R < 120) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_panda", X = 280, Y = 675, W = 105, H = 100,
                    // Panda wedge is cyan
                    IsBg = c => (c.B > 160 && c.B > c.R + 50) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_dragon", X = 150, Y = 590, W = 135, H = 135,
                    // Dragon wedge is deep purple
                    IsBg = c => (c.B > 150 && c.R > 90 && c.G < 60) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_phoenix", X = 85, Y = 465, W = 140, H = 145,
                    // Phoenix wedge is yellow-orange gradient
                    IsBg = c => (c.R > 220 && c.G > 130 && c.B < 40 && c.R - c.G < 80) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_unicorn", X = 100, Y = 335, W = 130, H = 130,
                    // Unicorn wedge is purple-violet
                    IsBg = c => (c.B > 160 && c.R > 110 && c.G < 110) || (c.R < 65 && c.G < 65 && c.B < 120)
                },
                new PetDef {
                    Id = "pet_cosmic_companion", X = 200, Y = 210, W = 120, H = 120,
                    // Cosmic wedge is dark space navy with stars
                    IsBg = c => (c.B > 70 && c.R < 70 && c.G < 50) || (c.R < 45 && c.G < 45 && c.B < 85)
                }
            };

            foreach (var p in pets) {
                // Target square output: 256x256
                int outSize = 256;
                using (Bitmap petBmp = new Bitmap(outSize, outSize, PixelFormat.Format32bppArgb)) {
                    using (Bitmap rawCrop = new Bitmap(p.W, p.H, PixelFormat.Format32bppArgb)) {
                        // Extract raw area
                        for (int y = 0; y < p.H; y++) {
                            for (int x = 0; x < p.W; x++) {
                                rawCrop.SetPixel(x, y, src.GetPixel(p.X + x, p.Y + y));
                            }
                        }

                        // Connected flood-fill from all 4 borders to remove outer wedge background
                        bool[,] isBg = new bool[p.W, p.H];
                        Queue<Point> q = new Queue<Point>();

                        for (int x = 0; x < p.W; x++) {
                            EnqueueIfBg(rawCrop, x, 0, p.IsBg, isBg, q);
                            EnqueueIfBg(rawCrop, x, p.H - 1, p.IsBg, isBg, q);
                        }
                        for (int y = 0; y < p.H; y++) {
                            EnqueueIfBg(rawCrop, 0, y, p.IsBg, isBg, q);
                            EnqueueIfBg(rawCrop, p.W - 1, y, p.IsBg, isBg, q);
                        }

                        int[] dx = { -1, 1, 0, 0 };
                        int[] dy = { 0, 0, -1, 1 };

                        while (q.Count > 0) {
                            Point pt = q.Dequeue();
                            for (int d = 0; d < 4; d++) {
                                int nx = pt.X + dx[d];
                                int ny = pt.Y + dy[d];
                                if (nx >= 0 && nx < p.W && ny >= 0 && ny < p.H && !isBg[nx, ny]) {
                                    Color c = rawCrop.GetPixel(nx, ny);
                                    if (p.IsBg(c)) {
                                        isBg[nx, ny] = true;
                                        q.Enqueue(new Point(nx, ny));
                                    }
                                }
                            }
                        }

                        // Apply transparency with edge smoothing
                        using (Bitmap cleanCut = new Bitmap(p.W, p.H, PixelFormat.Format32bppArgb)) {
                            for (int y = 0; y < p.H; y++) {
                                for (int x = 0; x < p.W; x++) {
                                    if (isBg[x, y]) {
                                        cleanCut.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                                    } else {
                                        Color c = rawCrop.GetPixel(x, y);
                                        // Soft edge
                                        int bgCount = 0;
                                        for (int d = 0; d < 4; d++) {
                                            int nx = x + dx[d];
                                            int ny = y + dy[d];
                                            if (nx < 0 || nx >= p.W || ny < 0 || ny >= p.H || isBg[nx, ny]) bgCount++;
                                        }
                                        int a = 255;
                                        if (bgCount >= 2) a = 180;
                                        else if (bgCount == 1) a = 225;
                                        cleanCut.SetPixel(x, y, Color.FromArgb(a, c.R, c.G, c.B));
                                    }
                                }
                            }

                            // Render centered onto 256x256 target
                            using (Graphics g = Graphics.FromImage(petBmp)) {
                                g.SmoothingMode = SmoothingMode.AntiAlias;
                                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                float scale = Math.Min(220.0f / p.W, 220.0f / p.H);
                                int dw = (int)(p.W * scale);
                                int dh = (int)(p.H * scale);
                                int dxPos = (outSize - dw) / 2;
                                int dyPos = outSize - dh - 16; // Sits nicely near ground!
                                g.DrawImage(cleanCut, new Rectangle(dxPos, dyPos, dw, dh));
                            }
                        }
                    }
                    petBmp.Save(outDir + "\\" + p.Id + ".png", ImageFormat.Png);
                    Console.WriteLine("Extracted clean freestanding " + p.Id);
                }
            }
        }
    }

    private static void EnqueueIfBg(Bitmap bmp, int x, int y, Func<Color, bool> isBgFunc, bool[,] isBg, Queue<Point> q) {
        if (!isBg[x, y]) {
            Color c = bmp.GetPixel(x, y);
            if (isBgFunc(c)) {
                isBg[x, y] = true;
                q.Enqueue(new Point(x, y));
            }
        }
    }
}
