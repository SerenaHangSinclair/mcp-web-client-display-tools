# Contributing to MCP MS SQL Server

Thank you for your interest in contributing to this project! 

## How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use issue templates** when available
3. **Provide detailed information**:
   - Operating system and version
   - Python version
   - SQL Server version
   - Error messages and stack traces
   - Steps to reproduce the issue

### Suggesting Features

1. **Check existing feature requests** first
2. **Describe the use case** clearly
3. **Explain why it would be useful**
4. **Consider the scope** and maintenance burden

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Add tests** for new functionality
5. **Update documentation** if needed
6. **Commit your changes** (`git commit -m 'Add amazing feature'`)
7. **Push to the branch** (`git push origin feature/amazing-feature`)
8. **Open a Pull Request**

## Development Setup

```bash
# Clone your fork
git clone https://github.com/serenahangsinclair/mcp-mssql-server.git
cd mcp-mssql-server

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

or use uv to create virtual environment
uv venv

# Install in development mode
pip install -e .

# Install development dependencies
pip install pytest black flake8 mypy

# Copy example environment file
cp .env.example .env
# Edit .env with your database credentials
```

## Code Style

- **Python**: Follow PEP 8
- **Formatting**: Use `black` for code formatting
- **Linting**: Use `flake8` for linting
- **Type hints**: Use type hints where appropriate
- **Docstrings**: Use clear docstrings for functions and classes

```bash
# Format code
black .

# Check linting
flake8 .

# Type checking
mypy .
```

## Testing

```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=mcp_mssql_server
```

## Pull Request Guidelines

1. **Small, focused changes**: Keep PRs focused on a single feature or fix
2. **Clear description**: Explain what the PR does and why
3. **Tests**: Include tests for new functionality
4. **Documentation**: Update README or docs if needed
5. **No breaking changes**: Avoid breaking existing functionality
6. **Clean commit history**: Use meaningful commit messages

## Code Review Process

1. All PRs require at least one review
2. Automated checks must pass
3. Address reviewer feedback promptly
4. Maintain backward compatibility
5. Follow the existing code patterns

## Questions?

Feel free to open an issue for questions about contributing!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
