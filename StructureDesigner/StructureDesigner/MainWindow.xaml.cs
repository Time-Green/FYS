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
        private const int EditorGridWidth = 50;
        private const int EditorGridHeight = 100;

        private int _undoIndex;
        private readonly List<UndoAction> _undoActions = new List<UndoAction>();

        private List<Image[,]> _layers = new List<Image[,]>();
        private int _selectedLayer;
        private string _fysDataDirectory;
        private bool _isMouseDownOnCanvas;
        private string _currentProjectName;

        private readonly ScaleTransform _scaleTransform = new ScaleTransform();

        private Image _selectedImage;

        public MainWindow()
        {
            InitializeComponent();

            Canvas.RenderTransform = _scaleTransform;
            Canvas.Width = EditorGridWidth * TileSize;
            Canvas.Height = EditorGridHeight * TileSize;

            AddLayers(true);
            AddGridLines();
            LoadTiles();

            SaveUndoAction(false);
        }

        private void AddLayers(bool updateLayerView)
        {
            if (updateLayerView)
            {
                var gridView = new GridView();
                LayerView.View = gridView;

                gridView.Columns.Add(new GridViewColumn
                {
                    Header = "Layer"
                });
            }

            for (var i = 0; i < LayerAmount; i++)
            {
                if (updateLayerView)
                {
                    if (i == 0)
                    {
                        LayerView.Items.Add("Tiles");
                    }
                    else
                    {
                        LayerView.Items.Add("Decoration " + i);
                    }
                }

                var layerArray = new Image[EditorGridWidth, EditorGridHeight];

                _layers.Add(layerArray);
            }

            LayerView.SelectedItem = "Tiles";
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
                    Y2 = EditorGridHeight * TileSize,
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
                    X2 = EditorGridWidth * TileSize,
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
            if (_selectedImage != null)
            {
                _selectedImage.Margin = new Thickness(5);
                _selectedImage.Width = 50;
                _selectedImage.Height = 50;
            }

            _selectedImage = (Image)sender;
            _selectedImage.Margin = new Thickness(1);
            _selectedImage.Width = 58;
            _selectedImage.Height = 58;
        }

        private void Canvas_OnMouseDown(object sender, MouseButtonEventArgs e)
        {
            _isMouseDownOnCanvas = true;

            if (_selectedImage == null)
            {
                return;
            }

            if (e.LeftButton == MouseButtonState.Pressed)
            {
                var gridPoint = GetGridPos(e.GetPosition(Canvas));

                AddTile(gridPoint, _selectedImage.Source, _selectedLayer);
            }
        }

        private void Canvas_OnMouseUp(object sender, MouseButtonEventArgs e)
        {
            _isMouseDownOnCanvas = false;

            SaveUndoAction(true);
        }

        private void Canvas_OnMouseMove(object sender, MouseEventArgs e)
        {
            if (!_isMouseDownOnCanvas)
            {
                return;
            }

            if (_selectedImage == null)
            {
                return;
            }

            if (e.LeftButton == MouseButtonState.Pressed)
            {
                var gridPoint = GetGridPos(e.GetPosition(Canvas));

                AddTile(gridPoint, _selectedImage.Source, _selectedLayer);
            }
            else if (e.LeftButton == MouseButtonState.Pressed)
            {
                //TODO: dragging
            }
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

            AddToGrid(img, gridPoint, layer);
        }

        private void AddToGrid(Image img, Point gridPoint, int layer)
        {
            Canvas.SetLeft(img, gridPoint.X);
            Canvas.SetTop(img, gridPoint.Y);

            _layers[layer][(int)gridPoint.X / TileSize, (int)gridPoint.Y / TileSize] = img;
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

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            DoSave();
        }

        private async void DoSave()
        {
            //if we are working on an existing structure, don't ask for a name again
            if (!string.IsNullOrWhiteSpace(_currentProjectName))
            {
                Save(_currentProjectName);
                MessageBox.Show("Structure saved as: " + _currentProjectName, "Saved");
                return;
            }

            var result = await this.ShowInputAsync("Enter name", "Enter a name for your amazing structure");

            if (!string.IsNullOrWhiteSpace(result))
            {
                Save(result);
            }
        }

        private void LoadButton_Click(object sender, RoutedEventArgs e)
        {
            DoLoad();
        }

        private void DoLoad()
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

            ClearAllTiles();

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

            _currentProjectName = Path.GetFileNameWithoutExtension(fileDialog.FileName);
            Title = $"Structure Designer - {_currentProjectName}";
        }

        private void ClearAllTiles()
        {
            Canvas.Children.Clear();
            _layers.Clear();
            AddLayers(false);
            AddGridLines();
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

                        currentLayer.Add((currentX - minXPos) + "|" + (currentY - minYPos) + "|" + baseRemovedPath);
                    }
                }

                saveList.Add(currentLayer);
            }

            var saveString = JsonConvert.SerializeObject(saveList, Formatting.Indented);

            File.WriteAllText(Path.Combine(_fysDataDirectory, "Structures", saveName + ".json"), saveString);

            Title = $"Structure Designer - {_currentProjectName}";
        }

        private void SaveUndoAction(bool checkForSelectedImage)
        {
            if (checkForSelectedImage && _selectedImage == null)
            {
                return;
            }

            var undoAction = new UndoAction(TileSize, EditorGridWidth, EditorGridHeight, _layers);

            _undoActions.Add(undoAction);

            _undoIndex++;
        }

        private void Undo()
        {
            if (_undoActions.Count <= 1)
            {
                return;
            }

            _undoIndex--;

            var undoAction = _undoActions[_undoIndex - 1];

            ClearAllTiles();

            var layerCount = 0;

            foreach (var layer in undoAction.Layers)
            {
                for (var y = 0; y < EditorGridHeight; y++)
                {
                    for (var x = 0; x < EditorGridWidth; x++)
                    {
                        if (layer[x, y] != null)
                        {
                            AddTile(new Point(x * TileSize, y * TileSize), layer[x, y].Source, layerCount);
                        }
                    }
                }

                layerCount++;
            }

            _undoActions.RemoveAt(_undoActions.IndexOf(undoAction) + 1);

            //_layers = undoAction.Layers;
            //_undoIndex = _undoActions.Count;
        }

        private void MainWindow_OnMouseWheel(object sender, MouseWheelEventArgs e)
        {
            if (e.Delta > 0)
            {
                _scaleTransform.ScaleX *= 1.1f;
                _scaleTransform.ScaleY *= 1.1f;
            }
            else
            {
                _scaleTransform.ScaleX /= 1.1f;
                _scaleTransform.ScaleY /= 1.1f;
            }
        }

        private void MetroWindow_KeyDown(object sender, KeyEventArgs e)
        {
            if (Keyboard.Modifiers == ModifierKeys.Control && e.Key == Key.Z)
            {
                Undo();
            }
            else if (Keyboard.Modifiers == ModifierKeys.Control && e.Key == Key.S)
            {
                DoSave();
            }
            else if(Keyboard.Modifiers == ModifierKeys.Control && e.Key == Key.L)
            {
                DoLoad();
            }
        }
    }
}
