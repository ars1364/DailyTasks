# Bash notes

## `[[` not found (bash 4)
Run the script with `bash` instead of `sh`.

## `((i++))` not found
Use:

```bash
i=$((i-1))
```

## Ignore errors for a command
```bash
set -e
EXIT_CODE=0
command || EXIT_CODE=$?
echo $EXIT_CODE
```
