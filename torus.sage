#!/usr/bin/python

var("t,u,v")

p=5
q=17
main_rad=8
minor_rad=2
offset=2
width=2.5
num_points=1000

start = -0.055*(2*pi/q)
cut_start = 0
cut_end = 0.1
end = 2*pi/q+start

f = lambda a,b,u,v: vector(((a+b*cos(v)) * cos(u), (a+b*cos(v))*sin(u), b*sin(v)))

g=f(main_rad,minor_rad,p*t,q*t)
h=f(main_rad,minor_rad,-p*(t+0.5),q*t)

blue_surface = g+u*g.derivative(t).normalized()
green_surface = h+u*h.derivative(t).normalized()

finalmodel = parametric_plot3d(blue_surface, (t,0,2*pi), (u,offset,offset+width), plot_points=(num_points,3), color="blue")
finalmodel += parametric_plot3d(green_surface, (t,0,2*pi), (u,offset,offset+width), plot_points=(num_points,3), color="darkgreen")


def plane_at_ang(theta):
    return parametric_plot3d( (u*cos(theta), u*sin(theta), v), (u,4,12), (v,-4,4), color="pink", alpha=0.5)


#G+=sum(plane_at_ang(i*pi/68) for i in range(5,45,4))

def zigzag(points):
    inc = float(2*pi/q/points)
    zigzag = []
    for t0 in srange(start,end, inc):
        zigzag.append(vector([float(u) for u in blue_surface.subs({t:t0,u:offset})]))
        zigzag.append(vector([float(u) for u in blue_surface.subs({t:t0,u:offset+width})]))
    return zigzag

# see if the line segment a + t(b-a) cuts through the plane at angle theta, for each consecutive (a,b) in the list of points
# if so, return which line segment, and how far along it the intersection occurs
def cutpoints_at_ang(zz, theta):
    L = []
    for i in range(1,len(zz)):
        (a1, a2, a3) = zz[i-1]
        (b1, b2, b3) = zz[i]
        t = float((a1*tan(theta)-a2)/((b2-a2)-tan(theta)*(b1-a1)))
        if -0.1 <= t <= 1.1:
            L.append((i,t))
    return(L)

def find_all_cutpoints(zz):
    cuts = []
    for i in range(5,45,4):
        cuts.append(cutpoints_at_ang(zz,i*pi/68))
    return(cuts)

def place_cutpoints(zz, cutpoints):
    pts = []
    for (i,t) in cutpoints:
        a=zz[i-1]
        b=zz[i]
        pts.append(a + t*(b-a))
    return pts

def show_3d():
    G = parametric_plot3d(blue_surface, (t, start, end), (u,offset,offset+width), plot_points=(num_points//q,3))
    zz = zigzag(200)
    G += line(zz)
    cuts = find_all_cutpoints(zz)
    for c in cuts:
        G += line(place_cutpoints(zz, c), color="black", thickness=15)
    return G


def length(zz,i):
    return float((zz[i]-zz[i-1]).norm())

def zigzag_angle(zz, i):
    v = (zz[i-1]-zz[i]).normalized()
    w = (zz[i+1]-zz[i]).normalized()
    return float((-1)^i*acos(v.dot_product(w)))



def flatten(zz):
    points = [vector((0.0,0.0))]
    ang = 0.0
    for i in range(1,len(zz)-1):
        inc = vector((cos(ang), sin(ang))) * length(zz, i)
        points.append(points[-1]+inc)
        ang = float(pi+ang)+zigzag_angle(zz,i)
    inc = vector((cos(ang), sin(ang))) * length(zz, len(zz)-1)
    points.append(points[-1]+inc)
    return points

def apply_cut_to_zigzag(c,zz):
    points = []
    for (i, t) in c:
        a = zz[i-1]
        b = zz[i]
        points.append(a + t*(b-a))
    return points

def apply_all_cuts_to_zigzag(cuts,zz):
    return [apply_cut_to_zigzag(c,zz) for c in cuts]


def unzigzag(fzz):
    return fzz[::2] + list(reversed(fzz[1::2]))

def midline(fzz):
    return [(fzz[2*i] + fzz[2*i+1])/2 for i in range(len(fzz)//2)]

def makepic(cuts, fzz):
    G = line(unzigzag(fzz))
    for c in apply_all_cuts_to_zigzag(cuts, fzz):
        G += line(c,color="black")
    G += line(midline(fzz))
    G.save("torus.svg", aspect_ratio=1, ymin=-0.5, axes=False)

