# GitHub repository metadata (SEO)

Run after pushing to GitHub. Requires [GitHub CLI](https://cli.github.com/).

```bash
gh repo edit DiegoCalleri/devops-components \
  --description "Reusable GitHub Actions workflows: build & push Docker images for Next.js and Node.js to GHCR/ECR/YCR" \
  --add-topic github-actions \
  --add-topic reusable-workflows \
  --add-topic docker \
  --add-topic nextjs \
  --add-topic nodejs \
  --add-topic cicd \
  --add-topic devops \
  --add-topic container-registry
```

Create the first release tag (required for `@v1` references in examples):

```bash
git tag v1.0.0
git push origin v1.0.0
gh release create v1.0.0 --title "v1.0.0" --notes "Initial release: push-image workflow, build-and-push action, Next.js and Node.js Dockerfiles."
```
