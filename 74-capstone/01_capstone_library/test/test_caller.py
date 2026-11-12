import ctypes
import sys

def test():
    if len(sys.argv) < 2:
        print("Usage: python3 test_caller.py <path_to_so>")
        sys.exit(1)
        
    lib_path = sys.argv[1]
    lib = ctypes.CDLL(lib_path)
    
    # void interp1d_linear(int n, const double *x, const double *y, int nq, const double *xq, double *yq, int *stat)
    lib.interp1d_linear.argtypes = [
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_double),
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_double),
        ctypes.POINTER(ctypes.c_double),
        ctypes.POINTER(ctypes.c_int)
    ]
    lib.interp1d_linear.restype = None

    x = (ctypes.c_double * 4)(0.0, 1.0, 2.0, 4.0)
    y = (ctypes.c_double * 4)(0.0, 10.0, 20.0, 40.0)
    xq = (ctypes.c_double * 3)(0.5, 1.5, 3.0)
    yq = (ctypes.c_double * 3)()
    stat = ctypes.c_int(0)

    lib.interp1d_linear(4, x, y, 3, xq, yq, ctypes.byref(stat))
    if stat.value != 0:
        raise RuntimeError(f"Error stat: {stat.value}")
    if abs(yq[0] - 5.0) > 1e-12 or abs(yq[1] - 15.0) > 1e-12 or abs(yq[2] - 30.0) > 1e-12:
        raise ValueError(f"Interpolation mismatch: {yq[0]}, {yq[1]}, {yq[2]}")
        
    print(f"Python caller verified: {yq[0]:.1f} {yq[1]:.1f} {yq[2]:.1f}")

if __name__ == "__main__":
    test()
