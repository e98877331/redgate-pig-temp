arr = [1,2,3,4,5,6]

brr = arr[:]

brr[0] = 222
print arr
print brr

out = ""
for i in brr:
    out += str(i)
    out += ", "
print out
print out.rstrip(", ")

