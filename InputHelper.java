public class InputHelper
{
  private static final int KEYAMOUNT = 256;

  private static boolean[] keyCodes = new boolean[KEYAMOUNT];
  private static boolean[] keys = new boolean[KEYAMOUNT];

  public static boolean isKeyDown(int key) {
    return keyCodes[key];
  }

  public static boolean isKeyDown(char key) {
    return keys[key];
  }

  //Set the key to true
  public static void onKeyPressed(int keyCode) {
    updateKey(keyCode, true);
  }

  public static void onKeyPressed(char key) {
    updateKey(key, true);
  }

  //Set the key to release to prevent endless loops
  public static void onKeyReleased(int keyCode) {
    updateKey(keyCode, false);
  }

  public static void onKeyReleased(char key) {
    updateKey(key, false);
  }

  //Set the keypressed to true or false
  private static void updateKey(int keyCode, boolean pressed) {
    if (keyCode < keyCodes.length)
      keyCodes[keyCode] = pressed;
  }

  private static void updateKey( char key, boolean pressed) {
    if (key < 65535)
      keys[key] = pressed;
  }
}
