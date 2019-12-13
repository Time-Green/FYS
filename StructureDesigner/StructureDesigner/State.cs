﻿using System.Collections.Generic;
using System.Windows.Controls;

namespace StructureDesigner
{
    public class State
    {
        public readonly List<Image[,]> Layers = new List<Image[,]>();

        public State(int Globals.TILE_SIZE, int editorGridWidth, int editorGridHeight, List<Image[,]> layers)
        {
            //copy data
            foreach (var layer in layers)
            {
                var layerArray = new Image[editorGridWidth, editorGridHeight];

                for (var y = 0; y < editorGridHeight; y++)
                {
                    for (var x = 0; x < editorGridWidth; x++)
                    {
                        if (layer[x, y] != null)
                        {
                            layerArray[x, y] = new Image
                            {
                                Height = Globals.TILE_SIZE,
                                Width = Globals.TILE_SIZE,
                                Source = layer[x, y].Source.Clone()
                            };
                        }
                    }
                }

                Layers.Add(layerArray);
            }
        }
    }
}
