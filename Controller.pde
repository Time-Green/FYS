public class Controller {

    private ControlIO control;
    private Configuration config;
    private ControlDevice gpad;

    public Controller () {
        // Initialise the ControlIO
        control = ControlIO.getInstance(FYS.this);
        // Find a device that matches the configuration file
        gpad = control.getMatchedDevice("Game_Controller");
        if (gpad == null) {
            println("No suitable device configured");
            //System.exit(-1); // End the program NOW!
        }
    }

    public boolean isButtonDown(String button) {
        if (gpad.getButton(button).pressed()) return true;
        return false;
    }

    public boolean isSliderDown(String button, boolean negative) {
        if (negative && gpad.getSlider(button).getValue() == -1) return true;
        else if (!negative && gpad.getSlider(button).getValue() == 1) return true;

        return false;       
    }

}


