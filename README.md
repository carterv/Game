Game
====================
This is a 2d grid-based game, loosely based off of Terraria and a class project.

Created by Carter Van Deuren.

You may modify and redistribute this code under the following conditions:
- You may not sell this code, or any modification of it
- You must attribute the author (Carter Van Deuren)
- If you do choose to redistribute the work or any modification of it, it must carry these same conditions

Notes
====================
To add new blocks:
- Create a class that extends either Block, Fluid, or Emitter. See BlockStone for a simple example.
- Add an entry to the constructor of SpriteManager, if the block uses a sprite. Otherwise, override Block/Fluid/Emitter->draw().
- Add an entry to Game->newBlock() so the game knows how to create the block.
- If desired, add the block to the inventory in Game->startup().
