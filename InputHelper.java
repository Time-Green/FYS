public class InputHelper
{
    private static final int KEYAMOUNT = 256;

    private static boolean[] keyCodes = new boolean[KEYAMOUNT];
    private static boolean[] keys = new boolean[KEYAMOUNT];

    public static boolean isKeyDown(int key)
    {
        return keyCodes[key];
    }

    public static boolean isKeyDown(char key)
    {
        return keys[key];
    }

    public static void onKeyPressed(int keyCode, char key)
    {
        updateKey(keyCode, key, true);
    }

    public static void onKeyReleased(int keyCode, char key)
    {
        updateKey(keyCode, key, false);
    }

    private static void updateKey(int keyCode, char key, boolean pressed)
    {
        if(key < 65535)
        {
            keys[key] = pressed;
        }

        if(keyCode < keyCodes.length)
        {
            keyCodes[keyCode] = pressed;
        }
    }
}
