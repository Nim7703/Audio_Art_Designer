/*
 * =====================================================================================
 *
 *       Filename:  Audio_Art_Designer.pde
 *
 *    Description:  An audio-visualisation project for Processing.
 *                  Translates the properties of an audio file into a generative art piece.
 *
 *         Author:  Nimra Rafique
 *
 * =====================================================================================
 */
import ddf.minim.*;
import processing.pdf.*; // pdf export
import java.util.Calendar; // java calendar timestamp
Minim minim;
AudioPlayer song;
AudioMetaData meta;
int spacing = 50; // space between lines in pixels
int border = spacing*2; // top,s left, right, bottom border
int amplification = 1; // frequency amplification factor
int y = spacing;
float ySteps; // number of lines in y direction
float lastx, lasty;
int borderStroke = 8;
int colorviz;

//Colors from Drake new album, #6e9ab4, light blue, #c98d93, pink, #caccd1 - White, #cdc2b6 - Light yellow, #bfd5cc - light green
//Colors from Drake new album, 117,159,191,255, light blue, 199,134,140,255, pink, 206,197,208,255 - White, 214,201,190,255 - Light yellow, 182,206,191,255 - light green



void setup() {
  size(1080, 1080); //1080x1080 for ig post, 1080x1920 for ig story, 360x360 for ig profile
  background(#000000);
  rect(0, 0, width, borderStroke); // Top
  rect(width-borderStroke, 0, borderStroke, height); // Right
  rect(0, height-borderStroke, width, borderStroke); // Bottom
  rect(0, 0, borderStroke, height); // Left
  textFont(createFont("Helvetica", 13)); // set up font
  textAlign(CENTER); // align text to the right
  minim = new Minim(this);
  song = minim.loadFile("The_Weeknd_Sacrifice_LIVE.mp3");
  meta = song.getMetaData(); // load music meta data
  song.play();
 
}

void draw() {
  int screenSize = int((width-2*border)*(height-1.5*border)/spacing);
  int x = int(map(song.position(), 4, song.length(), 4, screenSize)); // current song pos
  ySteps = x/(width-2*border); // number of lines
  x -= (width-2*border)*ySteps; // new x pos in each line
  float freqMix = song.mix.get(int(x));
  float freqLeft = song.left.get(int(x));
  float freqRight = song.right.get(int(x));
  float amplitude = song.mix.level();
  float size = freqMix * spacing * amplification;
  float opacity = map(amplitude, 0.3, 0.5, 80, 0);
  colorviz = (color) random(#7895B4,#87a1bd);
  strokeWeight(amplitude*25);//+ gives an effect, / gives an effect
 
  stroke(random(0),255,255, opacity);
  
 
  //stroke(random(206),197,208, opacity);
  //stroke(random(214),201,190, opacity);
  //stroke(random(182),206,191, opacity);
  if((amplitude > 0)&&(amplitude<=1)) {
  ellipse(x+border,y*ySteps+border,size,size);
  fill(random(colorviz), opacity);
  };
  lastx = x;//gives a cool effect
  lasty = y;//gives a cool effect
}

void position() { // current song position in minutes and
  //seconds
  int totalSeconds = (int)(song.length()/1000) % 60;
  int totalMinutes = (int)(song.length()/(1000*60)) % 60;
  int playheadSeconds = (int)(song.position()/1000) % 60;
  int playheadMinutes = (int)(song.position()/(1000*60)) % 60;
  String info = playheadMinutes + ":" + nf(playheadSeconds, 2 ) + "/" + totalMinutes + ":" +nf(totalSeconds, 2 );
  println(info);
}
void stop() {
  song.close();
  minim.stop();
  super.stop();
}
void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png"); // save png of current
  //frame
  if ((song.isMuted() == false && key == 'S')) song.mute(); // mute song
  else if ((song.isMuted() == true && key == 'S')) song.unmute(); // unmute song
}
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$tH%1$tM%1$tS", now);
}
