---
title: Dual Example Bridge
updated: 2025-10-02
tags:
  - core
---

# Dual Example Bridge Pattern

## Purpose
Show how placeholder-based templates map to real project code by pairing a generic snippet with one or more concrete adaptations.

## Structure

```markdown
### [Feature Title] · Generic Pattern (adapt this)
```elixir
defmodule {YourApp}.Domain.{Resource} do
  ...
end
```

### Example · "XTweak" Project
```elixir
defmodule XTweak.Core.User do
  ...
end
```

### Optional Example · "Blog" Project
```elixir
defmodule Blog.Domain.User do
  ...
end
```
```

## Rules
- Always label which block is generic vs concrete.
- Keep code structure identical between blocks—only swap identifiers.
- Limit to two concrete examples unless architectural differences demand more.
- If an agent handles multiple ecosystems, include examples per ecosystem.

## Usage Tips
- Pair with `placeholder-basics` so readers already understand the placeholder system.
- Use language-specific fences (` ```elixir`, ` ```bash`, etc.) to preserve formatting.
- Reference the pattern in agent text as `Pattern: dual-example-bridge` for traceability.

## Change Log
- – Migrated from legacy dual-example pattern with consistent naming and metadata.
