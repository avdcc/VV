import static javax.swing.JOptionPane.*;
//import javax.swing.JPasswordField;

// socket
Client client = new Client("localhost", 12345);

// frame
int rJX = 800, rJY = 600;
int menuState;
Button[] btn = new Button[7];
Ranks[]  rnk = new Ranks[2];

void drawInit(){
    if      (btn[5].MouseIsOver()) { fill(color(50)); rect(btn[5].x-2, btn[5].y-2, btn[5].w+4, btn[5].h+4, 10); }
    else if (btn[6].MouseIsOver()) { fill(color(50)); rect(btn[6].x-2, btn[6].y-2, btn[6].w+4, btn[6].h+4, 10); }
    else if (btn[3].MouseIsOver()) { fill(color(50)); rect(btn[3].x-2, btn[3].y-2, btn[3].w+4, btn[3].h+4, 10); }
    else if (btn[4].MouseIsOver()) { fill(color(50)); rect(btn[4].x-2, btn[4].y-2, btn[4].w+4, btn[4].h+4, 10); }
    else    { background(30); }

    fill(255);
    textAlign(RIGHT);
    String res = String.format("%s x %s", rJX, rJY);
    text(res, 780, 20);
    textAlign(CENTER);
    int[] list = {5,6,3,4};
    for (int i: list) btn[i].display();
    //for (Button b: btn) b.display();
}

void drawMenu(){
  
    if      (btn[0].MouseIsOver()) { fill(color(50)); rect(btn[0].x-2, btn[0].y-2, btn[0].w+4, btn[0].h+4, 10); }
    else if (btn[1].MouseIsOver()) { fill(color(50)); rect(btn[1].x-2, btn[1].y-2, btn[1].w+4, btn[1].h+4, 10); }
    else if (btn[2].MouseIsOver()) { fill(color(50)); rect(btn[2].x-2, btn[2].y-2, btn[2].w+4, btn[2].h+4, 10); }
    else if (btn[3].MouseIsOver()) { fill(color(50)); rect(btn[3].x-2, btn[3].y-2, btn[3].w+4, btn[3].h+4, 10); }
    else if (btn[4].MouseIsOver()) { fill(color(50)); rect(btn[4].x-2, btn[4].y-2, btn[4].w+4, btn[4].h+4, 10); }
    else background(30);

    fill(255);
    textAlign(RIGHT);
    String res = String.format("%s x %s", rJX, rJY);
    text(res, 780, 20);
    textAlign(CENTER);
    int[] list = {0,1,2,3,4};
    for (int i: list) btn[i].display();
    //for (Button b: btn) b.display();
}
void drawGame() {
    if(client.gameState == null) menuState = 1;
    else{
        background(255);
        client.gameState.display();
        System.out.println("menuState" + menuState);
    }
}

void draw() {
    switch(menuState){
        case 0: drawInit();     break;
        case 1: drawMenu();     break;
        case 2: drawGame();     break;
    }
}

void setup() {
    size(800,600);
    if (frame != null) { surface.setResizable(true); }
    smooth(4);
    frameRate(60);
    startButtons();
    menuState = 0;
}

boolean login() {
    String user = showInputDialog("Please enter user:");
    String pass = showInputDialog("Please enter password:");
    return client.login(user, pass);
}

boolean signin() {
    String user = showInputDialog("Please enter user:");
    String pass = showInputDialog("Please enter password:");
    if(user==null || pass==null) return false;
    return client.signin(user, pass);
}

void signout(){
    client.singout();
}

boolean play() {
    return client.play();
}

void confirmQuit() {
    if (showConfirmDialog(null, "Do you want to exit?", "Exit", OK_CANCEL_OPTION) == OK_OPTION) { exit(); }
}
