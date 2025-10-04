import processing.sound.*;

int N = 12;  // number of notes in the 11-limit JI scale
SinOsc[] oscs;
boolean[] isOn;
float[] freqs = new float[N];

float baseFreq = 440.0;  // reference pitch A4

// 11-limit Just Intonation ratios (relative to 1/1)
// Includes natural and neutral intervals
float[] ratios = {
  1.0/1.0,   // unison
  9.0/8.0,   // major 2nd
  6.0/5.0,   // minor 3rd
  5.0/4.0,   // major 3rd
  11.0/8.0,  // undecimal (neutral) fourth
  4.0/3.0,   // perfect fourth
  3.0/2.0,   // perfect fifth
  7.0/5.0,   // septimal tritone
  5.0/3.0,   // major sixth
  7.0/4.0,   // harmonic seventh
  15.0/8.0,  // major seventh
  2.0/1.0    // octave
};

// Map 12 keys to notes
char[] keyMap = {
  'a','s','d','f','g','h','j','k','l',';','\'','\\'
};

void setup() {
  size(600, 250);
  
  oscs = new SinOsc[N];
  isOn = new boolean[N];

  // Calculate absolute frequencies from ratios
  for (int i = 0; i < N; i++) {
    freqs[i] = baseFreq * ratios[i];
    
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
  text("11-limit Just Intonation (polyphonic)", width/2, height/2 - 40);
  text("Keys [A - \\] play notes", width/2, height/2 - 20);
  
  // Visual feedback for active notes
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
