# PolyAdmin
Polytoria chat moderation, fun, utility & misc commands. Made by Index.

> An example game with admin commands built in (free admin for all players visiting) can be visited here to try out the model before adding it into your own games: https://polytoria.com/games/2537

> **You do not have to add your own USER ID to the "permissions" table if you are the owner of the game.**

# Prefix
To use commands, your message must start with a ":" colon (this can be changed later in settings per the game developer's wishes by changing the "prefix" variable at the top of the script).

# Known Bugs
- **Automatically giving Administrator Permissions to "Player" in Polytoria Creator** - Will 100% be fixed in the next release of the model, for now, just publish your games & go to the real game & play it or just use no admin in the "Test Game" in Polytoria's Creator.
- **Fixing Usernames with Spaces** - Slight fix implemented by adding shortended usernames.

# Commands Available (10)
- **:help** - Displays a list of commands in chat to the user who executed the command.
- **:version** - Displays the current model version that is being used in the game.
- **:userid (OR) :uid** [PLAYER (required)] - Displays the USER ID of the player, the player must be in the game at the time of the command.
- **:warn** [PLAYER (required)] [REASON (required)] - Warns the player in chat & notifies them of the reason.
- **:kick** [PLAYER (required)] [REASON (required)] - Kicks the player from the game & notifies them of the reason.
- **:ban** [PLAYER (required)] [REASON (required)] - Bans the player from the current server. (NOT PERMANENT AT THE MOMENT)
- **:announce** [TEXT (required)] - Broadcasts a message in chat to all players of the game.
- **:tp** [PLAYER 1 (required)] [PLAYER 2 (required)] - Teleports player 1 to player 2.
- **:bring** [PLAYER (required)] - Brings the player to the player who executed the command.
- **:to** [PLAYER (required)] - Teleports the player who executed the command to the player.
- **:explode** [PLAYER (required)] - Creates an explosion in the game environment on the player.
- **:respawn** [PLAYER (required)] - Respawns the player (may be a bit buggy with Polytoria's player:Respawn function).
- **:damage** [PLAYER (required)] [DAMAGE (required)] - Damages the player by the specified amount.
- **:kill** [PLAYER (required)] - Kills the player.
- **:jail** [PLAYER (required)] - Spawns a jail model around the player that they cannot get out until someone does :unjail (only 1 jail per player to prevent lag).
- **:unjail** [PLAYER (required)] - Removes the player's jail if they have one.
- **:sword** [PLAYER (required)] - Gives the player a sword.
- **:health** [PLAYER (required)] [HEALTH (required)] - Sets the player's health to the health specified. 
- **:heal** [PLAYER (required)] - Sets the player's health to their maximum health.
- **:reset (OR) :re** [PLAYER (required)] - Resets the player's health, walk speed, jump power, respawn time, etc (the player also gets respawned but in the exact same position as where they were before they were respawned).
- **:walkspeed (OR) :speed** [PLAYER (required)] [WALK SPEED (required)] - Sets the player's walk speed to the walk speed specified (will throw an error if the number is massive).
- **:jumppower (OR) :jp** [PLAYER (required)] [JUMP POWER (required)] - Sets the player's jump power to the jump power specified (will throw an error if the number is massive).
- **:maxhealth** [PLAYER (required)] [MAX HEALTH (required)] - Sets the player's max health to the max health specified.
- **:music play** [SOUND ID (required)] - Plays the specified sound ID to everyone in the game (if the sound has already been played before, it'll replay that sound instead of creating an entire new sounds & downloading an entirely new sound to reduce lag).
- **:music stop** [SOUND ID (required)] - Stops all sounds currently playing (only sounds started by the model).

## More commands will be added in the future, some commands have not been added due to Polytoria scripting limitations.
