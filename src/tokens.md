# Token Spend

Reverse engineering costs a _lot_ of tokens. I personally have an Anthropic Max 20x account which, for programming alone, I have a really hard time reaching the limits of. In any capacity (weekly or session).

Reverse engineering?

I've gone through my 20x weekly limit in about 24 hours before.

You have to keep in mind that with programming you have far fewer _input_ tokens and probably more _output_ tokens.

With reverse engineering it's a bit flipped: far, far more input tokens and more output tokens than normal programming. And likely more iteration resulting in more token spend too once the agent starts to test and realize things are wrong.

If you want to get real fancy, there are various tricks to keep in mind:
    
1. If you block an agent, your prompt will likely be evicted from your provider's cache after a TTL (for Anthropic I think it's 5m, for OpenAI 30m?). That cache hit _will_ hurt for longer sessions since the entire conversation needs to be re-read.


2. Compaction is kind of like giving your agent a labotomy, but if you're continuing very long tasks and have a good AGENTS.md the labotomy might not be so bad. [Maurice Heumann wrote a blog post](https://momo5502.com/posts/2026-10-09-game-decompilation/) about decompiling Call of Duty: Modern Warfare 2 and had some interesting things to say about reducing token usage.

3. Some 3rd party harnesses may be better at reducing token burn than the 1p harnesses. But as mentioned in the [Introduction](introduction.md), this may be against ToS with subscription-based plans.

At any rate, for reverse engineering I really don't think it's **ever** worthwhile to pay that extra cash for the API-based billing just to continue the session and get something done. The cost may highly vary depending on what's remaining and you may be better off just waiting for your usage to reset.

Otherwise, I am unfortunately not an expert in this area. 