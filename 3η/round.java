import java.io.*;
import java.util.*;

public class Round {
  public static void main ( String args [] ) {
    try {
      BufferedReader in = new BufferedReader (new FileReader (args[0])) ;
      String line = in . readLine () ;
      String [] num = line . split (" ") ;
      int n = Integer . parseInt (num[0]) ;
      int k = Integer . parseInt (num[1]) ;
      List <Integer> inputline = new ArrayList<Integer>();
      line = in.readLine();
      num = line.split(" ");
      for (int i=0; i<k; i++) {
        Integer a = Integer.parseInt(num[i]);
        inputline.add(a);
      }
      //System.out.println(inputline);
      Solver lysi = new Solver(inputline,n,k);
      int [] sol = new int[2];
      sol=lysi.traverse();
      System.out.print(sol[0]);
      System.out.print(" ");
      System.out.println(sol[1]);
    }
    catch ( IOException e ) {
      e.printStackTrace () ;
    }
  }
}

class Solver {
  private List<Integer> cars;
  private int N;
  private int K;

  public Solver(List<Integer> c,int citiesNo,int carsNo) {
    cars = c;
    N = citiesNo;
    K = carsNo;
  }

  public int[] traverse(){
    //int MAX = 0;
    int SUM = Integer.MAX_VALUE;
    int bestcity=0;

    for (int i = 0; i < N; i++){
      int [] currDif = Tuple(i);
      // System.out.print(currDif[0]);
      // System.out.print(" ");
      // System.out.println(currDif[1]);
      if (currDif[0] < SUM && viable(currDif[0],currDif[1])) {
        //System.out.println("entered");
        SUM = currDif[0];
        bestcity = i;
      }
      else if (currDif[0] < SUM && !viable(currDif[0],currDif[1])){
        boolean isadj = false;
        int athr = 0;
        int athr1 = 0;
        for(int j=0; j<K; j++) {
          athr1 = 0;
          int curr_city = cars.get(j);
          if (curr_city != i) {
            if (curr_city < i) {
              athr1 = i - curr_city;
            }
            else {
              athr1 = N-curr_city+i;
            }
            if ((i+1)%N == curr_city) {
              isadj = true;
            }
            athr = athr + athr1;
          }
        }
        if (isadj) {
          athr = athr + N;
        }
        else {
          athr = athr + 2*N;
        }
        if (athr < SUM) {
          SUM = athr;
          bestcity = i;
        }
      }
    }
    int [] tuple = new int[2];
    tuple[0]=SUM;
    tuple[1]=bestcity;

    return tuple;
  }

  public boolean viable(int mov, int maxx) {
    if (maxx <= mov - maxx + 1)
      return true;
    else
      return false;
  }

  public int [] Tuple(int city) {
    int Moves = 0;
    int Maxx = 0;
    int diaf;
    for (int i=0; i<K; i++) {
      if (city>=cars.get(i)) {
        diaf = city - cars.get(i);
      }
      else {
        diaf = N - cars.get(i) + city;
      }
      Moves = Moves + diaf;
      if (diaf > Maxx)
        Maxx = diaf;
    }
    int [] tuple = new int[2];
    tuple[0]=Moves;
    tuple[1]=Maxx;

    return tuple;
  }
}
