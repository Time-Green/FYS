using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Path = System.IO.Path;

namespace StructureDesigner
{

    public partial class MainWindow
    {
        private const int TileSize = 50;

        public MainWindow()
        {
            InitializeComponent();

            AddLayers();
            AddGridLines();
            LoadTiles();
        }

        private void AddLayers()
        {
            var gridView = new GridView();
            LayerView.View = gridView;

            gridView.Columns.Add(new GridViewColumn
            {
                Header = "Layer"
            });

            // Populate list
            LayerView.Items.Add("Background");
            LayerView.Items.Add("Layer 1");
            LayerView.Items.Add("Layer 2");
            LayerView.Items.Add("Layer 3");

            LayerView.SelectedItem = "Background";
        }

        private void AddGridLines()
        {
            //horizontal lines
            for (var i = 0; i < 100; i++)
            {
                var line = new Line
                {
                    X1 = i * TileSize,
                    X2 = i * TileSize,
                    Y1 = 0,
                    Y2 = 10000,
                    Stroke = Brushes.DarkRed,
                    StrokeThickness = 1
                };

                Canvas.Children.Add(line);
            }

            //vertical lines
            for (var i = 0; i < 100; i++)
            {
                var line = new Line
                {
                    X1 = 0,
                    X2 = 10000,
                    Y1 = i * TileSize,
                    Y2 = i * TileSize,
                    Stroke = Brushes.DarkRed,
                    StrokeThickness = 1
                };

                Canvas.Children.Add(line);
            }
        }

        private void LoadTiles()
        {
            var currentDirectory = Directory.GetCurrentDirectory();
            var fysDirectory = currentDirectory.Split(new[] {"FYS"}, StringSplitOptions.None)[0];
            var fysDataDirectory = Path.Combine(fysDirectory, "FYS", "data");

            var allFiles = new List<string>();

            var categoriesToUse = new List<string>
            {
                "Blocks",
                "Enemies",
                "Cave",
                "House",
                "Landscape",
                "Structures"
            };

            foreach (var category in categoriesToUse)
            {
                var directory = Path.Combine(fysDataDirectory, "Sprites", category);
                var allTiles = Directory.GetFiles(directory, "*.*", SearchOption.AllDirectories).Where(s => s.EndsWith(".png") || s.EndsWith(".jpg")).ToList();

                allFiles.AddRange(allTiles);
            }

            foreach (var file in allFiles)
            {
                var image = new Image
                {
                    Source = new BitmapImage(new Uri(file)),
                    Width = TileSize,
                    Height = TileSize,
                    Margin = new Thickness(5),
                    ToolTip = Path.GetFileNameWithoutExtension(file)
                };

                image.PreviewMouseDown += ImageOnPreviewMouseDown;

                SelectionPanel.Children.Add(image);
            }
        }

        private static void ImageOnPreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            DragDrop.DoDragDrop((DependencyObject)sender, ((Image)sender).Source, DragDropEffects.Copy);
        }

        private void Canvas_Drop(object sender, DragEventArgs e)
        {
            foreach (var format in e.Data.GetFormats())
            {
                if (!(e.Data.GetData(format) is ImageSource imageSource))
                {
                    continue;
                }

                var img = new Image
                {
                    Height = TileSize,
                    Width = TileSize,
                    Source = imageSource
                };

                ((Canvas)sender).Children.Add(img);

                AlignToGrid(img, e.GetPosition(Canvas));
            }
        }

        private static void AlignToGrid(UIElement img, Point dropPoint)
        {
            var targetX = GetGridPos(dropPoint.X);
            var targetY = GetGridPos(dropPoint.Y);

            Canvas.SetLeft(img, targetX);
            Canvas.SetTop(img, targetY);
        }

        private static int GetGridPos(double dropPos)
        {
            var flooredValue = (int) Math.Floor(dropPos);

            while (flooredValue % TileSize != 0)
            {
                flooredValue--;
            }

            return flooredValue;
        }
    }
}
