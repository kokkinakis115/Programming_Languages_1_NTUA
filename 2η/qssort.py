from collections import deque
import sys

filename=sys.argv[1]
infile = open(filename, 'r')
N = int(infile.readline())
st = infile.readline()
init = (tuple(map(int, st.split())), () , '')

fin = tuple(sorted(init[0]))
def next(s):
    for i in range(2):
        if s[0] and i==0:
            source = s[0][1:]
            target = list(s[1][:])
            target.append(s[0][0])
            comp = 'Q'
            yield (source, tuple(target), comp)
        elif s[1] and i==1:
            if s[0] and s[1]:
                if s[0][0] == s[1][-1]:
                    break
            source = list(s[0][:])
            source.append(s[1][-1])
            target = s[1][:-1]
            comp = 'S'
            yield (tuple(source), target, comp)


Q = deque([init])
prev = {init: None}
solved = False
while Q:
    s = Q.popleft()
    if s[0]==fin:
        solved = True
        break
    for t in next(s):
        if t not in prev:
            Q.append(t)
            prev[t] = s
answer = ''
if solved:
    while s:
        answer = ''.join((s[2],answer))
        s = prev[s]
if answer == '':
    print('empty\n')
else:
    print(answer)
