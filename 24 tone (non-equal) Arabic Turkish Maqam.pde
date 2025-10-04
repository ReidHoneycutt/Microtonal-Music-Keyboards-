import processing.sound.*;

int N = 24;            // 24-tone (approx Arabic/Turkish maqam)
SinOsc[] oscs;         // one oscillator per note
boolean[] isOn;        // track which notes are active
float[] freqs = new float[N];

float baseFreq = 440.0;  // reference A4

// Approximate maqam/makam steps in cents (not equally spaced)
// Based roughly on Rast and Hijaz style tunings (microtonal)
float[] cents = {
  0,   90,  204,  294,  386,  498,  588,  702,
  792, 906, 996, 1088, 1200, 1290, 1404, 1494,
  1586, 1698, 1788, 1902, 1992, 2086, 2178, 2290
};

// Map 24 keys to the notes
char[] keyMap = {
  '1','2','3','4','5','6','7','8','9','0','-','=',
  'q','w','e','r','t','y','u','i','o','p','[',']'
};

void setup() {
  size(640, 260);
  
  oscs = new SinOsc[N];
  isOn = new boolean[N];

  // Precompute note frequencies and initialize oscillators
  for (int i = 0; i < N; i++) {
    float ratio = pow(2, cents[i] / 1200.0);
    freqs[i] = baseFreq * ratio;
    
    oscs[i] = new SinOsc(this);
    oscs[i].freq(freqs[i]);
    oscs[i].amp(0);     // start silent
    oscs[i].play();
    isOn[i] = false;
  }
  
  textAlign(CENTER, CENTER);
  textSize(16);
}

void draw() {
  background(0);
  fill(255);
  text("Arabic/Turkish Maqam (~24-tone, non-equal) - Polyphonic", width/2, height/2 - 40);
  text("Play with keys [1-=, Q-]]", width/2, height/2 - 20);
  
  // Visualize which notes are active
  fill(0, 255, 0);
  for (int i = 0; i < N; i++) {
    if (isOn[i]) {
      ellipse(map(i, 0, N-1, 50, width-50), height/2 + 40, 10, 10);
    }
  }
}

void keyPressed() {
  for (int i = 0; i < keyMap.length; i++) {
    if (key == keyMap[i]) {
      oscs[i].amp(0.3);
      isOn[i] = true;
      break;
    }
  }
}

void keyReleased() {
  for (int i = 0; i < keyMap.length; i++) {
    if (key == keyMap[i]) {
      oscs[i].amp(0);
      isOn[i] = false;
      break;
    }
  }
}
