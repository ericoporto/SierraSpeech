/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * SIERRA SPEECH MODULE - Header                                                           *
 * forked from SPEECH BUBBLE MODULE - Header                                               *
 * by Gunnar Harboe (Snarky), v0.8.0                                                       *
 *                                                                                         *
 * Copyright (c) 2017 Gunnar Harboe                                                        *
 *                                                                                         *
 * This module allows you to display conversation text in comic book-style speech sierras. *
 * The appearance of the speech sierras can be extensively customized.                     *
 *                                                                                         *
 * GitHub repository:                                                                      *
 * https://github.com/messengerbag/SierraSpeech                                            *
 *                                                                                         *
 * AGS Forum thread:                                                                       *
 * http://www.adventuregamestudio.co.uk/forums/index.php?topic=55542                       *
 *                                                                                         *
 * THIS MODULE IS UNFINISHED. SOME FEATURES ARE NOT YET IMPLEMENTED,                       *
 * AND OTHERS MAY CHANGE BEFORE THE FINAL RELEASE.                                         *
 *                                                                                         *
 * To use, you call Character.SaySierra(). For example:                                    *
 *                                                                                         *
 *     player.SaySierra("This line will be said in a speech sierra");                      *
 *                                                                                         *
 * You can also use Character.SayAtSierra() to position the sierra elsewhere on screen,    *
 * and Character.SayBackgroundSierra() for non-blocking speech.                            *
 * Character.ThinkSierra() IS NOT YET IMPLEMENTED.                                         *
 *                                                                                         *
 * To configure the appearance of the speech sierras, you set the SierraSpeech properties. *
 * This is usually best done in GlobalScript game_start(). For example:                    *
 *                                                                                         *
 *   function game_start()                                                                 *
 *   {                                                                                     *
 *     SierraSpeech.BorderColor = Game.GetColorFromRGB(0,128,0);                           *
 *     SierraSpeech.BackgroundColor = Game.GetColorFromRGB(128,255,128);                   *
 *     SierraSpeech.PaddingTop = 5;                                                        *
 *     SierraSpeech.PaddingBottom = 5;                                                     *
 *     SierraSpeech.PaddingLeft = 15;                                                      *
 *     SierraSpeech.PaddingRight = 15;                                                     *
 *     // Other code                                                                       *
 *   }                                                                                     *
 *                                                                                         *
 * See the declaration below for the full list and explanation of the properties.          *
 *                                                                                         *
 * The module relies on built-in AGS settings as far as possible. In particular, it uses   *
 * these settings to customize the appearance and behavior of the speech sierras:          *
 *                                                                                         *
 * - Character.SpeechColor                                                                 *
 * - game.bgspeech_stay_on_display                                                         *
 * - Game.MinimumTextDisplayTimeMs                                                         *
 * - Game.SpeechFont                                                                       *
 * - Game.TextReadingSpeed                                                                 *
 * - Speech.DisplayPostTimeMs                                                              *
 * - Speech.SkipStyle                                                                      *
 * - Speech.VoiceMode                                                                      *
 *                                                                                         *
 * Note that to get text-based lip sync to work, you need to provide an invisible font,    *
 * and set the SierraSpeech.InvisibleFont property accordingly. You may download one here: *
 *                                                                                         *
 *   http://www.angelfire.com/pr/pgpf/if.html                                              *
 *                                                                                         *
 * Finally, the module (usually) calls Character.Say() to render speech animation and play *
 * voice clips. If you are already using some custom Say module (e.g. TotalLipSync), you   *
 * may want to call a custom Say() function instead. To do this, simply change the         *
 * function call in SB_sayImpl() at the top of SierraSpeech.asc.                           *
 *                                                                                         *
 * This code is offered under the MIT License                                              *
 * https://opensource.org/licenses/MIT                                                     *
 *                                                                                         *
 * It is also licensed under a Creative Commons Attribution 4.0 International License.     *
 * https://creativecommons.org/licenses/by/4.0/                                            *
 *                                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/// The shape of a text outline
enum TextOutlineStyle
{
  /// A circular, rounded outline
  eTextOutlineRounded = 0,
  /// A square "block" outline
  eTextOutlineSquare
};

