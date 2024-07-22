# Godot Node2Tile is based on Crocotile 3d where it uses Godot's own editor to create fast levels. 📐

### It is recommended to use the editor's grid snap for better vertex editing.

### Basic Instructions
[Link for YouTube Instructions Video](https://youtu.be/e3lItaFOlow)

Nodes:
- ![brush](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_brush.png) Brush: is a Node3D that groups and draws all tiles, in addition to defining the collision.
- ![form](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_form.png) BrushForm: A surface with data for a face of the model.
- ![vatt](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_vatt.png) VertexAttachment: is an optional node that allows changing the shape’s vertices

![demo](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/128dbe646975a855bd1e33eb9ebe396f7b60de8b/pic_1.png)

# Changelogs 🎉
## Version 1.5
- Added UV editor to BrushForm Node.
  ![image](https://github.com/user-attachments/assets/9e580b55-5190-422d-989e-9c079262fea9)


## Version 1.4
- Fixed bugs.
- Added Vertex Gizmo.
- Added an "Add BrushForm" button in the inspector (by Smorty10).
- Now a "BrushForm" can be drawn with a separate primitive type.
  ![image](https://github.com/user-attachments/assets/5cb66878-ba3c-444c-a46d-65fe1bbe2f32)


## Version 1.3
- Fixed surface normals.
- Added "surface_normal" property to BrushForm Nodes.
- Added auto-recalculate normals property.
- Brush nodes can now change their visibility.
- Fixed error when moving a Brush node.

## Version 1.2
- Added cubic projection UV property to BrushForm Nodes.
- Added offset attachment to VertexAttachment Nodes.
 ![demo1](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/128dbe646975a855bd1e33eb9ebe396f7b60de8b/pic_2.gif)


## Version 1.1
- Fixed problem when a triangle is formed on a single face.
- Added "override non materials" property to the "Brush" node to replicate the null materials from all "BrushForms".
- Collision fixed!
- Supported for Godot 4.2.2!
