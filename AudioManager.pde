import ddf.minim.*;

public static class AudioManager
{
	private static final boolean AUDIO_ENABLED = true;

	private final static int SEQUENTIAL_AUDIO_AMOUNT = 10;
	private final static float AUDIO_DISTSANCE_FALLOFF = 1500;

	private static FYS game;
	private static Minim minim;

	private static HashMap<String, AudioPlayer> musicMap = new HashMap<String, AudioPlayer>();
	private static HashMap<String, AudioPlayer[]> soundEffectMap = new HashMap<String, AudioPlayer[]>();
	private static IntDict soundEffectMapIndex = new IntDict();
	private static FloatDict maxAudioVolumes = new FloatDict();

	public static void setup(FYS game)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioManager.game = game;

		minim = new Minim(game);
	}

	public static void loadMusic(String name, String fileName)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer music = minim.loadFile(fileName);

		if (music == null)
		{
			println("Could not load music: " + fileName);

			return;
		}

		maxAudioVolumes.set(name, 1f);
		musicMap.put(name, music);
	}

	private static int tries = 0;
	private final static int MAX_TRIES = 10;

	public static void loadSoundEffect(String name, String fileName)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		try
		{
			AudioPlayer[] soundArray = new AudioPlayer[SEQUENTIAL_AUDIO_AMOUNT];

			for (int i = 0; i < SEQUENTIAL_AUDIO_AMOUNT; i++)
			{
				AudioPlayer sound = minim.loadFile(fileName);

				if (sound == null)
				{
					println("Could not load sound: " + fileName);

					return;
				}

				soundArray[i] = sound;
			}

			soundEffectMap.put(name, soundArray);
			soundEffectMapIndex.set(name, 0);
			maxAudioVolumes.set(name, 1f);

		}
		catch(Exception e)
		{
			tries++;

			if(tries > MAX_TRIES)
			{
				return;
			}

			loadSoundEffect(name, fileName);
		}
	}

	public static void playSoundEffect(String name)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer[] soundEffects = soundEffectMap.get(name);
		int playAtIndex = soundEffectMapIndex.get(name);
		AudioPlayer soundToPlay = soundEffects[playAtIndex];

		if(soundToPlay == null)
		{
			println("AudioPlayer '" + name + "' not found!");

			return;
		}

		if(playAtIndex < SEQUENTIAL_AUDIO_AMOUNT - 1)
		{
			soundEffectMapIndex.set(name, playAtIndex + 1);
		}
		else
		{
			soundEffectMapIndex.set(name, 0);
		}

		setVolume(soundToPlay, maxAudioVolumes.get(name));
		soundToPlay.play(0);
	}

	public static void playSoundEffect(String name, PVector atLocation)
	{
		// if(!AUDIO_ENABLED)
		// {
		// 	return;
		// }

		AudioPlayer[] soundEffects = soundEffectMap.get(name);
		int playAtIndex = soundEffectMapIndex.get(name);
		AudioPlayer soundToPlay = soundEffects[playAtIndex];

		if(soundToPlay == null)
		{
			println("AudioPlayer '" + name + "' not found!");

			return;
		}

		if (playAtIndex < SEQUENTIAL_AUDIO_AMOUNT - 1)
		{
			soundEffectMapIndex.set(name, playAtIndex + 1);
		}
		else
		{
			soundEffectMapIndex.set(name, 0);
		}

		float volumeBasedOnDistance = game.dist(game.player.position.x, game.player.position.y, atLocation.x, atLocation.y);

		volumeBasedOnDistance /= AUDIO_DISTSANCE_FALLOFF;
		volumeBasedOnDistance = 1 - volumeBasedOnDistance;
		volumeBasedOnDistance = constrain(volumeBasedOnDistance, 0f, 1f);

		if(volumeBasedOnDistance > 0)
		{
			setVolume(soundToPlay, volumeBasedOnDistance * maxAudioVolumes.get(name));
			soundToPlay.play(0);
		}
	}

	public static void playMusic(String name)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer soundToPlay = musicMap.get(name);

		if(soundToPlay == null)
		{
			println("AudioPlayer '" + name + "' not found!");

			return;
		}

		setVolume(soundToPlay, maxAudioVolumes.get(name));
		soundToPlay.play(0);
	}

	public static void stopMusic(String name)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer soundToStop = musicMap.get(name);

		if(soundToStop == null)
		{
			println("AudioPlayer '" + name + "' not found!");

			return;
		}
		
		soundToStop.pause();
    	soundToStop.cue(0);
	}

	public static void loopMusic(String name)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer soundToPlay = musicMap.get(name);

		if(soundToPlay == null)
		{
			println("AudioPlayer '" + name + "' not found!");

			return;
		}

        soundToPlay.cue(0);
		setVolume(soundToPlay, maxAudioVolumes.get(name));
		soundToPlay.loop();
	}

	// volume range [0-1]
	public static void setMaxVolume(String name, float volume)
	{
		if(!AUDIO_ENABLED)
		{
			return;
		}

		AudioPlayer music = musicMap.get(name);

		if(music != null)
		{
			maxAudioVolumes.set(name, volume);
			setVolume(music, volume);
		}

		AudioPlayer[] soundEffects = soundEffectMap.get(name);

		if(soundEffects != null)
		{
			maxAudioVolumes.set(name, volume);

			for (AudioPlayer soundFile : soundEffects)
			{
				setVolume(soundFile, volume);
			}
		}
	}

	// convert volume to gain
	private static void setVolume(AudioPlayer audio, float volume)
	{
		audio.setGain(-60 + volume * 60);
	}
}
