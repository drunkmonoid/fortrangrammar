# Call the Fortran kernel through ctypes. The array is a NumPy buffer.
import ctypes
import sys

import numpy as np

lib = ctypes.CDLL(sys.argv[1])
lib.fill.argtypes = [ctypes.c_int, ctypes.POINTER(ctypes.c_double)]
lib.fill.restype = None

n = 4
values = np.zeros(n, dtype=np.float64)
lib.fill(n, values.ctypes.data_as(ctypes.POINTER(ctypes.c_double)))
if not np.array_equal(values, np.arange(1, n + 1, dtype=np.float64)):
    raise SystemExit('fill did not write 1..n')
print('a =', ' '.join(str(int(item)) for item in values))
