import ddf.minim.*;
Minim minim;

 public AudioPlayer mainSong, handgunSound, shotgunSound, openDoor, doorClosed, finishHIM, enemyInjured, enemyDeath, fatality;
 
//Global Variables
 
//Global Variables
 
  //Environment Variables
  //NPC variables
  //NPC start position
    float positionX=0;
    float positionZ=1;
    float positionX2=0;
    float positionZ2=-1;
  //NPC Speed
    float speedX= 10;
    float speedZ= 15;
    float speedX2= 18;
    float speedZ2= 6;
  //character direction
    int xDirection=1;
    int zDirection=1;
    int xDirection2=1;
    int zDirection2=1;
  //Change Sprites
    int mov = 1;
    int mov2= 1;
  //Texture NPC variables
    int numFrames = 8;  // The number of frames in the animation
    int actualFrame = 0;
      
  //Camera Variables
    float x,y,z;
    float rotateX,rotateY, rotateZ;
    float rotX,rotY;
    float mX, mY;
    float frameCounter;
    float xComp, zComp;
    float angle;
  //Movement Variables
    boolean move =false;
    int moveX;
    int moveZ;
    float vY;    
    boolean canJump;
    boolean moveUP,moveDOWN,moveLEFT,moveRIGHT;
      
  /* Constants */
  int ground = 0;
  int totalBoxes = 20;
  int standHeight = 100;
  int movementSpeed = 50;    //Bigger number = slower
  float sensitivity = 15;      //Bigger number = slower
  int centerBox = 80;        /* This used mainly for mouse smoothness. Creates a virtual invisible box, when the mouse leaves it, the rotation begins */
  float camBuffer = 10;
  int cameraDistance = 1000;  //distance from camera to camera target in lookmode... 8?
  
  int FloorSize = 1600;
  float FloorTiling = 6.5f;
   
  //Options
  int lookMode = 8;
  int spotLightMode = 4;
  int cameraMode = 1;
  int moveMode = 2;
  
  /************************* Textures  **********************/
  int actualFrameWeapon = 0;
  int numFramesWeapon = 2;

    //EnemyLife
  float enemyLife = 6;

  PImage[] handGunAnimations = new PImage[8];
  PImage[] shotGunAnimations = new PImage[10];
  
  PImage[] faceAnimations = new PImage[3];
  
  PImage Floor;
  PImage brownWalls;
  PImage bigWalls;
  PImage bigDoor;
  PImage ceiling;
  PImage marble1, marble2;
  
  PImage HUD, face; 
  boolean crouch = false;
  
  /* Weapon */
  PGraphics weapon, doomHUD; 
  int wi = 400, hi = 390;
  float moveWeapon = 0.0f;
  boolean isGoingDown = false;
  boolean isGoingUp = false;
  PImage[][] actualWeapon;
  PImage shotGun;
  public int thisWeapon = 0;
  float thisShoot = 0.0f;
  boolean isShooting = false;
  int shootingAnimation = 0;
    boolean shot, changeTexture;
  
  /* Face Animaion */
  float facePosition = 0.0f;
  boolean isIdle = false;
  
  /* Door */
  float doorUp = 0.0f;
  boolean isDoorGoingUp = false;
  boolean isDoorClosing = false;
  float idleDoor = 0.0f;
  boolean isDoorSoundPlaying = false;
  float idleClosedDoor = 0.0f;
  
  /* Enemy Animations */
  boolean isenemyInjured = false;
  float hurtEnemyTexture = 0.0f;
  
  float animation = 0.0f; 
  
  /* Enemy TYPE 2 */
  ArrayList<EnemyTypeTwo> demonEnemy = new ArrayList<EnemyTypeTwo>();

  public static PImage[] demon = new PImage[3];
  public static PImage[] demonBack = new PImage[3];

  public static PImage[] enemyMove = new PImage[7];
  public static PImage[] enemyDead = new PImage[7];
 
