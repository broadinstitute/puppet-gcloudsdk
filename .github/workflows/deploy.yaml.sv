---
name: 'deploy'

'on':
  push:
    tags:
      - '[0-9]+.[0-9]+.[0-9]+'

jobs:
  forge_deploy:

    runs-on: 'ubuntu-latest'

    steps:
      - name: 'Checkout repo'
        uses: 'actions/checkout@v3'

      - name: 'Set up Ruby'
        uses: 'ruby/setup-ruby@v1.100.1'
        with:
          rubygems: 'latest'
          ruby-version: '2.4'

      - name: Get full Ruby version
        id: full-ruby-version
        run: |
          echo ::set-output name=version::$(ruby -e 'puts RUBY_VERSION')

      - name: 'Cache Ruby'
        uses: 'actions/cache@v2.1.7'
        with:
          path: 'vendor/bundle'
          key: ${{ runner.os }}-${{ steps.full-ruby-version.outputs.version }}-v1-gems-${{ hashFiles('**/Gemfile') }}
          restore-keys: |
            ${{ runner.os }}-${{ steps.full-ruby-version.outputs.version }}-v1-gems-

      - name: 'Install ruby dependencies'
        run: |
          gem install bundler
          bundler --version
          bundle config path vendor/bundle
          bundle config set with 'development'
          bundle install --jobs 4 --retry 3

      - name: 'Module build'
        run: 'bundle exec rake module:build'

      - name: 'Publish package to Puppet Forge'
        env:
          BLACKSMITH_FORGE_URL: 'https://forgeapi.puppet.com'
          BLACKSMITH_FORGE_API_KEY: ${{ secrets.BLACKSMITH_FORGE_API_KEY }}
        run: 'bundle exec rake module:push'
