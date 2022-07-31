#!/usr/bin/python

var("t,u,v")

p=5
q=15
main_rad=8
minor_rad=2
offset=5
width=2
overlap=1
num_points=1000

shift_blue = 0.168
shift_green = -0.105
start_blue = shift_blue-pi/q
start_green = shift_green-pi/q
cut_start = 0
cut_end = 0.1
end_blue = shift_blue+pi/q
end_green = shift_green+pi/q

f = lambda a,b,u,v: vector(((a+b*cos(v)) * cos(u), (a+b*cos(v))*sin(u), b*sin(v)))


g=f(main_rad,minor_rad,p*t,q*t)
h=f(main_rad,minor_rad,-p*t,q*t)


blue_surface = g+u*g.derivative(t).normalized()
green_surface = h+u*h.derivative(t).normalized()


shifted_g = [f(main_rad,minor_rad,p*t+S*2*pi/15,q*t) for S in range(5)]
shifted_h = [f(main_rad,minor_rad,-p*t+S*2*pi/15,q*t) for S in range(5)]

blue_surfaces = [gg +u*gg.derivative(t).normalized() for gg in shifted_g]
green_surfaces = [hh + u*hh.derivative(t).normalized() for hh in shifted_h]




finalmodel = parametric_plot3d(blue_surface, 
        (t,start_blue,end_blue), 
        (u,offset-overlap/2,offset+width-overlap/2), 
        plot_points=(num_points,3), color="blue")

finalmodel += parametric_plot3d(green_surface, 
        (t,start_green,end_green), 
        (u,offset-width+overlap/2,offset+overlap/2), 
        plot_points=(num_points,3), color="darkgreen")

finalmodel = parametric_plot3d(blue_surface, 
        (t,0,2*pi), 
        (u,offset-overlap/2,offset+width-overlap/2), 
        plot_points=(num_points,3), color="blue")
finalmodel += parametric_plot3d(green_surface, 
        (t,0,2*pi), 
        (u,offset-width+overlap/2,offset+overlap/2), 
        plot_points=(num_points,3), color="darkgreen")

for bb in blue_surfaces:
    finalmodel += parametric_plot3d(bb, 
            (t,0,2*pi), 
            (u,offset-overlap/2,offset+width-overlap/2), 
            plot_points=(num_points,3), color="blue")

for gg in green_surfaces:
    finalmodel += parametric_plot3d(gg, 
            (t,0,2*pi), 
            (u,offset-width+overlap/2,offset+overlap/2), 
            plot_points=(num_points,3), color="darkgreen")


def plane_at_ang(theta):
    return parametric_plot3d( (u*cos(theta), u*sin(theta), v), (u,4,16), (v,-4,4), color="pink", alpha=0.5)

finalmodel+=sum(plane_at_ang(i*pi/60) for i in range(4,52,4))

def zigzag(points,surface=blue_surface,start_width=offset,end_width=offset+width,start=start_blue, end=end_blue):
    inc = float(2*pi/q/points)
    zigzag = []
    for t0 in srange(start,end, inc):
        zigzag.append(vector([float(u) for u in surface.subs({t:t0,u:start_width})]))
        zigzag.append(vector([float(u) for u in surface.subs({t:t0,u:end_width})]))
    return zigzag

# see if the line segment a + t(b-a) cuts through the plane at angle theta, for each consecutive (a,b) in the list of points
# if so, return which line segment, and how far along it the intersection occurs
def cutpoints_at_ang(zz, theta, start, end):
    L = []
    for i in range(1,len(zz)):
        (a1, a2, a3) = zz[i-1]
        (b1, b2, b3) = zz[i]
        t = float((a1*tan(theta)-a2)/((b2-a2)-tan(theta)*(b1-a1)))
        if start <= t <= end:
            L.append((i,t))
    return(L)

def find_all_cutpoints(zz, start=-0.1, end=1.1):
    cuts = []
    for i in range(4,52,4):
        cuts.append(cutpoints_at_ang(zz,i*pi/60, start, end))
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

def midline(fzz,t=0.5):
    return [t*fzz[2*i] + (1-t)*fzz[2*i+1] for i in range(len(fzz)//2)]


def makepic(cuts, fzz, filename="torus.svg"):
    G = line(unzigzag(fzz))
    for i,c in enumerate(apply_all_cuts_to_zigzag(cuts, fzz)):
        if i==0:
            G += line(c,color="red")
        else:
            G += line(c,color="black")
    G += line(midline(fzz, float(overlap/2/width)))
    G += line(midline(fzz, float(1 - overlap/2/width)))
    G += line([[-7,0], [-7,5], [-2,5], [-2,0], [-7,0]])
    G.save(filename, aspect_ratio=1, xmin=-15,xmax=15,ymin=-15,ymax=15,axes=False)

def make_flat_blue_surface(points):
    zz = zigzag(points, blue_surface, offset-overlap/2, offset-overlap/2+width, start_blue, end_blue)
    fzz = flatten(zz) 
    cuts = find_all_cutpoints(zz,-0.05,1.05)
    makepic(cuts,fzz,"torus-blue.svg")

def make_flat_green_surface(points):
    zz = zigzag(points, green_surface, offset-width+overlap/2, offset+overlap/2, start_green, end_green)
    fzz = flatten(zz) 
    cuts = find_all_cutpoints(zz,-0.05, 1.05)
    makepic(cuts,fzz,"torus-green.svg")



