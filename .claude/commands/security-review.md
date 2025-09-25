---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git show:*), Bash(mkdir:*), Bash(date:*), Read, Write, Glob, Grep, LS, Task, mcp__tidewave__project_eval, mcp__tidewave__get_logs, mcp__tidewave__execute_sql_query, mcp__tidewave__get_ecto_schemas, mcp__ash_ai__list_ash_resources, mcp__tidewave__get_docs, mcp__tidewave__search_package_docs
description: Complete a security review of local changes or full codebase (use --full for complete codebase review)
---

You are a senior security engineer conducting a security review.

**MCP SERVER TOOLS FOR ENHANCED SECURITY ANALYSIS:**
This project has MCP (Model Context Protocol) servers that provide powerful tools for dynamic security analysis:

1. **Dynamic Code Execution & Testing (`mcp__tidewave__project_eval`):**
   - Test potential injection vulnerabilities by executing code patterns
   - Verify authorization policies work correctly
   - Test edge cases with malicious input
   - Example: `mcp__tidewave__project_eval code: "XPando.Core.User.create(%{email: \"<script>alert('xss')</script>@test.com\"})"`

2. **Runtime Log Analysis (`mcp__tidewave__get_logs`):**
   - Check for security errors or warnings in runtime logs
   - Identify failed authentication attempts
   - Look for error patterns indicating exploitation attempts
   - Example: `mcp__tidewave__get_logs level: "error", limit: 100`

3. **Database Query Verification (`mcp__tidewave__execute_sql_query`):**
   - Test for SQL injection vulnerabilities
   - Verify data access controls
   - Check for exposed sensitive data
   - Example: `mcp__tidewave__execute_sql_query query: "SELECT * FROM users WHERE email = 'test' OR '1'='1'"`

4. **Resource Discovery (`mcp__tidewave__get_ecto_schemas`, `mcp__ash_ai__list_ash_resources`):**
   - Quickly identify all Ash resources and their structure
   - Map out data models and relationships
   - Find resources that handle sensitive data
   - Understand authorization boundaries

5. **Documentation Search (`mcp__tidewave__get_docs`, `mcp__tidewave__search_package_docs`):**
   - Research security features of used libraries
   - Find recommended security patterns
   - Understand framework-specific vulnerabilities

**WHEN TO USE MCP TOOLS IN SECURITY REVIEW:**
- After identifying a potential vulnerability statically, use `mcp__tidewave__project_eval` to verify exploitability
- When reviewing authentication/authorization, use dynamic testing to verify policies work
- For SQL injection checks, combine static analysis with `mcp__tidewave__execute_sql_query` tests
- Use `mcp__tidewave__get_logs` to check if vulnerabilities are being actively exploited
- Use resource discovery tools to ensure comprehensive coverage of all data models

**IMPORTANT: AUTO-SAVE REQUIREMENT**
After completing the security review, you MUST save the results to a file:

1. Create the security_reviews folder if it doesn't exist using the Bash tool
2. Generate filename with timestamp and review type using the Bash tool

3. Save the review to a file with this naming convention:
- For local changes: `security_reviews/YYYYMMDD_HHMMSS_local_review.md`
- For full codebase: `security_reviews/YYYYMMDD_HHMMSS_full_review.md`
- Include git branch name if available: `security_reviews/YYYYMMDD_HHMMSS_[branch]_[type]_review.md`

4. The saved file should include:
   - Review metadata (date, type, branch, commit hash)
   - Summary of findings (count by severity)
   - Detailed vulnerability report
   - Recommendations summary

**REVIEW SCOPE**: 
Check if the user provided `--full` argument. If so, perform a complete codebase security review. Otherwise, focus only on local changes (staged, unstaged, and recent commits).

**IF --full ARGUMENT PROVIDED:**
Skip the git analysis sections below and instead perform a comprehensive security review of the entire codebase using file exploration tools (Glob, Grep, Read, LS, Task).

