# peak-clothingitems

Turn worn GTA V clothing into inventory items for FiveM servers. Players can remove clothing, store it, trade it, and wear it again while preserving drawable, texture, model, and sex metadata.

## Features

- 15 supported clothing slots: masks, torso, pants, bags, shoes, accessories, undershirts, vests, decals, tops, hats, glasses, earrings, watches, and bracelets.
- Framework auto-detection for QBCore, QBox, ESX, and standalone mode.
- Inventory support for `ox_inventory`, `qb-inventory`, `ps-inventory`, `qs-inventory`, and `codem-inventory`.
- Appearance persistence through `illenium-appearance`, `rcore_clothing`, `fivem-appearance`, or `skinchanger`.
- Command flow with `/clothing remove <slot|all>` and `/clothing list`.
- Optional radial menu integration through `ox_lib` or `qb-radialmenu`.
- Admin item grant command with ACE/framework permission checks.
- Server-side item-use confirmation tracking to prevent forged refund events.
- Localized strings for English, French, Spanish, and Arabic.

## Requirements

- FiveM artifact with `lua54` support.
- One supported framework, or standalone mode.
- One supported inventory system for item storage.
- Optional but recommended: one supported appearance resource for persistence.
- Optional: `ox_lib` for notifications/radial menu.

## Quick Start

1. Place `peak-clothingitems` in your server `resources` folder.
2. Add the inventory item definitions from `install/` to your inventory.
3. Copy the transparent item icons from `images/` into your inventory image folder.
4. Add this to `server.cfg` after your framework, inventory, and appearance resources:

```cfg
ensure peak-clothingitems
```

5. Leave `shared/config.lua` on `auto` or set your exact systems.
6. Restart the server and test `/clothing list`, `/clothing remove hat`, and using the generated clothing item.

For a full setup guide, see [INSTALLATION.md](INSTALLATION.md).

## Commands

| Command | Description |
| :--- | :--- |
| `/clothing remove <slot>` | Removes one worn clothing slot and converts it into an inventory item. |
| `/clothing remove all` | Converts all currently worn non-default supported slots into inventory items. |
| `/clothing list` | Lists currently worn removable slots. |
| `/clothingadmin give <player_id> <slot> <drawable> <texture>` | Gives a metadata-backed clothing item to a player. |

Available slots:

```text
mask, torso, pants, bag, shoes, accessory, undershirt, vest, decal, top,
hat, glasses, earring, watch, bracelet
```

## Documentation

- [Installation](INSTALLATION.md)
- [Configuration](CONFIGURATION.md)
- [API Reference](API.md)
- [Troubleshooting](TROUBLESHOOTING.md)
- [Security](SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

`PROMPT.md` is included for AI-assisted installation in customer servers.

## Included Item Images

The `images/` folder contains one 256x256 transparent PNG for each clothing item. Copy these files into your inventory image directory, such as `qb-inventory/html/images/`, `ps-inventory/html/images/`, or the equivalent folder for your inventory resource.

## Security Notes

The server validates slot payloads, rate-limits clothing conversion, and only refunds worn items when a matching server-created pending wear action exists. Client ped state still originates from the player client because FiveM clothing drawable reads are client-side in this resource flow. Do not expose additional server events that grant clothing items without similar validation.

## License

MIT. See [LICENSE](LICENSE).
