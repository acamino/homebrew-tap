# Homebrew Tap for acamino

This tap provides Homebrew formulas for my tools.

## Installation

```bash
brew tap acamino/tap
brew install table-extractor
```

## Available Formulas

- **table-extractor** - Convert various tabular data formats (Markdown, MySQL, PostgreSQL, CSV, TSV)

## Usage

After installation, use the `tabx` command:

```bash
# Convert CSV to TSV (default)
echo "id,name
1,Alice
2,Bob" | tabx

# Convert between different formats
tabx --from csv --to markdown < input.csv
tabx --from mysql --to postgresql < dump.sql
```

## Uninstall

```bash
brew uninstall table-extractor
brew untap acamino/tap
```

## Development

To test the formula locally:

```bash
brew audit --strict table-extractor
brew test table-extractor
```

## License

See individual formula files for license information.
