# [PROJECT NAME] Development Guidelines

Auto-generated from all feature plans. Last updated: [DATE]

## Active Technologies
[EXTRACTED FROM ALL PLAN.MD FILES]

## Platform Configuration
**Type**: [service|library|cli|frontend|pwa|android|ios|flutter|react-native]
**Platform Category**: [backend|frontend|mobile]
**Language**: [language from ops/config.yml]
**Framework**: [framework from ops/config.yml]

## Project Structure
```
[ACTUAL STRUCTURE FROM PLANS]
```

## Commands
Use `scripts/run-task.sh <task>` for all operations:

### Core Commands
[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES]

### Mobile Commands *(if applicable)*
- Build Android: `scripts/run-task.sh build_android`
- Build iOS: `scripts/run-task.sh build_ios`
- Deploy to TestFlight: `scripts/run-task.sh deploy_testflight`
- Deploy to Play Store: `scripts/run-task.sh deploy_play_store`
- Deploy to Firebase: `scripts/run-task.sh deploy_firebase`

### Frontend Commands *(if applicable)*
- Lighthouse audit: `scripts/run-task.sh lighthouse`
- Bundle analysis: `scripts/run-task.sh bundle_analyze`
- Visual regression: `scripts/run-task.sh visual_test`
- E2E tests: `scripts/run-task.sh e2e`

## Code Style
[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE]

### Mobile Code Style *(if applicable)*
- **Kotlin**: Follow [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html), use ktlint
- **Swift**: Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/), use SwiftLint
- **Dart**: Follow [Effective Dart](https://dart.dev/effective-dart), use dart format
- **React Native**: Functional components, TypeScript strict mode, ESLint + Prettier

### Frontend Code Style *(if applicable)*
- **React/Next.js**: Functional components with hooks, TypeScript strict mode
- **Vue/Nuxt**: Composition API, TypeScript, script setup
- **Angular**: Standalone components, strict mode
- **CSS**: Utility-first (Tailwind) or CSS Modules, avoid inline styles

## Testing Guidelines

### Mobile Testing
- Unit tests: ViewModel/BLoC logic, utilities
- Widget/UI tests: Component rendering, interactions
- Integration tests: API clients, navigation flows
- E2E tests: Critical user journeys (Espresso/XCTest/Detox)

### Frontend Testing
- Unit tests: Utilities, hooks, state management
- Component tests: Isolated component behavior
- E2E tests: User journeys (Playwright/Cypress)
- Visual regression: Screenshot comparison
- Accessibility: axe-core automated checks

## Security Checklist

### Mobile Security
- [ ] No hardcoded secrets in source code
- [ ] Secure storage for sensitive data (Keychain/Keystore)
- [ ] Certificate pinning for API calls
- [ ] ProGuard/R8 enabled for release builds
- [ ] Debug logging disabled in release

### Frontend Security
- [ ] CSP headers configured
- [ ] No sensitive data in localStorage
- [ ] HTTPS enforced
- [ ] XSS protection enabled
- [ ] Dependencies audited

## Recent Changes
[LAST 3 FEATURES AND WHAT THEY ADDED]

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
