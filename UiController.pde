public class UIController {

    //Colors
    color titleColor = #FA3535;
    color titleOutline = #FAFA2A;
    color titleBackground = #FFA500;

    PFont font;
    float menuFontSize = 96;
    

    UIController() {
        font = createFont("Fonts/mario_kart_f2.ttf",menuFontSize);
    }

    public void setup() {

    }

    void draw() {
        if (Globals.currentGameState == Globals.gameState.menu) {
            rectMode(CENTER);
            fill(titleBackground);
            rect(width/2, (float)height/4.5, width-menuFontSize*4, menuFontSize*2);
            textAlign(CENTER);
            textFont(font, menuFontSize);
            fill(titleColor);
            text("ROCKY", width/2, height/5);
            text("RAIN", width/2, height/3);
            textFont(font, menuFontSize/2);
            text("Press Enter to start", width/2, height/2);
        }
    }

    // void keyPressed() {
    //     if (keys[Enter]) println("Enter: "+Enter);
    // }

}