/// Speech sierra settings
managed struct SierraSpeech
{
  #region Static Properties
  /// The GUI that will be used to display blocking sierras if no GUI argument is passed. Default: null (use overlays)
  import static attribute GUI* DefaultGui;              // $AUTOCOMPLETESTATICONLY$

  /// The color of any outline applied to speech sierra text (an AGS color number). Default: 0 (black)
  import static attribute int TextOutlineColor;         // $AUTOCOMPLETESTATICONLY$
  /// The percentage by which text outlines are tinted by the speech color (0-100). Default: 0
  import static attribute int TextOutlineSpeechTint;         // $AUTOCOMPLETESTATICONLY$
  /// The width of the outline applied to speech sierra text. Default: 0 (none)
  import static attribute int TextOutlineWidth;         // $AUTOCOMPLETESTATICONLY$
  /// The style of the outline applied to speech sierra text. Default: eTextOutlineRounded
  import static attribute TextOutlineStyle TextOutlineStyle;         // $AUTOCOMPLETESTATICONLY$

  /// How wide a line of text can be before it wraps. Add left+right padding for total speech sierra width. If <= 0, use default AGS text wrapping. Default: 0
  import static attribute int MaxTextWidth;             // $AUTOCOMPLETESTATICONLY$
  /// Pixels between the text and the top of speech sierras. Default: 10
  import static attribute int PaddingTop;               // $AUTOCOMPLETESTATICONLY$
  /// Pixels between the text and the bottom of speech sierras. Default: 10
  import static attribute int PaddingBottom;            // $AUTOCOMPLETESTATICONLY$
  /// Pixels between the text and the left of speech sierras. Default: 20
  import static attribute int PaddingLeft;              // $AUTOCOMPLETESTATICONLY$
  /// Pixels between the text and the right of speech sierras. Default: 20
  import static attribute int PaddingRight;             // $AUTOCOMPLETESTATICONLY$
  /// Pixels between the top of the character sprite and the bottom of the speech sierra tail (can be negative)
  import static attribute int HeightOverHead;           // $AUTOCOMPLETESTATICONLY$

  /// The text alignment in speech sierras. Default: eAlignCentre
  import static attribute Alignment TextAlign;          // $AUTOCOMPLETESTATICONLY$
  /// Set a font where all characters are invisible, to improve integration. Default: -1 (none)
  import static attribute FontType InvisibleFont;       // $AUTOCOMPLETESTATICONLY$
  #endregion

  #region Instance Properties
  /// Get the Character that this speech sierra belongs to
  import readonly attribute Character* OwningCharacter;
  /// Get whether this speech sierra is valid (not removed from screen)
  import readonly attribute bool Valid;
  /// Get whether this speech sierra is displaying non-blocking background speech
  import readonly attribute bool IsBackgroundSpeech;
  /// Get whether this is a thought sierra
  import readonly attribute bool IsThinking;
  /// Get whether the character is being (manually) animated
  import readonly attribute bool Animating;
  /// Get the text of this speech sierra
  import readonly attribute String Text;
  /// Get the rendered version of this speech sierra, as a DynamicSprite
  import readonly attribute DynamicSprite* SierraSprite;
  /// Get the Overlay this speech sierra is rendered on (null if none)
  import readonly attribute Overlay* SierraOverlay;
  /// Get the GUI this speech sierra is rendered on (null if none)
  import readonly attribute GUI* SierraGUI;
  /// Get the total number of game loops this speech sierra is displayed before it times out (-1 if no timeout)
  import readonly attribute int TotalDuration;
  /// Get how many game loops this speech sierra has been displayed
  import readonly attribute int ElapsedDuration;
  /// Get/set the X screen-coordinate of this speech sierra's top-left corner
  import attribute int X;
  /// Get/set the Y screen-coordinate of this speech sierra's top-left corner
  import attribute int Y;
  #endregion

  #region Protected member variables
  // The underlying variables for the instance properties
  protected int _id;
  protected bool _valid;
  protected bool _isBackgroundSpeech;
  protected bool _isThinking;
  protected bool _isAnimating;
  protected int _totalDuration;
  protected int _elapsedDuration;
  protected int _x;
  protected int _y;
  #endregion
};

#region Character Extender functions
/// Like Character.Say(), but using a speech sierra.
import void SaySierra(this Character*, String message, GUI* sierraGui=0);
/// Like SaySierra(), but the sierra will be positioned with the top-left corner at the given coordinates
import void SayAtSierra(this Character*, int x, int y, String message, GUI* sierraGui=0);
/// Non-blocking speech, similar to SayBackground() - if animate is true, will play the speech animation
import SierraSpeech* SayBackgroundSierra(this Character*, String message, bool animate=true, GUI* sierraGui=0);
/// Like Character.Think(), but using this module's thought sierra
import void ThinkSierra(this Character*, String message, GUI* sierraGui=0);

/// The current height of the character (pixels from the Character.x position to the top of their sprite)
import int GetHeight(this Character*);
/// Interrupt the character if they are speaking in the background (returns whether they were)
import bool StopBackgroundSierra(this Character*);
/// Whether the character is speaking in a sierra
import bool IsSpeakingSierra(this Character*, bool includeBackground=true);
/// The speech sierra used by the character (null if none)
import SierraSpeech* GetSierraSpeech(this Character*);
#endregion
