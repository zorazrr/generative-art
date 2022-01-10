class RK
{
    String alphabetString;                                         // Index reference
    int prime;                                                     // Prime number
    int[] hashVals;                                                // hash values
    int index;                                                     // first occurance index
    String txt;                                                    // text need to be searched through
    String wd;                                                     // word looking for
    int count = -1;
    int max;                                                       // max hash value

    
    /**
     * @param     txt         long text need to be searched through
     *            wd          word to look for
     *            numOfAlph   the number of Alph exist in txt and wd (counting from `a`)
     */
    RK(String txt, String wd, int numofalph)
    {
        alphabetString = "";
        for(char i = 'a'; i < 'a' + numofalph; i++)
        {
            alphabetString += char(i);
        }
        prime = numofalph;
        hashVals = new int[txt.length() - wd.length() + 1];
        this.txt = txt;
        this.wd = wd;
        max = (int) pow(numofalph, wd.length()) - 1;
        rk();
    }
    
     /**
     * @param     txt         len of the random txt
     *            wd          len of the random wd
     *            numOfAlph   the number of Alph exist in txt and wd (counting from `a`)
     */
    RK(int txtLen, int wdLen, int numofalph)
    {
        this(randString(txtLen, numofalph), randString(wdLen, numofalph), numofalph);
    }
    
    private int getHash(String txt, int index, int exp) {
        int hash = 0;
        char letter = txt.charAt(index);
        hash += alphabetString.indexOf(letter) * pow(prime, exp);
        return hash;
    }

    private void rk() {
        // Get information of the word that we are searching for 
        int wdHash = 0; 
        int wdLen = wd.length();
        for (int i = 0; i < wd.length(); i++) {
            wdHash += getHash(wd, i, i);
        }

        // Get information of the document that we are searching in 
        int txtLen = txt.length(); 
        int txtHash = 0; 

        // get first hash
        for (int i = 0; i < wdLen; i++) {
            txtHash += getHash(txt, i, i);
        }
        
        hashVals[0] = txtHash;

        // rolling hash
        boolean found = false;
        for (int i = wdLen; i < txtLen; i++) {
          
          if (!found && wdHash == txtHash && checkCollision(txt,wd,i)) {
                index = i - wdLen;
                found = true;
            }
            
            int newHash = getHash(txt, i, wdLen - 1);
            int oldHash = getHash(txt, (i - wdLen), 0);
            txtHash = (txtHash - oldHash)/prime + newHash;
            
            hashVals[i - wdLen + 1] = txtHash;
        }
        
        if (!found) {
            if(wdHash == txtHash && checkCollision(txt,wd,txtLen)){
                index = txtLen - wdLen;
            }
            else
            {
                index = -1;
            }
        }
    }
    
    private boolean checkCollision(String txt, String wd, int i){
        int index = i - wd.length();
        boolean holder = true;
        for(int j = 0; j < wd.length(); j++){
          if (txt.charAt(index + j) != wd.charAt(j)){
            holder = false;
          }
        }
        return holder;
    }
    
    // get number from array of hash values, map to min-a, max-b
    float getNext(float a, float b)
    {
        count += 1;
        if(count >= hashVals.length)
            reset();
        return map(hashVals[count],0,max,a,b);
    }
    
    // get number from array of hash values, map to min-0, max-a
    float getNext(float a){
      return getNext(0,a);
    }
    
    // get numbders from array of hash values
    int getNext()
    {
        count += 1;
        if(count >= hashVals.length)
            reset();
        return hashVals[count];
    }
    
    // generate new strings, reset count, redo searching
    void reset()
    {
        this.txt = randString(txt.length(), alphabetString.length());
        println(txt + " " + wd);
        count = 0;
        rk();
    }
    
    void display(){
      for (int i = 0; i < 5; i++){
        float len = constrain(this.getNext(),0,height);
        if ((int)random(2) == 2){
          line(0,width/2, len, width/2);
      }
      else {
        line(height/2, 0, height/2, len);
      }
    }
}
}
