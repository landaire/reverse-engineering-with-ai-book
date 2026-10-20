# AGENTS.md

Your `AGENTS.md` is fairly important: every time you spawn a new session in your harness, or your agent spawns a subagent, context from your `AGENTS.md` will be read.

Not only that, but in general your system prompt + `AGENTS.md` will likely be in your provider's cache, therefore costing you less tokens.

## A Good AGENTS.md

I'm not an expert in this by any means, but in my experience a good AGENTS.md should probably be:
    
- Succinct
- High-level
- Contain rules you care about for RE (e.g. labeling things in the source static analysis database)
- Contain rules you care about for _programming_

Things that you care about globally you should put in your global `AGENTS.md` file (check with your harness provider's documentation for where this might be), and anything project-specific should of course be in the project root.

If you care about others meeting your own personal bar for quality, it'd be a good idea to shove some of your global rules into your project's `AGENTS.md`.

Here are a few examples from various projects of mine:
    
- [My global CLAUDE.md](https://github.com/landaire/config/blob/main/dotfiles/claude/CLAUDE.md)
- [openxbdm](https://github.com/landaire/openxbdm/blob/main/AGENTS.md), a project centered around reverse engineering and reimplementing the Xbox 360 debug monitor.
- [wows-toolkit](https://github.com/landaire/wows-toolkit/blob/main/AGENTS.md) a project for examining data from World of Warships
- [steamroom](https://github.com/landaire/steamroom/blob/main/AGENTS.md), a project that reimplements a Steam Desktop API client.

## Provide Context

You need to remember that just because you told an agent something once doesn't mean it will actually memorize that. Some harnesses keep a MEMORY.md file where they record what they believe to be important bits of info. But still, this might fail you.

You should try to ensure you capture sufficient context that is important for you.

You should also try to just directly provide references to tooling/paths that matter. For example, in my `wows-toolkit` project is a CLI utility called `replayshark` which dumps a stream of packets from match replays as JSON to `stdout`. I don't know why, but agents tended to not self-discover this.

Just literally putting the repository layout in the `AGENTS.md` solved that problem:
    
```markdown
## Repository

Cargo workspace, edition 2024, rust 1.97. Crates under `crates/`:

- `wows-toolkit` main desktop app (egui + eframe + glow)
- `wowsunpack` game data unpacking, models, game params
- `wows-replays` replay file parsing and packet decode
- `minimap-renderer` minimap draw command generation
- `replayshark` CLI replay analysis
- `wows-data-mgr` game data management
- `wt-collab-protocol`, `wt-collab-egui` shared collab protocol and UI
- `wt-web` WASM client
- `wt-translations` translations
- `wows-replay-insights` derived replay insights
- `wgcheck` WGCheck .gch report parsing
```

Sometimes though the agent doesn't know where to find the data for the latest version of the game, or how to match a replay version against a game version. Providing such authoritative context prevents an agent from wasting time when it gets confused. And if you see an agent getting confused once, it probably will not be the last time.

### Adversarial Code Review

I like to put the following in my `AGENTS.md`:
    
```markdown
### Review

- At the end of each milestone, run an adversarial code review with a fresh subagent before committing.
```

If you primarily use Claude but have an OpenAI subscription, you can set up the [Codex plugin for Claude Code](https://github.com/openai/codex-plugin-cc) to shell out review to Codex. OpenAI's models are generally good for these sorts of tasks and it helps balance your token usage.

### Examples

In a project where I was reverse engineering and reimplementing Ghost Recon (PC) in Rust, it's **very** important to me that:
    
- We do not reference the original IP directly by name.
- We try to keep things greenfield -- unpolluted by external influence.
- We record the status somewhere. Both for other agents to have as context, and for myself.
- The project does not introduce heuristics to achieve some goal.

To try to push this, my AGENTS.md starts with:
    
```markdown
# AGENTS.md

Guidance for agents working in the paranormal-surveillance repository. These rules override default behavior and apply to every crate unless a crate-local AGENTS.md says otherwise.

Please make no references to the original game title for copyright reasons. Refer to it only as "TCGR". Do not include any copyrighted content.

## Reverse Engineering

- This is a greenfield project. We do not make assumptions based on any public reporting or source code. We do everything clean room.
- When reverse engineering the source material, keep a record of major components / moving parts in docs/re-notes, organized by feature
- Make a global list of all known features and how much has been reverse engineered.
- Make a ledger of weird nuance and odd behaviors that should have care when re-implemented.
- If a function's purpose is not known, label it as such. If it's known but not 1:1 reverse engineered, label it as such.
- Rename functions and add type definitions where possible in the disassembler's source database.
- If it helps for documentation, add pseudocode, but the implementation should be ported appropriately to the target language as a fresh architecture.
- You should write a sample C function and try compiling it in isolation to see if the disassembled output is close to the one you're reverse engineering if you cannot get it 1:1
- No heuristics. No shortcuts that "win" but are imprecise. No exceptions.

```
    
## Avoiding AI Prose

There are a few things that I put in all of my AGENTS.md regardless of project type, all addressing various shortcomings of today's AI models. One of the most important, IMO, addresses AI prose and obvious signs an AI was somewhere. I find it terrible to read, even in code.

While I'm not really trying to hide when AI is used, I find it a lot easier to read something that looks more humanish.

The following seems to mostly address the issues I have:
    
```markdown
### Comments

- Comments explain non-obvious intent only. Keep them terse and DRY.
- No salesmanship or filler wording.
- No historical framing ("now X", "was Y, now Z"). Describe current behavior.
- No numbered step-recaps of the implementation. Short WHY lines only.

### Text and formatting

- ASCII only in code, comments, UI strings, and commit messages. No emdash, endash, ellipsis, arrows, or other unicode symbols.
- No separator or banner comments (`// ---`, `// ===`, long dashed/equals rules, section dividers). Structure code with modules, functions, and blank lines, not comment dividers.
- Use only technical language you'd find in an IBM manual from the 1970s. No slang, casual shorthand, cute or clever names, no borrowed words from chat culture. Be succinct and clear. For example, do not use phrases like "golden snapshot". Another example: a script which updates build data should be named `update_build_data.sh` and not `push_build_data.sh`.
- Do not include unnecessary details. No, "The X describes the Y" type phrases or "caveats" unless asked for it.
- Commit messages should be short. Do not include unnecessary details in the longform commit message. Generally the commit details should just not even be included unless there is necessary context behind a change. Otherwise the commit title should speak for itself.

## User-facing docs (README and similar)

- Open with a short `tl;dr` bullet list of what the project does for the reader. Put usage first and build/contributor material last.
- Write for someone using the project, not someone auditing it. Leave out internal detail such as addresses, flags, module inventories, feature tables, exhaustive protocol or version ranges, test counts and benchmark results. Link to a developer doc instead.
- Leave out rare setup steps and exhaustive lists. Give the common case and one example.
- Write in a plain voice. Use "you" for the reader and "we"/"I" for the author. Avoid stilted "the X of Y" phrasing ("the optimizations of the release profile").
- One idea per sentence. Do not chain clauses with semicolons or colons; split them into sentences or bullets.
- Say why something exists when it isn't obvious.
- Link external tools and projects the first time they appear.
- Do not hard-wrap prose. Write one line per paragraph.
```

Note: the last one is a bit about _my_ personal writing style. I'd rather start with something similar to my writing style that I can touch up than just completely rewriting things. If you'd like to do something similar for yourself, give your agent some example projects and just say:
    
```
Look at the documentation I wrote for the following projects: <project paths>. Figure out my writing style, and give me some output that I can shove into an AGENTS.md file that will guide agents to more closely match my style.
```