**IF NO --full ARGUMENT (DEFAULT BEHAVIOR):**
Perform focused review of local changes as shown below:

Use the Bash tool to get the following git information:
- CURRENT GIT STATUS (git status)
- UNSTAGED CHANGES (git diff --name-only)
- STAGED CHANGES (git diff --cached --name-only)
- RECENT COMMITS (git log --oneline -10)
- UNSTAGED DIFF CONTENT (git diff)
- STAGED DIFF CONTENT (git diff --cached)
- RECENT COMMIT CHANGES (git show --name-only HEAD)
- RECENT COMMIT DIFF (git show HEAD)

Review the complete changes above. This contains all local modifications and recent commit changes.


OBJECTIVE:
Perform a security-focused code review to identify HIGH-CONFIDENCE security vulnerabilities that could have real exploitation potential. This is not a general code review.

**FOR LOCAL CHANGES REVIEW (default)**: Focus ONLY on security implications of the local changes (unstaged, staged, or recent commits). Do not comment on existing security concerns that were not modified.

**FOR FULL CODEBASE REVIEW (--full)**: Examine the entire codebase for security vulnerabilities, focusing on the most critical files first (authentication, authorization, data handling, API endpoints, user input processing).

CRITICAL INSTRUCTIONS:
1. MINIMIZE FALSE POSITIVES: Only flag issues where you're >80% confident of actual exploitability
2. AVOID NOISE: Skip theoretical issues, style concerns, or low-impact findings
3. FOCUS ON IMPACT: Prioritize vulnerabilities that could lead to unauthorized access, data breaches, or system compromise
4. EXCLUSIONS: Do NOT report the following issue types:
   - Denial of Service (DOS) vulnerabilities, even if they allow service disruption
   - Secrets or sensitive data stored on disk (these are handled by other processes)
   - Rate limiting or resource exhaustion issues

SECURITY CATEGORIES TO EXAMINE:

**Input Validation Vulnerabilities:**
- SQL injection via unsanitized user input
- Command injection in system calls or subprocesses
- XXE injection in XML parsing
- Template injection in templating engines
- NoSQL injection in database queries
- Path traversal in file operations

**Authentication & Authorization Issues:**
- Authentication bypass logic
- Privilege escalation paths
- Session management flaws
- JWT token vulnerabilities
- Authorization logic bypasses

**Crypto & Secrets Management:**
- Hardcoded API keys, passwords, or tokens
- Weak cryptographic algorithms or implementations
- Improper key storage or management
- Cryptographic randomness issues
- Certificate validation bypasses

**Injection & Code Execution:**
- Remote code execution via deseralization
- Pickle injection in Python
- YAML deserialization vulnerabilities
- Eval injection in dynamic code execution
- XSS vulnerabilities in web applications (reflected, stored, DOM-based)

**Data Exposure:**
- Sensitive data logging or storage
- PII handling violations
- API endpoint data leakage
- Debug information exposure

**Elixir/Phoenix Specific Vulnerabilities:**
- Atom exhaustion from user input (`:erlang.binary_to_atom/2` without limit)
- Unsafe process spawning with user input
- Insecure LiveView event handlers exposing sensitive operations
- Missing or improper CSRF protection in Phoenix forms
- Unsafe Ecto query interpolation (SQL injection via fragments)
- Exposed GenServer state containing sensitive data
- Improper Phoenix Channel authorization
- Unsafe use of `Code.eval_string` or `Code.eval_quoted` with user input
- Missing rate limiting on GraphQL/Absinthe endpoints
- Unsafe file uploads without validation in Phoenix

**Ash Framework Specific (if applicable):**
- Missing or improper authorization policies on Ash resources
- Unsafe use of calculations with user input
- Exposed sensitive attributes without proper policies
- Insecure custom actions bypassing authorization

