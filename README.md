# Godot Node2Tile is based on Crocotile 3d where it uses Godot's own editor to create scenarios. 📐

## It is recommended to activate the editor's grid option to modify vertices!

Nodes:
- ![brush](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/GodotNode2Tile/misc/icon_brush.png) Brush: is a Node3D that groups and draws all tiles, in addition to defining the collision.
- ![form](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/GodotNode2Tile/misc/icon_form.png) BrushForm: A surface with data for a face of the model.
- ![vatt](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/GodotNode2Tile/misc/icon_vatt.png) VertexAttachment: is an optional node that allows changing the shape’s vertices

# Updates 🎉
## Version 1.2
- Added cubic projection UV property to BrushForm Nodes.
 ![demo](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/128dbe646975a855bd1e33eb9ebe396f7b60de8b/pic_1.png)
- Added offset attachment to VertexAttachment Nodes.
 ![demo1](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/128dbe646975a855bd1e33eb9ebe396f7b60de8b/pic_2.gif)


## Version 1.1
- Fixed problem when a triangle is formed on a single face.
- Added "override non materials" property to the "Brush" node to replicate the null materials from all "BrushForms".
- Collision fixed!
- Supported for Godot 4.2.2!

![demo](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/pic_0.png)

Demo:

![screenshot](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/Captura%20de%20tela%202024-04-16%20125949.png)
