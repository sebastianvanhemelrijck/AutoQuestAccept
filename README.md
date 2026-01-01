# AutoQuestAccept

AutoQuestAccept is a simple Vanilla 1.12.1 addon that automatically accepts quests when the quest detail window opens. Hold SHIFT to bypass auto-accept for a single quest.

## Installation

### From GitHub (ZIP)

1) Click Code -> Download ZIP on GitHub.
2) Extract the ZIP.
3) Rename the extracted folder from `AutoQuestAccept-main` (or similar) to `AutoQuestAccept`.
4) Move it to your game folder:

`Interface/AddOns/AutoQuestAccept/`

### Verify Folder Structure

Make sure it looks like this:

```
Interface/AddOns/AutoQuestAccept/
  AutoQuestAccept.toc
  AutoQuestAccept.lua
  README.md
```

Then enable the addon in the in-game AddOns list and use `/reload`.

## Usage

- /aq -> open the UI
- /aq on -> enable auto-accept
- /aq off -> disable auto-accept
- /aq ui -> open the UI
- /aq feedback -> show the Issues link
- /aq project -> show the Project link
- Hold SHIFT while opening a quest to bypass auto-accept

## Screenshot

![AutoQuestAccept UI](docs/ui.png)

## Notes

This addon intentionally targets the Vanilla 1.12.1 API. Classic or retail addons will not work.

## Support Development

Made by SVH. If you want to support development, you can donate at:

https://paypal.me/SVH24
https://ko-fi.com/sebastianvanh

Donation links are intentionally not shown inside the in-game UI; see this README instead.
