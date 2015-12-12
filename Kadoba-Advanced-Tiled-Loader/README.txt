
Advanced Tiled Loader by Kadoba (Casey Baxter)

--------------------------------------------------------------------------------------

CHANGES:

0.9.0
- Advanced Tile Loader now has a wiki page and a github repository!
- Cleaned up the code quite a bit.
- Classes are now broken up into individual files rather than grouping similar ones into one file.
- Many identifiers have been changed to be less confusing and more consistent. Now camelCase is 
	used to separate words instead of underscores. Internal functions and data are now prefixed 
	with an underscore.
- Sprite batch mode can now be set through the map or through individual tile layers. Tile layer 
	settings take precedence.
- A bug with layer transparency has been fixed.
- Tile:draw() now accepts parameters for scaling, rotation, and offset.
- TileLayer:drawAfterTile() now works with multiple functions
- Forcing a redraw is now automatic when you switch sprite batch modes.
- Added support for flipped tiles that were introduced in Tiled version 8.0.0

0.8.2 (5/9/11):
- Tileset images are now cached between maps.
- Added an option to automatically pad images for PO2. To do this set Loader.fix_po2 to true.
- Changed Map.tl and Map.ol back to their old names. Map.tl and Map.ol remain as aliases.
- Tile layers can now render using sprite batches by setting TileLayer.use_batch to true.
- Added an init.lua file.
- Removed hardcoded require() paths. Added in global TILED_LOADER_PATH to point to the library path.
- Renamed the TileSet functions getWidth() and getHeight() to tilesWide() and tilesHigh().

0.8.1 (3/10/11):
- Renamed Map.tilelayers and Map.objectlayers to Map.tl and Map.ol respectively.
- Added function Tile.drawAfterTile()
- You may now define a draw() function for objects which overrides the default drawing routine

0.8.0 (2/28/11):
- Initial release

The LOVE forum thread:
http://love2d.org/forums/viewtopic.php?f=5&t=2567

GitHub Repository:
https://github.com/Kadoba/Advanced-Tiled-Loader

--------------------------------------------------------------------------------------


All images and code is subject to the following license unless otherwise stated:


Copyright (c) 2011 Casey Baxter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.