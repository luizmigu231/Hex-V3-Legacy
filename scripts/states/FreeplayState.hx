import funkin.scripting.PluginsManager;

var hexV3DisplayNames:Dynamic = {};
Reflect.setField(hexV3DisplayNames, "bit", "B.I.T.");
Reflect.setField(hexV3DisplayNames, "bombs-n-combs", "Bombs N Combs");
Reflect.setField(hexV3DisplayNames, "cooling", "Cooling");
Reflect.setField(hexV3DisplayNames, "detected", "Detected");
Reflect.setField(hexV3DisplayNames, "dunk", "Dunk");
Reflect.setField(hexV3DisplayNames, "encore", "Encore");
Reflect.setField(hexV3DisplayNames, "eye2eye", "Eye2Eye");
Reflect.setField(hexV3DisplayNames, "glitcher", "Glitcher");
Reflect.setField(hexV3DisplayNames, "glitcher-remix", "Glitcher (Remix)");
Reflect.setField(hexV3DisplayNames, "headbasher", "Headbasher");
Reflect.setField(hexV3DisplayNames, "hello-world", "Hello World");
Reflect.setField(hexV3DisplayNames, "hexcript", "HEXcript");
Reflect.setField(hexV3DisplayNames, "java", "Java");
Reflect.setField(hexV3DisplayNames, "jumpin", "Jumpin'");
Reflect.setField(hexV3DisplayNames, "lan", "LAN");
Reflect.setField(hexV3DisplayNames, "lcd", "LCD");
Reflect.setField(hexV3DisplayNames, "ram", "R.A.M");
Reflect.setField(hexV3DisplayNames, "rightpace", "Right Pace");
Reflect.setField(hexV3DisplayNames, "tangerine", "Tangerine");
Reflect.setField(hexV3DisplayNames, "thatretrosong", "That Retro Song");
var hexBg:FlxSprite = null;
var hexTv:FlxSprite = null;
var hexScaryTv:FlxSprite = null;
var hexScaryBg:FlxSprite = null;
var hexLogo:FlxSprite = null;
var hexVersionTag:FlxSprite = null;
var hexSongTitle:FlxText = null;
var hexVariantText:FlxText = null;
var hexPreview:FlxSound = null;
var hexSongId:String = "";
var hexVersion:String = "";
var hexAvailableVariant:String = "";
var hexHoldTime:Float = 0;
var hexHoldDone:Bool = false;
var hexTvBaseX:Float = 0;
var hexTvBaseY:Float = 0;
var hexTvShakeX:Float = 0;
var hexTvShakeY:Float = 0;
var hexVisualActive:Bool = false;

var hexLogoIds:Array<String> = [
    "bit", "bombs-n-combs", "cooling", "encore", "detected", "dunk", "eye2eye", "glitcher",
    "glitcher-remix", "headbasher", "hello-world", "hexcript", "java", "jumpin", "lan", "lcd",
    "ram", "rightpace", "tangerine", "thatretrosong"
];
var hexLogoFrames:Array<String> = [
    "bit", "bombs-n-combs", "cooling", "encore", "detected", "dunk", "eye2eye", "glitcher-reg",
    "glitcher-remix", "headbasher", "hello-world", "hexcript", "java", "jumpin", "lan", "lcd",
    "ram", "right-pace", "tangerine", "that-retro-song"
];

function hexGetSongId(name:String):String
{
    var value:String = Std.string(name).toLowerCase();
    value = StringTools.replace(value, ".", "");
    value = StringTools.replace(value, "'", "");
    value = StringTools.replace(value, " ", "-");
    value = StringTools.replace(value, "_", "-");
    return value;
}

function stopHexPreview()
{
    if (hexPreview != null)
    {
        hexPreview.stop();
        hexPreview = null;
    }
}

