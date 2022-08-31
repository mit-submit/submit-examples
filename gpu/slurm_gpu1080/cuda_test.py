from numba import jit, cuda, float32
import numpy as np
# to measure exec time
from timeit import default_timer as timer

bpg = 108
tpb = 16
n = bpg * tpb
TPB = tpb

@cuda.jit
def fast_matmul(A, B, C):
    # Define an array in the shared memory
    # The size and type of the arrays must be known at compile time
    sA = cuda.shared.array(shape=(TPB, TPB), dtype=float32)
    sB = cuda.shared.array(shape=(TPB, TPB), dtype=float32)

    x, y = cuda.grid(2)

    tx = cuda.threadIdx.x
    ty = cuda.threadIdx.y
    bpg = cuda.gridDim.x    # blocks per grid

    if x >= C.shape[0] and y >= C.shape[1]:
        # Quit if (x, y) is outside of valid C boundary
        return

    # Each thread computes one element in the result matrix.
    # The dot product is chunked into dot products of TPB-long vectors.
    tmp = 0.
    for i in range(bpg):
        # Preload data into shared memory
        sA[tx, ty] = A[x, ty + i * TPB]
        sB[tx, ty] = B[tx + i * TPB, y]

        # Wait until all threads finish preloading
        cuda.syncthreads()

        # Computes partial product on the shared memory
        for j in range(TPB):
            tmp += sA[tx, j] * sB[j, ty]

        # Wait until all threads finish computing
        cuda.syncthreads()

    C[x, y] = tmp

if __name__=="__main__":
    n = 29999
    m = 29999
    a = np.random.randn(n,m).astype('f')
    b = np.random.randn(n,m).astype('f')
    c=a 
    start = timer()
    print("Entering GPU code")
    for i in range(2000):#Running the GPU through many times to keep it busy and test the heat
        fast_matmul[bpg,tpb](a,b,c)
    print("with GPU:", timer()-start)
