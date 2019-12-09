import processing.sound.*;

public static class AudioManager {

  private static FYS game;

  private final static int AUDIO_AMOUNT = 1;
  private final static float AUDIO_DISTSANCE_FALLOFF = 1500;

  private static HashMap<String, SoundFile> musicMap = new HashMap<String, SoundFile>();
  private static HashMap<String, SoundFile[]> soundEffectMap = new HashMap<String, SoundFile[]>();
  private static IntDict soundEffectMapIndex = new IntDict();
  private static FloatDict maxAudioVolumes = new FloatDict();

  public static void setup(FYS game) {
    AudioManager.game = game;
  }

  public static void loadMusic(String name, String fileName) {

    SoundFile music = new SoundFile(game, fileName);

    if (music == null) {
      println("Could not load music: " + fileName);
      return;
    }

    maxAudioVolumes.set(name, 1f);
    musicMap.put(name, music);
  }

  public static void loadSoundEffect(String name, String fileName) {

    SoundFile[] soundArray = new SoundFile[AUDIO_AMOUNT];

    for (int i = 0; i < AUDIO_AMOUNT; i++) {

      SoundFile sound = new SoundFile(game, fileName);

      if (sound == null) {
        println("Could not load sound: " + fileName);
        return;
      }

      soundArray[i] = sound;
    }

    soundEffectMap.put(name, soundArray);
    soundEffectMapIndex.set(name, 0);
    maxAudioVolumes.set(name, 1f);
  }

  public static void playSoundEffect(String name) {
    SoundFile[] soundEffects = soundEffectMap.get(name);
    int playAtIndex = soundEffectMapIndex.get(name);
    SoundFile soundToPlay = soundEffects[playAtIndex];

    if (soundToPlay == null) {
      println("SoundFile '" + name + "' not found!");
      return;
    }

    if (playAtIndex < AUDIO_AMOUNT - 1) {
      soundEffectMapIndex.set(name, playAtIndex + 1);
    } else {
      soundEffectMapIndex.set(name, 0);
    }

    soundToPlay.stop();
    soundToPlay.amp(maxAudioVolumes.get(name));
    soundToPlay.play();
  }

  public static void playSoundEffect(String name, PVector atLocation) {
    SoundFile[] soundEffects = soundEffectMap.get(name);
    int playAtIndex = soundEffectMapIndex.get(name);
    SoundFile soundToPlay = soundEffects[playAtIndex];

    if (soundToPlay == null) {
      println("SoundFile '" + name + "' not found!");
      return;
    }

    if (playAtIndex < AUDIO_AMOUNT - 1) {
      soundEffectMapIndex.set(name, playAtIndex + 1);
    } else {
      soundEffectMapIndex.set(name, 0);
    }

    float volumeBasedOnDistance = game.dist(game.player.position.x, game.player.position.y, atLocation.x, atLocation.y);

    volumeBasedOnDistance /= AUDIO_DISTSANCE_FALLOFF;
    volumeBasedOnDistance = 1 - volumeBasedOnDistance;
    volumeBasedOnDistance = constrain(volumeBasedOnDistance, 0f, 1f);

    if (volumeBasedOnDistance > 0) {
      soundToPlay.stop();
      soundToPlay.amp(volumeBasedOnDistance * maxAudioVolumes.get(name));
      soundToPlay.play();
    }
  }

  public static void playMusic(String name) {
    SoundFile soundToPlay = musicMap.get(name);

    if (soundToPlay == null) {
      println("SoundFile '" + name + "' not found!");
      return;
    }

    soundToPlay.stop();
    soundToPlay.amp(maxAudioVolumes.get(name));
    soundToPlay.play();
  }

  public static void stopMusic(String name) {
    SoundFile soundToStop = musicMap.get(name);

    if (soundToStop == null) {
      println("SoundFile '" + name + "' not found!");
      return;
    }

    soundToStop.stop();
  }

  public static void loopMusic(String name) {
    SoundFile soundToPlay = musicMap.get(name);

    if (soundToPlay == null) {
      println("SoundFile '" + name + "' not found!");
      return;
    }

    soundToPlay.stop();
    soundToPlay.amp(maxAudioVolumes.get(name));
    soundToPlay.loop();
  }

  // volume range [0-1]
  public static void setMaxAudioVolume(String name, float volume) {
    SoundFile music = musicMap.get(name);

    if (music != null) {
      maxAudioVolumes.set(name, volume);
      music.amp(volume);
    }

    SoundFile[] soundEffects = soundEffectMap.get(name);

    if (soundEffects != null) {
      maxAudioVolumes.set(name, volume);

      for (SoundFile soundFile : soundEffects) {
        soundFile.amp(volume);
      }
    }
  }
}