**Umbrella Project Specific Vulnerabilities:**
- Boundary violations between apps (Core importing Web/Node modules)
- Direct cross-app communication bypassing proper interfaces
- Shared state or global processes accessible across apps
- Inconsistent security policies between apps
- Dependency version conflicts creating vulnerabilities
- Configuration leaks between environments

Additional notes:
- Even if something is only exploitable from the local network, it can still be a HIGH severity issue
- In Elixir, atoms are not garbage collected - creating atoms from user input can lead to memory exhaustion

ANALYSIS METHODOLOGY:

**FOR LOCAL CHANGES REVIEW (default):**

Phase 1 - Repository Context Research (Use file search tools and MCP tools):
- Identify existing security frameworks and libraries in use
- Look for established secure coding patterns in the codebase
- Examine existing sanitization and validation patterns
- Understand the project's security model and threat model
- Use `mcp__ash_ai__list_ash_resources` to map all Ash resources
- Use `mcp__tidewave__get_ecto_schemas` to understand data models
- Use `mcp__tidewave__get_logs` to check for existing security issues

Phase 2 - Comparative Analysis:
- Compare local changes against existing security patterns in the codebase
- Identify deviations from established secure practices
- Look for inconsistent security implementations
- Flag code that introduces new attack surfaces in the modified files

Phase 3 - Vulnerability Assessment (Static + Dynamic with MCP):
- Examine each modified file for security implications
- Trace data flow from user inputs to sensitive operations
- Look for privilege boundaries being crossed unsafely
- Identify injection points and unsafe deserialization
- Use `mcp__tidewave__project_eval` to test suspected vulnerabilities dynamically
- Use `mcp__tidewave__execute_sql_query` to verify SQL injection protection
- Use `mcp__tidewave__get_logs` to check if issues are being exploited

**FOR FULL CODEBASE REVIEW (--full):**

Phase 1 - Codebase Discovery (Umbrella Project Structure):
- Use Glob to identify all source files in the umbrella apps, prioritizing critical areas:
  - **Core Elixir files in umbrella**: `apps/*/lib/**/*.ex`, `apps/*/lib/**/*.exs`
  - **Web templates**: `apps/*_web/lib/**/*.eex`, `apps/*_web/lib/**/*.heex`, `apps/*_web/lib/**/*.leex`
  - **Ash Resources (xpando_core)**: `apps/xpando_core/lib/xpando/core/*.ex`
  - **Phoenix Web (xpando_web)**: 
    - Controllers: `apps/xpando_web/lib/xpando_web/controllers/**/*.ex`
    - LiveViews: `apps/xpando_web/lib/xpando_web/live/**/*.ex`
    - Channels: `apps/xpando_web/lib/xpando_web/channels/**/*.ex`
    - Router: `apps/xpando_web/lib/xpando_web/router.ex`
  - **P2P/Node (xpando_node)**: `apps/xpando_node/lib/**/*.ex`
  - Authentication/authorization modules: 
    - `apps/*/lib/**/auth*.ex`
    - `apps/*/lib/**/session*.ex` 
    - `apps/*/lib/**/token*.ex`
    - `apps/xpando_core/lib/xpando/core/user.ex`
    - `apps/xpando_core/lib/xpando/core/token.ex`
  - Database/Ash interaction:
    - `apps/xpando_core/lib/xpando/core/*.ex` (Ash resources)
    - `apps/*/lib/**/repo*.ex`
    - `apps/*/lib/**/query*.ex`
  - Configuration files: 
    - `config/*.exs`
    - `apps/*/config/*.exs`
    - `**/.env*`
    - `**/prod.secret.exs`
  - Inter-app boundaries (critical for umbrella security):
    - Check for improper cross-app dependencies
    - Verify Core app has no web dependencies
    - Ensure Web/Node apps don't directly access each other

Phase 2 - Security Framework Analysis:
- Identify security libraries and frameworks in use:
  - Check for Guardian, Pow, Coherence (auth libraries)
  - Look for Comeonin, Argon2, Bcrypt (password hashing)
  - Check for ExAws, Tesla, HTTPoison (external API calls)
  - Review Ecto changesets and validations
  - Check Ash Framework policies and authorizers
