# Security Policy & Baseline

## 1. Objective
To ensure all contributions to this project meet a minimum security standard before being merged. This policy is enforced by the CI/CD pipelines defined in `ops/pipelines/`.

## 2. Required Tooling

### 2.1 All Projects (Universal)
| Category | Tool | Command | Failure Threshold |
| :--- | :--- | :--- | :--- |
| **Secrets Detection** | `gitleaks` | `gitleaks detect --no-git` | Any detection |
| **SAST (Static Analysis)** | `trivy` | `trivy fs . --security-checks config,vuln` | High, Critical |
| **SCA (Dependencies)** | `trivy` | `trivy fs .` | High, Critical |

### 2.2 Mobile Applications (Android / iOS / Flutter / React Native)
| Category | Tool | Command | Failure Threshold |
| :--- | :--- | :--- | :--- |
| **Mobile SAST** | `MobSF` | `mobsf --scan <apk/ipa>` | High, Critical |
| **Android Lint** | `gradle` | `./gradlew lint` | Error |
| **iOS Static** | `swiftlint` | `swiftlint lint --strict` | Error |
| **Dependency Check** | Platform-specific | `npm audit` / `flutter pub outdated` | High |

#### Mobile-Specific Security Checklist
- [ ] No hardcoded API keys, tokens, or secrets in source code
- [ ] Certificate pinning implemented for API communications
- [ ] Sensitive data stored in secure storage (Keychain/Keystore)
- [ ] ProGuard/R8 enabled for Android release builds
- [ ] App Transport Security (ATS) properly configured for iOS
- [ ] Root/jailbreak detection implemented (if required)
- [ ] Debug logging disabled in release builds
- [ ] Biometric authentication uses proper security APIs

### 2.3 Frontend Applications (Web / PWA)
| Category | Tool | Command | Failure Threshold |
| :--- | :--- | :--- | :--- |
| **NPM Audit** | `npm` | `npm audit --production` | High, Critical |
| **Bundle Analysis** | `webpack-bundle-analyzer` | varies | N/A (informational) |
| **Lighthouse Security** | `lighthouse` | `lighthouse --only-categories=best-practices` | Score < 80 |
| **Dependency Scanning** | `snyk` / `npm audit` | `snyk test` | High, Critical |

#### Frontend-Specific Security Checklist
- [ ] Content Security Policy (CSP) headers configured
- [ ] HTTPS enforced (no mixed content)
- [ ] Sensitive data not stored in localStorage (use httpOnly cookies)
- [ ] XSS protection enabled via framework sanitization
- [ ] CSRF tokens implemented for state-changing operations
- [ ] Subresource Integrity (SRI) for third-party scripts
- [ ] No sensitive data in URL parameters or browser history
- [ ] Proper CORS configuration for API calls

## 3. Workflow

### 3.1 Local Development
1. **All Projects**: Run `gitleaks` locally before committing
2. **Mobile (Android)**: Run `./gradlew lint` before pushing
3. **Mobile (iOS)**: Run `swiftlint lint` before pushing
4. **Mobile (Flutter)**: Run `flutter analyze` before pushing
5. **Frontend**: Run `npm audit` before pushing

### 3.2 Pull Request
- Secrets scan must pass
- SAST/SCA must pass (or have findings allowlisted)
- Mobile projects: MobSF scan on APK/IPA (can be manual for iOS)
- Frontend projects: Lighthouse best-practices score >= 80

### 3.3 Main Branch
- Daily scans run to detect newly disclosed vulnerabilities (CVEs)
- Weekly MobSF scans for mobile applications
- Automated dependency update PRs via Dependabot/Renovate

## 4. Exceptions
If a false positive or acceptable risk is identified:
1. Create a `.trivyignore` file in the root for SAST/SCA findings
2. Update `.gitleaksignore` for secret patterns (use with extreme caution)
3. Document the reasoning in `docs/SECURITY_ALLOWLIST.md`

### Mobile-Specific Exceptions
- `.mobsfignore` - MobSF findings to ignore (document reasoning)
- `lint-baseline.xml` - Android Lint baseline for known issues

### Frontend-Specific Exceptions
- `.nsprc` - npm audit exceptions
- `lighthouserc.json` - Lighthouse threshold overrides

## 5. Security Tools by Platform

### Android
```bash
# Lint
./gradlew lint

# Dependency vulnerabilities
./gradlew dependencyCheckAnalyze

# MobSF (Docker)
docker run -it --rm -v $(pwd):/src opensecurity/mobile-security-framework-mobsf
```

### iOS
```bash
# SwiftLint
swiftlint lint --strict

# Dependency audit (CocoaPods)
pod audit

# Static analysis
xcodebuild analyze -scheme App
```

### Flutter
```bash
# Analyze
flutter analyze

# Dependency check
flutter pub outdated

# Format check (can catch some issues)
dart format --set-exit-if-changed .
```

### React Native
```bash
# NPM audit
npm audit --production

# TypeScript strict mode catches many issues
npx tsc --noEmit --strict
```

### Frontend (Web)
```bash
# NPM audit
npm audit --production

# Lighthouse (security subset)
npx lighthouse http://localhost:3000 --only-categories=best-practices

# Snyk (if configured)
snyk test
```

## 6. Incident Response
In the event of a critical security breach or leaked credential:
1. **Rotate** the compromised credential immediately
2. **Revert** the commit if possible
3. **Trigger** the `ops/runbooks/incident-template.md` workflow
4. **Mobile**: Submit emergency app update to stores if credentials were in released builds
5. **Frontend**: Invalidate any exposed tokens/sessions
6. **Notify** affected users per data breach notification requirements
