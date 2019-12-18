class Jukebox extends Obstacle
{
    int musicNotes = 4;
    int travelDistance = 200;
    boolean destroyed = false;
    int numbers = 3;

    Jukebox()
    {
        image = ResourceManager.getImage("Jukebox");
    }

    void update()
    {
        super.update();

        spreadNotes();
        music();
    }

    void spreadNotes()
    {
        //hihi super secret easter egg, groetjes Jordy :)
    }

    void music()
    {
        for (int i = 0; i < numbers; i++)
        {
            AudioManager.playSoundEffect("JukeboxNum" + i);
        }
    }

    void takeDamage(float damageTaken)
    {
        super.takeDamage(damageTaken);

        delete(this);
    }
}
