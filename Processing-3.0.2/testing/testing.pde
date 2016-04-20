import processing.serial.*;

// arduino variables
String val; // Data received from the serial port
Serial port;
boolean firstContact = false;
boolean collision = false;

// pong variables
float ballX = 100;
float ballY = 350;
float ballRadius = 10;
float ballSpeedX = random(3, 5);
float ballSpeedY = random(-3, 3);

// paddle variables
float paddleX = 900;
float paddleY = 350;
float paddleWidth = 10;
float paddleHeight = 50; 
float paddleSpeed = 0;
float paddleSpeedCap = 5;
float paddleSpeedFriction = 0.93;

// game variables
int score = 0;

void setup()
{
  size(1000,700);
  
  port = new Serial(this, Serial.list()[1], 9600);
  port.bufferUntil('\n');
}


void draw()
{ 
  background(255,255,255);
  
  String s = "Score: " + score;
  fill(50);
  textSize(14);
  text(s, 25, 25);
  
  // paddleX = mouseX;
  // paddleY = mouseY;
  if(paddleSpeed > paddleSpeedCap)
  {
    paddleSpeed = paddleSpeedCap;
  }
  
  if(paddleSpeed < -paddleSpeedCap)
  {
    paddleSpeed = -paddleSpeedCap;
  }
  
  paddleY += paddleSpeed;
  paddleSpeed *= paddleSpeedFriction;
  
  if(paddleY - paddleHeight < 0)
  {
    paddleY = paddleHeight;
  }
  
  if(paddleY + paddleHeight > height)
  {
    paddleY = height - paddleHeight;
  }
  
  rectMode(RADIUS);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
  
  ellipseMode(RADIUS);
  ellipse(ballX,ballY,ballRadius,ballRadius);
  
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  if(ballX - ballRadius < 0)
  {
    ballSpeedX = -ballSpeedX;
    ballX += ballSpeedX;
    collision = true;
  }
  
  if(ballX + ballRadius > width)
  {
    score -= 500;
    ballX = 100;
    ballY = 350;
    ballSpeedX = random(3, 5);
    ballSpeedY = random(-3, 3);
  }
  
  if(ballY + ballRadius > height || ballY - ballRadius < 0)
  {
    ballSpeedY = -ballSpeedY;
    ballY += ballSpeedY;
    collision = true;
  }
  
  if((ballX + ballRadius > paddleX - paddleWidth) && (ballX - ballRadius < paddleX + paddleWidth) &&
    (ballY + ballRadius > paddleY - paddleHeight) && (ballY - ballRadius < paddleY + paddleHeight))
    {
      ballSpeedX = -ballSpeedX;
      ballX += ballSpeedX;
      collision = true;
      score += 100;
    }
}


void serialEvent(Serial port)
{
  val = port.readStringUntil('\n');
  
  if(val != null)
  {
    val = trim(val);
    println(val);
    
    if(firstContact == false)
    {
      if(val.equals("A"))
      {
        port.clear();
        firstContact = true;
        port.write("A");
        println("contact");
      }
    }
    else
    {
      println(val);
      
      if(val.equals("up"))
      {
        paddleSpeed = -5;
      }
      
      if(val.equals("down"))
      {
        paddleSpeed = 5;
      }
      
      if(collision == true)
      {
        port.write('1');
        println("1");
        collision = false;
      }
      
      // port.write("A");
    }   
  }
}

void keyPressed()
{
}