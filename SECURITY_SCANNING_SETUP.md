# GitHub Actions Security Scanning Setup

## Required Secrets

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

### SonarCloud
- **SONAR_TOKEN**: Your SonarCloud authentication token
  - Go to SonarCloud > My Account > Security > Generate Tokens
  - Token value: `db4e199bbd42cbc92c75fcd6ea2cb8da247382a1`
- **SONAR_PROJECT_KEY**: Project key for SonarCloud
  - Value: `fabrizioperezperalta_recipeplatform`

### Snyk
- **SNYK_TOKEN**: Your Snyk authentication token
  - Get from: https://app.snyk.io/account
  - Token value: `snyk_uat.1fcad39e...`

### Optional: Container Registry (for deployment)
- **AZURE_CREDENTIALS**: Azure service principal JSON (for Azure deployment)
- **DOCKER_USERNAME**: Docker Hub username
- **DOCKER_PASSWORD**: Docker Hub password/token

## Automated Security Scanning

### SonarCloud Analysis
- **Triggers**: Every push/PR to main/develop branches
- **Output**: Code quality metrics, code coverage, code smells, bugs, vulnerabilities
- **Dashboard**: https://sonarcloud.io/project/overview?branch=main&id=fabrizioperezperalta_recipeplatform

### Snyk Scan
- **Triggers**: Every push/PR + weekly scheduled scan
- **Checks**: SCA (Software Composition Analysis) for dependencies
- **Output**: Vulnerabilities in NuGet packages, fix PRs automatically

### Semgrep Scan
- **Triggers**: Every push/PR
- **Checks**: SAST (Static Application Security Testing)
- **Rules**: OWASP Top 10, CWE, injection flaws, XSS, CSRF, etc.

### Code Build & Test
- **Triggers**: Every push/PR
- **Runs**: dotnet build + dotnet test + coverage

## Setting up Secrets

```bash
# Using GitHub CLI
gh secret set SONAR_TOKEN -b"db4e199bbd42cbc92c75fcd6ea2cb8da247382a1"
gh secret set SNYK_TOKEN -b"snyk_uat.1fcad39e..."
gh secret set SONAR_PROJECT_KEY -b"fabrizioperezperalta_recipeplatform"
```

## Viewing Results

### Security Reports
- **Artifacts**: Download from each workflow run
  - `semgrep-report.md` - Semgrep findings
  - `snyk-security-report.md` - Snyk vulnerabilities
  - `test-results` - Unit test outcomes
  - `code-coverage` - Cobertura format coverage report

### SonarCloud Dashboard
Visit: https://sonarcloud.io/project/overview?id=fabrizioperezperalta_recipeplatform

## Required Quality Gates

All security tools are configured to **FAIL** if:
- **High severity** vulnerabilities found (Semgrep ERROR/HIGH)
- **Critical/High** vulnerabilities found (Snyk)
- **Quality Gate** fails on SonarCloud (0 bugs, 0 vulnerabilities, >80% coverage)

## Notifications

Configure status checks in branch protection rules:
- `Build and Test` - must pass
- `SonarCloud Scan` - must pass
- `Semgrep Scan` - must pass
- `Snyk Scan` - must pass

## Local Testing

```bash
# Build and test locally
dotnet build
dotnet test

# Run Semgrep locally
pip install semgrep
semgrep scan --config auto .

# Run Snyk locally
npm install -g snyk
snyk test --all-projects
```

## Next Steps

1. Add repository secrets above
2. Push to GitHub to trigger first workflow
3. Monitor SonarCloud dashboard for quality gate status
4. Configure branch protection rules
5. Set up automated deployment (Azure, AWS, etc.)