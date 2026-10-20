# Intro

Reverse engineering with agents is not something you need to overcomplicate. If you're already experienced in reverse engineering, you're probably thinking you need tools XYZ, you need to expose an MCP, and decompilers-this and that.

To some extent: sure. This depends on your goals.

But you really do not need to overcomplicate things, and if you are not an experienced reverse engineer you don't need to start buying fancy static analysis tools. Keep things simple.

AI agents are now fairly good at figuring out what they need to accomplish a task and it's up to you to figure out how to provide that.

## IMPORTANT SECURITY NOTE

I'll say right away: for effective, self-guided reverse engineering you will want to run your harness in "YOLO" mode (i.e. the agent doesn't ask for permissions).

**Your agent may get adventurous and start grabbing random tools/libraries off the internet which is obviously dangerous**.

You should absolutely run the harness in a sandboxed environment if you remotely care about the possibility of a machine compromise, which I will explain later in the "Tooling Provider" section on this page.

And by "sandbox" I mean: a real sandbox. A Docker container _can_ be a sandbox of sorts... if you properly isolate its network capabilities and filesystem.

A VM is a stronger sandbox... if you again properly isolate its network and filesystem.

Just be smart.

Codex surfaces "YOLO" mode via:
    
```shell
codex --yolo
```

And Claude Code via:
    
```shell
claude --permission-mode bypassPermissions
```

## Getting in the Mood

First thing's first, get in the mood. I'd recommend [this hour-long mix](https://www.youtube.com/watch?v=A8Mz713rkE4) by RÜFÜS DU SOL. Maybe throw on the video and enjoy the visuals of one of the best concert venues in the world while your agents work.

## Recommended Models

This is highly opinionated, but I've basically only used Anthropic's models. I'm unsure at this point if Anthropic's memory of me has learned my preferences well-enough, or if the gap is really that high between OpenAI and Anthropic, but it does feel like models like GPT-5.6 Sol is a bit worse than Opus 4.8 was for some tasks. And 5.6 Sol vs Opus 5.5 are completely different beasts.

## Recommended Tooling

### Plugins

I'll be straightforward: I really don't think harness plugins are necessary at all. You can give something like [Reverse Engineer Anything (REA)](https://github.com/morluto/rea) a shot, but I have never personally felt like the agents were lacking something outside of the guidance I provided.

### Harnesses

Use the harness you're most comfortable with. For me for a long time, it was Zed's integrated `ACP` editor. Once Anthropic kind of killed that, I moved to the Claude Code CLI and used that up until recently.

I switched to [oh-my-pi (omp)](https://omp.sh/) recently and have noticed a decent improvement over subagent coordination and some other smaller things. **It is extremely important to note that using 3rd party harnesses with Claude Code may be against their ToS and could result in your account being suspended/banned**. From discussion in the `omp` Discord, nobody seems to have gotten banned from using `omp` and according to the lead developer Can:
 
>> [Brit]: can you get banned, yeah, will you be banned? unlikely, I used it on my 200 usd plan for months
>
> [Can]: We're working together with Anthropic atm, and they didn't mention anything against it so I'd say highly unlikely

Use at your own risk.

### Static Analysis

If you do not want to install static analysis software, please note that `otool` and `objdump` will work fine. These are present on macOS/Unix machines and spit out the disassembly of a target executable. If you're trying to RE something for your host platform, this will work fine for just getting things done.
    
If you are using a commercial static analysis tool, figure out how its MCP works. For Binary Ninja, it's now integrated into BN 6.0 and I believe IDA Pro has something similar. You will just need to start it from the Plugins menu and enlighten your coding harness using a command like:
        
```shell
 claude mcp add --transport http binja http://127.0.0.1:24642/mcp
 ```
 
 If you are using something free like [Ghidra](https://github.com/nationalsecurityagency/ghidra), it has a [headless mode](https://github.com/NationalSecurityAgency/ghidra/blob/c91ec18e6780a8a531a806a0660a9c28978a99a0/GhidraDocs/GettingStarted.md#headless-batch-mode) which you'd likely find useful combined with Laurie's [GhidraMCP](https://github.com/LaurieWired/GhidraMCP).
 
 I'd highly recommend using a static analysis tool so that you can reference the database later, poke around, and learn.
 
 ### Tool Providers
 
 Through reverse engineering in YOLO permissions mode, I've seen AI do some really weird things that I didn't like on my host machine. It'd try grabbing random tools, possibly installing stuff via my package manager(s) that go into my global `$PATH`.
 
 I would recommend checking out and installing [Nix](https://nixos.org/download/) (no not the OS, but its package manager).
 
 Nix will allow you to define a reproducible environment, and coupled with [devenv](https://devenv.sh/) makes setting up a development pretty straightforward with any tool provided by nixpkgs very easy with just `nix-shell -p <package_name>` dropping you into a temporary shell with that tool.
 
