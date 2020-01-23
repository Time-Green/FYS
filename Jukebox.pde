//currently disabled because of the particles not working properly after new particle system with multithread
class Jukebox extends Movable
{
    private final float PARTICLE_VELOCITY = 1.0f;
    private final int PARTICLE_DELAY = 30;

    private boolean destroyed = false;
    private int songId;
    private EmittingParticleSystem particleSystem;

    //give the jukebox an position in the world to spawn where otherwise would it be?
    Jukebox(PVector spawnPos)
    {
        position.set(spawnPos);

        image = ResourceManager.getImage("Jukebox");

        particleSystem = new EmittingParticleSystem(new PVector(position.x + 10, position.y + 5), PARTICLE_VELOCITY, PARTICLE_DELAY, true);
        load(particleSystem);

        playRandomMusic();

        // instance in FYS
        //jukebox = this;
    }

    void update()
    {
        super.update();

        // cheeky fix for audio not stopping
        if(position.y < wallOfDeath.position.y)
        {
            takeDamage(1.0f);
        }
    }

    //as it's name suggest a jukebox just randomly plays music in the overworld
    void playRandomMusic()
    {
        songId = floor(random(JUKEBOX_SONG_AMOUNT));

        AudioManager.setMaxVolume("JukeboxMusic" + songId, 0.65f);
        AudioManager.loopMusic("JukeboxMusic" + songId);
    }

    //we need to delete the jukebox and stop all numbers from playing
    void takeDamage(float damageTaken)
    {
        super.takeDamage(damageTaken);

        instantStopMusic();

        delete(particleSystem);
        delete(this);
    }

    void instantStopMusic()
    {
        AudioManager.stopMusic("JukeboxMusic" + songId);
    }

    void stopMusicOverTime(int millis)
    {
        AudioManager.muteOverTime("JukeboxMusic" + songId, millis);
    }
}
