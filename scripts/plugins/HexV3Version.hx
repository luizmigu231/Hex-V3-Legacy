import funkin.data.Chart;
import funkin.states.PlayState;
import funkin.states.FreeplayState;
import funkin.scripting.PluginsManager;

var hexV3Songs:Array<String> = ["bit", "bombs-n-combs", "cooling", "detected", "dunk", "encore", "eye2eye", "glitcher", "glitcher-remix", "headbasher", "hello-world", "hexcript", "java", "jumpin", "lan", "lcd", "ram", "rightpace", "tangerine", "thatretrosong"];
var hexV3Variants:Dynamic = {};
Reflect.setField(hexV3Variants, "bit", "erect");
Reflect.setField(hexV3Variants, "cooling", "new");
Reflect.setField(hexV3Variants, "detected", "new");
Reflect.setField(hexV3Variants, "dunk", "new");
Reflect.setField(hexV3Variants, "encore", "new");
Reflect.setField(hexV3Variants, "glitcher", "new");
Reflect.setField(hexV3Variants, "hello-world", "new");
Reflect.setField(hexV3Variants, "java", "new");
Reflect.setField(hexV3Variants, "lcd", "new");
Reflect.setField(hexV3Variants, "ram", "new");
var pendingSong:String = "";
var pendingVariant:String = "";

function isHexSong(songId:String):Bool
{
    return hexV3Songs.indexOf(songId) >= 0;
}

function getVariant(songId:String):String
{
    return Reflect.field(hexV3Variants, songId);
}

function selectVersion(songId:String, variant:String):Void
{
    pendingSong = songId;
    pendingVariant = variant;
}

function onStateSwitch(state)
{
    if (!Std.isOfType(state, FreeplayState)) return;
    if (pendingSong == "" || pendingVariant == "") return;
    if (PlayState.SONG == null) return;

    var currentSong:String = Paths.sanitize(PlayState.SONG.song);
    currentSong = StringTools.replace(currentSong, ".", "");
    if (currentSong != pendingSong) return;
    if (getVariant(pendingSong) != pendingVariant) return;

    try
    {
        var chartPath:String = Paths.json(pendingSong + "/data/normal-" + pendingVariant);
        var alternate = Chart.fromPath(chartPath);
        PlayState.SONG = alternate;
        PlayState.storyMeta.difficulty = 1;
        PlayState.isStoryMode = false;
    }
    catch (error:Dynamic)
    {
        trace("[HexV3] Não foi possível carregar a variante " + pendingVariant + " de " + pendingSong + ": " + error);
    }
}
