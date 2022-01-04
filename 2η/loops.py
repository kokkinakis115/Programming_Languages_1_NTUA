import numpy as np
import sys
sys.setrecursionlimit(100000)

filename=sys.argv[1]
infile = open(sys.argv[1], 'r')
N, M = [int(x) for x in next(infile).split()]
arr = np.zeros((N,M), dtype='U1')
i=0
for line in infile:
    j=0
    for x in line.split():
        for j in range(M):
            arr[i][j] = x[j]
    i = i+1
infile.close()

status = np.full((N,M),False, dtype=bool)

doomed=0

def check_access(u, k, sym):
    global doomed
    if (arr[u][k] == sym) and (status[u][k] == False):
        status[u][k] = True
        doomed+=1
        traverse(u,k)
    return

def traverse(i,j):
    if i-1>=0:
        check_access(i-1,j,'D')
    if i+1<N:
        check_access(i+1,j,'U')
    if j-1>=0:
        check_access(i,j-1,'R')
    if j+1<M:
        check_access(i,j+1,'L')
    return

for x in range(N):
    if (arr[x][0] == 'L'):
        status[x][0]=True
        doomed+=1
        traverse(x,0)
    if (arr[x][M-1] == 'R'):
        status[x][M-1]=True
        doomed+=1
        traverse(x,M-1)

for y in range(M):
    if (arr[0][y] == 'U'):
        status[0][y]=True
        doomed+=1
        traverse(0,y)
    if (arr[N-1][y] == 'D'):
        status[N-1][y]=True
        doomed+=1
        traverse(N-1,y)

print(N*M-doomed)
