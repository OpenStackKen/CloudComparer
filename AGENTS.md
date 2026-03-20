# AGENTS.md

Repository instructions for Codex and other coding agents working in `/Users/ken/Dev/CloudComparer`.

## Working Rules

- Do not prompt for browser MCP actions to be approved. Approval is assumed.
- Do not prompt for screenshots to be approved. Approval is assumed.
- Do not number headings. Ordered lists are fine when the content is inherently ordered.
- Keep changes reversible so work can be backed out cleanly if needed.
- Be pedantic with wording. If something is said to "look like" something else, that means it should look exactly like it.
- If unsure, say so plainly. Do not claim correctness unless it is provable.
- Comment source artifacts verbosely when comments are added, explaining intent, structure, and method rather than restating syntax.

## Repo Conventions

- All Markdown content files should use the `.md` extension, not `.markdown`.
- The site can be built with `make build`.
- The shared static preview is served through Docker Compose and Caddy on port `8090`.
- The Compose entrypoint for the preview server is `compose.yml`.
- The Caddy container name in Compose should remain `cloudcompare`.

## Current Site Direction

- The comparison includes `OpenStack` as a provider.
- Service providers can be shown or hidden from the UI.
- Services are grouped by category.
- Categories can be expanded or collapsed.
- Column reordering is intentionally out of scope for now.
- Graphics in provider headers and service cells should render at normalized sizes.
