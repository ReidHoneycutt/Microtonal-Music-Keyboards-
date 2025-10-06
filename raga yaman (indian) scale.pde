import processing.sound.*;

int N = 8;  // number of notes in the raga
SinOsc[] oscs;
boolean[] isOn;
float[] freqs = new float[N];

float baseFreq = 220.0;  // tonic (Sa) = A3 ~ 220 Hz

// Raga Yaman (Kalyan thaat) ratios
float[] ratios = {
  1.0/1.0,   // Sa
  16.0/15.0, // Komal Re
  5.0/4.0,   // Ga
  4.0/3.0,   // Ma
  3.0/2.0,   // Pa
  8.0/5.0,   // Komal Dha
  15.0/8.0,  // Ni
  2.0/1.0    // Sa’
};

// Key layout (8 notes)
char[] keyMap = {'a','s','d','f','g','h','j','k'};

void setup() {
  size(600, 250);
  
  oscs = new SinOsc[N];
  isOn = new boolean[N];

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
  text("Rāga Yaman (Just-tuned, polyphonic)", width/2, height/2 - 40);
  text("Keys [A–K] = Sa Re Ga Ma♯ Pa Dha Ni Sa’", width/2, height/2 - 20);
  
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
