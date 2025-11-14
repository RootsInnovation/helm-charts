# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automated chart releases and repository management.

## Workflows

### 1. `release.yml` - Chart Release Automation

**Trigger:** Automatically on push to `main` branch

**What it does:**
- Detects changed charts since last release
- Packages changed charts
- Creates GitHub releases with release notes
- Uploads chart packages as release assets
- Updates gh-pages branch with new index

**Usage:** Automatically runs when you push to main with chart changes

### 2. `pages.yml` - GitHub Pages Setup

**Trigger:** Manual (`workflow_dispatch`) or when the workflow file changes

**What it does:**
- Checks if gh-pages branch exists
- Creates gh-pages branch if missing
- Initializes index.yaml and README.md
- Verifies GitHub Pages configuration

**Usage:** 
```bash
# Trigger manually from GitHub Actions UI
# Or will run automatically when this workflow file is updated
```

### 3. `update-index.yml` - Manual Index Update

**Trigger:** Manual (`workflow_dispatch`)

**What it does:**
- Packages all charts from main branch
- Updates index.yaml on gh-pages branch
- Optionally force rebuilds entire index

**Usage:**
```bash
# Trigger from GitHub Actions UI
# Use "force-rebuild" option to regenerate entire index
```

## Workflow Execution Order

For first-time setup:

1. **First:** Run `pages.yml` to initialize gh-pages branch
2. **Then:** Run `release.yml` (automatic) to release charts
3. **Optional:** Run `update-index.yml` to manually update index

## Chart Release Process

When you want to release a new chart version:

1. Update chart version in `Chart.yaml`
2. Commit and push to main branch
3. `release.yml` automatically:
   - Packages the chart
   - Creates GitHub release
   - Updates gh-pages index
   
## Troubleshooting

### If index.yaml is missing:
Run `pages.yml` workflow manually to recreate it

### If a release fails due to existing tag:
Update the chart version in `Chart.yaml` to a new version

### If index.yaml is corrupted:
Run `update-index.yml` with "force-rebuild" enabled

## Permissions Required

All workflows need these permissions:
- `contents: write` - To push to branches and create releases
- `packages: write` - To publish chart packages
- `pages: write` - To configure GitHub Pages

## Configuration Files

- `.github/workflows/*.yml` - Workflow definitions
- `cr.yaml` - Chart Releaser configuration
- `Chart.yaml` - Chart metadata (includes version)

