# SierraSpeech

SierraSpeech [Adventure Game Studio (AGS)](http://www.adventuregamestudio.co.uk/) module mimics the Sierra Speech Style available by default in AGS, to solve some limitations. This is a fork of the [SpeechBubble AGS Module](https://www.adventuregamestudio.co.uk/forums/index.php?topic=55542.0) made by [Snarky](https://www.adventuregamestudio.co.uk/forums/index.php?action=profile;u=2581), [also available on github](https://github.com/messengerbag/SpeechBubble), which I aggregated [SSH'](https://www.adventuregamestudio.co.uk/forums/index.php?action=profile;u=668) efforts from [GUI Portrait module](https://www.adventuregamestudio.co.uk/forums/index.php?topic=34996.0), It requires AGS v3.4.3.1 or higher.

THIS MODULE IS UNFINISHED. SOME FEATURES ARE NOT YET IMPLEMENTED, AND OTHERS MAY CHANGE BEFORE THE FINAL RELEASE.

## How To Use
To use, you call Character.SayBubble(). For example:

```adventure-game-studio
player.SayBubble("This line will be said in a speech bubble");
```

You can also use `Character.SayAtBubble()` to position the bubble elsewhere on screen, and `Character.SayBackgroundBubble()` for non-blocking speech. `Character.ThinkBubble()` IS NOT YET IMPLEMENTED.

To configure the appearance of the speech bubbles, you set the SpeechBubble properties. This is usually best done in GlobalScript `game_start()`. For example:

```adventure-game-studio
function game_start()
{
  SpeechBubble.BorderColor = Game.GetColorFromRGB(0,128,0);
  SpeechBubble.BackgroundColor = Game.GetColorFromRGB(128,255,128);
  SpeechBubble.BackgroundTransparency = 33;
  SpeechBubble.PaddingTop = 5;
  SpeechBubble.PaddingBottom = 5;
  SpeechBubble.PaddingLeft = 15;
  SpeechBubble.PaddingRight = 15;
  // Other code
}
```

See the declaration below for the full list and explanation of the properties.

The module relies on built-in AGS settings as far as possible. In particular, it uses these settings to customize the appearance and behavior of the speech bubbles:

* `Character.SpeechColor`
* `Game.SpeechFont`
* `Game.TextReadingSpeed`
* `Speech.SkipStyle`
* `Speech.VoiceMode`

Note that to get text-based lip sync to work, you need to provide an invisible font, and set the `SpeechBubble.InvisibleFont` property accordingly. You may download one here:

  http://www.angelfire.com/pr/pgpf/if.html

Finally, the module (usually) calls `Character.Say()` to render speech animation and play voice clips. If you are already using some custom Say module (e.g. [TotalLipSync](https://github.com/messengerbag/TotalLipSync)), you may want to call a custom Say() function instead. To do this, simply change the function call in `SB_sayImpl()` at the top of SpeechBubble.asc.

## License details

This module carries the licenses of the module it forks from.

Sierra Speech was developed by [Snarky](https://github.com/messengerbag), who was funded by AGS forum member bx83, who agreed to make the code open-source. Thanks!

This code is offered under the [MIT License](LICENSE)

It is also licensed under a Creative Commons Attribution 4.0 International License:
  https://creativecommons.org/licenses/by/4.0/
