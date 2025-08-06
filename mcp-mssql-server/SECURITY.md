# Security Policy

## Reporting Security Vulnerabilities

If you discover a security vulnerability in this project, please report it privately to help protect users.

### How to Report

1. **Email**: [serena_hang@hotmail.com]
2. **Subject**: "Security Vulnerability in mcp-mssql-server"
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Any suggested fixes

## Security Best Practices

### For Users

1. **Never commit credentials**: Always use `.env` files and add them to `.gitignore`
2. **Use environment variables**: Store all sensitive data in environment variables
3. **Limit permissions**: Use database users with minimal required permissions
4. **Enable audit logs**: Monitor database access and queries
5. **Use secure connections**: Always enable SSL/TLS encryption
6. **Regular updates**: Keep the package and dependencies updated

### For Contributors

1. **No hardcoded secrets**: Never include passwords, API keys, or tokens in code
2. **Validate inputs**: Always sanitize and validate user inputs
3. **Use parameterized queries**: Prevent SQL injection attacks
4. **Follow principle of least privilege**: Request only necessary permissions
5. **Secure defaults**: Make the secure option the default behavior

## Security Features

- **Permission controls**: Write operations are disabled by default
- **Environment variable security**: Credentials stored in `.env` files
- **SQL injection protection**: Uses parameterized queries
- **Connection encryption**: Supports SSL/TLS connections
- **Audit logging**: Comprehensive logging of database operations

## Known Security Considerations

1. **Database credentials**: Must be stored securely in environment variables
2. **Network security**: Ensure database server is properly firewalled
3. **Access control**: Use database-level permissions to limit access
4. **Query logging**: Be aware that queries may be logged by the database server
