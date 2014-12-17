This is a 2d grid-based game, loosely based off of Terraria and a class project. It is authored by Carter Van Deuren.<br/>
<br/>
Note:<br/>
To add new blocks:<br/>
- Create a class that extends either Block, Fluid, or Emitter. See BlockStone for a simple example.<br/>
- Add an entry to the constructor of SpriteManager, if the block uses a sprite. Otherwise, override Block/Fluid/Emitter->draw().<br/>
- Add an entry to Game->newBlock() so the game knows how to create the block.<br/>
- If desired, add the block to the inventory in Game->startup().<br/>
