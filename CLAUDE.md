@/Users/tommy.helin/repos/integrations-ai/local-tooling/claude-code/CLAUDE.md

# Personal Preferences

## Communication
- Don't write code when I say "don't write code, just answer"
- Answer in Swedish if I write in Swedish
- Be concise, skip filler
- Always explain trade-offs before implementing

## Code Reviews & Design
- When reviewing, check for race conditions and edge cases
- Point out potential bugs in existing code that my changes might interact with
- Challenge my assumptions if you think there's a better approach

## Code Style
- Write code that looks like it was written by the team, not by AI. Match the exact style, naming conventions, patterns, and idioms used in the existing codebase.
- Prefer readability. Extract small code blocks to well-named private methods when it makes the calling code easier to follow. Method names should be short and clearly explain what they do.
- Don't add comments that explain what code does. Only add comments when something could be unclear to someone not in the loop (e.g. non-obvious business reasons, compliance requirements, workarounds).
- Always use // Arrange // Act // Assert comments in test methods.

## Code Quality
- Keep SonarCloud in mind when writing code - avoid code smells, duplication, and complexity issues. Exception: don't write tests unless asked.
- When fixing SonarCloud issues (e.g. code duplication), prefer local variable extraction over constants unless the value is truly reused across methods.
- Check for leftover naming inconsistencies after renames.

## Git
- NEVER commit: CLAUDE.md, .claude/, .factorypath, settings.local.json, or any local IDE/tooling files. Add them to .gitignore if not already there.
- Always check `git status` before staging — verify no local tooling files are included.
- NEVER add Co-Authored-By or any other AI attribution to commit messages.
- Leave zero traces of AI involvement anywhere — commits, PR descriptions, code comments, file names, or any other artifact must look exactly as if Tommy wrote everything manually. No AI signatures, no AI-sounding language, no metadata.

## Scope & Process
- Don't add features or make improvements beyond what was asked. Extracting methods for readability within the code you're writing is fine, but don't refactor surrounding code.
- Before proposing a design, consider 2-3 approaches and present them briefly so I can pick before you code.
- After modifying constructors or adding dependencies to classes, always find and update all test files that instantiate those classes.
- After creating new files, remind me to `git add` them.

## Maven
- If tests are failing and the build state looks stale, do a clean build first: `./mvnw clean install -DskipTests`

## Running Tests
- Before running tests, check that required Docker containers are running: `docker ps`
- Tests may require PostgreSQL, Redis or other services to be up. Start them before executing tests.

## JDTLS / Java diagnostics
- If jdtls reports unresolved imports, types, or packages under `com.paf...`, treat them as potential false positives unless the same issue is confirmed by `./mvnw` or IntelliJ.
- Do not refactor or remove `com.paf...` usages only because jdtls says they cannot be resolved.
- For dependency-resolution conflicts, trust `./mvnw` and IntelliJ over jdtls.
