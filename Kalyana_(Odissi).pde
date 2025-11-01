/**
 * Kalyana (Odissi) – Just Intonation Poly Synth + Tanpura Drone
 * Keys: q w e r t y u i  => Sa Re Ga Ma# Pa Dha Ni Sa'
 * Hold SPACE for drone (Sa–Pa–Sa’–Pa pulsing tanpura pattern)
 * Z / X = transpose tonic down/up an octave
 */

import processing.core.*;
import processing.sound.*;

final char[] KEY_MAP = { 'q','w','e','r','t','y','u','i' };

// Just-intonation ratios for Kalyana (tivra Ma)
final float[] RATIOS = {
  1.0f/1.0f,   // Sa
  9.0f/8.0f,   // Re
  5.0f/4.0f,   // Ga
  45.0f/32.0f, // Ma# (tivra Ma)
  3.0f/2.0f,   // Pa
  5.0f/3.0f,   // Dha
  15.0f/8.0f,  // Ni
  2.0f/1.0f    // Sa’
};

// ===== CONFIG =====
float SA_HZ = 440.0f;
float NOTE_AMP = 0.22f;
float DRONE_AMP = 0.10f;
float ATTACK_MS = 12;
float RELEASE_MS = 60;

// ===== STATE =====
Voice[] voices = new Voice[KEY_MAP.length];
boolean[] keyHeld = new boolean[KEY_MAP.length];
boolean droneOn = false;

SinOsc[] tanpura = new SinOsc[4];
float[] tanpuraFreqs; 
float tanpuraTimer = 0;
float tanpuraInterval = 1.6f; // seconds per pluck cycle
float transpose = 1.0f; // octave shift (2^n)

void setup() {
  size(760, 380);
  surface.setTitle("Kalyana (Odissi) — Polyphonic Synth + Tanpura Drone");

  for (int i = 0; i < voices.length; i++) {
    voices[i] = new Voice(this, ATTACK_MS, RELEASE_MS);
  }

  // Drone tanpura setup (Sa–Pa–Sa’–Pa)
  tanpuraFreqs = new float[]{
    SA_HZ * RATIOS[0], 
    SA_HZ * RATIOS[4],
    SA_HZ * RATIOS[7],
    SA_HZ * RATIOS[4]
  };
  for (int i=0; i<tanpura.length; i++) {
    tanpura[i] = new SinOsc(this);
  }
  textFont(createFont("Inter", 14, true));
}

void draw() {
  background(12);
  fill(240);
  textSize(16);
  text("Kalyana (Odissi) – Just Intonation Poly Synth + Tanpura Drone", 16, 16);
  text("Sa = " + nf(SA_HZ*transpose,0,2)+" Hz",16,42);
  text("Keys: q–i  Sa Re Ga Ma# Pa Dha Ni Sa’",16,68);
  text("Hold SPACE = Drone   |   Z/X = Octave Down/Up",16,94);

  float dt = 1.0/max(1, frameRate);
  for (int i=0; i<voices.length; i++) voices[i].update(dt);

  if (droneOn) playTanpura(dt);
  drawUI();
}

void drawUI() {
  float x=16, y=140;
  textSize(13);
  for (int i=0;i<KEY_MAP.length;i++){
    boolean held=keyHeld[i];
    float freq=SA_HZ*RATIOS[i]*transpose;
    fill(held?color(120,220,160):color(210));
    rect(x,y,80,46,10);
    fill(20);textAlign(CENTER,CENTER);
    text(KEY_MAP[i]+"\n"+swaraName(i)+"\n"+nf(freq,0,2)+"Hz",x+40,y+23);
    x+=90;
  }
  y+=70;
  fill(droneOn?color(120,220,160):color(210));
  rect(16,y,200,36,10);
  fill(20);textAlign(CENTER,CENTER);
  text(droneOn?"Drone: ON (Sa–Pa–Sa’–Pa)":"Drone: OFF",116,y+18);
}