void setup(){
  size(1024,720,P3D);
  noStroke();
  noCursor();
  //************************************************ START load texture 
  enemyMove[0] = loadImage("enemy/enemy-02.png");
  enemyMove[1] = loadImage("enemy/enemy-03.png");
  enemyMove[2] = loadImage("enemy/enemy-04.png");
  enemyMove[3] = loadImage("enemy/enemy-05.png");
  enemyMove[4] = loadImage("enemy/enemy-06.png");
  enemyMove[5] = loadImage("enemy/enemy-07.png");
  enemyMove[6] = loadImage("enemy/enemy-08.png");
  
  enemyDead[0] = loadImage("enemy/muerte-1.png");
  enemyDead[1] = loadImage("enemy/muerte-2.png");
  enemyDead[2] = loadImage("enemy/muerte-3.png");
  enemyDead[3] = loadImage("enemy/muerte-4.png");
  enemyDead[4] = loadImage("enemy/muerte-5.png");
  enemyDead[5] = loadImage("enemy/muerte-6.png");
  enemyDead[6] = loadImage("enemy/muerte-7.png");
  
  demon[0] = loadImage("enemy/enemy-01.png");
  demon[1] = loadImage("enemy/enemy-02.png");
  demon[2] = loadImage("enemy/enemy-05.png");
  
  demonBack[0] = loadImage("enemy/enemy-09.png");
  demonBack[1] = loadImage("enemy/enemy-10.png");
  demonBack[2] = loadImage("enemy/enemy-11.png");


  Floor = loadImage("rockFloor.jpg");
  brownWalls = loadImage("Walls.png");
  bigWalls = loadImage("Big wall.jpg");
  bigDoor = loadImage("BigDoor.png");
  ceiling = loadImage("CeilingT2.png");
  marble1 = loadImage("marble1.png");
  marble2 = loadImage("CeilingT2.png");
   
  weapon = createGraphics(wi, hi, P3D); 
  
  HUD = loadImage("HUD.png");
  doomHUD = createGraphics(width, hi, P2D); 
  
  //******************************************************* END load textures
   
  //Camera Initialization
  x = width/2;
  y = height/2;
    y-= standHeight;
  z = (height/2.0) / tan(PI*60.0 / 360.0);
  rotateX = width/2;
  rotateY = height/2;
  rotateZ = 0;
  rotX = 0;
  rotY = 0;
  xComp = rotateX - x;
  zComp = rotateZ - z;
  angle = 0;
   
  //Movement Initialization
  moveX = 0;
  moveUP = false;
  moveDOWN = false;
  moveLEFT = false;
  moveRIGHT = false; 
  canJump = true;
  vY = 0;
  
      /* Load handgun animations */
  for(int i = 0; i < handGunAnimations.length; i++)
    handGunAnimations[i] = loadImage("Weapons/Handgun/Handgun0" + i + ".png");
    
   /* Load shotgun animations */
  for(int i = 0; i < shotGunAnimations.length; i++)
    shotGunAnimations[i] = loadImage("Weapons/Shotgun/Shotgun0" + i + ".png");
    
   /* Load face animations */
   for(int i = 0; i < faceAnimations.length; i++)
     faceAnimations[i] = loadImage("face/face0" + i + ".png");
     
   face = faceAnimations[0];
 
  weapon = createGraphics(wi, hi, P3D);
  actualWeapon = new PImage[][]{{handGunAnimations[0], handGunAnimations[1], handGunAnimations[2], handGunAnimations[3], handGunAnimations[4], handGunAnimations[4], handGunAnimations[4], handGunAnimations[7]}, {shotGunAnimations[0], shotGunAnimations[1], shotGunAnimations[2], shotGunAnimations[3], shotGunAnimations[4], shotGunAnimations[5], shotGunAnimations[6], shotGunAnimations[7], shotGunAnimations[8], shotGunAnimations[9], shotGunAnimations[0]}};
  
  /* OST */
  minim = new Minim(this);
  mainSong = minim.loadFile("Audio/Music/main.mp3");
  mainSong.loop();
  handgunSound = minim.loadFile("Audio/Sound Effects/handgun.wav");
  handgunSound.setGain(14);
  
  shotgunSound = minim.loadFile("Audio/Sound Effects/shotgun.wav");
  shotgunSound.setGain(14);
  
  openDoor = minim.loadFile("Audio/Sound Effects/doorOpen.wav");
  openDoor.setGain(14);
  
  doorClosed = minim.loadFile("Audio/Sound Effects/doorClose.wav");
  doorClosed.setGain(14);
  
  enemyInjured = minim.loadFile("Audio/Sound Effects/enemyInjured.wav");
  enemyInjured.setGain(14);
  
  enemyDeath = minim.loadFile("Audio/Sound Effects/enemyDeath.wav");
  enemyDeath.setGain(14);
  
  finishHIM = minim.loadFile("Audio/Sound Effects/finish him.mp3");
  finishHIM.setGain(14);
  
  fatality = minim.loadFile("Audio/Sound Effects/fatality.mp3");
  fatality.setGain(14);
  
  finishHIM.play();
  
  demonEnemy.add(new EnemyTypeTwo(800, -700, 6, 0, 0));
  demonEnemy.add(new EnemyTypeTwo(5400, 2550, 6, 2100, 3200));
  demonEnemy.add(new EnemyTypeTwo(8700, 5700, 6, 1300, 6000));
  demonEnemy.add(new EnemyTypeTwo(8700, 5650, 6, -1900, 5650));
  demonEnemy.add(new EnemyTypeTwo(8700, 5650, 6, -1900, 5650));
  /*demonEnemy.add(new EnemyTypeTwo(300, -700, 6, 0, 0));*/
}
 
   void weapon()
{
        pushMatrix();
      weapon.beginDraw();
        weapon.background(255, 0);
        weapon.scale(400);
        weapon.noStroke();
        weapon.translate(0, moveWeapon, 0);
        weapon.beginShape(TRIANGLE_STRIP);
          weapon.texture(actualWeapon[thisWeapon][floor(thisShoot)]);
          weapon.textureMode(NORMAL);
          weapon.vertex(0, 0, 0,  0, 0);
          weapon.vertex(0, 1, 0, 0, 1);
          weapon.vertex(1, 0, 0, 1, 0);
          weapon.vertex(1, 1, 0, 1, 1);
        weapon.endShape();
      weapon.endDraw();
      popMatrix();
      
      /* CHANGING WEAPON */
      if(isGoingDown && moveWeapon < 1.0)
        moveWeapon += 0.08;
        
      if(isGoingDown && moveWeapon >= 1.0){
        thisWeapon = (thisWeapon + 1) % actualWeapon.length;
        isGoingDown = false;
        isGoingUp = true;
      }
      
      if(isGoingUp){
        moveWeapon -= 0.08;
        println(moveWeapon);
       // isChanging = false;
      }
      
      if(isGoingUp && moveWeapon <= 0.0){
        moveWeapon = 0.0;
        isGoingUp = false;
        isGoingDown = false;
      }
      
      if(isShooting && thisWeapon == 0 && thisShoot < 6){
        thisShoot += 0.2;
      }
      
      if(thisWeapon == 0 && thisShoot >= 6){
        thisShoot = 0;
        isShooting = false;
      }
      
      if(thisWeapon == 0 && thisShoot >= 2 && thisShoot < 3){
        shot = true;
        for(EnemyTypeTwo daemon : demonEnemy)
          daemon.shot = true;
      }
      
        if(isShooting && thisWeapon == 1 && thisShoot < 6){
        thisShoot += 0.15;
 
      }
      
      
       if(thisWeapon == 1 && (thisShoot >= 6)){
        thisShoot += 0.12;
      }
      
      if(thisWeapon == 1 && thisShoot >= 10){
        thisShoot = 0;
        isShooting = false;
      }
      
      if(thisWeapon == 1 && thisShoot >= 1 && thisShoot < 2){
        shot = true;
        for(EnemyTypeTwo daemon : demonEnemy)
          daemon.shot = true;
      }
   
 }
 void HUD()
 {
      doomHUD.beginDraw(); 
        doomHUD.beginShape();
            doomHUD.texture(HUD);
            doomHUD.vertex(0,0,0,0); 
            doomHUD.vertex(width, 0,HUD.width,0);
            doomHUD.vertex(width, 100, HUD.width,HUD.height);
            doomHUD.vertex(0, 100,0,HUD.height);
        doomHUD.endShape(); 
      doomHUD.endDraw(); 

       doomHUD.beginDraw();       
         doomHUD.noStroke();
         doomHUD.beginShape();
          doomHUD.texture(faceAnimations[floor(facePosition)]);
          doomHUD.vertex(width/2-35,0,0,0); 
          doomHUD.vertex(width/2+35, 0, face.width,0);
          doomHUD.vertex(width/2+35, face.height-25, face.width, face.height);
          doomHUD.vertex(width/2-35, face.height-25, 0, face.height);
        doomHUD.endShape();
       doomHUD.endDraw();
       
      
      if(!isIdle)
       facePosition = (facePosition + 0.05) % faceAnimations.length;
       
       if(floor(facePosition) == 2){
          facePosition = (facePosition + 0.02) % faceAnimations.length;
          isIdle = true;
       }
   
       
       if(floor(facePosition) == 0)
         isIdle = false;
       
       
 }
   
  void environment()
  {
    // START BIG WALLS
      pushMatrix();
      translate(FloorSize/2,height/2,FloorSize/2);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize, 0, -FloorSize,0,0); 
      vertex(FloorSize, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      beginShape();
      texture(bigWalls);
      vertex(-FloorSize, 0, -FloorSize,0,0); 
      vertex(-FloorSize, 0,  FloorSize, bigWalls.width,0);
      vertex(-FloorSize, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      beginShape();
      texture(bigWalls);
      vertex(-FloorSize, 0, -FloorSize,0,0); 
      vertex(FloorSize, 0,  -FloorSize, bigWalls.width,0);
      vertex(FloorSize, -512, -FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      beginShape();
      texture(bigWalls);
      translate(FloorSize - FloorSize/3,0,0);
      vertex(-FloorSize/2 , 0, FloorSize,0,0); 
      vertex(FloorSize/2 , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2 , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize/2 , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      beginShape();
      texture(bigWalls);
      translate(-FloorSize - FloorSize/3,0,0);
      vertex(-FloorSize/2 , 0, FloorSize,0,0); 
      vertex(FloorSize/2 , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2 , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize/2 , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
       beginShape();
      texture(bigDoor);
      translate(5*FloorSize/6,doorUp,0);
      vertex(-FloorSize/3 , 0, FloorSize,0,0); 
      vertex(0 , 0,  FloorSize, bigWalls.width,0);
      vertex(0 , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize/3 , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      /* Door animations */
      if(isDoorGoingUp && idleDoor < 3)
        idleDoor += 0.1;
      
      if(isDoorGoingUp && doorUp > -FloorSize/4 && idleDoor >= 3)
        doorUp -= 7.0;
      
      /* Is totally open */
      if(isDoorGoingUp && doorUp <= -FloorSize/4){
        if(z >= 3000){
          isDoorClosing = true;
          isDoorGoingUp = false;
          idleDoor = 0;
        }
      }
      
      if(isDoorClosing && idleClosedDoor < 3){
        if(!isDoorSoundPlaying){
          doorClosed.loop();
          doorClosed.play();
          isDoorSoundPlaying = true;
        }
        idleClosedDoor += 0.1;
      }
      
      if(isDoorClosing && doorUp < 0 && idleClosedDoor >= 3)
        doorUp += 7.0;
        
      if(doorUp == 0){
        isDoorClosing = false;
        isDoorSoundPlaying = false;
        idleClosedDoor = 0;
      }
      
      
     popMatrix(); 
     //END MATRIX Big Walls     
     
     //START SECOND ROOM
      pushMatrix();
      translate(FloorSize/2,height/2, 2.5* FloorSize);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize, 0, -FloorSize,0,0); 
      vertex(FloorSize, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
     beginShape();
      texture(bigWalls);
      vertex(-FloorSize, 0, -FloorSize,0,0); 
      vertex(-FloorSize, 0,  FloorSize, bigWalls.width,0);
      vertex(-FloorSize, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      
            beginShape();
      texture(bigWalls);
      translate(FloorSize,0,0);
      vertex(-FloorSize/2 , 0, FloorSize,0,0); 
      vertex(FloorSize/2 , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2 , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize/2 , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      /* RIGHT EXTENDED WALL */
      beginShape();
      texture(bigWalls);
      translate(- 3 * FloorSize,0,0);
      vertex(-FloorSize , 0, FloorSize,0,0); 
      vertex(FloorSize , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      
     /* beginShape();
      texture(bigWalls);
      vertex(-FloorSize , 0, FloorSize,0,0); 
      vertex(FloorSize , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize , -512, FloorSize, 0,bigWalls.height);
      endShape();*/
      
      popMatrix();
      
      /* BASE LEFT WALL */
      pushMatrix();
      translate(FloorSize/2,height/2, 4.5 * FloorSize);
      
      beginShape();
      texture(bigWalls);
      vertex(FloorSize, 0, -FloorSize,0,0); 
      vertex(FloorSize, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize, -512, -FloorSize, 0,bigWalls.height);
      endShape();
     beginShape();
     popMatrix();
     
     /* LEFT WALL */
      pushMatrix();
      translate(FloorSize/2,height/2, 7 * FloorSize);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize/2, 0, -FloorSize,0,0); 
      vertex(FloorSize/2, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize/2, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      popMatrix();
      
      /* BACK WALL */
      pushMatrix();
      beginShape();
      translate(FloorSize/2,height/2, 4.5 * FloorSize);
      texture(bigWalls);
      vertex(-FloorSize , 0, FloorSize,0,0); 
      vertex(FloorSize , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      popMatrix();
      
      /* LEFT SECRET WALL */
      pushMatrix();
      translate(FloorSize/2,height/2, 4.5 * FloorSize);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize/2, 0, -FloorSize,0,0); 
      vertex(FloorSize/2, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize/2, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      popMatrix();
      
      
       /* BACK WALL EXTENDED */
      pushMatrix();
      beginShape();
      translate(-1.5 * FloorSize,height/2, 4.5 * FloorSize);
      texture(bigWalls);
      vertex(-FloorSize , 0, FloorSize,0,0); 
      vertex(FloorSize , 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize , -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(-FloorSize , -512, FloorSize, 0,bigWalls.height);
      endShape();
      
      popMatrix();
      

     
     // START CELLING
     pushMatrix();
      translate(FloorSize/2, height/2,FloorSize/2);   
      beginShape();
      texture(ceiling);
      textureMode(IMAGE);
      textureWrap(REPEAT);
      vertex(-FloorSize, -512, -FloorSize,0,0); 
      vertex(FloorSize, -512,  -FloorSize, ceiling.width , 0 );
      vertex(FloorSize, -512, FloorSize, ceiling.width, ceiling.width);
      vertex(-FloorSize, -512, FloorSize, 0,ceiling.width);
      endShape();
      popMatrix();
    // END CELLING
    
         
     // START CELLING SECOND ROOM
      pushMatrix();
      translate(FloorSize/2, height/2,2.5 * FloorSize);      
      beginShape();
      texture(ceiling);
      vertex(-FloorSize, -512, -FloorSize,0,0); 
      vertex(FloorSize, -512,  -FloorSize, ceiling.width ,0);
      vertex(FloorSize, -512, FloorSize, ceiling.width, ceiling.height);
      vertex(-FloorSize, -512, FloorSize, 0,ceiling.height);
      endShape();
      popMatrix();
      
       pushMatrix();
      translate(FloorSize/2, height/2, 4.5 * FloorSize);      
      beginShape();
      texture(ceiling);
      vertex(-FloorSize, -512, -FloorSize,0,0); 
      vertex(FloorSize, -512,  -FloorSize, ceiling.width,0);
      vertex(FloorSize, -512, FloorSize, ceiling.width, ceiling.height);
      vertex(-FloorSize, -512, FloorSize, 0,ceiling.height);
      endShape();
      popMatrix();
      
      /* Second Part */
      pushMatrix();
      translate(-FloorSize * 1.5, height/2, 4.5 * FloorSize);      
      beginShape();
      texture(ceiling);
      vertex(-FloorSize, -512, -FloorSize,0,0); 
      vertex(FloorSize, -512,  -FloorSize, ceiling.width,0);
      vertex(FloorSize, -512, FloorSize, ceiling.width, ceiling.height);
      vertex(-FloorSize, -512, FloorSize, 0,ceiling.height);
      endShape();
      popMatrix();
    // END CELLING
    
    
   // START PLANE
       pushMatrix();
       translate(FloorSize/2, height/2, FloorSize/2); //MODIFIQUE DE 100 A 0 ************************           
         beginShape();
            texture(Floor);
            vertex(-FloorSize, 0, -FloorSize, 0, 0);
            vertex(FloorSize, 0, -FloorSize, Floor.width, 0);
            vertex(FloorSize,  0, FloorSize, Floor.width, Floor.height);
            vertex(-FloorSize,  0, FloorSize, 0, Floor.height);
         endShape();        
        popMatrix();
    //END PLANE
    
       // START PLANE SECOND ROOM
       //First Part
              pushMatrix();
       translate(FloorSize/2, height/2, 2.5 * FloorSize); //MODIFIQUE DE 100 A 0 ************************           
         beginShape();
            texture(Floor);
            vertex(-FloorSize, 0, -FloorSize, 0, 0);
            vertex(FloorSize, 0, -FloorSize, Floor.width, 0);
            vertex(FloorSize,  0, FloorSize, Floor.width, Floor.height);
            vertex(-FloorSize,  0, FloorSize, 0, Floor.height);
         endShape();        
        popMatrix();
        
        //Second Part
       pushMatrix();
       translate(FloorSize/2, height/2, 4.5 * FloorSize); //MODIFIQUE DE 100 A 0 ************************           
         beginShape();
            texture(Floor);
            vertex(-FloorSize, 0, -FloorSize, 0, 0);
            vertex(FloorSize, 0, -FloorSize, Floor.width, 0);
            vertex(FloorSize,  0, FloorSize, Floor.width, Floor.height);
            vertex(-FloorSize,  0, FloorSize, 0, Floor.height);
         endShape();        
        popMatrix();
        
        //Third Part
       pushMatrix();
       translate(-1.5 * FloorSize, height/2, 4.5 * FloorSize); //MODIFIQUE DE 100 A 0 ************************           
         beginShape();
            texture(Floor);
            vertex(-FloorSize, 0, -FloorSize, 0, 0);
            vertex(FloorSize, 0, -FloorSize, Floor.width, 0);
            vertex(FloorSize,  0, FloorSize, Floor.width, Floor.height);
            vertex(-FloorSize,  0, FloorSize, 0, Floor.height);
         endShape();        
        popMatrix();
    //END PLANE
    
    //STARTING CROPPED WALLS
          pushMatrix();
      translate(-1.5 * FloorSize,height/2, 6 * FloorSize);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize/2, 0, -FloorSize,0,0); 
      vertex(FloorSize/2, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize/2, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      popMatrix();
      
                pushMatrix();
      translate(-3 * FloorSize,height/2, 4.5 * FloorSize);
      beginShape();
      texture(bigWalls);
      vertex(FloorSize/2, 0, -FloorSize,0,0); 
      vertex(FloorSize/2, 0,  FloorSize, bigWalls.width,0);
      vertex(FloorSize/2, -512, FloorSize, bigWalls.width, bigWalls.height);
      vertex(FloorSize/2, -512, -FloorSize, 0,bigWalls.height);
      endShape();
      popMatrix();
     
     
  //  START BOX 1
      //wall 1 
      pushMatrix();
      translate(FloorSize/2, height/2,FloorSize/2);
     
      beginShape();
      texture(brownWalls);
      vertex(-FloorSize+600, 0, FloorSize-1000,0,0); 
      vertex(-FloorSize+600, 0, FloorSize-600 ,brownWalls.width,0);
      vertex(-FloorSize+600, -512, FloorSize-600, brownWalls.width, brownWalls.height);
      vertex(-FloorSize+600, -512, FloorSize-1000,0,brownWalls.height);
      endShape(); 
      //wall 2
      beginShape();
      texture(brownWalls);
      vertex(-FloorSize+1000, 0, FloorSize-1000,0,0); 
      vertex(-FloorSize+1000, 0, FloorSize-600 ,brownWalls.width,0);
      vertex(-FloorSize+1000, -512, FloorSize-600, brownWalls.width, brownWalls.height);
      vertex(-FloorSize+1000, -512, FloorSize-1000,0,brownWalls.height);
      endShape();
      //wall 3
      beginShape();
      texture(brownWalls);
      vertex(-FloorSize+600, 0, FloorSize-1000,0,0); 
      vertex(-FloorSize+1000, 0, FloorSize-1000 ,brownWalls.width,0);
      vertex(-FloorSize+1000, -512, FloorSize-1000, brownWalls.width, brownWalls.height);
      vertex(-FloorSize+600, -512, FloorSize-1000,0,brownWalls.height);
      endShape();
      //wall 4
      beginShape();
      texture(brownWalls);
      vertex(-FloorSize+600, 0, FloorSize-600,0,0); 
      vertex(-FloorSize+1000, 0, FloorSize-600 ,brownWalls.width,0);
      vertex(-FloorSize+1000, -512, FloorSize-600, brownWalls.width, brownWalls.height);
      vertex(-FloorSize+600, -512, FloorSize-600,0,brownWalls.height);
      endShape();      
     
     //  START BOX 2
      //wall 1
      beginShape();
      texture(brownWalls);
      vertex(FloorSize-600, 0, -FloorSize+600,0,0); 
      vertex(FloorSize-600, 0, -FloorSize+1000 ,brownWalls.width,0);
      vertex(FloorSize-600, -512, -FloorSize+1000, brownWalls.width, brownWalls.height);
      vertex(FloorSize-600, -512, -FloorSize+600,0,brownWalls.height);
      endShape(); 
      //wall 2
      beginShape();
      texture(brownWalls);
      vertex(FloorSize-1000, 0, -FloorSize+600,0,0); 
      vertex(FloorSize-1000, 0, -FloorSize+1000 ,brownWalls.width,0);
      vertex(FloorSize-1000, -512, -FloorSize+1000, brownWalls.width, brownWalls.height);
      vertex(FloorSize-1000, -512, -FloorSize+600,0,brownWalls.height);
      endShape();
      //wall 3
      beginShape();
      texture(brownWalls);
      vertex(FloorSize-1000, 0, -FloorSize+600,0,0); 
      vertex(FloorSize-600, 0, -FloorSize+600 ,brownWalls.width,0);
      vertex(FloorSize-600, -512, -FloorSize+600, brownWalls.width, brownWalls.height);
      vertex(FloorSize-1000, -512, -FloorSize+600,0,brownWalls.height);
      endShape();
      //wall 4
      beginShape();
      texture(brownWalls);
      vertex(FloorSize-1000, 0, -FloorSize+1000,0,0); 
      vertex(FloorSize-600, 0, -FloorSize+1000 ,brownWalls.width,0);
      vertex(FloorSize-600, -512, -FloorSize+1000, brownWalls.width, brownWalls.height);
      vertex(FloorSize-1000, -512, -FloorSize+1000,0,brownWalls.height);
      endShape();
     
  /*-------------------Fin del BOX 2 ----------------------------------*/
  popMatrix();  
  
  // END MATRIX BOXES
    
  }
  
   //NPC CREATION
   
   
  void enemy(PImage textura)
  {
      beginShape();
      translate(0,0,0); // *******RE LOCATE Matrix in Center, primary Y
      //rotateY(radians(sqrt(pow(z, 2) + pow(x, 2))));
      texture(textura); //asignar textura
      textureWrap(CLAMP);
      vertex(-100, -200, 0, 0, 0); 
      vertex(100, -200, 0, 102, 0);
      vertex(100, 200, 0, 102, 178);
      vertex(-100, 200, 0, 0, 178);
      endShape();
  }
  
   void enemy(){
    //**********************************************************  NPC  1
  pushMatrix();  
  translate (positionX, height/2 - 120, -positionZ);   //MOVE NPC
  
  //Create  y  Muerte de Enemy
  if(enemyLife > 0){
    //  UPDATE Position in X, Z
    positionX = positionX + (speedX * xDirection); 
    positionZ = positionZ + (speedZ * zDirection);  
   
    if(changeTexture){
      enemy(enemyDead[0]); 
      if(thisWeapon == 0)
        enemyLife--;
       if(thisWeapon == 1)
         enemyLife -= 2;
      enemyInjured.loop();
      enemyInjured.play();
      changeTexture = false;
      isenemyInjured = true;
    }

    if(isenemyInjured){
      isenemyInjured = false;
      hurtEnemyTexture = 5;
    }
    
    /* Enemy Idle */
    if(changeTexture==false && hurtEnemyTexture <= 0)
      enemy(enemyMove[0]);
      
    if(changeTexture==false && hurtEnemyTexture > 0){
      enemy(enemyDead[0]);
      hurtEnemyTexture -= 0.3;
    }
 }
    
  else {
    if(animation <= 0){
      fatality.loop();
      fatality.play();
      enemyDeath.loop();
      enemyDeath.play();
    }
    if(floor(animation) < enemyDead.length - 1)
        animation += 0.1;
    enemy(enemyDead[floor(animation)]);
    positionX = positionX + 0; //Stop enemy
    positionZ = positionZ + 0;
  }

  //  CHANGE Speed in X, z based on PLANE
  if (positionX > FloorSize || positionZ>-FloorSize)
  {
    speedX = random(2, 8);
    speedZ = random(2, 8);    
  }
  
  //  CHANGE DIRECTION
 //  Z
 if (positionZ>FloorSize-800) {
    zDirection*=-1;
 
  }
  if (positionZ<-FloorSize-800) {
    zDirection*=-1;

  }
  // X
   if (positionX>FloorSize+700) {
    xDirection*=-1;

  }
  if (positionX<-FloorSize+800) {
    xDirection*=-1;

  }
   
   // **********************  OBJECT 1 COLLISION wall 1  |
  if (positionX<-FloorSize+1010)
  {
    if (positionX>-FloorSize+990)
    {
      if (positionZ<FloorSize-600)
      {
        if (positionZ>FloorSize-1000)
        {
          println("BOX 1 wall 1"  );
          xDirection*=-1;
          zDirection*=-1;              
        }
      }
    }
  }
  
   // **********************  OBJECT 1 COLLISION wall 2
    if (positionX<-FloorSize+610)
  {
    if (positionX>-FloorSize+590)
    {
      if (positionZ<FloorSize-600)
      {
        if (positionZ>FloorSize-1000)
        {
          println("BOX 1 wall 2"  );
          xDirection*=-1;
          zDirection*=-1;             
        }
      }
    }
  }
  
  // **********************  OBJECT 1 COLLISION wall 3
 if (positionX<-FloorSize+600)
  {
    if (positionX>-FloorSize+1000)
    {println("BOX 1 wall 3"  );
      if (positionZ<FloorSize-990)
      {
        if (positionZ>FloorSize-1010)
        {
          println("BOX 1 wall 3"  );
          xDirection*=-1;
          zDirection*=-1;              
        }
      }
    }
  }
  
  // **********************  OBJECT 1 COLLISION wall 4
  if (positionX<-FloorSize+600)
  {
    if (positionX>-FloorSize+1000)
    {
      if (positionZ<FloorSize-590)
      {
        if (positionZ>FloorSize-610)
        {
          println("BOX 1 wall 4"  );
          xDirection*=-1;
          zDirection*=-1;    
          
        }
      }
    }
  }
    
  // **********************  OBJECT 2 COLLISION wall 1
   if (positionX<FloorSize-610)
  {
    if (positionX>FloorSize-590)
    {
      if (positionZ<-FloorSize+600)
      {
        if (positionZ>-FloorSize+1000)
        {
          println("BOX 2 wall 1"  );
          xDirection*=-1;
          zDirection*=-1; 
        }
      }
    }
  }
  
   // **********************  OBJECT 2 COLLISION wall 2
  if (positionX<FloorSize-990)
  {
    if (positionX>FloorSize-1010)
    {
      if (positionZ<-FloorSize+600)
      {
        if (positionZ>-FloorSize+1000)
        {
          println("BOX 2 wall 2"  );
          xDirection*=-1;
          zDirection*=-1;    
          
        }
      }
    }
  }
  
  // **********************  OBJECT 2 COLLISION wall 3 
  if (positionX<FloorSize-600)
  {
    if (positionX>FloorSize-1000)
    {
      if (positionZ<-FloorSize+590)
      {
        if (positionZ>-FloorSize+610)
        {
          println("BOX 2 wall 3"  );
          xDirection*=-1;
          zDirection*=-1;    
          
        }
      }
    }
  }
  
  // **********************  OBJECT 2 COLLISION wall 4
  if (positionX<FloorSize-600)
  {
    if (positionX>FloorSize-1000)
    {
      if (positionZ<-FloorSize+990)
      {
        if (positionZ>-FloorSize+1010)
        {
          println("BOX 2 wall 3"  );
          xDirection*=-1;
          zDirection*=-1;  
        }
      }
    }
  }
  popMatrix();
  }
 
public void cameraUpdate(){
  if (lookMode == 8){
    int diffX = mouseX - width/2;
    int diffY = mouseY - width/2; /* The width of the screen is more, this is used in order to have the same speed between axis */
     
     /* Camera rotation in X */
    if(abs(diffX) > centerBox){ /* If you are outside the box */
      xComp = rotateX - x; 
      zComp = rotateZ - z;
      angle = correctAngle(xComp,zComp);
        
      angle+= diffX/(sensitivity*10);
       
      if(angle < 0)
        angle += 360;
      else if (angle >= 360)
        angle -= 360;
       
      float newXComp = cameraDistance * sin(radians(angle));
      float newZComp = cameraDistance * cos(radians(angle));
       
      rotateX = newXComp + x;
      rotateZ = -newZComp + z;
     
      /*println("rotateX:    " + rotateX);
      println("rotateZ:    " + rotateZ);*/
      println("X: " +x);
      println("Z: " +z);
        
    }
    
                
    if (abs(diffY) > centerBox)
      rotateY += diffY/(sensitivity/1.5);

  }
  /* Weapon */ 
}
 
public void locationUpdate(){
  
   /*******************************************/
   /****************** Movement ***************/
   /*******************************************/
  if(moveMode == 2){
    if(moveUP){
      z += zComp/movementSpeed;
      rotateZ+= zComp/movementSpeed;
      x += xComp/movementSpeed;
      rotateX+= xComp/movementSpeed;
    }
    if(moveDOWN){
      z -= zComp/movementSpeed;
      rotateZ-= zComp/movementSpeed;
      x -= xComp/movementSpeed;
      rotateX-= xComp/movementSpeed;
    }
    if (moveRIGHT){
      z += xComp/movementSpeed;
      rotateZ+= xComp/movementSpeed;
      x -= zComp/movementSpeed;
      rotateX-= zComp/movementSpeed;
    }
    if (moveLEFT){
      z -= xComp/movementSpeed;
      rotateZ-= xComp/movementSpeed;
      x += zComp/movementSpeed;
      rotateX+= zComp/movementSpeed;
    }
        
  }
  //New method also uses keyPressed() and keyReleased()
  // Scroll Down!
}
 
public void jumpManager(int magnitude){
  move=false;
  if(keyPressed && key == ' ' && canJump){
    vY -= magnitude;
    if(vY < -10)
      canJump = false;
  }
  else if (y < ground+standHeight)
    vY ++;
  else if (y >= ground+standHeight){
    vY = 0;
    y = ground + standHeight;
  }
   
  if((!canJump) && (!keyPressed)){
    println("Jump Reset!");
    canJump = true;
  }
     
  y += vY;
}
 
public void keyPressed(){ //**ADD "w" and "W"
  move = true;
  if(keyCode == UP || key == 'w'  || key == 'W'){
    moveZ = -10;
    moveUP = true;
  }
   
   if(keyCode == DOWN || key == 's'  || key == 'S'){
    moveZ = 10;
    moveDOWN = true;
  }
   
   if(keyCode == LEFT || key == 'a'  || key == 'A'){
    moveX = -10;
    moveLEFT = true;
  }
   
   if(keyCode == RIGHT || key == 'd'  || key == 'D'){
    moveX = 10;
    moveRIGHT = true;
  }
  
   if(key =='z' || key == 'Z'){
    crouch=true;
  }
  
    /* Change Weapons */
  if(!isGoingUp && !isGoingDown)
    if(key == 'r' || key == 'R'){
      isGoingDown = true;
  }
  
  if(z >= 1900 && z < 3000 && !isDoorGoingUp && x < 1100 && x > 300){
    if(key == 'e' || key == 'E'){
      isDoorGoingUp = true;
      openDoor.loop();
      openDoor.play();
    }
  }
}
 
public void keyReleased(){
  move =false;
  if(keyCode == UP || key == 'w'  || key == 'W'){
    moveUP = false;
    moveZ = 0;
  }
  else if(keyCode == DOWN || key == 's'  || key == 'S'){
    moveDOWN = false;
    moveZ = 0;
  }
     
  else if(keyCode == LEFT || key == 'a'  || key == 'A'){
    moveLEFT = false;
    moveX = 0;
  }
   
  else if(keyCode == RIGHT || key == 'd'  || key == 'D'){
    moveRIGHT = false;
    moveX = 0;
  }
  
  else if(key =='z' || key == 'Z'){
    crouch=false;
  }
  
}

void mousePressed(){
  if (mouseButton == LEFT){
    if(!isShooting){
      if(thisWeapon == 0){
        handgunSound.loop();
        handgunSound.play();
        isShooting = true;
      }
       if(thisWeapon == 1){
         shotgunSound.loop();
         shotgunSound.play();
        isShooting = true;
      }
      
             //  DISPARO COLISION  
       boolean collisionDetected = isCollidingBulletEnemy(rotateX, rotateZ, centerBox, positionX, -positionZ, 100, 300); //////////////////////////////////////////////////
       if (collisionDetected == true) {  
           if(shot == true){ println("IMPACTA");changeTexture = true;}
       }
       else {shot=false; changeTexture=false;}
       
       for(EnemyTypeTwo daemon : demonEnemy){
         if(daemon.isCollidingBulletEnemy(rotateX, rotateZ, centerBox, daemon.getPositionX(), 0, 100, 300)){
           if(daemon.shot == true){daemon.setTexture(true);}
           else { daemon.shot = false; daemon.setTexture(false);}
         }
       }
    }
  }
}
 
public float correctAngle(float xc, float zc){
  float newAngle = -degrees(atan(xc/zc));
  if (xComp > 0 && zComp > 0)
    newAngle = (90 + newAngle)+90;
  else if (xComp < 0 && zComp > 0)
    newAngle = newAngle + 180;
  else if (xComp < 0 && zComp < 0)
    newAngle = (90+ newAngle) + 270;
  return newAngle;
}

boolean isCollidingBulletEnemy(
      float lookX, //aim
      float lookY,  //aim
      float aimRadius,  //aimRadius
      float rectangleX,  //positionX
      float rectangleY,  //positionZ
      float rectangleWidth,  //sizeW
      float rectangleHeight  //sizeY    
        )
{
    float positionAimX = abs(lookX - rectangleX - 100/2);
    float positionAimZ = abs(lookY - rectangleY - 300/2);
 
    if (positionAimX > (100/2 + aimRadius)) { return false; }
    if (positionAimZ > (1000)) { return false; }
 
    if (positionAimX <= (100/2)) { return true; }
    if (positionAimZ <= (100)) { return true; }
 
    float cornerDistance_sq = pow(positionAimX - rectangleWidth/2, 2) +
                         pow(positionAimZ - rectangleHeight/2, 2);
 
    return (cornerDistance_sq <= pow(centerBox,2));
}

void draw(){
   
   background(117,98,74);

   hint(ENABLE_DEPTH_TEST);
      
    cameraUpdate();
    locationUpdate();
    jumpManager(10);
    
    HUD();
    weapon();  //Load Weapon
    environment();  //Load Enviromnment

     
  //Camera Mode 1 - Original
    if(cameraMode == 1)
      camera(x,y,z,rotateX,0,rotateZ,0,1,0);
      pushMatrix();
       enemy();
       popMatrix();
       for(EnemyTypeTwo daemon : demonEnemy){
         pushMatrix();
           daemon.movement();
         popMatrix();
       }
     //weapon and HUD 
     pushMatrix();
       camera();
       hint(DISABLE_DEPTH_TEST);
       image(weapon, width/2 - (wi/2), height - (hi + 100));
       image(doomHUD, 0, height-100); 
     popMatrix();
     
}
