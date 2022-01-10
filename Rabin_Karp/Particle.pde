import java.util.*;


class Particle{
    PVector pos;                  // position
    PVector vel;                  // velocity
    float dia = 20;               // initial size   
    float realDia;               // initial size   
    boolean isVert;                // movement axis
    boolean isRightOrDown;        //movement direction
    boolean diag;                //diagonal movement 
    float layerDia = 5;           // layer width
    int layer = 0;                // number of color layers 
    color c;                      // initial color 
    color[] palette = {#4c99c6, #12375b, #98d9d8, #ffffff, #6fa1d1, #497180}; //#5c7b65, #878787
    IntList colors = new IntList();
    RK rk;
    
    Particle()
    {
        rk = new RK(100,4,6);
        println(rk.index);
        if (rk.index != -1){
          this.palette = new color[1];
          palette[0] = #FFF1CC;
        }
        realDia = dia;
        c = palette[(int)rk.getNext(palette.length)];
        colors.append(c);
        double[] randHolder = {0.2, 0.8};
        // a 1/5 chance that the particle moves in diagonal 
        if ((int)(rk.getNext(5)) == 2){
            // initialize position & velocity with Rabin Karp
            pos = new PVector((int) (randHolder[(int)rk.getNext(2)] * height), (int) (randHolder[(int)rk.getNext(2)] * width));
            vel = new PVector(rk.getNext(1,3), rk.getNext(3,5));
            diag = true;
        }
        else {
            // false: move horizontally
            // true: move vertically 
            isVert = randTruth();
            isRightOrDown = randTruth();
            int dirSign = isRightOrDown? 1:-1;
            
            pos = randStartPos(isVert);
            if(isVert)   vel = new PVector(rk.getNext(3,5) * dirSign, 0);
            else         vel = new PVector(0, rk.getNext(3,5) * dirSign);
        }
    }
    
    Particle(float dia){
      this.dia = dia;
      rk = new RK(100,4,10);
        realDia = dia;
        c = palette[(int)rk.getNext(palette.length)];
        colors.append(c);
        double[] randHolder = {0.2, 0.8};
        // a 1/5 chance that the particle moves in diagonal 
        if ((int)(rk.getNext(5)) == 2){
            // initialize position & velocity with Rabin Karp
            pos = new PVector((int) (randHolder[(int)rk.getNext(2)] * height), (int) (randHolder[(int)rk.getNext(2)] * width));
            vel = new PVector(rk.getNext(1,3), rk.getNext(3,5));
            diag = true;
        }
        else {
            // false: move horizontally
            // true: move vertically 
            isVert = randTruth();
            isRightOrDown = randTruth();
            int dirSign = isRightOrDown? 1:-1;
            
            pos = randStartPos(isVert);
            if(isVert)   vel = new PVector(rk.getNext(3,5) * dirSign, 0);
            else         vel = new PVector(0, rk.getNext(3,5) * dirSign);
        }
    }
    
    // defining a starting position according to the movement direction
    PVector randStartPos(boolean dir)
    {
        //float mean = 0;
        //float sd = 0.6;  // standard devisation
        float rand = rand();
        int sign = randTruth()? -1:1;
        rand = map(rand * sign, -1,1,0.1,0.9);
        if(dir)   return new PVector(width/2, rand*height);
        else      return new PVector(rand*width, height/2);
    }
    
    // a value between 0 and 1 with more value close to 0
    float rand()
    {
        while(true)
        {
            float r1 = rk.getNext(0,1);
            float r2 = rk.getNext(0,1);
            if(r2 < r1)
            {
                return r2;
            }
        }
        // constrain(pow(((randomGaussian() * sd + mean) / 1.5),2),0,1)
    }
    
    
    int randSign()
    {
        return rk.getNext(2) > 1? -1:1;
    }
    
    boolean randTruth()
    {
        return rk.getNext(2) > 1? true:false;
    }
    
    void update()
    {
        pos.add(vel);
    }
    
    // bounce back if particle hits an edge 
    void edges()
    {
        if(pos.x + dia/2 > width)
        {
            vel.x = -1 * Math.abs(vel.x);
            pos.x = width - dia/2;
            isRightOrDown = !isRightOrDown;
        }
        else if(pos.x - dia/2 < 0)
        {
            vel.x = Math.abs(vel.x);
            pos.x = dia/2;
            isRightOrDown = !isRightOrDown;
        }
        else if(pos.y + dia/2 > height)
        {
            vel.y = -1 * Math.abs(vel.y);
            pos.y = height - dia/2;
            isRightOrDown = !isRightOrDown;
        }
        else if(pos.y - dia/2 < 0)
        {
            pos.y = dia/2;
            vel.y = Math.abs(vel.y);
            isRightOrDown = !isRightOrDown;
        }
    }
    
    void addLayer(color col)
    {
        if(diag){
            if(rk.getNext(1) > 0.2)
            {
                return;
            }
        }
        if(rk.getNext(layer+3) > layer)
        {
            layer += 1;
            realDia += layerDia;
            colors.append(col);
        }
    }
    
    void display()
    {
        noStroke();
        //fill(colors.get(colors.size() - 1));
        //ellipse(pos.x, pos.y, dia + layer, dia + layer);
        for (int i = this.layer; i >= 0; i--){
          fill(colors.get(i));
          ellipse(pos.x, pos.y, dia + i * layerDia, dia + i * layerDia);
        }
    }
}
