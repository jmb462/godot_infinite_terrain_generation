Godot Infinite Terrain Generation (Godot 3.x)
=================================

How does it works ?
-------------------

Terrain is composed by 72 x 72 hexagonal tiles. All tiles are instanciated at initialization.
Then each tile is updated from OpenSimplexNoise values to get its material and its altitude.
While the camera is moving, the tiles are repositionned to give the illusion that new tiles are coming for the horizon.
No new tile is instanciated to speedup terrain generation.

Control for the demo
--------------------

Mouse to control direction
Mouse Wheel to control FOV of camera

License
-------

See [License file](./LICENSE)
