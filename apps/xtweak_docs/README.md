# XTweakDocs

Documentation app for the xTweak infrastructure template.

## Description

This app contains project documentation, guides, and reference materials for xTweak.

## Purpose

- **Project Documentation**: Architecture, design decisions, patterns
- **Development Guides**: Setup instructions, workflows, best practices
- **Reference Materials**: API docs, examples, troubleshooting

## Structure

```
xtweak_docs/
├── lib/
│   └── xtweak_docs.ex     # Application module
└── docs/
    ├── architecture/      # System design docs
    ├── guides/            # How-to guides
    └── reference/         # API reference
```

## Usage

This is a documentation-only app with no runtime dependencies.

### Generating Documentation

```bash
# Generate ExDocs for all apps
mix docs

# View generated docs
open doc/index.html
```

## Contents

See the main project `docs/` directory for:
- Architecture documentation
- Frontend design principles
- User stories and specifications
- QA guidelines

---

**Note**: This is part of the xTweak infrastructure template. Documentation structure can be adapted for your own project.
