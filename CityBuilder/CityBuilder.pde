import processing.serial.*;

/**
 * Edge Detection. 
 * 
 * Exposing areas of contrast within an image 
 * by processing it through a high-pass filter. 
 */
 
Data data;
Data road; 
Data mapNodes; 

PVector pVectors[] = new PVector[100];
PVector pmap[] = new PVector[1000];
PVector roads[][] = new PVector[1000][1000];

int maxX = 0;
int maxY = 0;
int numberOfRoads = 5 ;

boolean isSave = true; 
int numberofNodes;

PVector pmapX[][];

void setup() {
  randomSeed(16);
  pmapX =  new PVector[1800][1800];
  numberofNodes = 0;  
smooth();
  print(pmapX);
  float[][] kernel = { 
    { 
      -1, -1, -1
    }
    , 
    { 
      -1, 9, -1
    }
    , 
    { 
      -1, -1, -1
    }
  };

  size(600, 500);
  PImage img = loadImage("tile.png"); // Load the original image
  image(img, 0, 0); // Displays the image from point (0,0) 
  img.loadPixels();
  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(img.width, img.height, RGB);
  // Loop through every pixel in the image.
  for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(img.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*img.width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();

  noLoop();
  image(edgeImg, 100, 0); // Draw the new image

  if (isSave) {
    data = new Data();
    data.beginSave();

    road = new Data();
    road.beginSave();

    mapNodes = new Data();
    mapNodes.beginSave();
  }
  int startPoint = 0;
  maxX -=10;
  for (int x = 100; x < width; x +=10) {
    for (int y = 100; y < width; y +=10) {

      color c = get(x, y);
      if (c == -1) 
      {
        // cross(x, y);

        //        pmap[maxX] = new PVector(x, y);
        pmapX[maxX][maxY] = new PVector(x, y);
        println(": "+maxX+":_:"+maxY+" :" +pmapX[maxX][maxY]);

        maxY++;

        //       cross(x,y);
        if (random(1) < .008) {
          pVectors[numberofNodes++] = new PVector(x, y);
        }
        if (isSave) {
          // data.add( (x - 100)/3  +" "+ (y -100)/3 );
        }
      }
    }        
    maxX++;
    maxY=0;
  }
  if (isSave) {
    // 
    //    data.endSave(
    //    data.getIncrementalFilename(
    //    sketchPath("save"+
    //      java.io.File.separator+
    //      "data####.txt")));
    //    mapNodes.endSave(
    //    mapNodes.getIncrementalFilename(
    //    sketchPath("save"+
    //      java.io.File.separator+
    //      "buildings####.txt")));
  }
  //print(maxY);
}



void cross(float x, float y ) {
  int d = 1;
  line(x - d, y, x + d, y);
  line(x, y - d, x, y +d);
}

void oldAgo() {
  int index = 0;
  PVector fullLengths[] = new PVector[500];

  for (int i = 0 ; i < numberofNodes ; i ++) {

    ellipse(pVectors[i].x, pVectors[i].y, 10, 10);

    PVector tempLengths[] = new PVector[20];
    int low = 0; 
    for (int j = 0 ; j < numberofNodes ; j ++) 
    {
      if (i != j) {
        float d  = dist(pVectors[i].x, pVectors[i].y, pVectors[j].x, pVectors[j].y);
        tempLengths[i] = new PVector(i, j, d);
        fullLengths[index++] = tempLengths[i];
        //        print(tempLengths[i]);
      }
    }

    tempLengths = null;
  }


  PVector extraLengths[] = new PVector[50];
  //  PVector temp = new PVector(0, 0, 1000000);
  println(numberofNodes);

  for (int all = 0; all < index -1; all++) {
    //    println(fullLengths[all]);
    PVector temp = new PVector(0, 0, 1000000);

    for (int i = all ; i < numberofNodes +all; i++) 
    {
      if (fullLengths[all].z <  temp.z) 
      {
        temp.z = fullLengths[all].z;
        //        println(temp.z);
      }
    }
    extraLengths[all] =  temp;
    //    print(extraLengths[all]);
  }
}
void draw() 
{
  println(""+maxX+" "+maxY );
  println("draw");

  //  ellipse(530,320,20,20);

  for (int j = 0; j < numberOfRoads; j ++)
  {
    int rix = 0; 
    int riy = 0; 

    for (int i = 0; i < 100; i++) {
      rix = int(random(maxX));
      riy = int(random(maxX));
      //      println("trails"+i);
      if (pmapX[rix][riy] != null) 
      {
//        ellipse(pmapX[rix][riy].x, pmapX[rix][riy].y, 10, 10 );
        rix = rix;
        riy = riy;
        break;
      }
    }

    // x      
    if (isSave) { 

      road.add("vertical");
    }
    for (int i = -0; i < 50;i ++) 
    {
      if (pmapX[rix][i] != null) 
      {
        //        ellipse(pmapX[rix][i].x, pmapX[rix][i].y, 4, 4);

        if (isSave) {
          int x = int(pmapX[rix][i].x);
          int y = int(pmapX[rix][i].y);

          road.add(x+" "+0 +" "+ y);
        }
        pmapX[rix][i] = null;
      }
    }
    if (isSave) { 
      road.add("end");
      road.add("horizontal");
    }

    // y
    for (int i = -0; i < 50;i ++) {

      if (pmapX[i][riy] != null) {
        int x = int(pmapX[i][riy].x);
        int y = int(pmapX[i][riy].y);
        fill(i*10, 1, 10 );
        //        ellipse(x, y, 4, 4);
        if (isSave) {
          road.add(x+" "+ 0 + " " +y); // y = z 2d to 3d conversion
        }
        pmapX[i][riy] = null;
      }
    }    
//    if (isSave) 
//      road.add("end");
  }

  println("ar "+maxY);
  fill(100, 100, 100);
  for (int x = 0 ; x < 100 ; x++) {
    for (int y = 0 ; y <  100; y++) {
      if (pmapX[x][y] != null)
      {
        ellipse(pmapX[x][y].x, pmapX[x][y].y, 4, 4);
        if (isSave)
          mapNodes.add(int(pmapX[x][y].x) + " " + 0 + " "+ int(pmapX[x][y].y) );
          
      }
    }
  }
  if (isSave) {

    road.endSave(
    data.getIncrementalFilename(
    sketchPath("save"+
      java.io.File.separator+
      "Road####.txt")));

    mapNodes.endSave(
    mapNodes.getIncrementalFilename(
    sketchPath("save"+
      java.io.File.separator+
      "buildings####.txt")));
  }
}


class Data {
  ArrayList datalist;
  String filename, data[];
  int datalineId;

  // begin data saving
  void beginSave() {
    datalist=new ArrayList();
  }

  void add(String s) {
    datalist.add(s);
  }

  void add(float val) {
    datalist.add(""+val);
  }

  void add(int val) {
    datalist.add(""+val);
  }

  void add(boolean val) {
    datalist.add(""+val);
  }

  void endSave(String _filename) {
    filename=_filename;

    data=new String[datalist.size()];
    data=(String [])datalist.toArray(data);

    saveStrings(filename, data);
    println("Saved data to '"+filename+
      "', "+data.length+" lines.");
  }

  void load(String _filename) {
    filename=_filename;

    datalineId=0;
    data=loadStrings(filename);
    println("Loaded data from '"+filename+
      "', "+data.length+" lines.");
  }

  float readFloat() {
    return float(data[datalineId++]);
  }

  int readInt() {
    return int(data[datalineId++]);
  }

  boolean readBoolean() {
    return boolean(data[datalineId++]);
  }

  String readString() {
    return data[datalineId++];
  }

  // Utility function to auto-increment filenames
  // based on filename templates like "name-###.txt" 

  public String getIncrementalFilename(String templ) {
    String s="", prefix, suffix, padstr, numstr;
    int index=0, first, last, count;
    File f;
    boolean ok;

    first=templ.indexOf('#');
    last=templ.lastIndexOf('#');
    count=last-first+1;

    if ( (first!=-1)&& (last-first>0)) {
      prefix=templ.substring(0, first);
      suffix=templ.substring(last+1);

      // Comment out if you want to use absolute paths
      // or if you're not using this inside PApplet
      if (sketchPath!=null) prefix=savePath(prefix);

      index=0;
      ok=false;

      do {
        padstr="";
        numstr=""+index;
        for (int i=0; i< count-numstr.length(); i++) padstr+="0";
        s=prefix+padstr+numstr+suffix;

        f=new File(s);
        ok=!f.exists();
        index++;

        // Provide a panic button. If index > 10000 chances are it's an
        // invalid filename.
        if (index>10000) ok=true;
      }
      while (!ok);

      // Panic button - comment out if you know what you're doing
      if (index> 10000) {
        println("getIncrementalFilename thinks there is a problem - "+
          "Is there  more than 10000 files already in the sequence "+
          " or is the filename invalid?");
        println("Returning "+prefix+"ERR"+suffix);
        return prefix+"ERR"+suffix;
      }
    }

    return s;
  }
}