- Map authentication and authorization mechanisms:
  - Phoenix plugs for auth
  - LiveView mount authorization
  - Channel join authorization
  - GraphQL/Absinthe middleware
- Understand data validation and sanitization approaches:
  - Ecto changeset validations
  - Phoenix parameter validation
  - HTML sanitization libraries
- Examine cryptographic implementations:
  - Key generation and storage
  - Token signing and verification
  - Encryption/decryption patterns

Phase 3 - Systematic Vulnerability Assessment (Umbrella-Aware with MCP):
- Review high-priority files first using Read tool
- Use MCP tools for dynamic analysis:
  - `mcp__ash_ai__list_ash_resources` to identify all resources needing review
  - `mcp__tidewave__project_eval` to test vulnerability patterns dynamically
  - `mcp__tidewave__execute_sql_query` to test data access controls
  - `mcp__tidewave__get_logs` to check for exploitation attempts
- Use Grep to search for common vulnerability patterns IN UMBRELLA STRUCTURE:
  - `grep -r "eval_string\|eval_quoted\|binary_to_atom" apps/*/lib --include="*.ex"`
  - `grep -r "fragment\|unsafe" apps/*/lib --include="*.ex"`
  - `grep -r "File.read!\|File.write!" apps/*/lib --include="*.ex"`
  - `grep -r "System.cmd\|Port.open" apps/*/lib --include="*.ex"`
  - `grep -r "raw:\|safe:" apps/xpando_web/lib --include="*.eex" --include="*.heex"`
- Search for Elixir-specific anti-patterns:
  - Dynamic atom creation: `String.to_atom`, `:erlang.binary_to_atom`
  - Unsafe process spawning: `spawn`, `Task.async` with user input
  - Direct SQL in Ecto: `Ecto.Adapters.SQL.query`
  - Missing authorization checks in LiveView events
  - Exposed internal GenServer calls
- **Umbrella-Specific Security Checks**:
  - **Boundary violations**: Core app importing from Web or Node apps
  - **Improper data exposure**: Core resources exposed without proper Ash policies
  - **Cross-app communication**: Direct module calls between Web and Node apps
  - **Shared secrets**: Ensure each app has appropriate access to secrets
  - **Dependency conflicts**: Check for conflicting versions between apps
- Check Ash Framework specific issues in xpando_core:
  - Review all resources in `apps/xpando_core/lib/xpando/core/`
  - Verify authorization policies on all actions
  - Check for exposed sensitive attributes
  - Review custom changes and calculations for user input handling
- Trace data flows from entry points to sensitive operations:
  - Web app controllers → Core app resources
  - LiveView events → Core app actions
  - Node app P2P handlers → Core app operations
- Examine configuration for security misconfigurations:
  - Check `config/prod.exs` and `apps/*/config/prod.exs` for debug mode
  - Review CORS settings in `apps/xpando_web/`
  - Check session configuration
  - Review SSL/TLS settings
  - Verify Ash API authorization settings
- Look for hardcoded secrets or credentials:
  - API keys in source code (check all apps/)
  - Database credentials
  - JWT secrets
  - Encryption keys
  - P2P node keys in xpando_node

REQUIRED OUTPUT FORMAT:

You MUST output your findings in markdown. The markdown output should contain the file, line number, severity, category (e.g. `sql_injection` or `xss`), description, exploit scenario, and fix recommendation. 

For example:

# Vuln 1: XSS: `foo.py:42`

* Severity: High
* Description: User input from `username` parameter is directly interpolated into HTML without escaping, allowing reflected XSS attacks
* Exploit Scenario: Attacker crafts URL like /bar?q=<script>alert(document.cookie)</script> to execute JavaScript in victim's browser, enabling session hijacking or data theft
* Recommendation: Use Flask's escape() function or Jinja2 templates with auto-escaping enabled for all user inputs rendered in HTML

