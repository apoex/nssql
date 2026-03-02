# Tag v2.0.1 Creation

## Status
The tag `v2.0.1` has been successfully created locally on commit `de6879ca04302704293a72fcd99920f6896d1f7a` (master branch).

## Commit Details
- **Commit SHA**: de6879ca04302704293a72fcd99920f6896d1f7a
- **Commit Message**: Merge pull request #15 from apoex/fv-update-truststore - Update Truststore to include additional certificate
- **Date**: Mon Mar 2 16:58:08 2026 +0100

## Next Steps
Due to workflow permissions being read-only, the tag cannot be pushed from this automated environment. To complete the tag creation, a repository maintainer with write access needs to:

### Option 1: Push the tag manually
```bash
git fetch origin master
git tag v2.0.1 de6879ca04302704293a72fcd99920f6896d1f7a
git push origin v2.0.1
```

### Option 2: Create the tag via GitHub UI
1. Go to https://github.com/apoex/nssql/releases/new
2. Click "Choose a tag" and type `v2.0.1`
3. Select target: `master` (commit de6879c)
4. Click "Create new tag: v2.0.1 on publish"
5. Fill in release details if needed and publish

### Option 3: Create the tag via GitHub CLI
```bash
gh api /repos/apoex/nssql/git/refs -f ref='refs/tags/v2.0.1' -f sha='de6879ca04302704293a72fcd99920f6896d1f7a'
```

## Verification
Once the tag is pushed, verify it exists:
```bash
git ls-remote --tags origin v2.0.1
```

Or visit: https://github.com/apoex/nssql/tags
