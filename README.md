## Portable chests

This mod adds portable variants to the vanilla chests.

Portable chests have the following properties:

 - can be carried like normal items
 - can be placed and mined
 - inventory accessible by right-clicking on them (when in item form)
 - can be renamed (but the label will be lost if they're placed)
 - can be dropped on the ground (the label stays)
 - can contain other portable chests (unlimited storage, but they're not cheap)
 - can't be mined or placed by robots


## Changelog

**0.1.2**:
 - Make sure the steel chest recipe is enabled when loading an existing save
   without the mod and with steel processing already researched.

 - Add new builder entities for the `place_result` of each container item.
   The container entity can't be used because that would allow robots
   to construct using any container item (regardless of their contents).

   Also, this avoids a bug where the game will try to build ghosts of
   vanilla chests using the portable item rather than vanilla one.

 - Remove the "right click to access inventory" mention since the game
   already has one below the description.

**0.1.1**:
 - Fixed "LuaItemStack API call when LuaItemStack was invalid" error

**0.1.0**:
 - Initial release
