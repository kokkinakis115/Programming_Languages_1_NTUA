#include <utility>
#include <iostream>
#include <stack>
#include <fstream>
using namespace std;


int N, M;
unsigned int doomed = 0;
enum state {current, unvisited, loop, win};
static stack<pair<int, int>> stoiva;

pair<int,int> check_char(char k, int i,int j)
{
    pair<int, int> toreturn;
    switch (k)
    {
        case 'U':
        {
            toreturn.first = i-1;
            toreturn.second = j;
            break;
        }
        case 'D':
        {
            toreturn.first = i+1;
            toreturn.second = j;
            break;
        }
        case 'R':
        {
            toreturn.first = i;
            toreturn.second = j+1;
            break;
        }
        case 'L':
        {
            toreturn.first = i;
            toreturn.second = j-1;
            break;
        }
    }
    return toreturn;
}

pair<int,int> epomeno, trexon;


void update(state u, state *status, pair<int,int> py)
{
      status[py.first*M+py.second] = u;
}

void stack_update(state s,state *status)
{
    while (!stoiva.empty())
    {
        if(s == loop) {doomed++;}
        update(s,status, stoiva.top());
        stoiva.pop();
    }
    return;
}


void traverse(int i, int j, state *status, char a[])
{
    trexon.first = i;
    trexon.second = j;
    stoiva.push(trexon);
    update(current,status,trexon);
    epomeno = check_char(a[i*M+j], i, j);

    if (epomeno.first<0 || epomeno.first == N || epomeno.second<0 || epomeno.second == M)
    {
        stack_update(win, status);
        return;
    }
    else if (status[epomeno.first*M+epomeno.second] == win)
    {
        stack_update(win, status);
        return;
    }
    else if (status[epomeno.first*M+epomeno.second] == loop || status[epomeno.first*M+epomeno.second] == current)
    {
        stack_update(loop, status);
        return;
    }
    else if (status[epomeno.first*M+epomeno.second] == unvisited)
    {
        traverse(epomeno.first, epomeno.second, status, a);
        return;
    }
}

int main(int argc, char **argv)
{
    ifstream myfile;

    myfile.open(argv[1]);



    myfile >> N;
    myfile >> M;

    char a[N*M];
    state status[N*M];

    for(int i=0; i<N; ++i)
    {
      for(int j=0; j<M; ++j)
      {
        status[i*M+j] = unvisited;
        myfile >> a[i*M+j];
      }
    }

    state *otaku;
    otaku = status;

    for(int i=0; i<N; ++i)
    {
        for(int j=0; j<M; ++j)
        {
            if (status[i*M+j] == unvisited)
                traverse(i,j, otaku, a);
        }
    }
    cout <<  doomed << endl;
    return 0;
}