String swaraName(int i){
  switch (i) {
    case 0: return "Sa";
    case 1: return "Re";
    case 2: return "Ga";
    case 3: return "Ma#";
    case 4: return "Pa";
    case 5: return "Dha";
    case 6: return "Ni";
    case 7: return "Sa’";
    default: return "";
  }
}

// ===== INPUT =====
void keyPressed(){
  if (key==' '){startDrone();return;}
  if (key=='z'){transpose/=2.0f;updateTanpura();return;}
  if (key=='x'){transpose*=2.0f;updateTanpura();return;}

  int idx=indexForKey(key);
  if(idx>=0 && !keyHeld[idx]){
    keyHeld[idx]=true;
    float freq=SA_HZ*RATIOS[idx]*transpose;
    voices[idx].noteOn(freq,NOTE_AMP);
  }
}

void keyReleased(){
  if(key==' '){stopDrone();return;}
  int idx=indexForKey(key);
  if(idx>=0){
    keyHeld[idx]=false;
    voices[idx].noteOff();
  }
}

int indexForKey(char k){
  char c=Character.toLowerCase(k);
  for(int i=0;i<KEY_MAP.length;i++) if(c==KEY_MAP[i]) return i;
  return -1;
}

// ===== TANPURA DRONE =====
void startDrone(){
  if(droneOn)return;
  droneOn=true;
  for(int i=0;i<tanpura.length;i++){
    tanpura[i].play(tanpuraFreqs[i]*transpose,0);
  }
  tanpuraTimer=0;
}

void stopDrone(){
  if(!droneOn)return;
  droneOn=false;
  for(int i=0;i<tanpura.length;i++){
    tanpura[i].stop();
  }
}

void playTanpura(float dt){
  tanpuraTimer+=dt;
  if(tanpuraTimer>tanpuraInterval){
    tanpuraTimer=0;
    // Classic Runnable instead of lambda for compatibility
    Thread t = new Thread(new Runnable(){
      public void run(){
        for(int i=0;i<tanpura.length && droneOn;i++){
          float f=tanpuraFreqs[i]*transpose;
          SinOsc o=tanpura[i];
          o.freq(f);
          o.amp(0);
          // fade in
          for(int s=0;s<=40 && droneOn;s++){
            o.amp(DRONE_AMP*(s/40.0f));
            try{ Thread.sleep(4); } catch(Exception e){}
          }
          // curved fade out
          for(int s=40;s>=0 && droneOn;s--){
            float g = (s/40.0f);
            o.amp(DRONE_AMP*g*g);
            try{ Thread.sleep(6); } catch(Exception e){}
          }
          try{ Thread.sleep(250); } catch(Exception e){}
        }
      }
    });
    t.start();
  }
}

void updateTanpura(){
  for(int i=0;i<tanpuraFreqs.length;i++){
    tanpura[i].freq(tanpuraFreqs[i]*transpose);
  }
}

// ===== VOICE CLASS =====
class Voice{
  final float attackSec,releaseSec;
  SinOsc osc;boolean gate=false,active=false;
  float f=0,amp=0,target=0;

  Voice(PApplet p,float aMs,float rMs){
    attackSec=aMs/1000.0f;
    releaseSec=rMs/1000.0f;
    osc=new SinOsc(p);
  }

  void noteOn(float freq,float peak){
    f=freq;target=peak;
    if(!active){
      osc.play(freq,0); // start silent
      active=true;
    } else {
      osc.freq(freq);
    }
    gate=true;
  }

  void noteOff(){ gate=false; }

  void update(float dt){
    // linear ramp toward target (attack) or zero (release)
    float ramp = gate ? (dt/attackSec) : (dt/releaseSec);
    if (ramp < 0) ramp = 0;
    if (ramp > 1) ramp = 1;

    float dest = gate ? target : 0;
    amp = lerp(amp, dest, ramp);

    osc.amp(amp);
    if (active) osc.freq(f);

    // stop when silent to save CPU
    if (active && !gate && amp < 0.0005f){
      osc.stop();
      active=false;
      amp=0;
    }
  }
}
