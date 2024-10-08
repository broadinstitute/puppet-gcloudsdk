---
name: 'deploy'

'on':
  push:
    tags:
      - '[0-9]+.[0-9]+.[0-9]+'
jobs:
  deploy:
    uses: broadinstitute/shared-workflows/.github/workflows/puppet-forge-deploy.yaml@v2.2.0
    secrets:
      forge_token: ${{ secrets.BLACKSMITH_FORGE_API_KEY }}
