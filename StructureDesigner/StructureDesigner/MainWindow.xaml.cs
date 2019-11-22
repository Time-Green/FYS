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
using MahApps.Metro.Controls.Dialogs;
using Microsoft.Win32;
using Newtonsoft.Json;
using Path = System.IO.Path;

namespace StructureDesigner
{
    public partial class MainWindow
    {
        private const int TileSize = 50;
        private const int LayerAmount = 4;
        private const int EditorGridWidth = 100;
        private const int EditorGridHeight = 100;

        private readonly List<Image[,]> _layers = new List<Image[,]>();
        private int _selectedLayer;
        private string _fysDataDirectory;
        private bool isMouseDownOnCanvas;

        private Image selectedImage;

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

            for (var i = 0; i < LayerAmount; i++)
            {
                if (i == 0)
                {
                    LayerView.Items.Add("Background");
                }
                else
                {
                    LayerView.Items.Add("Layer " + i);
                }

                var layerArray = new Image[EditorGridWidth, EditorGridHeight];

                _layers.Add(layerArray);
            }

            LayerView.SelectedItem = "Background";
        }

        private void AddGridLines()
        {
            //horizontal lines
            for (var i = 0; i < EditorGridWidth; i++)
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
            for (var i = 0; i < EditorGridHeight; i++)
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
            _fysDataDirectory = Path.Combine(fysDirectory, "FYS", "data");

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
                var directory = Path.Combine(_fysDataDirectory, "Sprites", category);
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

        private void ImageOnPreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            if (selectedImage != null)
            {
                selectedImage.Margin = new Thickness(5);
                selectedImage.Width = 50;
                selectedImage.Height = 50;
            }

            selectedImage = (Image)sender;
            selectedImage.Margin = new Thickness(1);
            selectedImage.Width = 58;
            selectedImage.Height = 58;
        }

        private void Canvas_OnMouseDown(object sender, MouseButtonEventArgs e)
        {
            isMouseDownOnCanvas = true;

            var gridPoint = GetGridPos(e.GetPosition(Canvas));

            AddTile(gridPoint, selectedImage.Source, _selectedLayer);
        }

        private void Canvas_OnMouseUp(object sender, MouseButtonEventArgs e)
        {
            isMouseDownOnCanvas = false;
        }

        private void Canvas_OnMouseMove(object sender, MouseEventArgs e)
        {
            if (!isMouseDownOnCanvas)
            {
                return;
            }

            var gridPoint = GetGridPos(e.GetPosition(Canvas));

            AddTile(gridPoint, selectedImage.Source, _selectedLayer);
        }

        private void AddTile(Point gridPoint, ImageSource imageSource, int layer)
        {
            var existingImageOnGridPoint = _layers[layer][(int) gridPoint.X / TileSize, (int) gridPoint.Y / TileSize];

            if (existingImageOnGridPoint != null)
            {
                //same image
                if (existingImageOnGridPoint.Source == imageSource)
                {
                    return;
                }

                Canvas.Children.Remove(existingImageOnGridPoint);
            }

            var img = new Image
            {
                Height = TileSize,
                Width = TileSize,
                Source = imageSource
            };

            Canvas.Children.Add(img);

            AddToGrid(img, gridPoint);
        }

        private void AddToGrid(Image img, Point gridPoint)
        {
            Canvas.SetLeft(img, gridPoint.X);
            Canvas.SetTop(img, gridPoint.Y);

            _layers[_selectedLayer][(int)gridPoint.X / TileSize, (int)gridPoint.Y / TileSize] = img;
        }

        private static Point GetGridPos(Point dropPoint)
        {
            var flooredXValue = (int) Math.Floor(dropPoint.X);

            while (flooredXValue % TileSize != 0)
            {
                flooredXValue--;
            }
            
            var flooredYValue = (int)Math.Floor(dropPoint.Y);

            while (flooredYValue % TileSize != 0)
            {
                flooredYValue--;
            }

            return new Point(flooredXValue, flooredYValue);
        }

        private void LayerView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            _selectedLayer = LayerView.SelectedIndex;
        }

        private async void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            var result = await this.ShowInputAsync("Enter name", "Enter a name to save the structure as");

            if (!string.IsNullOrWhiteSpace(result))
            {
                Save(result);
            }
        }
        private void LoadButton_Click(object sender, RoutedEventArgs e)
        {
            var fileDialog = new OpenFileDialog
            {
                InitialDirectory = Path.Combine(_fysDataDirectory, "Structures"),
                Filter = "json files (*.json)|*.json"
            };

            var selectedFile = fileDialog.ShowDialog();

            if (!selectedFile.HasValue || string.IsNullOrEmpty(fileDialog.FileName))
            {
                return;
            }

            var data = File.ReadAllText(fileDialog.FileName);

            var structure = JsonConvert.DeserializeObject<List<List<string>>>(data);

            var layerIndex = 0;

            foreach (var layer in structure)
            {
                foreach (var tile in layer)
                {
                    var split = tile.Split('|');

                    if (split.Length == 1)
                    {
                        continue;
                    }

                    var x = int.Parse(split[0]);
                    var y = int.Parse(split[1]);
                    var file = split[2];
                    var point = new Point(x * TileSize, y * TileSize);
                    var fullPath = _fysDataDirectory + file;

                    AddTile(point, new BitmapImage(new Uri(fullPath)), layerIndex);
                }

                layerIndex++;
            }
        }

        private void Save(string saveName)
        {
            var minXPos = EditorGridWidth;
            var minYPos = EditorGridHeight;
            var maxXPos = -1;
            var maxYPos = -1;

            for (var y = 0; y < EditorGridHeight; y++)
            {
                for (var x = 0; x < EditorGridWidth; x++)
                {
                    var existingImageOnGrid = _layers[0][x, y];

                    if (existingImageOnGrid != null)
                    {
                        if (x < minXPos)
                        {
                            minXPos = x;
                        }
                            
                        if (y < minYPos)
                        {
                            minYPos = y;
                        }

                        if (x > maxXPos)
                        {
                            maxXPos = x;
                        }

                        if (y > maxYPos)
                        {
                            maxYPos = y;
                        }
                    }
                }
            }

            var saveList = new List<List<string>>();

            for (var layer = 0; layer < LayerAmount; layer++)
            {
                var currentLayer = new List<string>();
                
                for (var currentY = minYPos; currentY <= maxYPos; currentY++)
                {
                    for (var currentX = minXPos; currentX <= maxXPos; currentX++)
                    {
                        var img = _layers[layer][currentX, currentY];

                        if (img == null)
                        {
                            currentLayer.Add("");
                            continue;
                        }

                        var fullSource = img.Source.ToString();
                        var removedFileTitle = fullSource.Remove(0, 8);
                        var replacedFullSource = removedFileTitle.Replace("/", "\\");
                        var baseRemovedPath = replacedFullSource.Replace(_fysDataDirectory, string.Empty);

                        currentLayer.Add(currentX + "|" + currentY + "|" + baseRemovedPath);
                    }
                }

                saveList.Add(currentLayer);
            }

            var saveString = JsonConvert.SerializeObject(saveList, Formatting.Indented);

            File.WriteAllText(Path.Combine(_fysDataDirectory, "Structures", saveName + ".json"), saveString);
        }
    }
}
