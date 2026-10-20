# Prompting

The art of prompting is still relevant. I don't quite know how people end up with such insane misalignment from LLMs, but at least the way I engage with them rarely results in pushback, obviously doing the wrong thing, or worse.

While it's probably unnecessary, I tend to start things off by reinforcing what I've already said in the `AGENTS.md` file and give exact instruction on where things are, where we're going, and `/goal` all in one go.

For my Ghost Recon decompilation project I kept things very basic:
    
```
/goal Reverse engineer the game binary as provided by the binassist
  MCP. Get all dependencies of loading into the main menu operational
  and working so that we can at least explore the main menu of the game.
  If you can get further and into game, that's an added bonus.
```

Sometimes I'll get a bit fancier with it though. When trying to decompile the Xbox 360 hypervisor, I gave this prompt:

```markdown
We are going to be reimplementing the Xbox 360 bootloaders and kernel through reverse engineering. You have access to many of these dumps in my downloads directory, including dumps from my own dev kit. I'd like you to:

1. Keep in mind that retail and devkit bootloaders are different. assume that a devkit piece of software is mostly an extension of the retail software and, e.g. in the kernel, you will need to appropriately #ifdef the functions for devkits, testkits, whatever.

2. This project will be in C. I would like you to write this as MSVC-flavored C, leveraging Microsoft's official compiler for compilation. The compiler should be on my NTFS disk (which I believe is mounted) under the Xbox 360 SDK dir. However, we do not want to include actual official SDK artifacts in our own code.

3. Use ~/dev/rust-xbox360 as a basis for the buck toolchain driving this. We will want to set up a platform using official SDK tooling.

4. We want to strive for as close to byte-for-byte exact comparisons for generated assembly as we can. In some situations this may not be possible. Do not take shortcuts. The official tooling will obviously have inline assembly in some places -- such as the hypercall handler or whatever -- but we shouldn't be cutting corners to reach parity.

5. Start with the hypervisor. It's the most important piece of software.

6. Use binary ninja to analyze existing dumps, and possibly new dumps

7. You can write supplemental tooling in Rust. In fact, that's probably a good idea. But the core hypervisor is Microsoft NT kernel-style C.

8. Put reverse engineering notes in docs/re-notes. Track status of all things reverse engineered and well understood, as well as completeness of function code which has been determined to be a 100% match of the reimplementation vs original.

/goal reimplement the hypervisor in C
```

## Goals

You should not try to one-shot something. If you do, don't be surprised when things are a little... off.

Even after giving an initial prompt, I'll start to read the logic traces of what the agent is doing and realize that _it_ is questioning certain things and just not asking me for clarity (probably because I used `/goal`, which tends not to prompt unless absolutely necessary)

You should:
    
- Be realistic where your manual review point is, and set your `/goal` accordingly. Tell the agent to stop after achieving a particular milestone.
- Periodically check in on the progress. Literally click in to view what subagents are doing, view thinking traces, etc. You may see an agent going down a path that requires immediate correction.
- Move goal posts mid-session if you see unexpected blockers. The agent may try to work around those blockers and the reality is that you just need to get X done while you figure out how to approach Y.