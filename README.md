# Envplate plugin for Drone CI

Trivial templating for configuration files using environment keys based of https://github.com/kreuzwerker/envplate

References to such keys are declared in arbitrary config files either as:

1. `${key}` or

- `${key:-default value}`

Envplate (`ep`) parses arbitrary configuration files (using glob patterns) and replaces all references with values from the environment or with default values (if given). These values replace the keys _inline_ (= the files will be changed).

Failure to resolve the supplied glob pattern(s) to at least one file results in an error.

## Usage

### Minimal

```yaml
kind: pipeline
type: docker

steps:
  - name: substitute env vars
    image: bibasoft/drone-envplate
    settings:
      file: docker-compose.yml
```

### Advanced

```yaml
kind: pipeline
type: docker

steps:
  - name: substitute env vars
    image: bibasoft/drone-envplate
    environment:
      IMAGE_REPO:
        from_secret: image_repo
      BRANCH: ${DRONE_COMMIT_BRANCH/\//-}
    settings:
      file: docker-compose.yml
      backup: true
      dry_run: true
      strict: true
      verbose: true
```
## Settings
- backup (`-b` flag): create backups of the files it changes, appending a `.bak` extension to backup copies
- dry-run (`-d` flag): output to stdout instead of replacing values inline
- strict (`-s` flag): refuse to fallback to default values
- verbose (`-v` flag): be verbose about it's operations

## Escaping

In case the file you want to modify already uses the pattern envplate is searching for ( e.g. for reading environment variables ) you can escape the sequence by adding a leading backslash `\`. It's also possible to escape a leading backslash by adding an additional backslash. Basically a sequence with an even number of leading backslashes will be parsed, is the number of leading backslashes odd the sequence will be escaped.

See https://github.com/kreuzwerker/envplate#full-example

## Full example

```
$ cat /etc/foo.conf
Database=${FOO_DATABASE}
DatabaseSlave=${BAR_DATABASE:-db2.example.com}
Mode=fancy
Escaped1=\${FOO_DATABASE}
NotEscaped1=\\${FOO_DATABASE}
Escaped2=\\\${BAR_DATABASE:-db2.example.com}
NotEscaped2=\\\\${BAR_DATABASE:-db2.example.com}

$ export FOO_DATABASE=db.example.com

$ ep /etc/f*.conf

$ cat /etc/foo.conf
Database=db.example.com
DatabaseSlave=db2.example.com
Mode=fancy
Escaped1=${FOO_DATABASE}
NotEscaped1=\db.example.com
Escaped2=\${BAR_DATABASE:-db2.example.com}
NotEscaped2=\\db2.example.com
```

## Local test

```bash
docker run --volume $PWD/test.yml:/test.yml -e PLUGIN_FILE=/test.yml -e PLUGIN_DRY_RUN=true -e ENV_VAR=test bibasoft/drone-envplate
```
