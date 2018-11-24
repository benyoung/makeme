#!/usr/bin/python

# dimers are always (black, white) with black at (0,0)
def dimer(p):
    assert len(p) == 2, "dimers have 2 ends"
    (a,b) = p
    assert len(a) == 2 and len(b)==2, "dimers should have coordinates in the plane"
    assert (a[0]-b[0])**2 + (a[1]-b[1])**2 == 1, "dimers are length 1"
    if ((a[0] - a[1])% 2) == 0:
        return (a,b)
    else:
        return (b,a)

#height function for the all-vertical dimer cover of 2m x 2n rectangle
def flat_hf(m,n):
    rows = []
    for i in range(m):
        rows.append([0,1]*n + [0])
        rows.append([-1,2]*n + [-1])
    rows.append([0,1]*n+[0])
    return rows


def hf_to_dimers(h):
    m = (len(h)-1)/2
    n = (len(h[0])-1)/2
    dimers = set([])
    for i in range(2*m):
        for j in range(2*n):
            if abs(h[i][j] - h[i][j+1]) == 3:
                d = dimer(((i-1,j),(i,j)))
                dimers.add(d)
            if abs(h[i][j] - h[i+1][j]) == 3:
                d = dimer(((i,j-1),(i,j)))
                dimers.add(d)
    return dimers

def vert_dimers(cover):
    return set(d for d in cover if d[0][1] == d[1][1])


def horiz_dimers(cover):
    return set(d for d in cover if d[0][0] == d[1][0])


def horiz_dimers_to_hf(d, m, n):
    h = [[0,1]*n + [0]]
    for i in range(2*m):
        h.append([0]*(2*n+1))

    for i in range(1,2*m+1):
        for j in range(2*n+1):
            if dimer(((i-1,j-1),(i-1,j))) in d:
                if ((i+j)%2) == 0:
                    change = -3
                else:
                    change = 3
            else:
                if ((i+j)%2) == 0:
                    change = 1
                else:
                    change = -1
            h[i][j] = h[i-1][j] + change
    return h

def dimers_to_hf(d):
    max_row, max_col = max(max(d))
    m = int((max_row + 1)/2)
    n = int((max_col + 1)/2)
    return horiz_dimers_to_hf(d, m, n)

mod_four_height = {
    (0,0):0,    (0,1):1,
    (1,0):3,    (1,1):2
}

def min_dimers(m,n):
    dimers = set()
    k = 0
    while len(dimers) < 2*m*n:
        for j in range(k,2*n-k,2):
            dimers.add(dimer(((k,j),(k,j+1))))
            dimers.add(dimer(((2*m-1-k,j),(2*m-1-k,j+1))))
        for i in range(1+k,2*m-1-k,2):
            dimers.add(dimer(((i,k),(i+1,k))))
            dimers.add(dimer(((i,2*n-1-k),(i+1,2*n-1-k))))
        k += 1
    return dimers

def max_dimers(m,n):
    M = matrix(dimers_to_hf(min_dimers(n,m))).transpose()
    return hf_to_dimers(list(M))
    
def blocks(h):
    blocks = []
    m = (len(h)-1)/2
    n = (len(h[0])-1)/2
    hmin = dimers_to_hf(min_dimers(m,n))
    for i in range(1,2*m):
        for j in range(1,2*n):
            for k in range(hmin[i][j], h[i][j], 4):
                blocks.append((i,j,k))
    return blocks

def show_blocks(h):
    pics = []
    for b in blocks(h):
        pics.append(cube(color=(b[2]%2,0,(b[2]+1)%2)).scale([2,2,1]).translate(b))
    show(sum(pics), aspect_ratio=1)