function playHexPreview()
{
    stopHexPreview();
    if (!hexVisualActive || hexSongId == "") return;
    var instrumental = hexVersion == "" ? Paths.inst(hexSongId) : Paths.inst(hexSongId, hexVersion);
    hexPreview = FlxG.sound.play(instrumental, 0.7, false);
}

function onCreatePost()
{
    var scale:Float = Math.min(FlxG.width / 1280, FlxG.height / 720);
    if (scale <= 0) scale = 1;

    hexBg = new FlxSprite(0, 0).loadGraphic(Paths.image("ui/hex/hex_freeplay/bg"));
    hexBg.scrollFactor.set();
    hexBg.setGraphicSize(FlxG.width, FlxG.height);
    hexBg.updateHitbox();
    hexBg.visible = false;
    insert(0, hexBg);

    hexScaryBg = new FlxSprite(0, 0).loadGraphic(Paths.image("ui/hex/hex_freeplay/bgEye"));
    hexScaryBg.scrollFactor.set();
    hexScaryBg.setGraphicSize(FlxG.width, FlxG.height);
    hexScaryBg.updateHitbox();
    hexScaryBg.alpha = 0;
    insert(1, hexScaryBg);

    var oldPortrait = Reflect.field(this, "portrait");
    var oldGlow = Reflect.field(this, "porGlow");
    var oldRimlight = Reflect.field(this, "rimlight");
    if (oldPortrait != null) oldPortrait.visible = false;
    if (oldGlow != null) oldGlow.visible = false;
    if (oldRimlight != null) oldRimlight.visible = false;

    var tvScale:Float = scale * 0.65;
    hexTv = new FlxSprite();
    hexTv.frames = Paths.getSparrowAtlas("ui/hex/hex_freeplay/tv");
    hexTv.animation.addByPrefix("idle", "tv.png", 24, true);
    hexTv.animation.addByPrefix("trans", "tvSongTransition", 24, false);
    hexTv.animation.addByPrefix("select", "tvSongSelection", 24, false);
    hexTv.scale.set(tvScale, tvScale);
    hexTv.updateHitbox();
    hexTv.x = FlxG.width * 0.445;
    hexTv.y = (FlxG.height - hexTv.height) * 0.5;
    hexTvBaseX = hexTv.x;
    hexTvBaseY = hexTv.y;
    hexTv.scrollFactor.set();
    hexTv.animation.play("idle");
    hexTv.visible = false;
    add(hexTv);

    hexScaryTv = new FlxSprite();
    hexScaryTv.frames = Paths.getSparrowAtlas("ui/hex/hex_freeplay/tvIris");
    hexScaryTv.animation.addByPrefix("idle", "tvIris.png", 24, true);
    hexScaryTv.animation.addByPrefix("trans", "tvIrisSongTransition", 24, false);
    hexScaryTv.animation.addByPrefix("select", "tvIrisSongSelection", 24, false);
    hexScaryTv.scale.set(tvScale, tvScale);
    hexScaryTv.updateHitbox();
    hexScaryTv.x = hexTvBaseX;
    hexScaryTv.y = hexTvBaseY;
    hexScaryTv.scrollFactor.set();
    hexScaryTv.animation.play("idle");
    hexScaryTv.visible = false;
    add(hexScaryTv);

    hexLogo = new FlxSprite();
    hexLogo.frames = Paths.getSparrowAtlas("ui/hex/hex_freeplay/songlogos");
    for (i in 0...hexLogoIds.length)
    {
        hexLogo.animation.addByPrefix(hexLogoIds[i], hexLogoFrames[i], 24, true);
    }
    hexLogo.scale.set(scale * 0.52, scale * 0.52);
    hexLogo.scrollFactor.set();
    hexLogo.visible = false;
    add(hexLogo);

    hexSongTitle = new FlxText(0, 0, FlxG.width * 0.34, "", Std.int(30 * scale));
    hexSongTitle.setFormat(Paths.font("vcr.ttf"), Std.int(30 * scale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    hexSongTitle.scrollFactor.set();
    hexSongTitle.visible = false;
    add(hexSongTitle);

    hexVersionTag = new FlxSprite();
    hexVersionTag.loadGraphic(Paths.image("ui/hex/hex_freeplay/tag2026"));
    hexVersionTag.scale.set(scale * 0.8, scale * 0.8);
    hexVersionTag.updateHitbox();
    hexVersionTag.scrollFactor.set();
    hexVersionTag.visible = false;
    add(hexVersionTag);

    hexVariantText = new FlxText(0, 0, 220 * scale, "", Std.int(21 * scale));
    hexVariantText.setFormat(Paths.font("vcr.ttf"), Std.int(21 * scale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    hexVariantText.scrollFactor.set();
    hexVariantText.visible = false;
    add(hexVariantText);
}

function onSongChange(songName:String)
{
    hexSongId = hexGetSongId(songName);
    var displayName:Dynamic = Reflect.field(hexV3DisplayNames, hexSongId);
    if (displayName == null) displayName = songName;
    var cardGroup:Dynamic = Reflect.field(this, "cards");
    var selectedIndex:Int = Reflect.field(this, "curSelect");
    if (cardGroup != null && cardGroup.members != null && selectedIndex >= 0 && selectedIndex < cardGroup.members.length)
    {
        var selectedCard = cardGroup.members[selectedIndex];
        if (selectedCard != null && selectedCard.name != null) selectedCard.name.text = displayName;
    }
    hexAvailableVariant = PluginsManager.callPluginFunc("HexV3Version", "getVariant", [hexSongId]);
    hexVisualActive = PluginsManager.callPluginFunc("HexV3Version", "isHexSong", [hexSongId]) == true;
    hexVersion = "";
    PluginsManager.callPluginFunc("HexV3Version", "selectVersion", [hexSongId, ""]);

    hexBg.visible = hexVisualActive;
    hexTv.visible = hexVisualActive;
    hexSongTitle.visible = hexVisualActive;
    hexLogo.visible = false;
    hexVersionTag.visible = false;
    hexVariantText.visible = false;

    var oldPortrait = Reflect.field(this, "portrait");
    var oldGlow = Reflect.field(this, "porGlow");
    var oldRimlight = Reflect.field(this, "rimlight");
    if (oldPortrait != null) oldPortrait.visible = !hexVisualActive;
    if (oldGlow != null) oldGlow.visible = !hexVisualActive;
    if (oldRimlight != null) oldRimlight.visible = !hexVisualActive;

    if (!hexVisualActive)
    {
        stopHexPreview();
        if (FlxG.sound.music != null) FlxG.sound.music.volume = 0.7;
        return;
    }

    if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
    setHexTvOffset(0, 0);
    hexTv.x = hexTvBaseX;
    hexTv.y = hexTvBaseY;
    hexScaryTv.x = hexTvBaseX;
    hexScaryTv.y = hexTvBaseY;
    hexScaryTv.visible = hexVisualActive && hexSongId == "eye2eye";
    hexScaryBg.alpha = 0;
    hexTv.animation.play("trans", true);
    if (hexScaryTv.visible) hexScaryTv.animation.play("trans", true);

    if (hexLogoIds.indexOf(hexSongId) >= 0)
    {
        hexLogo.visible = true;
        hexLogo.animation.play(hexSongId, true);
        hexLogo.x = hexTv.x + hexTv.width * 0.20;
        hexLogo.y = hexTv.y + hexTv.height * 0.37;
    }

    hexSongTitle.text = displayName;
    hexSongTitle.x = hexTv.x + hexTv.width * 0.13;
    hexSongTitle.y = hexTv.y + hexTv.height * 0.79;

    refreshHexVersion();
    playHexPreview();
}

function refreshHexVersion()
{
    if (!hexVisualActive) return;
    hexVersionTag.visible = hexVersion == "new";
    hexVariantText.visible = hexVersion == "erect";
    hexVariantText.text = hexVersion == "erect" ? "ERECT" : "";
    hexVersionTag.x = hexTv.x + hexTv.width * 0.68;
    hexVersionTag.y = hexTv.y + hexTv.height * 0.12;
    hexVariantText.x = hexTv.x + hexTv.width * 0.62;
    hexVariantText.y = hexTv.y + hexTv.height * 0.12;
}

function setHexTvOffset(toX:Float, toY:Float)
{
    var dx:Float = toX - hexTvShakeX;
    var dy:Float = toY - hexTvShakeY;
    if (dx == 0 && dy == 0) return;
    hexTvShakeX = toX;
    hexTvShakeY = toY;
    hexTv.x += dx;
    hexTv.y += dy;
    hexScaryTv.x += dx;
    hexScaryTv.y += dy;
    hexLogo.x += dx;
    hexLogo.y += dy;
    hexSongTitle.x += dx;
    hexSongTitle.y += dy;
    hexVersionTag.x += dx;
    hexVersionTag.y += dy;
    hexVariantText.x += dx;
    hexVariantText.y += dy;
}

function hexAnyPointerPressed():Bool
{
    if (FlxG.mouse.pressed) return true;
    for (touch in FlxG.touches.list) if (touch.pressed) return true;
    return false;
}

function hexPointerOverTv():Bool
{
    if (FlxG.mouse.pressed && FlxG.mouse.overlaps(hexTv)) return true;
    for (touch in FlxG.touches.list)
    {
        if (touch.pressed && touch.overlaps(hexTv)) return true;
    }
    return false;
}

function toggleHexVersion()
{
    if (!hexVisualActive || hexAvailableVariant == null || hexAvailableVariant == "") return;
    hexVersion = hexVersion == "" ? hexAvailableVariant : "";
    PluginsManager.callPluginFunc("HexV3Version", "selectVersion", [hexSongId, hexVersion]);
    refreshHexVersion();
    if (hexTv != null) hexTv.animation.play("trans", true);
    if (hexScaryTv != null && hexScaryTv.visible) hexScaryTv.animation.play("trans", true);
    playHexPreview();
}

function onUpdate(elapsed:Float)
{
    if (!hexVisualActive) return;
    if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;

    if (FlxG.keys.justPressed.V) toggleHexVersion();

    var pointerPressed:Bool = hexAnyPointerPressed();
    if (!pointerPressed) hexHoldDone = false;
    var held:Bool = pointerPressed && !hexHoldDone && hexPointerOverTv();
    if (!held)
    {
        hexHoldTime = 0;
        setHexTvOffset(0, 0);
    }
    else
    {
        hexHoldTime += elapsed;
        if (hexHoldTime >= 1)
        {
            hexHoldDone = true;
            hexHoldTime = 0;
            setHexTvOffset(0, 0);
            FlxG.camera.flash(0xFFFFFFFF, 0.35);
            toggleHexVersion();
        }
        else if (hexHoldTime > 0.25)
        {
            var t:Float = (hexHoldTime - 0.25) / 0.75;
            var reach:Float = 1 + 8 * t * t;
            setHexTvOffset(FlxG.random.float(-reach, reach), FlxG.random.float(-reach, reach));
        }
    }

    var scaryTarget:Float = hexSongId == "eye2eye" ? 1 : 0;
    hexScaryBg.alpha += (scaryTarget - hexScaryBg.alpha) * Math.min(1, elapsed * 4.8);
    if (hexTv.animation.finished && hexTv.animation.name == "trans") hexTv.animation.play("idle");
    if (hexScaryTv.visible && hexScaryTv.animation.finished && hexScaryTv.animation.name == "trans") hexScaryTv.animation.play("idle");
}

function onDestroy()
{
    stopHexPreview();
    if (FlxG.sound.music != null) FlxG.sound.music.volume = 0.7;
}
