# Instructor Notes — Collecting Portfolios

[← Instructor notes](./README.md) · [Pre-study](../pre-study.md) · [Syllabus](../syllabus.md)

Students create their portfolio from the template in **one click** and invite the
instructor. This page is the instructor side of that workflow.

## What students are told

Every entry point (README, pre-study, resource-bank primer, Day-1 slide, syllabus,
the template's own `README.md`) says the same three things:

1. **Create** from `https://github.com/new?template_name=iot-portfolio-template&template_owner=iotempire`
   — or `iot-portfolio-template/generate` if that link ever loses the pre-selection.
2. **Name it exactly** `net-iot-hsbi-2026-portfolio`. Everyone uses the same name; the
   GitHub account tells them apart.
3. **Invite `ulno`** with role *Write* via
   `https://github.com/<user>/net-iot-hsbi-2026-portfolio/settings/access`.

Treat the invite as part of Module 0. **An unshared portfolio is an empty portfolio.**

## Bulk accept and clone

`tools/collect-portfolios.sh` (repository root) handles 40–80 invitations without 80
emails:

```sh
bash tools/collect-portfolios.sh invitations            # what is pending, who invited you
bash tools/collect-portfolios.sh accept                 # accept all
bash tools/collect-portfolios.sh list                   # repos named net-iot-hsbi-20YY-portfolio
bash tools/collect-portfolios.sh clone --dir ~/review   # clone them side by side
```

- Clones land in `DIR/<owner>__<repo>`, because every repository has the same name.
- `--pattern RE` matches the **repository name** (after the owner), not `owner/repo`.
- `--dry-run` shows what would happen; `--depth N` keeps a large cohort fast.

### Two commands that do not exist

`gh repo invite` and `gh repo list --collaborator` are not GitHub CLI commands. Use the
API forms the script uses:

```sh
gh api -X PUT "repos/{owner}/{repo}/collaborators/ulno" -f permission=push   # push = Write
gh api "user/repos?affiliation=collaborator&per_page=100" --paginate --jq '.[].full_name'
```

## Discipline points

- Run `invitations` **before the first checkpoint**, not on the last day: invitations
  expire, and a student who never invites never appears.
- Invitation accepted + empty repository = empty submission. Check for at least one
  commit before the checkpoint.
- Keep review clones outside the teaching repository (e.g. `~/review`) — student work
  is evidence, not course material.
