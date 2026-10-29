# Nuanced Equivalence

AI is very good at taking large architecture, analyzing it, and reimplementing it fairly faithfully.

What I find it's really bad at is the small details -- especially those it cannot self-evaluate. For example, in my Ghost Recon reverse engineering project I was playing the game and noticed a couple of bugs:

1. When AI shot, it just completely dumped its magazine, or the sound just played forever.

2. When I died, my player model correctly dropped to the ground and I was just looking parallel to the ground... but I could still move my camera?

3. ...pressing the "Pause" button brought up the menu, but the game still played underneath the menu. It never paused.

Neither of these behaviors are correct!

Keep your eye out for the small details. I don't quite know how to quantify this exactly at this time. Trying to tell agents to keep a ledger of all behaviors kind of works, but it still misses stuff.

## Byte Matching

A strategy some projects use for ensuring that AI-assisted decompilation for example is accurate is to attempt performing a round-trip of the data.

That is: Compiled binary -> decompiled source -> recompiled binary -> compare at some "unit" level for equivalence.

For a file format, parsing it into the high-level representationa and serializing it back to disk.

For scenarios where you are attempting to decompile software into the same language / architecture, this would generally mean function-level equivalence since it's the smallest meaningful unit of output result that you can reasonably compare.

There comes a point of diminishing returns though: reaching 100% equivalence is extremely difficult, and you might hit basic mismatches just caused by register allocation. You should bucketize the equivalence into different categories that help understand if things are functionally equivalent.

There are some obvious issues though, as outlined below.

### Compiler Equivlance

Different compilers will rarely generate the same exact code for a sufficiently complex codebase. The same applies to different _versions_ of the same compiler.

It's important to first try to identify which compiler was used for the project. If on Windows, it's likely some version of MSVC or `clang`. You will almost never see `gcc` used on Windows.

From there you can identify the compiler version maybe through debug symbols, or as a simple starting point: use a compiler no newer than the software release date, but probably no older than a year or two before.

Start with something close to the release date and you can tune this in over time.

### Compiler Flag Equivalence

Compiler flags affect _everything_. Most important and nuanced though is the optimization level, which can impact everything from optimizing for _speed_ vs _size_, register allocation, tagged at a function level might ensure that function doesn't get erased, and function inlining... and how aggressively the compiler exploits undefined behavior!

The LLMs are fairly good about deducing optimization level, but this is something to keep in mind.

## Functional Equivalence

Emulators can be an extremely useful tool for testing software. You should consider the complexity of your target and if it makes sense to use an emulator such as [Unicorn](https://www.unicorn-engine.org/), [QEMU](https://www.qemu.org/), [Bochs](https://bochs.sourceforge.io/), or a custom solution for capturing state at checkpoints in your original software, replaying it in your reimplementation, and checking for equivalence.

The basic premise is:

1. Run some set of reproducible inputs through your original software
2. Capture the registers and stack data at various checkpoints (function entry/exit would be a good start)
3. Run the same input through your recompiled software
4. At the same checkpoints, compare against the original captured checkpoints

You will of course have issues with various optimization levels/register allocations resulting in different state, but you can accomodate for this with a register remapping at a function level.
