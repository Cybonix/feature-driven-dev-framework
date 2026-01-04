# Feature-Driven Development Constitution

## Core Principles

### I. Library-First
Every feature starts as a standalone library. Libraries must be self-contained, independently testable, and documented. Clear purpose required - no organizational-only libraries.

### II. CLI Interface
Every library exposes functionality via CLI. Text in/out protocol: stdin/args → stdout, errors → stderr. Support JSON + human-readable formats.

### III. Test-First (NON-NEGOTIABLE)
TDD mandatory: Tests written → User approved → Tests fail → Then implement. Red-Green-Refactor cycle strictly enforced. Order: Contract → Integration → E2E → Unit.

### IV. Integration Testing
Focus areas requiring integration tests: New library contract tests, Contract changes, Inter-service communication, Shared schemas. Use real dependencies (actual DBs, not mocks).

### V. Observability
Text I/O ensures debuggability. Structured logging required. Frontend logs stream to backend for unified observability.

### VI. Versioning & Breaking Changes
MAJOR.MINOR.BUILD format. BUILD increments on every change. Breaking changes require parallel tests and migration plan.

### VII. Simplicity (YAGNI)
Start simple. Maximum 3 projects per feature. Use frameworks directly (no wrappers). Single data model (no DTOs unless serialization differs). Avoid patterns without proven need.

## Platform-Specific Principles

### VIII. Mobile-First Quality
Mobile applications must meet platform-native standards:

**Performance Budgets**:
- Cold start: < 2 seconds
- UI transitions: 60fps minimum
- APK/IPA size: Reasonable for target market (consider low-bandwidth regions)

**Platform Conventions**:
- Follow platform design guidelines (Material Design 3 for Android, Human Interface Guidelines for iOS)
- Use native navigation patterns
- Support platform accessibility features (TalkBack, VoiceOver)
- Handle platform lifecycle correctly (background/foreground, low memory)

**Security Requirements**:
- No hardcoded secrets in source code
- Secure storage for sensitive data (Keychain/Keystore)
- Certificate pinning for API calls
- Obfuscation enabled for release builds (ProGuard/R8)
- Debug logging disabled in release

**Testing Requirements**:
- Unit tests for ViewModels/BLoCs/business logic
- Widget/UI tests for component behavior
- Integration tests for API clients
- E2E tests for critical user journeys

### IX. Frontend Performance
Frontend applications must meet Core Web Vitals and user experience standards:

**Core Web Vitals Targets**:
- LCP (Largest Contentful Paint): < 2.5 seconds
- FID (First Input Delay): < 100ms
- CLS (Cumulative Layout Shift): < 0.1

**Bundle Budgets**:
- Initial JS bundle: < 200KB gzipped (configurable per project)
- Track bundle size changes in CI
- Code splitting for route-based lazy loading

**Quality Gates**:
- Lighthouse performance score: 90+ (configurable)
- Accessibility audit: axe-core with zero violations
- Browser compatibility: Test across Chromium, Firefox, WebKit
- Visual regression: Screenshot comparison on PRs

**PWA Requirements** (when applicable):
- Service worker for offline capability
- Valid web manifest
- HTTPS enforced
- Install prompt handling

## Development Workflow

### Specification Phase
1. Normalize prompt → Create feature branch and intake artifacts
2. Write specification (what, not how) → Get approval
3. Generate implementation plan → Research unknowns
4. Design contracts and data model → Create failing tests

### Implementation Phase
1. Generate task breakdown from plan
2. Execute tasks following TDD (tests fail first)
3. Commit after each completed task
4. Run full test suite before PR

### Quality Gates
- All tests must pass
- Security scans must pass (Trivy, Gitleaks, MobSF)
- Platform-specific linting must pass
- Performance budgets must be met
- Accessibility requirements must be satisfied

## Governance

Constitution supersedes all other practices. Amendments require:
1. Documentation of the change
2. Approval from project maintainers
3. Migration plan for existing features

All PRs/reviews must verify compliance. Complexity deviations must be justified and documented in plan.md.

**Version**: 2.2.0 | **Ratified**: 2024-01-01 | **Last Amended**: 2026-01-04
