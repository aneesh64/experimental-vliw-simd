x=[1,6,11,16,21,26,31,36,41,46,51,56,61,2,7,12,17,22,27,32,37,42,47,52,57,62,3,8,13,18,23,28]
w=[2,9,16,23,30,5,12,19,26,1,8,15,22,29,4,11,18,25,0,7,14,21,28,3,10,17,24,31,6,13,20,27]
tgt=17568


def dot(a,b):
    return sum(i*j for i,j in zip(a,b))

n=len(x)
hits=[]

# 1) shift w by k (circular)
for k in range(1,n):
    d=dot(x,w[k:]+w[:k])
    if d==tgt:
        hits.append(("shift_w",k,d))

# 2) shift x by k (circular)
for k in range(1,n):
    d=dot(x[k:]+x[:k],w)
    if d==tgt:
        hits.append(("shift_x",k,d))

# 3) chunks of 8 with lane reversal in either x or w
cs=8
for revx in [False,True]:
    for revw in [False,True]:
        if not (revx or revw):
            continue
        xx=[]
        ww=[]
        for i in range(0,n,cs):
            cx=x[i:i+cs]
            cw=w[i:i+cs]
            if revx:
                cx=list(reversed(cx))
            if revw:
                cw=list(reversed(cw))
            xx.extend(cx)
            ww.extend(cw)
        d=dot(xx,ww)
        if d==tgt:
            hits.append(("chunk8_lane_rev",revx,revw,d))

# 4) first/last 24 values
first24=dot(x[:24],w[:24])
last24=dot(x[-24:],w[-24:])
if first24==tgt:
    hits.append(("subset24","first24",first24))
if last24==tgt:
    hits.append(("subset24","last24",last24))

# 5) pair x with itself or w with itself
d_xx=dot(x,x)
d_ww=dot(w,w)
if d_xx==tgt:
    hits.append(("self","x*x",d_xx))
if d_ww==tgt:
    hits.append(("self","w*w",d_ww))

print("dot_xw",dot(x,w))
print("first24",first24)
print("last24",last24)

chunk_rev_x=sum((list(reversed(x[i:i+8])) for i in range(0,n,8)),[])
chunk_rev_w=sum((list(reversed(w[i:i+8])) for i in range(0,n,8)),[])
print("chunk8_rev_x",dot(chunk_rev_x,w))
print("chunk8_rev_w",dot(x,chunk_rev_w))
print("chunk8_rev_both",dot(chunk_rev_x,chunk_rev_w))

print("dot_xx",d_xx)
print("dot_ww",d_ww)
print("hits",hits)
