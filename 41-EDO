import processing.sound.*;

int N = 41;           // number of notes in 41-EDO
SinOsc[] oscs;        // one oscillator per note
boolean[] isOn;       // note on/off states

float[] freqs = new float[N];

// Reference pitch A4 = 440 Hz
float baseFreq = 440.0;
// Step ratio for 41 equal divisions of octave
float stepRatio = pow(2, 1.0/41);

// Keyboard mapping — 41 keys total
char[] keyMap = {
  '1','2','3','4','5','6','7','8','9','0',
  'q','w','e','r','t','y','u','i','o','p',
  'a','s','d','f','g','h','j','k','l',
  'z','x','c','v','b','n','m',',','.','/',';','\''
};

void setup() {
  size(600, 250);
  
  oscs = new SinOsc[N];
  isOn = new boolean[N];
  
  // Calculate 41-EDO frequencies centered around 440 Hz
  for (int i = 0; i < N; i++) {
    // Center the middle note near A4
    freqs[i] = baseFreq * pow(stepRatio, i - N/2);
    
    oscs[i] = new SinOsc(this);
    oscs[i].freq(freqs[i]);
    oscs[i].amp(0);
    oscs[i].play();
    isOn[i] = false;
  }

  textAlign(CENTER, CENTER);
  textSize(16);
}

void draw() {
  background(0);
  fill(255);
  text("Press [1-0, Q-P, A-L, Z-/;’] for 41-EDO polyphonic notes", width/2, height/2 - 40);
  
  // Visual feedback: active notes light up
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
