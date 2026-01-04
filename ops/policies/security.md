# Security Policy & Baseline

## 1. Objective
To ensure all contributions to this project meet a minimum security standard before being merged. This policy is enforced by the CI/CD pipelines defined in `ops/pipelines/`.

## 2. Required Tooling
The following tools are mandated for all pipelines:

| Category | Tool | Command | Failure Threshold |
| :--- | :--- | :--- | :--- |
| **Secrets Detection** | `gitleaks` | `gitleaks detect --no-git` | Any detection |
| **SAST (Static Analysis)** | `trivy` | `trivy fs . --security-checks config,vuln` | High, Critical |
| **SCA (Dependencies)** | `trivy` | `trivy fs .` | High, Critical |

## 3. Workflow
1.  **Local Dev**: Developers should run `gitleaks` locally before committing.
2.  **Pull Request**:
    *   Secrets scan must pass.
    *   SAST/SCA must pass (or have findings allowlisted).
3.  **Main Branch**:
    *   Daily scans run to detect newly disclosed vulnerabilities (CVEs) in existing dependencies.

## 4. Exceptions
If a false positive or acceptable risk is identified:
1.  Create a `.trivyignore` file in the root for SAST/SCA findings.
2.  Update `.gitleaksignore` for secret patterns (use with extreme caution).
3.  Document the reasoning in `docs/SECURITY_ALLOWLIST.md`.

## 5. Incident Response
In the event of a critical security breach or leaked credential:
1.  **Rotate** the compromised credential immediately.
2.  **Revert** the commit if possible.
3.  **Trigger** the `ops/runbooks/incident-template.md` workflow.