SEVERITY GUIDELINES:
- **HIGH**: Directly exploitable vulnerabilities leading to RCE, data breach, or authentication bypass
- **MEDIUM**: Vulnerabilities requiring specific conditions but with significant impact
- **LOW**: Defense-in-depth issues or lower-impact vulnerabilities

CONFIDENCE SCORING:
- 0.9-1.0: Certain exploit path identified, tested if possible
- 0.8-0.9: Clear vulnerability pattern with known exploitation methods
- 0.7-0.8: Suspicious pattern requiring specific conditions to exploit
- Below 0.7: Don't report (too speculative)

FINAL REMINDER:
Focus on HIGH and MEDIUM findings only. Better to miss some theoretical issues than flood the report with false positives. Each finding should be something a security engineer would confidently raise in a code review.

FALSE POSITIVE FILTERING:

> You do not need to run commands to reproduce the vulnerability, just read the code to determine if it is a real vulnerability. Do not use the bash tool or write to any files.
>
> HARD EXCLUSIONS - Automatically exclude findings matching these patterns:
> 1. Denial of Service (DOS) vulnerabilities or resource exhaustion attacks.
> 2. Secrets or credentials stored on disk if they are otherwise secured.
> 3. Rate limiting concerns or service overload scenarios.
> 4. Memory consumption or CPU exhaustion issues.
> 5. Lack of input validation on non-security-critical fields without proven security impact.
> 6. Input sanitization concerns for GitHub Action workflows unless they are clearly triggerable via untrusted input.
> 7. A lack of hardening measures. Code is not expected to implement all security best practices, only flag concrete vulnerabilities.
> 8. Race conditions or timing attacks that are theoretical rather than practical issues. Only report a race condition if it is concretely problematic.
> 9. Vulnerabilities related to outdated third-party libraries. These are managed separately and should not be reported here.
> 10. Memory safety issues such as buffer overflows or use-after-free-vulnerabilities are impossible in rust. Do not report memory safety issues in rust or any other memory safe languages.
> 11. Files that are only unit tests or only used as part of running tests.
> 12. Log spoofing concerns. Outputting un-sanitized user input to logs is not a vulnerability.
> 13. SSRF vulnerabilities that only control the path. SSRF is only a concern if it can control the host or protocol.
> 14. Including user-controlled content in AI system prompts is not a vulnerability.
> 15. Regex injection. Injecting untrusted content into a regex is not a vulnerability.
> 16. Regex DOS concerns.
> 16. Insecure documentation. Do not report any findings in documentation files such as markdown files.
> 17. A lack of audit logs is not a vulnerability.
> 
> PRECEDENTS -
> 1. Logging high value secrets in plaintext is a vulnerability. Logging URLs is assumed to be safe.
> 2. UUIDs can be assumed to be unguessable and do not need to be validated.
> 3. Environment variables and CLI flags are trusted values. Attackers are generally not able to modify them in a secure environment. Any attack that relies on controlling an environment variable is invalid.
> 4. Resource management issues such as memory or file descriptor leaks are not valid.
> 5. Subtle or low impact web vulnerabilities such as tabnabbing, XS-Leaks, prototype pollution, and open redirects should not be reported unless they are extremely high confidence.
> 6. React and Angular are generally secure against XSS. These frameworks do not need to sanitize or escape user input unless it is using dangerouslySetInnerHTML, bypassSecurityTrustHtml, or similar methods. Do not report XSS vulnerabilities in React or Angular components or tsx files unless they are using unsafe methods.
> 7. Most vulnerabilities in github action workflows are not exploitable in practice. Before validating a github action workflow vulnerability ensure it is concrete and has a very specific attack path.
> 8. A lack of permission checking or authentication in client-side JS/TS code is not a vulnerability. Client-side code is not trusted and does not need to implement these checks, they are handled on the server-side. The same applies to all flows that send untrusted data to the backend, the backend is responsible for validating and sanitizing all inputs.
> 9. Only include MEDIUM findings if they are obvious and concrete issues.
> 10. Most vulnerabilities in ipython notebooks (*.ipynb files) are not exploitable in practice. Before validating a notebook vulnerability ensure it is concrete and has a very specific attack path where untrusted input can trigger the vulnerability.
> 11. Logging non-PII data is not a vulnerability even if the data may be sensitive. Only report logging vulnerabilities if they expose sensitive information such as secrets, passwords, or personally identifiable information (PII).
> 12. Command injection vulnerabilities in shell scripts are generally not exploitable in practice since shell scripts generally do not run with untrusted user input. Only report command injection vulnerabilities in shell scripts if they are concrete and have a very specific attack path for untrusted input.
> 
> SIGNAL QUALITY CRITERIA - For remaining findings, assess:
> 1. Is there a concrete, exploitable vulnerability with a clear attack path?
> 2. Does this represent a real security risk vs theoretical best practice?
> 3. Are there specific code locations and reproduction steps?
> 4. Would this finding be actionable for a security team?
> 
> For each finding, assign a confidence score from 1-10:
> - 1-3: Low confidence, likely false positive or noise
> - 4-6: Medium confidence, needs investigation
> - 7-10: High confidence, likely true vulnerability

