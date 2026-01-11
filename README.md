# Godot Node2Tile is based on Crocotile 3d where it uses Godot's own editor to create fast levels. 📐

### ⚠️ It is recommended to use the editor's grid snap for better vertex editing.

> ### Editing a tile
<img width="118" height="192" alt="image" src="https://github.com/user-attachments/assets/58cbbb23-c7a3-4c11-8a13-0c22f973195d" /><img width="590" height="191" alt="image" src="https://github.com/user-attachments/assets/c5d9fb03-3dd2-48de-aadc-a562224a038b" />

> Choose the dominant vertex in the "offset" property. Every time the dominant vertex moves, the other will move along with it.
<img width="267" height="153" alt="image" src="https://github.com/user-attachments/assets/8ea245ef-59cf-45f9-8a4d-3a9044a1c20a" />


> Composition
> - ![brush](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_brush.png) Brush: It is a node that groups all the BrushForms to be drawn (optionally applying a collision).
> - ![form](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_form.png) BrushForm: It is a node that creates a surface for a tile. Each vertex can be modified.
> - ![vatt](https://raw.githubusercontent.com/QJPG/GodotNode2Tile/main/addons/GodotNode2Tile/misc/icon_vatt.png) VertexAttachment: It is a node that allows you to specify which vertex of a BrushForm will be modified. It also allows you to attach another VertexAttachment to join multiple tiles into one.

![image](https://github.com/user-attachments/assets/2864452d-62cc-428f-bb6c-cbc8fa6194c9)
> To modify the UV of a tile (BrushForm), you first need to add a material that has a texture in "albedo_texture".
<img width="259" height="130" alt="image" src="https://github.com/user-attachments/assets/d5bd642a-bd7e-4083-b80a-a02edd0c14fd" />


> # Changelogs 🎉
## Version 1.6
- Fixed bugs.
- Updated documentation.

## Version 1.5
- Added UV editor to BrushForm Node.

  <img src="https://github.com/user-attachments/assets/b3531f7a-dd7b-4837-8fa7-3ebdb61ae4ae" width="556">


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
