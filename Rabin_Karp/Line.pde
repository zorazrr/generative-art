class Line
{
    color c;
    PVector start;
    PVector end;
    int w;
    
    
    Line(PVector start, PVector end)
    {
        this(start,end,color(0));
    }
    
    Line(float startx, float starty, float endx, float endy)
    {
        this(startx, starty, endx, endy, color(0));
    }
    
    Line(float startx, float starty, float endx, float endy, color c)
    {
        this.start = new PVector(startx, starty);
        this.end = new PVector(endx, endy);
        this.c = c;
    }
    
    Line(PVector start, PVector end, color c)
    {
        this(start.x, start.y, end.x, end.y, c);
    }
    
    void display()
    {
        strokeWeight(w);
        stroke(c);
        line(start.x, start.y, end.x, end.y);
    }
}
