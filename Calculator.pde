class Calculator {
  private boolean reset;
  private float a, b;
  private char operation;
  private final int displayTextSize = 50;
  private String displayString;

  private Button[] buttons;
  private final String[] texts = {
    "A/C",
    "7", "8", "9", "/",
    "4", "5", "6", "*",
    "1", "2", "3", "-",
    "0", "<<<", "=", "+"};

  public Calculator() {
    reset = false;
    a = 0;
    b = 0;
    operation = 0;
    displayString = "0";

    buttons = new Button[texts.length];

    int padding = 5;
    int x = padding;
    int y = 150;
    int w = (width - 5 * padding) / 4;
    int h = (height - y - 6 * padding) / 5;

    for (int i = 0; i < buttons.length; i++) {
      buttons[i] = new Button(x, y, w, h, texts[i]);
      if (texts[i].equals("=")) buttons[i].setColors(buttons[i].getTextColor(), color(255, 125, 0), buttons[i].getBorderColor());
      if (texts[i].equals("A/C")) buttons[i].setColors(buttons[i].getTextColor(), color(255, 125, 0), buttons[i].getBorderColor());

      if (i == 0) { //move to next row after /
        x = padding;
        y += h + padding;
      } else {
        if (i % 4 == 0) { //new row
          x = padding;
          y += h + padding;
        } else {
          x += w + padding; //next column
        }
      }
    }
  }

  private void checkInput() {
    for (Button b : buttons) {
      if (b.getPressed()) {
        String input = b.getText();

        //if the pressed button is a number, just add it
        float max = Integer.MAX_VALUE;
        if (input.length() == 1 && (input.charAt(0) > 47 && input.charAt(0) < 58) && a * this.b <= max) {
          if (reset) {
            a = 0;
            this.b = 0;
            operation = 0;
            reset = false;
            displayString = "0";
          }
          if (operation == 0 && a < max){ //operation isn't set yet
            a = a * 10 + Integer.parseInt(input);
            if(displayString.equals("0")) displayString = "";
            displayString+=input;
          } else if (this.b < max){ //operation has been set, b may or may not be set
            this.b = this.b * 10 + Integer.parseInt(input);
            if(displayString.substring(displayString.indexOf(operation) + 2).equals("0")){
              displayString = displayString.substring(displayString.indexOf(operation) + 1, displayString.length());
            } else displayString += Integer.parseInt(input);
          }
        } else if (input.equals("=")) { //else, if it was enter
          if (operation == 0) return;
          a = calculate(a, this.b, operation);
          println(a);
          this.b = 0;
          operation = 0;
          reset = true;
          if(Float.toString(a).substring(Float.toString(a).length() - 2, Float.toString(a).length()).equals(".0")){
            displayString = ("" + a).substring(0, ("" + a).length() - 2);
          } else {
            displayString = ("" + a);
          }
        } else if (input.equals("A/C")) { //else reset
          a = 0;
          this.b = 0;
          operation = 0;
          reset = false;
          displayString = "0";
          //else if operation is inputted and there isn't one already
        } else if (a > 0 && this.b == 0 && (input.equals("/") || input.equals("*") || input.equals("-") || input.equals("+"))) {
          reset = false;
          operation = input.charAt(0);
          
          if(displayString.length() > 3){
            char last = displayString.charAt(displayString.length()-2);
            if(last == '/' || last == '*' || last == '-' || last == '+'){
              displayString = displayString.substring(0, displayString.length() - 2) + input + " ";
            } else {
              displayString += " " + operation + " ";
            }
          } else {
            displayString += " " + operation + " ";
          }
        } else if (b.getText().equals("<<<") && a > 0) { //else if it was backspace
          if (operation == 0) {
            if (Float.toString(a).length() <= 3) {
              a = 0;
              displayString = "0";
            } else {
              a = Float.parseFloat(Float.toString(a).substring(0, Float.toString(a).length() - 3));
              displayString = displayString.substring(0, displayString.length() - 1);
            }
          } else if (this.b == 0) {
            displayString = (a + "").substring(0, displayString.indexOf(operation)-1);
            operation = 0;
          } else {
            if (Float.toString(this.b).length() <= 3) {
              this.b = 0;
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + "0";
            } else {
              this.b = Float.parseFloat(Float.toString(this.b).substring(0, Float.toString(this.b).length() - 3));
              displayString = displayString.substring(0, displayString.indexOf(operation) + 2) + this.b;
            }
          }
        }
      }
    }
  }

  private float calculate(float a, float b, char operation) {
    //println("a: " + a + " b: " + b);
    if (operation == '/') {
      if (b != 0) return a / b;
      else return 999999999;
    } else if (operation == '*') return a * b;
    else if (operation == '-') return a - b;
    else return a + b;
  }

  public void display() {
    fill(0);
    textAlign(RIGHT);
    textSize(displayTextSize);
    text(displayString, width - 20, 50);
    for (Button b : buttons) b.display();
  }
}
