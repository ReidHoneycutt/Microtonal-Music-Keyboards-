import processing.sound.*;

int N = 31;           // number of notes
SinOsc[] oscs;        // one oscillator per note
boolean[] isOn;       // keep track of which notes are on

// 31-EDO frequencies
float[] freqs = new float[N];

// Reference pitch A4 = 440 Hz
float baseFreq = 440.0;
float stepRatio = pow(2, 1.0/31);

// Map keys → notes
char[] keyMap = {
  '1','2','3','4','5','6','7','8','9','0',
  'q','w','e','r','t','y','u','i','o','p',
  'a','s','d','f','g','h','j','k','l','z','x'
};

void setup() {
  size(500, 200);
  
  oscs = new SinOsc[N];
  isOn = new boolean[N];

  // Precompute scale + init oscillators
  for (int i = 0; i < N; i++) {
    freqs[i] = baseFreq * pow(stepRatio, i - 15);
    oscs[i] = new SinOsc(this);
    oscs[i].freq(freqs[i]);
    oscs[i].amp(0);    // start silent
    oscs[i].play();
    isOn[i] = false;
  }
  
  textAlign(CENTER, CENTER);
  textSize(16);
}

void draw() {
  background(0);
  fill(255);
  text("Press [1-0, Q-P, A-L, Z-X] for polyphonic 31-EDO notes", width/2, height/2);
  
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
      oscs[i].amp(0.3);  // turn on
      isOn[i] = true;
      break;
    }
  }
}

void keyReleased() {
  for (int i = 0; i < keyMap.length; i++) {
    if (key == keyMap[i]) {
      oscs[i].amp(0);    // turn off
      isOn[i] = false;
      break;
    }
  }
}
