import processing.sound.*;

SinOsc[][] oscs;  // [12 chords][4 notes per chord]
boolean[] chordOn;  
boolean major7Mode = false;
boolean minorMode = false;

// Major chord root frequencies for C through B
float[] roots = {
  261.63, // C
  277.18, // C#
  293.66, // D
  311.13, // D#
  329.63, // E
  349.23, // F
  369.99, // F#
  392.00, // G
  415.30, // G#
  440.00, // A
  466.16, // A#
  493.88  // B
};

// Key mappings
char[] chordKeys = {
  'a','s','d','f','g','h','j','k','l',';','\'','\\'
};
char[] maj7Keys = {
  'q','w','e','r','t','y','u','i','o','p','[',']'
};
char[] minorKeys = {
  'z','x','c','v','b','n','m',',','.','/'
};

void setup() {
  size(600, 300);
  oscs = new SinOsc[12][4];
  chordOn = new boolean[12];

  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < 4; j++) {
      oscs[i][j] = new SinOsc(this);
      oscs[i][j].amp(0);
      oscs[i][j].play();
    }
  }

  textAlign(CENTER, CENTER);
  textSize(18);
}

void draw() {
  background(0);
  fill(255);
  text("Press A–\\ for major chords (C–B)", width/2, height/2 - 60);
  text("Hold Q–] for MAJOR 7", width/2, height/2 - 30);
  text("Hold Z–/ for MINOR", width/2, height/2);
  text("Hold both for MINOR 7", width/2, height/2 + 30);

  // Visualize chord state
  for (int i = 0; i < 12; i++) {
    if (chordOn[i]) {
      fill(0, 255, 0);
    } else {
      fill(100);
    }
    ellipse(map(i, 0, 11, 60, width-60), height - 80, 20, 20);
  }
}

void keyPressed() {
  char k = Character.toLowerCase(key);

  // Check modifier keys
  if (isInArray(k, maj7Keys)) {
    major7Mode = true;
    updateAllChords();
  }
  if (isInArray(k, minorKeys)) {
    minorMode = true;
    updateAllChords();
  }

  // Chord triggers
  for (int i = 0; i < chordKeys.length; i++) {
    if (k == chordKeys[i]) {
      playChord(i);
      chordOn[i] = true;
    }
  }
}

void keyReleased() {
  char k = Character.toLowerCase(key);

  // Modifier releases
  if (isInArray(k, maj7Keys)) {
    major7Mode = false;
    updateAllChords();
  }
  if (isInArray(k, minorKeys)) {
    minorMode = false;
    updateAllChords();
  }

  // Stop chords
  for (int i = 0; i < chordKeys.length; i++) {
    if (k == chordKeys[i]) {
      stopChord(i);
      chordOn[i] = false;
    }
  }
}

void playChord(int idx) {
  float root = roots[idx];
  float[] intervals;

  // Determine chord type based on modifiers
  if (minorMode && major7Mode) {
    // Minor 7 chord: 1, m3, P5, m7
    intervals = new float[]{1, 6.0/5.0, 3.0/2.0, 9.0/5.0};
  } else if (minorMode) {
    // Minor triad
    intervals = new float[]{1, 6.0/5.0, 3.0/2.0, 2};
  } else if (major7Mode) {
    // Major 7 chord
    intervals = new float[]{1, 5.0/4.0, 3.0/2.0, 15.0/8.0};
  } else {
    // Major triad
    intervals = new float[]{1, 5.0/4.0, 3.0/2.0, 2};
  }

  for (int i = 0; i < 4; i++) {
    oscs[idx][i].freq(root * intervals[i]);
    oscs[idx][i].amp(0.2);
  }
}

void stopChord(int idx) {
  for (int i = 0; i < 4; i++) {
    oscs[idx][i].amp(0);
  }
}

// Recompute chords when modifier state changes
void updateAllChords() {
  for (int i = 0; i < 12; i++) {
    if (chordOn[i]) playChord(i);
  }
}

boolean isInArray(char c, char[] arr) {
  for (char x : arr) if (x == c) return true;
  return false;
}
