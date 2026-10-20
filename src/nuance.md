# Nuance

AI is very good at taking large architecture, analyzing it, and reimplementing it fairly faithfully.

What I find it's really bad at is the small details -- especially those it cannot self-evaluate. For example, in my Ghost Recon reverse engineering project I was playing the game and noticed a couple of bugs:
    
1. When AI shot, it just completely dumped its magazine, or the sound just played forever.

2. When I died, my player model correctly dropped to the ground and I was just looking parallel to the ground... but I could still move my camera?

3. ...pressing the "Pause" button brought up the menu, but the game still played underneath the menu. It never paused.

Neither of these behaviors are correct!

Keep your eye out for the small details. I don't quite know how to quantify this exactly at this time. Trying to tell agents to keep a ledger of all behaviors kind of works, but it still misses stuff.