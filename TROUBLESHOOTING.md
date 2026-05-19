# Troubleshooting

## Items Do Not Appear In Inventory

- Confirm the item definitions were added to your inventory resource.
- Confirm clothing items are unique or non-stacking.
- Confirm the inventory resource starts before `peak-clothingitems`.
- Enable `Config.Debug = true` and check the server console for bridge warnings.

## Item Can Be Removed But Not Worn

- Check that the item metadata exists in the inventory item.
- Make sure the player model matches the metadata model. Male and female freemode clothing is not interchangeable.
- Remove clothing already occupying the target slot before using the item.

## Clothing Does Not Persist After Reconnect

- Confirm a supported appearance resource is running.
- Set `Config.Appearance` explicitly if auto-detection finds the wrong resource.
- Check the appearance resource logs for save errors.

## Radial Menu Does Not Show

- Confirm `Config.EnableRadialMenu = true`.
- Confirm `Config.RadialMenu` is set to `auto`, `ox_lib`, or `qb-radialmenu`.
- Make sure the radial menu resource starts before `peak-clothingitems`.

## Admin Command Denied

Add ACE permission:

```cfg
add_ace group.admin command.clothingadmin allow
```

Framework admin and god groups are also accepted for QBCore, QBox, and ESX.

## Custom Clothing Packs Use Different Bare Values

Edit `ClothingItems.DefaultValues` in `shared/items.lua`. If a default value is wrong, the script may think a bare slot is removable or may reset to the wrong drawable.