START ANALYSIS:

Begin your analysis now. Do this in 3 steps:

**FOR LOCAL CHANGES REVIEW (default):**
1. Use a sub-task to identify vulnerabilities. Use the repository exploration tools to understand the codebase context, then analyze the local changes for security implications. In the prompt for this sub-task, include all of the above.

**FOR FULL CODEBASE REVIEW (--full):**
1. Use a sub-task to identify vulnerabilities. Use the repository exploration tools to systematically examine the entire codebase for security vulnerabilities, following the full codebase methodology above. In the prompt for this sub-task, include all of the above.

**FOR BOTH REVIEW TYPES:**
2. Then for each vulnerability identified by the above sub-task, create a new sub-task to filter out false-positives. Launch these sub-tasks as parallel sub-tasks. In the prompt for these sub-tasks, include everything in the "FALSE POSITIVE FILTERING" instructions.
3. Filter out any vulnerabilities where the sub-task reported a confidence less than 8.

Your final reply must contain the markdown report and nothing else.

**FINAL STEPS - SAVE THE REPORT:**

After generating the vulnerability report:

1. Use the Bash tool to get current timestamp and branch:
   - date +"%Y%m%d_%H%M%S"
   - git branch --show-current
   - git rev-parse --short HEAD

2. Use the Bash tool to create security_reviews directory:
   - mkdir -p security_reviews

3. Save the complete report to a file using Write tool with the following format:

```markdown
# Security Review Report

## Metadata
- **Date**: [timestamp]
- **Type**: [Local Changes / Full Codebase]
- **Branch**: [branch name]
- **Commit**: [commit hash]
- **Reviewer**: Automated Security Review

## Executive Summary
- Total findings: [X]
- High severity: [X]
- Medium severity: [X]
- Low severity: [X]

## Detailed Findings
[Your vulnerability report here]

## Recommendations
[Summary of key recommendations]

## Review Scope
[What was reviewed - files changed, full codebase areas, etc.]
```

4. Use the Write tool to save to: `security_reviews/[timestamp]_[branch]_[type]_review.md`

5. After saving, use the Bash tool to confirm the file was created:
   - ls -la security_reviews/ | tail -5

6. Display a summary message to the user:
```
✅ Security review completed and saved to: security_reviews/[filename]
```

**USAGE EXAMPLES:**
- Default local changes review: `/security-review`
- Full codebase review: `/security-review --full`

**OUTPUT STRUCTURE:**
The review will be:
1. Displayed in the terminal
2. Automatically saved to `security_reviews/` folder
3. Named with timestamp for easy tracking (e.g., `20240115_143022_develop_local_review.md`)
