import processing.sound.*;

SinOsc[][] oscs;  // [12 chords][4 notes per chord]
boolean[] chordOn;

// Row modifier states
boolean row2 = false;
boolean row3 = false;
boolean row4 = false;

// Major chord root frequencies for C–B
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

// Row 1 keys → direct major chords
char[] row1Keys = {'z','x','c','v','b','n','m',',','.','/',';','\''};

// Row 2 keys → chord trigger keys (modifier chords)
char[] row2Keys = {'a','s','d','f','g','h','j','k','l',';','\'','\\'};

// Row 3 keys → extensions
char[] row3Keys = {'q','w','e','r','t','y','u','i','o','p','[',']'};

// Row 4 keys → diminished trigger
char[] row4Keys = {'1','2','3','4','5','6','7','8','9','0','-','='};

// Map Row 2 keys to chord indices (same as row1)
char[] chordKeys = row2Keys;

void setup() {
  size(750, 400);
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
  textSize(16);
}

void draw() {
  background(0);
  fill(255);
  text("Row 1 (Z–/) = Major chords directly", width/2, 30);
  text("Row 2 (A–\\) = Chord triggers w/ modifiers", width/2, 50);
  text("Row 3 (Q–]) = 7 extensions | Row 4 (1–=) = Diminished (w/1+2+3)", width/2, 70);
  text("Combinations: 1=Maj | 2=Min | 1+3=Maj7 | 2+3=Min7 | 1+2+3=Dom7 | 1+2+3+4=Dim7", width/2, 95);

  // Visual indicator of which rows are active
  drawRowIndicator(1, false); // Row 1 is direct chords, not modifier
  drawRowIndicator(2, row2);
  drawRowIndicator(3, row3);
  drawRowIndicator(4, row4);

  // Chord activity indicator
  for (int i = 0; i < 12; i++) {
    if (chordOn[i]) fill(0, 255, 0);
    else fill(100);
    ellipse(map(i, 0, 11, 60, width - 60), height - 80, 20, 20);
  }
}

void drawRowIndicator(int rowNum, boolean active) {
  int x = 120 + (rowNum-1)*120;
  fill(active ? color(0,255,0) : 80);
  rect(x, height-50, 100, 30, 5);
  fill(255);
  text("Row "+rowNum, x+50, height-35);
}

void keyPressed() {
  char k = Character.toLowerCase(key);

  // --- Row 1: Major chords directly ---
  int row1Index = getRow1Index(k);
  if (row1Index != -1) {
    playMajorChord(row1Index);
    chordOn[row1Index] = true;
    return;
  }

  // --- Modifier rows ---
  if (isInArray(k, row2Keys)) { row2 = true; updateAllChords(); }
  if (isInArray(k, row3Keys)) { row3 = true; updateAllChords(); }
  if (isInArray(k, row4Keys)) { row4 = true; updateAllChords(); }

  // --- Row 2 chord triggers ---
  for (int i = 0; i < chordKeys.length; i++) {
    if (k == chordKeys[i]) {
      playChord(i);
      chordOn[i] = true;
    }
  }
}

void keyReleased() {
  char k = Character.toLowerCase(key);

  // Row 1 stop
  int row1Index = getRow1Index(k);
  if (row1Index != -1) {
    stopChord(row1Index);
    chordOn[row1Index] = false;
    return;
  }

  // Modifier releases
  if (isInArray(k, row2Keys)) { row2 = false; updateAllChords(); }
  if (isInArray(k, row3Keys)) { row3 = false; updateAllChords(); }
  if (isInArray(k, row4Keys)) { row4 = false; updateAllChords(); }

  // Row 2 chord release
  for (int i = 0; i < chordKeys.length; i++) {
    if (k == chordKeys[i]) {
      stopChord(i);
      chordOn[i] = false;
    }
  }
}

// ---------------- CHORD LOGIC ----------------

void playChord(int idx) {
  float root = roots[idx];
  float[] intervals;

  if (!row2 && !row3 && !row4) {
    intervals = new float[]{1, 5.0/4.0, 3.0/2.0, 2};
  } else if (row2 && !row3 && !row4) {
    // Minor
    intervals = new float[]{1, 6.0/5.0, 3.0/2.0, 2};
  } else if (!row2 && row3 && !row4) {
    // Major 7
    intervals = new float[]{1, 5.0/4.0, 3.0/2.0, 15.0/8.0};
  } else if (row2 && row3 && !row4) {
    // Minor 7
    intervals = new float[]{1, 6.0/5.0, 3.0/2.0, 9.0/5.0};
  } else if (row2 && row3 && row4) {
    // ✅ Fully diminished 7 chord
    intervals = new float[]{
      1,
      pow(2, 3.0/12.0),  // minor third
      pow(2, 6.0/12.0),  // tritone
      pow(2, 9.0/12.0)   // diminished seventh
    };
  } else {
    intervals = new float[]{1, 5.0/4.0, 3.0/2.0, 2};
  }

  for (int i = 0; i < 4; i++) {
    oscs[idx][i].freq(root * intervals[i]);
    oscs[idx][i].amp(0.2);
  }
}

void playMajorChord(int idx) {
  float root = roots[idx];
  float[] intervals = {1, 5.0/4.0, 3.0/2.0, 2};
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

void updateAllChords() {
  for (int i = 0; i < 12; i++) {
    if (chordOn[i]) playChord(i);
  }
}

// ---------------- HELPERS ----------------

int getRow1Index(char k) {
  for (int i = 0; i < row1Keys.length; i++) {
    if (k == row1Keys[i]) return i;
  }
  return -1;
}

boolean isInArray(char c, char[] arr) {
  for (char x : arr) if (x == c) return true;
  return false;
}
