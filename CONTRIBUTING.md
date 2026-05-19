# Contributing

Contributions are welcome. Keep changes focused and easy to review.

## Local Workflow

1. Fork the repository.
2. Create a branch for your change.
3. Make the smallest practical patch.
4. Test on a FiveM server with at least one supported framework and inventory.
5. Open a pull request with reproduction steps and test notes.

## Code Style

- Use Lua 5.4-compatible syntax.
- Keep framework-specific behavior inside bridge files.
- Validate server events and callbacks before touching inventory.
- Prefer clear table shapes over positional argument chains.
- Add comments only where they explain non-obvious behavior.

## Pull Request Checklist

- The resource starts without console errors.
- Clothing removal creates an inventory item with metadata.
- Using the item applies the clothing and removes the inventory item.
- Failed wear attempts return the item only through the pending wear flow.
- Documentation is updated when configuration, commands, exports, or setup steps change.
